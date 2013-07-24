package dexequencelib;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.lang.ref.WeakReference;
import java.security.cert.Certificate;
import java.security.cert.CertificateEncodingException;
import java.util.Enumeration;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

/**
 * Stores package information about an Apk file.
 * 
 * @author Caleb Fenton
 */
public class AppInfo {

    public boolean UsesLicensing;
    public boolean UsesNativeModules;
    public String AppVersionName;
    public String AppVersionCode;
    public String AppPackageName;
    public int AppMinSDK = 0;
    public String[] SignatureChars;
    public String[] SignatureHashes;
    public String LaunchActivity;
    public String MD5Sum;
    // digests are byte[], but we store as base64 encoded (safe) strings
    // to more easily pass to hooks
    public String ApkDigestMD5;
    public String ApkDigestSHA1;
    public long ApkChecksumCRC32;
    public long ApkChecksumAdler32;
    public String DexDigestMD5;
    public String DexDigestSHA1;
    public long DexChecksumCRC32;
    public long DexChecksumAdler32;
    public long ZipClassesDexCrc = 0;
    public long ZipClassesDexSize = 0;
    public long ZipClassesDexCompressedSize = 0;
    public Certificate[] Certificates;
    public long ApkFileSize;
    public long ApkLastModified;
    public long ClassesDexFileSize;
    public long ClassesDexLastModified;
    public int CertsLoaded = 0;
    private String mApkPath, mAaptPath;
    private static final Object mSync = new Object();
    private WeakReference<byte[]> mReadBuffer;

    AppInfo(String apkPath, String aaptPath) {
        mApkPath = apkPath;
        mAaptPath = aaptPath;

        loadApkProperties();
    }

    private void loadApkProperties() {
        loadApkAaptProps();
        loadApkCertProps();
        loadApkFileProps();
        loadApkZipEntryProps();
        loadApkChecksums();
    }

    private void loadApkAaptProps() {
        String[] info = Console.execute(new String[] { mAaptPath, "d", "--values", "badging", "\"" + mApkPath + "\"" });
        Matcher m;

        Console.debug("Badging values:\n" + info[0], 2);

        // Parse info for package name. Assuming it's always there.
        m = Pattern.compile("(?im)^package: name='\\S+?'").matcher(info[0]);
        if (m.find()) {
            AppPackageName = info[0].substring(m.start() + "package: name='".length(), m.end() - "'".length());
        } else {
            AppPackageName = "unknown";
        }

        // Parse for version code
        m = Pattern.compile("versionCode='\\d+'").matcher(info[0]);
        if (m.find()) {
            AppVersionCode = info[0].substring(m.start() + "versionCode='".length(), m.end() - "'".length());
        } else {
            AppVersionCode = "unknown";
        }

        // Parse for version name
        m = Pattern.compile("versionName='\\d+'").matcher(info[0]);
        if (m.find()) {
            AppVersionName = info[0].substring(m.start() + "versionName='".length(), m.end() - "'".length());
        } else {
            AppVersionName = "unknown";
        }

        // Get first launchable activity
        m = Pattern.compile("launchable( |-)activity(:)? name='(\\S+?)'").matcher(info[0]);
        System.out.println("info: " + info[0]);

        if (m.find()) {
            // Will be of the form: com.package.Main but we want com/package/Main
            // to match .class public Lcom.package.Main
            LaunchActivity = m.group(3).replaceAll("\\.", "/");
        } else {
            LaunchActivity = "unknown";
            Console.warn("Unable to detect launchable activity. Not super important.");
        }

        // Parse info for check license permission
        // com.android.vending.CHECK_LICENSE
        m = Pattern.compile("(?im)^uses-permission:'com\\.android\\.vending" + "\\.CHECK_LICENSE'").matcher(info[0]);
        UsesLicensing = m.find();

        // minSdkVersion is used by some ops
        m = Pattern.compile("minSdkVersion:'\\d+?'").matcher(info[0]);
        if (m.find()) {
            AppMinSDK = Integer.parseInt(info[0].substring(m.start() + "minSdkVersion:'".length(),
                            m.end() - "'".length()));
        } else {
            AppMinSDK = 1;
        }

        m = Pattern.compile("(?m)^native-code:").matcher(info[0]);
        if (m.find()) {
            UsesNativeModules = true;
        }
    }

    private void loadApkCertProps() {
        Certificates = getCerts();

        SignatureHashes = new String[Certificates.length];
        SignatureChars = new String[Certificates.length];

        for (int i = 0; i < Certificates.length; i++) {
            String str = "0x" + Integer.toHexString(Certificates[i].hashCode());
            SignatureHashes[i] = str;

            str = "unknown";
            try {
                str = new String(certToChars(Certificates[i].getEncoded()));
            } catch (CertificateEncodingException ex) {
                Console.warn("Certificate encoding exception: " + ex);
            }
            SignatureChars[i] = str;
        }
    }

