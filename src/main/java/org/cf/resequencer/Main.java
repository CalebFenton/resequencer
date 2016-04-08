/*
 * Sequencer
 * 
 * TODO:
 * implement --sign-key and --sign-cert
 * add region resolution to variables (impossible)
 * afterOP (probably beforeOP) needs proper existance checking
 * and should always be there for it to work. give warning if not.
 * it has been completely rewritten once, and everyone knows developers do not
 * like their code until it has been rewritten at least three times.
 * do NOT list operations being performed if they're skipped because of sdk requirements (<1)
 */
package org.cf.resequencer;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;
import java.util.Set;

import org.apache.commons.io.FileUtils;
import org.cf.resequencer.patch.FingerprintReader;
import org.cf.resequencer.patch.SmaliFile;
import org.cf.resequencer.patch.SmaliHinter;
import org.cf.resequencer.patch.SmaliMatcher;
import org.cf.resequencer.patch.Splicer;
import org.cf.resequencer.sequence.ApkFile;
import org.cf.resequencer.sequence.ApkFile.DecodeResOption;

/**
 * 
 * @author Caleb Fenton
 */
public class Main {

    public static final String VERSION = "1.1";
    private static final String UPDATED = "Feb 28th, 2016";

    // You know regex, right? :D
    // this will match such that the end of the region will be
    // exactly where to insert stuff into a method
    // ie. after prologue (if there is one)
    private static final String MethodStarts = "(?sm)^\\s*\\.(locals|registers) \\d+((\\r)?\\n)+" + "(\\s*\\.parameter( \\\".*?\\\")?((\\r)?\\n)+)*" + "(\\s*\\.annotation.+?\\.end annotation((\\r)?\\n)+)*" + "(\\s*\\.end parameter((\\r)?\\n)+)*" + "(\\s*\\.annotation.+?\\.end annotation((\\r)?\\n)+)*" + "(\\s*\\.prologue((\\r)?\\n)+)?" + "(\\s*\\.line( \\d+)?((\\r)?\\n)+)?" + "(\\s*\\.local .+?((\\r)?\\n)+)?\\s*";
    private static ApkFile myApkFile;
    private static FingerprintReader myReader;

