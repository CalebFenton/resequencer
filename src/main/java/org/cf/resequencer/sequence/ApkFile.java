package org.cf.resequencer.sequence;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.ConsoleHandler;
import java.util.logging.Handler;
import java.util.logging.Level;
import java.util.logging.Logger;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.io.FileUtils;
import org.cf.resequencer.Console;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import brut.androlib.Androlib;
import brut.androlib.ApkDecoder;
import brut.androlib.ApkOptions;

/**
 * ApkFile handler
 * 
 * @author Caleb Fenton
 * 
 *         TODO: consider signing location, should accept private/public key stuff consider that this may be used with
 *         just a dump path
 */
public class ApkFile extends java.io.File {

    // Android Apks are zipaligned by 4 bytes
    private final static int DEFAULT_ZIPALIGN_PADDING = 4;

    /**
     * Path to ApkFile.
     */
    public String ApkPath;
    /**
     * Path to dump directory. Will contain sub-directories for resources and smali.
     */
    public String DumpDir;
    /**
     * Instance of AppInfo which is populated with bits of information needed from the Apk.
     */
    public AppInfo AppInfo;
    /**
     * Path to assembled classes.dex file.
     */
    public File ClassesDex;

    /**
     * Option for decoding Apk resources.
     */
    public enum DecodeResOption {
        /**
         * Decode resources and try to provide hint information, but do not rebuild resources.
         */
        HINTS_ONLY,
        /**
         * Decode resources, try to provide hint information and rebuild resources.
         */
        FULL_DECODE,
        /**
         * Do not decode resources.
         */
        NO_DECODE
    }

    /**
     * How to handle decoding Apk resources.
     */
    public DecodeResOption DecodeResources = DecodeResOption.NO_DECODE;
    /**
     * Collection of elements from public.xml and strings.xml.
     */
    public List<ResourceItem> AppResources = new ArrayList<ResourceItem>();

    private String mAaptPath, mZipalignPath;
    private boolean DexLock = true;

    /**
     * This constructor will not work fully because it has not Aapt/Zipalign path.
     * 
     * @param apkPath
     *            Path to Apk file.
     * @throws Exception
     */
    public ApkFile(final String apkPath) throws Exception {
        this(apkPath, "", "", "");
    }

    /**
     * 
     * @param apkPath
     *            Path to Apk file.
     * @param dumpDir
     *            Path to Smali dump directory. If blank, defaults to Apk path name + "-dump"
     * @param aaptPath
     *            Path to Aapt binary.
     * @param zipalignPath
     *            Path to Zipalign binary.
     * @throws Exception
     */
    public ApkFile(final String apkPath, final String dumpDir, final String aaptPath, final String zipalignPath)
                    throws Exception {
        super(apkPath);

        ApkPath = apkPath;
        DumpDir = dumpDir;
        mAaptPath = aaptPath;
        mZipalignPath = zipalignPath;

        if (DumpDir.isEmpty()) {
            DumpDir = ApkPath.replace(".apk", "") + "-dump";
        }

        // dex file will go inside dump directory as classes.dex
        // this is to emulate apktool behavior
        ClassesDex = new File(DumpDir + File.separator + "classes.dex");
        ClassesDex.deleteOnExit();
    }

    /**
     * 
     * @return true if Apk has been compiled, false otherwise
     */
    public boolean apkIsCompiled() {
        return (ClassesDex != null) && (ClassesDex.length() > 0);
    }

    /**
     * 
     * @return true if Apk has been decompiled, false otherwise
     */
    public boolean apkIsDecompiled() {
        return new File(DumpDir).exists();
    }

    /**
     * depricated, more or less
     * 
     * @return true if constructed with actual Apk file or Apk file set, false otherwise
     */
    public boolean apkHaveApkFile() {
        return (ApkPath != null) && new File(ApkPath).exists();
    }

    /**
     * depricated, more or less
     * 
     * @param apkPath
     *            Path to Apk file.
     */
    public void apkSetApk(final String apkPath) {
        ApkPath = apkPath;
    }