    private void loadApkFileProps() {
        File apkFile = new File(mApkPath);
        ApkFileSize = apkFile.length();
        ApkLastModified = apkFile.lastModified();

        File f = null;
        try {
            f = File.createTempFile("dex", "reseq");
            f.deleteOnExit();
            ZipUtils.extractZipEntry(apkFile, "classes.dex", f.getPath());
        } catch (IOException ex) {
            Console.die("Unable to extract classes.dex to load properties.\n" + ex);
        }

        try {
            DexDigestMD5 = Base64.encode(CryptoUtils.getMD5Digest(f.getPath()));
            DexDigestSHA1 = Base64.encode(CryptoUtils.getMD5Digest(f.getPath()));
            DexChecksumCRC32 = CryptoUtils.getCRC32Chksum(f.getPath());
            DexChecksumAdler32 = CryptoUtils.getAdler32Chksum(f.getPath());
        } catch (Exception ex) {
            Console.die("Unable to load classes.dex checksums with exception:\n" + ex);
        }

        ClassesDexFileSize = f.length();
        ClassesDexLastModified = f.lastModified();
    }

    private Certificate[] getCerts() {
        WeakReference<byte[]> readBufferRef;
        byte[] readBuffer = null;
        synchronized (mSync) {
            readBufferRef = mReadBuffer;
            if (readBufferRef != null) {
                mReadBuffer = null;
                readBuffer = readBufferRef.get();
            }
            if (readBuffer == null) {
                readBuffer = new byte[8192];
                readBufferRef = new WeakReference<byte[]>(readBuffer);
            }
        }

        Certificate[] certs = null;
        try {
            JarFile jarFile = new JarFile(mApkPath);

            Enumeration entries = jarFile.entries();
            while (entries.hasMoreElements()) {
                JarEntry je = (JarEntry) entries.nextElement();
                if (je.isDirectory()) {
                    continue;
                }
                if (je.getName().startsWith("META-INF/")) {
                    continue;
                }
                java.security.cert.Certificate[] localCerts = loadCertificates(jarFile, je, readBuffer);

                if (localCerts == null) {
                    Console.error("Package has no certificates at entry " + je.getName() + "; ignoring!");
                    jarFile.close();
                    return null;
                } else if (certs == null) {
                    certs = localCerts;
                } else {
                    // Ensure all certificates match.
                    for (Certificate cert : certs) {
                        boolean found = false;
                        for (Certificate localCert : localCerts) {
                            if ((cert != null) && cert.equals(localCert)) {
                                found = true;
                                break;
                            }
                        }
                        if (!found || (certs.length != localCerts.length)) {
                            Console.error("Package has mismatched certificates at entry " + je.getName()
                                            + "; ignoring!");
                            jarFile.close();
                            return null; // false
                        }
                    }
                }
            }

            jarFile.close();

            synchronized (mSync) {
                mReadBuffer = readBufferRef;
            }
        } catch (Exception ex) {
            Console.error("Exception reading " + mApkPath + "\n" + ex);
            ex.printStackTrace();
        }

        return certs;
    }

    public static char[] certToChars(byte[] mSignature) {
        byte[] sig = mSignature;
        final int N = sig.length;
        final int N2 = N * 2;
        char[] text = new char[N2];

        for (int j = 0; j < N; j++) {
            byte v = sig[j];
            int d = (v >> 4) & 0xf;
            text[j * 2] = (char) (d >= 10 ? (('a' + d) - 10) : ('0' + d));
            d = v & 0xf;
            text[(j * 2) + 1] = (char) (d >= 10 ? (('a' + d) - 10) : ('0' + d));
        }

        return text;
    }

    private Certificate[] loadCertificates(JarFile jarFile, JarEntry je, byte[] readBuffer) {
        try {
            // We must read the stream for the JarEntry to retrieve
            // its certificates.
            InputStream is = jarFile.getInputStream(je);
            while (is.read(readBuffer, 0, readBuffer.length) != -1) {
                ;
            }
            is.close();

            CertsLoaded++;
            return je != null ? je.getCertificates() : null;
        } catch (Exception e) {
            Console.error("Exception reading " + je.getName() + " in " + jarFile.getName() + ":\n" + e);
        }

        return null;
    }

    private void loadApkZipEntryProps() {
        ZipFile zf = null;
        try {
            zf = new ZipFile(mApkPath);
        } catch (IOException ex) {
            Console.die("Unable to get ZipEntry properties for classes.dex.\n" + ex);
        }

        if (zf == null) {
            return;
        }

        ZipEntry ze = zf.getEntry("classes.dex");
        ZipClassesDexCrc = ze.getCrc();
        ZipClassesDexSize = ze.getSize();
        ZipClassesDexCompressedSize = ze.getCompressedSize();
    }

    private void loadApkChecksums() {
        try {
            ApkDigestMD5 = Base64.encode(CryptoUtils.getMD5Digest(mApkPath));
            ApkDigestSHA1 = Base64.encode(CryptoUtils.getSHA1Digest(mApkPath));

            ApkChecksumCRC32 = CryptoUtils.getCRC32Chksum(mApkPath);
            ApkChecksumAdler32 = CryptoUtils.getAdler32Chksum(mApkPath);

            MD5Sum = CryptoUtils.getMD5Sum(mApkPath);
        } catch (Exception ex) {
            Console.die("Failed to load Apk checksums with exception:\n" + ex);
        }
    }
}