    /**
     * @param args
     *            the command line arguments
     */
    public static void main(String[] args) {
        showHeader();

        // parseArgs options and store in Options
        Options.parseArgs(args);

        // Check environment for required binaries depending on OS
        Console.debug("Checking environment ...");
        ensureBinariesPresent();

        if (Options.ListFPsOnly) {
            myReader = getFingerprintReader();
            displayFingerprints();
            System.exit(0);
        }

        // work with a copy, just in case something goes wrong
        copyApkIfNeeded();

        // we have a copy of the apk and are ready to make our ApkFile
        // set some options, check some things. actual decompiling takes
        // place when getSmaliFiles is called
        try {
            myApkFile = new ApkFile(Options.OutputApk, Options.SmaliDir, Options.AaptPath, Options.ZipalignPath);

            // apktool likes to throw a bunch of shit into the logs.
            ApkFile.apkDisableApktoolLogging();

            if (Options.DecodeResources) {
                myApkFile.apkSetDecodeResources(DecodeResOption.FULL_DECODE);
            } else if (Options.SkipCleanup) {
                myApkFile.apkSetDecodeResources(DecodeResOption.HINTS_ONLY);
            }

            // Need to clear previous smali dump dir or files not directly
            // overwritten by baksmali will be processed again.
            // This means hooks get all mangled.
            if (Options.givenApkFile() && !(Options.SignOnly || Options.AssembleOnly)) {
                Options.enforceOverwrite(myApkFile.DumpDir, "smali dump dir");
                if (!myApkFile.apkDeleteSmaliDir()) {
                    Console.die("Unable to remove Smali dump directory.");
                }
            }

            Options.SmaliDir = myApkFile.DumpDir;
        } catch (Exception ex) {
            Console.die(ex);
        }

        if (Options.SignOnly) {
            Console.msgln("Signing ...");
            signApk();
            finish();
        } else if (Options.AssembleOnly) {
            try {
                Console.msgln("Building ...");
                myApkFile.apkBuild();
            } catch (Exception ex) {
                Console.die(ex);
            }
            finish();
        }

        // We'll be needing app info now, if available
        if (Options.givenApkFile()) {
            myApkFile.apkLoadAppInfo();

            displayAppInfo();
        }

        if (Options.InfoOnly) {
            finish();
        }

        // get a new reader since script vars will be different
        // since we have app info in our apkfile loaded
        myReader = getFingerprintReader();

        SmaliFile[] smaliFiles = getSmaliFiles();

        if (!Options.SkipHints && (myApkFile.DecodeResources != DecodeResOption.NO_DECODE)) {
            Console.msg("\nAdding Smali hints .");
            int i = 0;
            for (SmaliFile sf : smaliFiles) {
                SmaliHinter.generateHints(sf, myApkFile.AppResources);
                sf.doModificationsAndSave();
                if ((i++ % 100) == 0) {
                    Console.msg(".");
                }
            }
            Console.msgln();
        }

        // Determine protection mechanisms
        Console.msgln("\nDetermining protection mechanisms ...");
        SmaliMatcher mySmaliMatcher = new SmaliMatcher(smaliFiles, myReader);
        ArrayList<SmaliFile> fileMatches = mySmaliMatcher.performMatching();

        if (Options.DetectOnly) {
            System.exit(0);
        }

        Set<String> hooks = myReader.getHooksToInstall(fileMatches);

        if (hooks.size() > 0) {
            Console.msg("\nInstalling hooks .");
            myReader.installSmaliHooks(hooks);
            Console.msgln();
        }

        Console.msgln("\nLiberating ...");
        // TODO: serialize AppInfo when running with Apk and load it if available
        // and working with smali dump
        Splicer myLiberator = new Splicer(fileMatches, myApkFile.DumpDir,
                        Options.givenApkFile() ? myApkFile.AppInfo.AppMinSDK : 1);
        if (myLiberator.splice()) {
            compileIfRequired();
        } else if (!Options.ApkPath.equals(Options.OutputApk)) {
            myApkFile.delete();
        }
        myLiberator;

        cleanup();

        finish();
    }

    private static SmaliFile[] getSmaliFiles() {
        java.io.File[] files = null;
        try {
            files = myApkFile.apkGetSmaliFiles();
        } catch (Exception ex) {
            Console.die(ex);
        }

        org.cf.resequencer.patch.SmaliFile[] smaliFiles = new org.cf.resequencer.patch.SmaliFile[files.length];
        for (int i = 0; i < files.length; i++) {
            smaliFiles[i] = new SmaliFile(files[i]);
        }

        return smaliFiles;
    }

    private static void signApk() {
        try {
            if ((Options.SignKey == null) || (Options.SignCert == null)) {
                myApkFile.apkSign(Options.OutputApk, Main.class.getResourceAsStream("/sequencer/key.pk8"),
                                Main.class.getResourceAsStream("/sequencer/certificate.pem"), "resequencer");
            } else {
                myApkFile.apkSign(Options.OutputApk, Options.SignKey, Options.SignCert, Options.SignPass);
            }
        } catch (Exception ex) {
            Console.die(ex);
        }
    }

    private static void copyApkIfNeeded() {
        if (Options.DetectOnly || Options.SkipAssembly || Options.InfoOnly || Options.AssembleOnly || !Options
                        .givenApkFile()) {
            return;
        }

        if (!Options.ApkPath.equals(Options.OutputApk)) {
            try {
                File apkF = new File(Options.ApkPath);
                File outF = new File(Options.OutputApk);
                Console.debug("Copying " + apkF + " to " + outF, 3);
                FileUtils.copyFile(apkF, outF);
            } catch (IOException ex) {
                Console.die(ex);
            }
        }
    }

