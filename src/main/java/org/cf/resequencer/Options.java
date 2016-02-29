package org.cf.resequencer;

import java.io.File;
import java.io.IOException;
import java.net.URISyntaxException;
import java.util.ArrayList;
import java.util.UUID;

import org.cf.resequencer.patch.SmaliHinter;

/**
 * Convenient storage of all command line options
 * 
 * @author Caleb Fenton
 */
public class Options {

    private static final int MaxVerboseLevel = 3;
    public static int VerboseLevel = 0;
    public static boolean SkipAssembly = false;
    public static boolean SkipCleanup = false;
    public static boolean DecodeResources = false;
    public static boolean SignOnly = false;
    public static boolean DetectOnly = false;
    public static boolean InfoOnly = false;
    public static boolean AssembleOnly = false;
    public static boolean AllowOverwrites = false;
    public static boolean ListFPsOnly = false;
    public static boolean SkipHints = false;
    public static int CheckSigsBehavior = 0;
    public static int GetPIBehavior = 0;
    public static int SigVerifyBehavior = 0;
    public static int DeviceIDSpoofType = 0;
    public static String DeviceIDSpoof = "";
    public static int WifiMacSpoofType = 0;
    public static String WifiMacSpoof = "";
    public static int BTMacSpoofType = 0;
    public static String BTMacSpoof = "";
    public static int AccountNameSpoofType = 0;
    public static String AccountNameSpoof = "";
    public static String NetworkOperatorSpoof = "";
    public static String DeviceModelSpoof = "";
    public static String DeviceManufacturerSpoof = "";
    public static ArrayList<String> ExcludedFPs = new ArrayList<String>();
    public static ArrayList<String> IncludedFPs = new ArrayList<String>();
    public static String SmaliDir = "";
    public static String ApkPath = "";
    public static String DexPath = "";
    public static String OutputApk = "";
    public static String SignedApk = "";
    public static String UnsignedApk = "";
    public static String AaptPath = "";
    public static String ZipalignPath = "";
    public static String KeyApkPath = "";
    public static File SignKey = null;
    public static File SignCert = null;
    public static String SignPass = null;
    public static boolean DebugHooks = false;