    /**
     * Sets path to Aapt binary.
     * 
     * @param aaptPath
     *            Path to Aapt binary.
     */
    public void apkSetAaptPath(final String aaptPath) {
        mAaptPath = aaptPath;
    }

    /**
     * Sets path to Zipalign binary.
     * 
     * @param zaPath
     */
    public void apkSetZipalignPath(final String zaPath) {
        mZipalignPath = zaPath;
    }

    /**
     * Load Apk info such as certificates, signatures, etc. Requires Aapt.
     */
    public void apkLoadAppInfo() {
        if (mAaptPath.isEmpty()) {
            Console.warn("Aapt path is empty, unable to get app info.");
            return;
        }

        AppInfo = new AppInfo(ApkPath, mAaptPath);
    }

    /**
     * Works the same as apkCompileSmali(), apkUpdateDex(), apkSign(), apkAlign()
     * 
     * @throws Exception
     */
    public void apkBuild() throws Exception {
        apkAssemble();
        apkSign();
        apkAlign();
    }

    /**
     * 
     * @throws Exception
     */
    public void apkAssemble() throws Exception {
        // pre-apktool integration compiled then updated dex
        apkCompileSmali();

        if (DecodeResources != DecodeResOption.FULL_DECODE) {
            apkUpdateDex();
        } else {
            ApkOptions opts = new ApkOptions();
            opts.forceBuildAll = false;
            opts.debugMode = false;
            opts.verbose = false;
            opts.copyOriginalFiles = false;
            opts.isFramework = false;
            opts.updateFiles = false;
            opts.aaptPath = mAaptPath;

            Androlib lib = new Androlib(opts);
            lib.build(new File(DumpDir), new File(ApkPath));
        }
    }

    /**
     * Compile Smali dump directory. Throws exception if not decompiled.
     * 
     * @throws Exception
     */
    public void apkCompileSmali() throws Exception {
        if (!apkIsDecompiled()) {
            throw new Exception("Cannot compile. Apk has not been decompiled yet.");
        }

        // no need to enforce overwrites, since we use temp files
        org.jf.smali.main.main(new String[] { "--allow-odex-instructions", "-o" + ClassesDex.getPath(), DumpDir });

        if (ClassesDex.length() == 0) {
            throw new Exception("Compile error. Check your code and try again.");
        }

        DexFile df = new DexFile(ClassesDex);
        df.dexLock();

        // To make it more like the original
        if ((AppInfo != null) && (AppInfo.ClassesDexLastModified != 0)) {
            df.DexFile.setLastModified(AppInfo.ClassesDexLastModified);
        }
    }

    /**
     * Decompile Apk to DumpDir.
     * 
     * @throws Exception
     */
    public void apkDecompile() throws Exception {
        apkDecompile(DumpDir);
    }

    /**
     * Decompile Apk to given path.
     * 
     * @param dumpPath
     *            Path to dump Smali files.
     * @throws Exception
     */
    public void apkDecompile(final String dumpPath) throws Exception {
        if (!apkHaveApkFile()) {
            throw new Exception("Cannot decompile. Apk does not exist.");
        }

        // Need at least SDK/API level for baksmali
        if (AppInfo == null) {
            apkLoadAppInfo();
        }

        if (DecodeResources != DecodeResOption.NO_DECODE) {
            ApkDecoder decoder = new ApkDecoder();
            decoder.setDecodeSources((short) 0x0000);
            decoder.setForceDelete(true);
            decoder.setKeepBrokenResources(true);
            decoder.setOutDir(new File(dumpPath));
            decoder.setApkFile(new File(ApkPath));
            try {
                decoder.decode();
            } catch (Exception ex) {
                Console.warn("Exception decoding resources:\n" + ex);

                if (DecodeResources == DecodeResOption.FULL_DECODE) {
                    Console.die("Unable to continue full decode because of above errors.");
                    ex.printStackTrace();
                }
            }

            // might as well load strings for use with code hints
            loadXMLStrings();

            // Futile attempt to unload Apktool classes to give up file handles
            decoder = null;
            System.gc();
        }

        // Apktool could give us classes.dex, but our baksmali is
        // usually more current. Extract it ourselves.
        apkExtractEntry("classes.dex", ClassesDex.getPath());

        if (!ClassesDex.exists()) {
            Console.die("Error while extracting classes.dex from Apk.");
        }

        String outDir = dumpPath + File.separator + "smali";
        String[] args = new String[] {
                        "--use-locals", "--sequential-labels", "--api-level", AppInfo.AppMinSDK + "", "--output",
                        outDir, ClassesDex.getPath() };
        org.jf.baksmali.main.main(args);

        // No easy and rigorous way to determine if baksmali was successful
        // Assume if directory exists, it worked
        if (!new File(outDir).exists()) {
            throw new Exception("Unknown error while decompiling " + ClassesDex + "!");
        }
    }

