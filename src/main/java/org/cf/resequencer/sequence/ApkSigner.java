package org.cf.resequencer.sequence;

import java.io.ByteArrayOutputStream;
import java.io.DataInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FilterOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import java.security.DigestOutputStream;
import java.security.GeneralSecurityException;
import java.security.Key;
import java.security.KeyFactory;
import java.security.MessageDigest;
import java.security.PrivateKey;
import java.security.Signature;
import java.security.SignatureException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.KeySpec;
import java.security.spec.PKCS8EncodedKeySpec;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.jar.Attributes;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.jar.JarOutputStream;
import java.util.jar.Manifest;

import javax.crypto.Cipher;
import javax.crypto.EncryptedPrivateKeyInfo;
import javax.crypto.SecretKeyFactory;
import javax.crypto.spec.PBEKeySpec;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.cf.resequencer.Console;

import sun.misc.BASE64Encoder;
import sun.security.pkcs.ContentInfo;
import sun.security.pkcs.PKCS7;
import sun.security.pkcs.SignerInfo;
import sun.security.x509.AlgorithmId;
import sun.security.x509.X500Name;

final class ApkSigner {

    private static final String CERT_SF_NAME = "META-INF/CERT.SF";
    private static final String CERT_RSA_NAME = "META-INF/CERT.RSA";
    private static final String CERT_PATH = "/keys/certificate.pem";
    private static final String KEY_PATH = "/keys/key.pk8";

    private static final int BUFF_SIZE = 4096;

    private ApkSigner() throws InstantiationException {
        throw new InstantiationException("This class is not created for instantiation");
    }

    private static class SignatureOutputStream extends FilterOutputStream {

        private Signature mSignature;

        public SignatureOutputStream(OutputStream out, Signature sig) {
            super(out);
            mSignature = sig;
        }

        @Override
        public void write(int b) throws IOException {
            try {
                mSignature.update((byte) b);
            } catch (SignatureException e) {
                throw new IOException("SignatureException: " + e);
            }

            super.write(b);
        }

        @Override
        public void write(byte[] b, int off, int len) throws IOException {
            try {
                mSignature.update(b, off, len);
            } catch (SignatureException e) {
                throw new IOException("SignatureException: " + e);
            }
            super.write(b, off, len);
        }
    }

    public static void signApkWithCerts(String inputJarPath) {
        signApkWithCerts(inputJarPath, null);
    }

    public static void signApkWithCerts(String inputJarPath, String outputJarPath) {
        signApkWithCerts(inputJarPath, outputJarPath, (InputStream) null, null, null);
    }

    public static void signApkWithCerts(String inputJarPath, String outputJarPath, File signKey, File signCert,
                    String keyPass) {
        try {
            signApkWithCerts(inputJarPath, outputJarPath, new FileInputStream(signCert), new FileInputStream(signKey),
                            keyPass);
        } catch (FileNotFoundException ex) {
            ex.printStackTrace();
            Console.die("Exception in ApkSigner:\n" + ex, -1);
        }
    }