    // returns false if options are not valid
    public static void parseArgs(String[] args) {
        // https://www.karlin.mff.cuni.cz/network/prirucky/javatut/java/cmdLineArgs/parsing.html
        String arg;
        int argPos = 0;

        while ((argPos < args.length) && args[argPos].startsWith("-")) {
            arg = args[argPos++];

            if (arg.startsWith("-v") || arg.startsWith("--verbose")) {
                String level = arg.startsWith("-v") ? arg.replace("-v", "") : arg.replace("--verbose", "");
                VerboseLevel = level.isEmpty() ? 1 : Integer.parseInt(level);
                if (VerboseLevel > MaxVerboseLevel) {
                    VerboseLevel = MaxVerboseLevel;
                } else if (VerboseLevel < 1) {
                    VerboseLevel = 1;
                }

                Console.VerboseLevel = VerboseLevel;
                Console.debug("Option: Verbose level set to " + VerboseLevel);
            } else if (arg.equals("-s") || arg.equals("--skip-assembly")) {
                Console.debug("Option: Skipping assembly.");
                SkipAssembly = true;
            } else if (arg.equals("--skip-cleanup")) {
                Console.debug("Option: Skipping cleanup.");
                SkipCleanup = true;
            } else if (arg.equals("--decode-res")) {
                Console.debug("Option: Decoding resources.");
                DecodeResources = true;
            } else if (arg.equals("-d") || arg.equals("--detect-only")) {
                Console.debug("Option: Determining protection information only.");
                DetectOnly = true;
            } else if (arg.equals("-f") || arg.equals("--force")) {
                Console.debug("Option: Allowing file overwrites.");
                AllowOverwrites = true;
            } else if (arg.equals("--sign-only")) {
                Console.debug("Option: Signing only.");
                SignOnly = true;
                AllowOverwrites = true; // disable any checking, wont be needed
                SkipCleanup = true;
            } else if (arg.equals("--sign-key")) {
                arg = args[argPos++];
                SignKey = new File(arg);
                if (!SignKey.exists()) {
                    Console.die("Signing key does not exist: " + arg);
                }
            } else if (arg.equals("--sign-cert")) {
                arg = args[argPos++];
                SignCert = new File(arg);
                if (!SignCert.exists()) {
                    Console.die("Signing certificate does not exist: " + arg);
                }
            } else if (arg.equals("--sign-pass")) {
                SignPass = args[argPos++];
            } else if (arg.equals("--info-only")) {
                Console.debug("Option: Getting info only.");
                InfoOnly = true;
                AllowOverwrites = true; // disable any checking, wont be needed
            } else if (arg.equals("--assemble-only")) {
                Console.debug("Option: Assembling only.");
                AssembleOnly = true;
            } else if (arg.equals("--fplist")) {
                ListFPsOnly = true;
            } else if (arg.equals("--fpexclude")) {
                arg = args[argPos++];
                String fps[] = arg.split(",");

                for (String fp : fps) {
                    ExcludedFPs.add(fp.trim());
                }

                Console.debug("Option: Excluding fingerprints: " + arg);
            } else if (arg.equals("--fpinclude")) {
                arg = args[argPos++];
                String fps[] = arg.split(",");

                for (String fp : fps) {
                    IncludedFPs.add(fp.trim());
                }

                Console.debug("Option: Including fingerprints: " + arg);
            } else if (arg.equals("--chksigs")) {
                arg = args[argPos++];
                CheckSigsBehavior = Integer.parseInt(arg);
            } else if (arg.equals("--getpi")) {
                arg = args[argPos++];
                GetPIBehavior = Integer.parseInt(arg);
            } else if (arg.equals("--sigvfy")) {
                arg = args[argPos++];
                SigVerifyBehavior = Integer.parseInt(arg);
            } else if (arg.equals("--spoof-id")) {
                arg = args[argPos++];
                DeviceIDSpoofType = Integer.parseInt(arg);

                // These are enabled=false by default
                IncludedFPs.add("Hook Get Secure Setting");
                IncludedFPs.add("Hook Device ID");

                if (DeviceIDSpoofType == 5) {
                    DeviceIDSpoof = args[argPos++];

                    // device id must be 15 characters, numeric only
                    if (!DeviceIDSpoof.matches("\\d{15}")) {
                        Console.die("Spoofed device ID is must be 15 digits.", -1);
                    }
                }
            } else if (arg.equals("--spoof-account")) {
                arg = args[argPos++];
                AccountNameSpoofType = Integer.parseInt(arg);

                // These are enabled=false by default
                IncludedFPs.add("Hook Get Account Name");

                if (AccountNameSpoofType == 3) {
                    AccountNameSpoof = args[argPos++].toUpperCase();

                    if (!AccountNameSpoof.matches("[a-zA-Z0-9\\.]+")) {
                        Console.die("Spoofed Account Name must be alpha-numeric!", -1);
                    }
                }
            } else if (arg.equals("--spoof-wifimac")) {
                arg = args[argPos++];
                WifiMacSpoofType = Integer.parseInt(arg);

                // These are enabled=false by default
                IncludedFPs.add("Hook Get Wifi Mac");

                if (WifiMacSpoofType == 3) {
                    WifiMacSpoof = args[argPos++].toUpperCase();

                    if (!WifiMacSpoof.matches("(?m)^([0-9A-F]{2}([:-]|$)){6}$")) {
                        Console.die("Spoofed Wifi MAC must be of the form 11:22:33:AA:BB:CC !", -1);
                    }
                }
            } else if (arg.equals("--spoof-btmac")) {
                arg = args[argPos++];
                BTMacSpoofType = Integer.parseInt(arg);

                // These are enabled=false by default
                IncludedFPs.add("Hook Bluetooth MAC");

                if (BTMacSpoofType == 3) {
                    BTMacSpoof = args[argPos++].toUpperCase();

                    if (!BTMacSpoof.matches("(?m)^([0-9A-F]{2}([:-]|$)){6}$")) {
                        Console.die("Spoofed BT MAC must be of the form 11:22:33:AA:BB:CC !", -1);
                    }
                }
            } else if (arg.equals("--spoof-model")) {
                arg = args[argPos++];

                // This is enabled=false by default
                IncludedFPs.add("Hook Device Model");

                Options.DeviceModelSpoof = arg;
                Console.debug("Spoofing model as " + Options.DeviceModelSpoof);
            } else if (arg.equals("--spoof-network")) {
                arg = args[argPos++];

                // This is enabled=false by default
                IncludedFPs.add("Hook Network Operator");

                Options.NetworkOperatorSpoof = arg;
                Console.debug("Spoofing network operator as " + Options.NetworkOperatorSpoof);
            } else if (arg.equals("--spoof-manufacturer")) {
                arg = args[argPos++];

                // This is enabled=false by default
                IncludedFPs.add("Hook Device Manufacturer");

                Options.DeviceManufacturerSpoof = arg;
                Console.debug("Spoofing manufacturer as " + Options.DeviceManufacturerSpoof);
            } else if (arg.equals("--key-apk")) {
                KeyApkPath = args[argPos++];
                File f = new File(KeyApkPath);
                if (!f.exists()) {
                    Console.die("The key apk " + KeyApkPath + " does not exist!");
                }
            } else if (arg.equals("--trace")) {
                Console.debug("Option: Enabling method trace and debug hooks.");
                IncludedFPs.add("Method Trace");
                IncludedFPs.add("Method Trace FixLocals");
                DebugHooks = true;
            } else if (arg.equals("--translate")) {
                Console.debug("Option: Enabling Smali string language translation.");
                SmaliHinter.enableTranslations();
            } else if (arg.equals("-h") || arg.equals("--help")) {
                showUsage();
                System.exit(0);
            } else if (arg.equals("--dbghooks")) {
                Console.debug("Option: Using debugging hooks.");
                DebugHooks = true;
            } else if (arg.equals("--skip-hints")) {
                Console.debug("Option: Skipping smali hint generation.");
                SkipHints = true;
            } else {
                Console.die("Unknown option: " + arg + ".", -1);
            }
        }

        // No bother processing the rest of the logic, we just want FP listing
        if (ListFPsOnly) {
            return;
        }

        // If either is alone, no bueno!
        if ((SignKey != null) ^ (SignKey != null)) {
            Console.die("Options --sign-key and --sign-cert must be used together.");
        }

        if (argPos == args.length) {
            Console.error("Oopsy! Dump path / Apk file missing. Please review:");
            showUsage();
            System.exit(-1);
        }

        // Make sure smali dump / apk exists
        File input = ensureExists(args[argPos]);

        if (input.isDirectory()) {
            if (SignOnly) {
                Console.die("Sign only option enabled but input is not an APK file.");
            }

            SmaliDir = input.getPath();

            if (!SkipAssembly) {
                if ((argPos + 1) >= args.length) {
                    Console.die("Output APK required.");
                }

                OutputApk = args[argPos + 1];
                ensureExists(OutputApk);
            }
        } else {
            if (AssembleOnly) {
                Console.die("Option --assemble-only only works with smali dump directories.");
            }

            ApkPath = input.getPath();
            OutputApk = ApkPath.replace(".apk", "");

            if (args.length <= (argPos + 1)) {
                // overwrite original by default
                if (SignOnly || DetectOnly || SkipAssembly || InfoOnly) {
                    OutputApk = ApkPath;
                } else {
                    OutputApk += "_sequenced.apk";
                }
            } else {
                OutputApk = args[argPos + 1];
            }
        }

        Console.debug("Output apk: " + OutputApk);
        Console.debug("Apk path: " + ApkPath);

        if (!DetectOnly && !SkipAssembly) {
            enforceOverwrite(OutputApk, "output file");
        }
    }