    /**
     * Sign the Apk.
     * 
     * @throws Exception
     */
    public void apkSign() throws Exception {
        apkSign(ApkPath);
    }

    /**
     * Sign the Apk and output the result to outPath.
     * 
     * @param outPath
     *            Path to put signed Apk.
     * @throws Exception
     */
    public void apkSign(final String outPath) throws Exception {
        apkSign(outPath, null, (InputStream) null, null);
    }

    /**
     * Sign the Apk and output the result to outPath.
     * 
     * @param outPath
     *            Path to put signed Apk.
     * @param signKey
     *            File for PK8 key to sign with. If null, ignored.
     * @param signCert
     *            File for x509 PEM certificate to sign with. If null, ignored.
     * @param signPass
     *            Password to use with key. If null, and keys non-null, will prompt.
     * @throws Exception
     */
    public void apkSign(final String outPath, final File signKey, final File signCert, final String signPass)
                    throws Exception {
        apkSign(outPath, new FileInputStream(signKey), new FileInputStream(signCert), signPass);
    }

    /**
     * Sign the Apk and output the result to outPath.
     * 
     * @param outPath
     *            Path to put signed Apk.
     * @param signKey
     *            FileInputStream for PK8 key to sign with. If null, ignored.
     * @param signCert
     *            FileInputStream for x509 PEM certificate to sign with. If null, ignored.
     * @param signPass
     *            Password to use with key. If null, and keys non-null, will prompt.
     * @throws Exception
     */
    public void apkSign(final String outPath, final InputStream signKey, final InputStream signCert,
                    final String signPass) throws Exception {
        if (outPath.equals(ApkPath)) {
            // remove old certs directory from apk
            apkDeleteCerts();
        } else {
            File outF = new File(outPath);
            FileUtils.copyFile(this, outF);
            ApkFile outApkFile = new ApkFile(outPath);
            outApkFile.apkDeleteCerts();
        }

        ApkSigner.signApkWithCerts(outPath, null, signKey, signCert, signPass);

        if (!new File(outPath).exists()) {
            throw new Exception("Unknown error while signing " + outPath + ".");
        }
    }

    /**
     * Run zipalign on Apk with recommended padding.
     * 
     * @throws Exception
     */
    public void apkAlign() throws Exception {
        apkAlign(DEFAULT_ZIPALIGN_PADDING);
    }

    /**
     * Run zipalign on Apk with given padding.
     * 
     * @param padding
     *            Padding to use for zipalign.
     * @throws Exception
     */
    public void apkAlign(final int padding) throws Exception {
        if (mZipalignPath.isEmpty()) {
            Console.warn("Zipalign path is empty, unable to zipalign.");
            return;
        }

        File outFile = File.createTempFile("zaapk", null);

        // Can't use Arrays.asList because it returns immutable
        List<String> args = new ArrayList<String>();
        args.add(mZipalignPath);
        args.add("-f");
        // if ( VerboseLevel >= 3 ) args.add("-v");
        args.add(String.valueOf(padding));
        args.add(this.getPath());
        args.add(outFile.getPath());
        String[] info = Console.execute(args.toArray(new String[args.size()]));

        // Print out any output. On normal success, there isn't any.
        if (!info[0].isEmpty()) {
            System.out.println("\n" + info[0]);
        }

        // Zipalign returns 0 on success, non-0 on failure
        if (!info[1].equals("0")) {
            throw new Exception("Zipalign failed.");
        }

        Console.deleteBestEffort(this, "output apk", 3, true);
        FileUtils.moveFile(outFile, this);
    }