    public static void signApkWithCerts(String inputJarPath, String outputJarPath, InputStream signKeyStream,
                    InputStream signCertStream, String keyPass) {
        // signKey and signCert must either be null or both have values.
        JarFile inputJar = null;
        JarOutputStream outputJar = null;

        try {
            File outputJarFile;
            File inputJarFile = new File(inputJarPath);

            if (outputJarPath == null) {
                outputJarFile = File.createTempFile("apk", null);
            } else {
                outputJarFile = new File(outputJarPath);
            }

            X509Certificate cert;
            PrivateKey key;
            if ((signCertStream == null) || (signKeyStream == null)) {
                cert = readPublicKey(ApkSigner.class.getResourceAsStream(CERT_PATH));
                key = readPrivateKey(ApkSigner.class.getResourceAsStream(KEY_PATH), keyPass);
            } else {
                cert = readPublicKey(signCertStream);
                key = readPrivateKey(signKeyStream, keyPass);
            }

            // Assume the certificate is valid for at least an hour.
            long timestamp = cert.getNotBefore().getTime() + (3600L * 1000);

            inputJar = new JarFile(inputJarFile, false); // Don't verify.
            outputJar = new JarOutputStream(new FileOutputStream(outputJarFile));
            outputJar.setLevel(9);

            JarEntry je;

            // MANIFEST.MF
            Manifest manifest = addDigestsToManifest(inputJar);
            je = new JarEntry(JarFile.MANIFEST_NAME);
            je.setTime(timestamp);
            outputJar.putNextEntry(je);
            manifest.write(outputJar);

            // CERT.SF
            Signature signature = Signature.getInstance("SHA1withRSA");
            signature.initSign(key);
            je = new JarEntry(CERT_SF_NAME);
            je.setTime(timestamp);
            outputJar.putNextEntry(je);
            writeSignatureFile(manifest, new SignatureOutputStream(outputJar, signature));

            // CERT.RSA
            je = new JarEntry(CERT_RSA_NAME);
            je.setTime(timestamp);
            outputJar.putNextEntry(je);
            writeSignatureBlock(signature, cert, outputJar);

            // Everything else
            copyFiles(manifest, inputJar, outputJar);

            if (outputJarPath == null) {
                inputJar.close();
                outputJar.close();
                Console.deleteBestEffort(inputJarFile, "unsigned apk", 3, true);
                FileUtils.moveFile(outputJarFile, inputJarFile);
            }
        } catch (GeneralSecurityException ex) {
            ex.printStackTrace();
            Console.die("Security exception in ApkSigner:\n" + ex, -1);
        } catch (IOException ex) {
            ex.printStackTrace();
            Console.die("Exception in ApkSigner:\n" + ex, -1);
        } finally {
            try {
                if (inputJar != null) {
                    inputJar.close();
                }
                org.apache.commons.io.IOUtils.closeQuietly(outputJar);
            } catch (IOException ex) {
                ex.printStackTrace();
            }
        }
    }

    private static X509Certificate readPublicKey(InputStream file) throws IOException, GeneralSecurityException {
        try {
            CertificateFactory cf = CertificateFactory.getInstance("X.509");
            return (X509Certificate) cf.generateCertificate(file);
        } finally {
            file.close();
        }
    }

    private static char[] readPassword() {
        System.out.flush();
        System.out.print("\nSigning key password: ");
        return System.console().readPassword();
    }

    private static KeySpec decryptPrivateKey(byte[] encryptedPrivateKey, String keyPass)
                    throws GeneralSecurityException {
        EncryptedPrivateKeyInfo epkInfo;
        try {
            epkInfo = new EncryptedPrivateKeyInfo(encryptedPrivateKey);
        } catch (IOException ex) {
            // Probably not an encrypted key.
            Console.error("Probably not given an encrypted key." + " Exception:\n" + ex);
            return null;
        }

        char[] password;
        if (keyPass == null) {
            password = readPassword();
        } else {
            password = keyPass.toCharArray();
        }

        SecretKeyFactory skFactory = SecretKeyFactory.getInstance(epkInfo.getAlgName());
        Key key = skFactory.generateSecret(new PBEKeySpec(password));

        Cipher cipher = Cipher.getInstance(epkInfo.getAlgName());
        cipher.init(Cipher.DECRYPT_MODE, key, epkInfo.getAlgParameters());

        try {
            return epkInfo.getKeySpec(cipher);
        } catch (InvalidKeySpecException ex) {
            System.err.println("Password for keyFile may be bad.");
            throw new InvalidKeySpecException("Password for keyFile may be bad.\n" + ex);
        }
    }

    private static PrivateKey readPrivateKey(InputStream file, String keyPass) throws IOException,
                    GeneralSecurityException {
        DataInputStream input = new DataInputStream(file);
        try {
            byte[] bytes = new byte[10000];
            int nBytesTotal = 0, nBytes;
            while ((nBytes = input.read(bytes, nBytesTotal, 10000 - nBytesTotal)) != -1) {
                nBytesTotal += nBytes;
            }

            byte[] bytes2 = new byte[nBytesTotal];
            System.arraycopy(bytes, 0, bytes2, 0, nBytesTotal);
            bytes = bytes2;

            KeySpec spec = decryptPrivateKey(bytes, keyPass);
            if (spec == null) {
                spec = new PKCS8EncodedKeySpec(bytes);
            }

            try {
                return KeyFactory.getInstance("RSA").generatePrivate(spec);
            } catch (InvalidKeySpecException ex) {
                return KeyFactory.getInstance("DSA").generatePrivate(spec);
            }
        } finally {
            input.close();
        }
    }