    public static void enforceOverwrite(final String filePath, final String whatIsIt) {
        if (!AllowOverwrites) {
            if (new File(filePath).exists()) {
                Console.die("The " + whatIsIt + " " + filePath + " already exists.\n"
                                + "Delete and try again or use --force option.");
            }
        }
    }

    public static boolean givenApkFile() {
        return !ApkPath.isEmpty();
    }

    private static File ensureExists(final String filePath) {
        File f = new File(filePath);
        if (!f.exists()) {
            Console.die(f.getPath() + " does not exist.");
        }
        return f;
    }

    public static String getUniquePath() {
        String unique = System.getProperty("java.io.tmpdir") + UUID.randomUUID().toString();
        File f;
        try {
            f = new File(unique);
            unique = f.getCanonicalPath();
        } catch (IOException ex) {
            Console.error("Strange file error.\n" + ex);
        }

        Console.debug("Generated unique path: " + unique, 3);
        return unique;
    }

    public static void showUsage() {
        String jarName;
        try {
            File f = new File((org.cf.resequencer.Main.class.getProtectionDomain().getCodeSource().getLocation().toURI()));
            jarName = f.getName();
        } catch (URISyntaxException ex) {
            jarName = "sequencer.jar";
            Console.warn("Strange... Unable to determine our path! Assuming " + jarName + ".\n" + ex);
        }

        Console.msgln("Usage: java -jar " + jarName + " [options] <Apktool/Baksmali dump | Apk file> [Output Apk]\n"
                        + "General Options:\n" + "  -f, --force\t\tAllow overwriting of any existent file\n"
                        + "  -s, --skip-assembly\tDecompile and modify but do not rebuild\n"
                        + "  -d, --detect-only\tDetect protection information only\n"
                        + "  --sign-only\t\tSign Apk file then exit\n" + "  --info-only\t\tGet App info then exit\n"
                        + "  --assemble-only\tAssemble dump, update Output Apk, sign, zipalign, exit\n"
                        + "  --skip-cleanup\tDo not delete dump directory after running\n"
                        + "  --skip-protect\tDo not protect with anti-dissassembly methods\n"
                        + "  --decode-res\t\tDecode XML resources and use them for Smali hints\n"
                        + "  --sign-key\t\tPK8 key to sign with (requires --sign-cert)\n"
                        + "  --sign-cert\t\tPEM certificate to sign with (reqires --sign-key)\n"
                        + "  --sign-pass\t\tPassword to use with signature\n"
                        + "  --fplist\t\tList installed fingerprints\n"
                        + "  --fpexclude\t\tComma-separated list of fingerprints to exclude\n"
                        + "  --fpinclude\t\tComma-separated list of fingerprints to include\n"
                        + "  --trace\t\tTrace all method calls in the logs (noisy!)\n"
                        + "  --dbghooks\t\tUse unobfuscated debugging hooks\n"
                        + "  -v#, --verbose#\tVerbose level (1-3)\n" + "  -h, --help\t\tShow this friendly message\n"
                        + "\nHint Options:\n" + "  --skip-hints\t\tSkip Smali hinting\n" + "\nHook Options:\n"
                        + "  --chksigs #\t\tCheck signatures behavior\n"
                        + "    0 - *default* only match signatures if installed\n"
                        + "    1 - always return signature match\n" + "  --getpi #\t\tGet PackageInfo behavior\n"
                        + "    0 - *default* spoof key/pro/full Apps if not installed\n"
                        + "    1 - do not spoof apps not installed\n" + "  --sigvfy #\t\tSignature.verify() behavior\n"
                        + "    0 - *default* always return true\n" + "    1 - return actual result of verify\n"
                        + "  --spoof-id # [15 digit device ID]\n" + "    Fake the Android / Device ID\n"
                        + "    0 - *default* no spoofing, 1 - always random, 2 - session random\n"
                        + "    3 - session permute, 4 - emulator (all 0s), 5 - user defined\n"
                        + "  --spoof-model <model>\n"
                        + "    Fake device model with given string, eg \"Galaxy Nexus\".\n"
                        + "  --spoof-manufacturer <manufacturer>\n"
                        + "    Fake device manufacturer with given string, eg \"Samsung\".\n"
                        + "  --spoof-account # [account name]\n"
                        + "    Fake the accout name checks (usually Google account)\n"
                        + "    0 - *default* no spoofing, 1 - always random\n"
                        + "    2 - session random, 3 - user defined\n" + "  --spoof-network <string>\n"
                        + "    Fake the network operator name, eg. t-mobile, sprint, nextel\n"
                        + "  --spoof-btmac # [MAC eg. 11:22:33:AA:BB:CC]\n" + "    Fake bluetooth MAC address\n"
                        + "    0 - *default* no spoofing, 1 - always random\n"
                        + "    2 - session random, 3 - user defined\n"
                        + "  --spoof-wifimac # [MAC eg. 11:22:33:AA:BB:CC]\n" + "    Fake WiFi MAC address\n"
                        + "    0 - *default* no spoofing, 1 - always random\n"
                        + "    2 - session random, 3 - user defined\n"
                        + "  --key-apk <key apk path> Collect fidelity information for key apk\n");
    }
}