    /**
     * Update classes.dex entry in the Apk file with compiled one.
     * 
     * @throws Exception
     */
    public void apkUpdateDex() throws Exception {
        if (!apkIsCompiled()) {
            apkCompileSmali();
        }

        apkUpdateDex(ClassesDex.getPath());
    }

    /**
     * Update classes.dex entry in the Apk file with given one.
     * 
     * @param dexPath
     *            Path to dex file to insert.
     * @throws Exception
     */
    public void apkUpdateDex(final String dexPath) throws Exception {
        File dexFile = new File(dexPath);

        if (DexLock) {
            Console.debug("DexLock: " + dexFile + " ... ");
            DexFile df = new DexFile(dexFile);
            df.dexLock();
        }

        apkInsertEntry(dexFile, "classes.dex");
    }

    /**
     * Insert zip entry into Apk file.
     * 
     * @param newEntryFile
     *            file to add
     * @param entryName
     *            name of the entry
     * @throws Exception
     */
    public void apkInsertEntry(final File newEntryFile, final String entryName) throws Exception {
        if (!newEntryFile.exists() && newEntryFile.isFile()) {
            throw new Exception("Unable to insert apk entry. File " + newEntryFile + " does not exist.");
        }

        ZipUtils.addFilesToZip(new File(ApkPath), new File[] { newEntryFile }, new String[] { entryName });
    }

    /**
     * Extract zip entry from Apk file.
     * 
     * @param entryName
     *            entry name of file to extract
     * @param outPath
     *            path to put file
     * @return
     * @throws Exception
     */
    public java.io.File apkExtractEntry(final String entryName, final String outPath) throws Exception {
        ZipUtils.extractZipEntry(new File(ApkPath), entryName, outPath);

        File outFile = new File(outPath);
        if (!outFile.exists()) {
            throw new Exception("Unable to extract zip entry: " + entryName + " from " + ApkPath + ".");
        }

        return outFile;
    }

    /**
     * Delete entry from Apk file.
     * 
     * @param entryName
     *            entry to delete, directories should have trailing '/'
     * @throws Exception
     */
    public void apkDeleteEntry(final String entryName) throws Exception {
        ZipUtils.deleteZipEntry(new File(ApkPath), entryName);
    }

    /**
     * Determine if Apk entry exists.
     * 
     * @param entryName
     *            zip entry name, including path
     * @return true if found, false otherwise
     */
    public boolean apkEntryExists(final String entryName) {
        return ZipUtils.zipEntryExists(new File(ApkPath), entryName);
    }

    /**
     * Calls apkDeleteEntry with META-INF/ to purge certificates from Apk.
     * 
     * @throws Exception
     */
    public void apkDeleteCerts() throws Exception {
        Console.debug("Deleting certs for " + getPath());
        apkDeleteEntry("META-INF/");
        apkInsertEntry(new File("META-INF/"), "META-INF/");
    }

    /**
     * Gets list of Smali file paths. If Apk is not decompiled, will decompile first.
     * 
     * @return array of Smali file paths
     * @throws Exception
     */
    public File[] apkGetSmaliFiles() throws Exception {
        if (!apkIsDecompiled()) {
            apkDecompile();
        }

        return SmaliFileFinder.getSmailFiles(new File(DumpDir));
    }

    /**
     * Sets ApkLastModified property on Apk based on what it thinks it should be. Some Apps check this.
     */
    public void apkSpoofLastModified() {
        if (AppInfo.ApkLastModified != 0) {
            this.setLastModified(AppInfo.ApkLastModified);
        }
    }

    /**
     * Delete Smali dump dir.
     * 
     * @return true if successful, false otherwise
     */
    public boolean apkDeleteSmaliDir() {
        File smaliDir = new File(DumpDir);
        if (!smaliDir.exists()) {
            return true;
        }

        // sometimes windows will not delete until you do this
        return Console.deleteBestEffort(smaliDir, "smali dir");
    }