    private static void displayFingerprints() {
        Console.msgln("Available fingerprints:");
        String msg;
        for (String fpName : myReader.FingerprintNames) {
            msg = "  " + fpName;
            if (!myReader.isEnabled(fpName)) {
                msg += " *disabled*";
            }
            Console.msgln(msg);
        }

        Console.msgln("Total: " + myReader.FingerprintNames.size());
    }

    private static void displayAppInfo() {
        Console.msgln("App package name: " + myApkFile.AppInfo.AppPackageName);

        if (Options.InfoOnly) {
            Console.msgln("Signature hash: " + myApkFile.AppInfo.SignatureHashes[0]);
        } else {
            Console.debug("Signature hash: " + myApkFile.AppInfo.SignatureHashes[0]);
            Console.debug("Signature chars: " + myApkFile.AppInfo.SignatureChars[0] + "File size: " + myApkFile.AppInfo.ApkFileSize + "Last modified: " + myApkFile.AppInfo.ApkLastModified,
                            2);
        }
    }

    private static void finish() {
        finish(0);
    }

    private static void finish(int exitCode) {
        Console.msgln("Finished.");

        System.exit(exitCode);
    }

    private static void cleanup() {
        myReader = null;

        if (Options.SkipCleanup) {
            Console.msgln("Skipping clean up.");
            return;
        }

        Console.msg("Cleaning up ...");

        // On Window's environments, files will fail to delete sometimes
        // unless we explicitly invoke garbage collector.
        System.gc();

        if (Options.givenApkFile() && !Options.SkipAssembly && !Options.SignOnly) {
            File smaliDirFile = new File(myApkFile.DumpDir);

            myApkFile = null;
            System.gc();
            try {
                FileUtils.forceDelete(smaliDirFile);
            } catch (IOException ex) {
                Console.warn("Unable to delete " + smaliDirFile.getAbsolutePath() + ".\n" + ex);
            }
        }

        Console.msgln(" done.");
    }

    private static void compileIfRequired() {
        if (Options.SkipAssembly) {
            return;
        }

        try {
            Console.msg("Assembling ...");
            myApkFile.apkAssemble();
            Console.msgln(" done.");

            Console.msg("Signing ...");
            // myApkFile.apkSign();
            signApk();
            Console.msgln(" done.");

            Console.msg("Zip aligning ...");
            myApkFile.apkAlign();
            Console.msgln(" done.");

            if (Options.givenApkFile()) {
                Console.debug("Spoofing last modified ...");
                myApkFile.apkSpoofLastModified();
            }
        } catch (Exception ex) {
            Console.die(ex);
        }

        if (new File(Options.OutputApk).exists()) {
            Console.msgln("  Produced: " + Options.OutputApk);
        }
    }

    // checks for binaries
    // returns false if anything required is missing
    private static void ensureBinariesPresent() {
        String os = System.getProperty("os.name");
        Console.debug("Operating system: " + os, 2);

        String myPath = "";
        try {
            myPath = new File(".").getCanonicalPath();
            myPath += File.separator;
        } catch (IOException ex) {
            Console.die("Strange... Unable" + " to determine current directory.\n" + ex);
        }

        if (os.toLowerCase().startsWith("windows")) {
            Options.AaptPath = "aapt.exe";
            Options.ZipalignPath = "zipalign.exe";
        } else {
            Options.AaptPath = "./aapt";
            Options.ZipalignPath = "./zipalign";
        }

        if (!new File(Options.AaptPath).exists()) {
            Console.die("Missing aapt binary!" + "\nSuggestion: Make sure it is in '" + myPath + "'.");
        }

        if (!new File(Options.ZipalignPath).exists()) {
            Console.die("Missing zipalign binary!" + "\nSuggestion: Make sure it is in '" + myPath + "'.");
        }

        File f = new File(Options.AaptPath);
        if (!f.canExecute()) {
            Console.die("We do not have execute permissions for " + Options.AaptPath + ".");
        }

        f = new File(Options.ZipalignPath);
        if (!f.canExecute()) {
            Console.die("We do not have execute permissions for " + Options.ZipalignPath + ".");
        }
    }