    private static Manifest addDigestsToManifest(JarFile jar) throws IOException, GeneralSecurityException {
        Manifest input = jar.getManifest();
        Manifest output = new Manifest();
        Attributes main = output.getMainAttributes();
        if (input != null) {
            main.putAll(input.getMainAttributes());
        } else {
            main.putValue("Manifest-Version", "1.0");
            main.putValue("Created-By", "Resequencer");
        }

        MessageDigest md = MessageDigest.getInstance("SHA1");
        byte[] buffer = new byte[BUFF_SIZE];

        // Sort the input entries by name, add them to the output manifest
        // in that order. Output map expected to be deterministic.

        Map<String, JarEntry> byName = new TreeMap<String, JarEntry>();

        for (Enumeration<JarEntry> e = jar.entries(); e.hasMoreElements();) {
            JarEntry entry = e.nextElement();
            byName.put(entry.getName(), entry);
        }

        int num;
        for (JarEntry entry : byName.values()) {
            String name = entry.getName();
            if (!entry.isDirectory() && !name.equals(JarFile.MANIFEST_NAME) && !name.equals(CERT_SF_NAME) && !name
                            .equals(CERT_RSA_NAME)) {
                InputStream data = jar.getInputStream(entry);
                int bytesRemaining = (int) entry.getSize();
                while ((bytesRemaining > 0) && ((num = data.read(buffer, 0, Math.min(BUFF_SIZE, bytesRemaining))) > 0)) {
                    bytesRemaining -= num;

                    if (num > 0) {
                        md.update(buffer, 0, num);
                    }
                }

                Attributes attr = null;
                if (input != null) {
                    attr = input.getAttributes(name);
                }
                attr = attr != null ? new Attributes(attr) : new Attributes();
                attr.putValue("SHA1-Digest", Base64.encode(md.digest()));
                output.getEntries().put(name, attr);
            }
        }

        return output;
    }

    private static void writeSignatureFile(Manifest manifest, OutputStream out) throws IOException,
                    GeneralSecurityException {
        Manifest sf = new Manifest();
        Attributes main = sf.getMainAttributes();
        main.putValue("Signature-Version", "1.0");
        main.putValue("Created-By", "Resequencer");

        MessageDigest md = MessageDigest.getInstance("SHA1");
        PrintStream print = new PrintStream(new DigestOutputStream(new ByteArrayOutputStream(), md), true, "UTF-8");

        // Digest of the entire manifest
        manifest.write(print);
        print.flush();
        main.putValue("SHA1-Digest-Manifest", Base64.encode(md.digest()));

        Map<String, Attributes> entries = manifest.getEntries();
        for (Map.Entry<String, Attributes> entry : entries.entrySet()) {
            // Digest of the manifest stanza for this entry.
            print.print("Name: " + entry.getKey() + "\r\n");
            for (Map.Entry<Object, Object> att : entry.getValue().entrySet()) {
                print.print(att.getKey() + ": " + att.getValue() + "\r\n");
            }
            print.print("\r\n");
            print.flush();

            Attributes sfAttr = new Attributes();
            sfAttr.putValue("SHA1-Digest", Base64.encode(md.digest()));
            sf.getEntries().put(entry.getKey(), sfAttr);
        }

        sf.write(out);
    }

    private static void writeSignatureBlock(Signature signature, X509Certificate publicKey, OutputStream out)
                    throws IOException, GeneralSecurityException {
        SignerInfo signerInfo = new SignerInfo(new X500Name(publicKey.getIssuerX500Principal().getName()),
                        publicKey.getSerialNumber(), AlgorithmId.get("SHA1"), AlgorithmId.get("RSA"), signature.sign());

        PKCS7 pkcs7 = new PKCS7(new AlgorithmId[] { AlgorithmId.get("SHA1") }, new ContentInfo(ContentInfo.DATA_OID,
                        null), new X509Certificate[] { publicKey }, new SignerInfo[] { signerInfo });

        pkcs7.encodeSignedData(out);
    }

    private static void copyFiles(Manifest manifest, JarFile in, JarOutputStream out) throws IOException {
        Map<String, Attributes> entries = manifest.getEntries();
        List<String> names = new ArrayList<String>(entries.keySet());
        Collections.sort(names);
        for (String name : names) {
            JarEntry inEntry = in.getJarEntry(name);
            if (inEntry.getMethod() == JarEntry.STORED) {
                // Preserve the STORED method of the input entry.
                out.putNextEntry(new JarEntry(inEntry));
            } else {
                // Create a new entry so that the compressed len is recomputed.
                JarEntry je = new JarEntry(name);
                je.setTime(inEntry.getTime());
                out.putNextEntry(je);
            }

            InputStream data = in.getInputStream(inEntry);
            IOUtils.copy(data, out);

            out.flush();
        }
    }
}