    /**
     * True will enable Dex header modification to stop disassembly with older versions of baksmali. False disables.
     * Default is true.
     * 
     * @param val
     */
    public void apkSetDexLock(boolean val) {
        DexLock = val;
    }

    /**
     * Setup how to handle resources. See DecodeResOption.
     * 
     * @param opt
     */
    public void apkSetDecodeResources(DecodeResOption opt) {
        DecodeResources = opt;
    }

    private void loadXMLStrings() {
        if (DecodeResources == DecodeResOption.NO_DECODE) {
            Console.debug("Skipped resources. Will not be loading XML strings.");
            return;
        }

        // contains the actual strings
        String xmlStringsPath = DumpDir + File.separator + "res" + File.separator + "values" + File.separator + "strings.xml";
        File xmlStrings = new File(xmlStringsPath);

        if (!xmlStrings.exists()) {
            xmlStringsPath = DumpDir + File.separator + "res" + File.separator + "values-en" + File.separator + "strings.xml";
            xmlStrings = new File(xmlStringsPath);
        }

        // contains the ID numbers and names
        String xmlPublicPath = DumpDir + File.separator + "res" + File.separator + "values" + File.separator + "public.xml";
        File xmlPublic = new File(xmlPublicPath);

        if (!xmlStrings.exists()) {
            Console.warn("Strings XML resource could not be found." + " Expected: " + xmlStringsPath);
            return;
        }

        if (!xmlPublic.exists()) {
            Console.warn("Public XML resource could not be found." + " Expected: " + xmlPublicPath);
            return;
        }

        DocumentBuilderFactory dbf = null;
        DocumentBuilder db = null;
        Document doc = null;

        try {
            dbf = DocumentBuilderFactory.newInstance();
            db = dbf.newDocumentBuilder();
            doc = db.parse(xmlPublic);
            doc.getDocumentElement().normalize();

            NodeList nList = doc.getElementsByTagName("public");
            for (int i = 0; i < nList.getLength(); i++) {
                Node n = nList.item(i);
                if (n.getNodeType() != Node.ELEMENT_NODE) {
                    continue;
                }

                NamedNodeMap attribs = n.getAttributes();
                Node nAttrib = attribs.getNamedItem("type");
                String resType = nAttrib == null ? "" : nAttrib.getNodeValue();

                nAttrib = attribs.getNamedItem("name");
                String resName = nAttrib == null ? "" : nAttrib.getNodeValue();

                nAttrib = attribs.getNamedItem("id");
                String resID = nAttrib == null ? "" : nAttrib.getNodeValue();

                AppResources.add(new ResourceItem(resType, resName, resID));
            }

            doc = db.parse(xmlStrings);
            doc.getDocumentElement().normalize();

            nList = doc.getElementsByTagName("string");
            for (int i = 0; i < nList.getLength(); i++) {
                Node n = nList.item(i);
                if (n.getNodeType() != Node.ELEMENT_NODE) {
                    continue;
                }

                NamedNodeMap attribs = n.getAttributes();
                Node nAttrib = attribs.getNamedItem("name");
                String resName = nAttrib == null ? "" : nAttrib.getNodeValue();
                String resValue = getXMLTagValue(n);

                // we have loaded the value of the string, so update
                // our resource item collection with the values
                for (ResourceItem ri : AppResources) {
                    if (ri.Name.equals(resName)) {
                        ri.setValue(resValue);
                        break;
                    }
                }
            }
        } catch (Exception ex) {
            Console.warn("Unable to parse XML resources.\n" + ex);
            ex.printStackTrace();
            return;
        }
    }

    private static String getXMLTagValue(Node node) {
        Node n = ((Element) node).getChildNodes().item(0);
        return n != null ? n.getNodeValue() : "";
    }

    /**
     * Disable all logging from Apktool.
     */
    public static void apkDisableApktoolLogging() {
        Logger logger = Logger.getLogger("");
        for (Handler handler : logger.getHandlers()) {
            logger.removeHandler(handler);
        }
        Handler handler = new ConsoleHandler();
        logger.addHandler(handler);

        handler.setLevel(Level.OFF);
        logger.setLevel(Level.OFF);
    }
}