    public static HashMap<String, String> getScriptVarsForSmali() {
        HashMap<String, String> result = new HashMap<String, String>();

        result.put("SequencerVersion", VERSION);
        result.put("MethodStarts", MethodStarts);
        result.put("CheckSigsBehavior", Options.CheckSigsBehavior + "");
        result.put("GetPIBehavior", Options.GetPIBehavior + "");
        result.put("SigVerifyBehavior", Options.SigVerifyBehavior + "");

        if ((myApkFile != null) && (myApkFile.AppInfo != null)) {
            result.put("AppPackage", myApkFile.AppInfo.AppPackageName);
            result.put("AppPackageL", myApkFile.AppInfo.AppPackageName.replace('.', '/'));
            result.put("LaunchActivity", myApkFile.AppInfo.LaunchActivity);
            result.put("AppVersionCode", myApkFile.AppInfo.AppVersionCode);
            result.put("AppVersionName", myApkFile.AppInfo.AppVersionName);
            result.put("SignatureChars", myApkFile.AppInfo.SignatureChars[0]);
            result.put("SignatureHash", myApkFile.AppInfo.SignatureHashes[0]);
            result.put("CertCount", myApkFile.AppInfo.CertsLoaded + "");
            result.put("CertCountHex", "0x" + Integer.toHexString(myApkFile.AppInfo.CertsLoaded));

            result.put("OrigApkFileSize", myApkFile.AppInfo.ApkFileSize + "");
            result.put("OrigApkFileSizeHex", "0x" + Long.toHexString(myApkFile.AppInfo.ApkFileSize) + "L");
            result.put("OrigApkLastModified", myApkFile.AppInfo.ApkLastModified + "");
            result.put("OrigApkLastModifiedHex", "0x" + Long.toHexString(myApkFile.AppInfo.ApkLastModified) + "L");

            result.put("OrigClassesDexFileSize", myApkFile.AppInfo.ClassesDexFileSize + "");
            result.put("OrigClassesDexFileSizeHex", "0x" + Long.toHexString(myApkFile.AppInfo.ClassesDexFileSize) + "L");
            result.put("OrigClassesDexLastModified", myApkFile.AppInfo.ClassesDexLastModified + "");
            result.put("OrigClassesDexLastModifiedHex",
                            "0x" + Long.toHexString(myApkFile.AppInfo.ClassesDexLastModified) + "L");

            result.put("MD5Sum", myApkFile.AppInfo.MD5Sum);

            result.put("ZipClassesDexCrc", "" + myApkFile.AppInfo.ZipClassesDexCrc);
            result.put("ZipClassesDexSize", "" + myApkFile.AppInfo.ZipClassesDexSize);
            result.put("ZipClassesDexCompressedSize", "" + myApkFile.AppInfo.ZipClassesDexCompressedSize);

            result.put("ChksumCRC32App", "" + myApkFile.AppInfo.ApkChecksumCRC32);
            result.put("ChksumAdler32App", "" + myApkFile.AppInfo.ApkChecksumAdler32);
            result.put("ChksumMD5App", myApkFile.AppInfo.ApkDigestMD5);
            result.put("ChksumSHA1App", myApkFile.AppInfo.ApkDigestSHA1);

            // Checksum values for Key package if available
            // REAL key values are loaded a little later
            result.put("KeyPackage", "");
            result.put("ChksumCRC32Key", "0");
            result.put("ChksumAdler32Key", "0");
            result.put("ChksumMD5Key", myApkFile.AppInfo.ApkDigestMD5);
            result.put("ChksumSHA1Key", myApkFile.AppInfo.ApkDigestSHA1);

            // Checksum values for classes.dex
            result.put("ChksumCRC32DEX", "" + myApkFile.AppInfo.DexChecksumCRC32);
            result.put("ChksumAdler32DEX", "" + myApkFile.AppInfo.DexChecksumAdler32);
            result.put("ChksumMD5DEX", myApkFile.AppInfo.DexDigestMD5);
            result.put("ChksumSHA1DEX", myApkFile.AppInfo.DexDigestSHA1);
        }

        Random rng = new Random();
        result.put("RndAlpha", org.cf.resequencer.sequence.StringUtils.generateString(
                        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", 5 + rng.nextInt(5)));
        result.put("RndAlphaNum", org.cf.resequencer.sequence.StringUtils.generateString(
                        "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890", 5 + rng.nextInt(5)));
        result.put("RndNum", org.cf.resequencer.sequence.StringUtils.generateString("0123456789", 5 + rng.nextInt(5)));

        result.put("DeviceIDSpoof", Options.DeviceIDSpoof);
        result.put("DeviceIDSpoofType", String.valueOf(Options.DeviceIDSpoofType));
        result.put("WifiMacSpoof", Options.WifiMacSpoof);
        result.put("WifiMacSpoofType", String.valueOf(Options.WifiMacSpoofType));
        result.put("BTMacSpoof", Options.BTMacSpoof);
        result.put("BTMacSpoofType", String.valueOf(Options.BTMacSpoofType));
        result.put("AccountNameSpoof", Options.AccountNameSpoof);
        result.put("AccountNameSpoofType", String.valueOf(Options.AccountNameSpoofType));
        result.put("DeviceModelSpoof", Options.DeviceModelSpoof);
        result.put("DeviceManufacturerSpoof", Options.DeviceManufacturerSpoof);
        result.put("NetworkOperatorSpoof", Options.NetworkOperatorSpoof);

        // We're given a key apk. Load up all properties and feed them
        // to our result list.
        if (!Options.KeyApkPath.isEmpty()) {
            Console.debug("Getting Key Apk properties: " + Options.KeyApkPath);
            ApkFile key = null;
            try {
                key = new ApkFile(Options.KeyApkPath, "Key", Options.AaptPath, Options.ZipalignPath);
            } catch (Exception ex) {
                Console.die("Erorr loading key apk properties:\n" + ex);
            }

            if (key == null) {
                Console.die("Very strange! Key apk is null!");
            }

            key.apkLoadAppInfo();

            result.put("KeyPackage", key.AppInfo.AppPackageName);
            result.put("ChksumCRC32Key", "" + key.AppInfo.ApkChecksumCRC32);
            result.put("ChksumAdler32Key", "" + key.AppInfo.ApkChecksumAdler32);
            result.put("ChksumMD5Key", key.AppInfo.ApkDigestMD5);
            result.put("ChksumSHA1Key", key.AppInfo.ApkDigestSHA1);
        }

        return result;
    }

    public static FingerprintReader getFingerprintReader() {
        String resPath = "/fingerprints/";
        ArrayList<String> xmlFileList = new ArrayList<String>();

        xmlFileList.add(resPath + "fingerprints.xml");
        xmlFileList.add(resPath + "hooks.xml");

        String hooksPath = "/hooks/";
        if (Options.DebugHooks) {
            // TODO: implement debug hooks
            hooksPath = "/hooks/";
            Console.debug("Using debug hooks.");
        }

        /*
         * return new FingerprintReader(xmlFileList.toArray(new String[xmlFileList.size()]), Options.ExcludedFPs,
         * Options.IncludedFPs, Options.SmaliDir, hooksPath, !Options.DebugHooks, getScriptVarsForSmali());
         */
        // Obfuscation needs to be rewritten, force false for now
        return new FingerprintReader(xmlFileList.toArray(new String[xmlFileList.size()]), Options.ExcludedFPs,
                        Options.IncludedFPs, Options.SmaliDir, hooksPath, false, getScriptVarsForSmali());

    }

    private static void showHeader() {
        Console.msgln("-----------------------------------------------------\n" + " Resequencer " + VERSION + " - " + UPDATED + "\n" + "-----------------------------------------------------\n\n");
    }
}
