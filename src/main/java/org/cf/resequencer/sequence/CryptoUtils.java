/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
package org.cf.resequencer.sequence;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.zip.Adler32;
import java.util.zip.CRC32;
import java.util.zip.CheckedInputStream;

import org.cf.resequencer.Console;

/**
 * 
 * @author Caleb Fenton
 */
public final class CryptoUtils {

    private CryptoUtils() throws InstantiationException {
        throw new InstantiationException("This class is not created for instantiation");
    }

    public static long getCRC32Chksum(String path) throws FileNotFoundException, IOException {
        byte[] bytes = new byte[0xFFFF];
        FileInputStream fis = new FileInputStream(path);
        CRC32 chkCRC32 = new CRC32();
        CheckedInputStream cis = new CheckedInputStream(fis, chkCRC32);
        while (cis.read(bytes) >= 0) {
            ;
        }
        fis.close();

        return chkCRC32.getValue();
    }

    public static long getAdler32Chksum(String path) throws FileNotFoundException, IOException {
        byte[] bytes = new byte[0xFFFF];
        FileInputStream fis = new FileInputStream(path);
        Adler32 chkAdler32 = new Adler32();
        CheckedInputStream cis = new CheckedInputStream(fis, chkAdler32);
        while (cis.read(bytes) >= 0) {
            ;
        }
        fis.close();

        return chkAdler32.getValue();
    }

    public static String getMD5Sum(String path) throws FileNotFoundException, NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("MD5");

        InputStream is = new FileInputStream(new File(path));

        byte[] buffer = new byte[0xFFFF];
        int read = 0;
        try {
            while ((read = is.read(buffer)) > 0) {
                digest.update(buffer, 0, read);
            }
            byte[] md5sum = digest.digest();
            BigInteger bigInt = new BigInteger(1, md5sum);
            return bigInt.toString(16);
        } catch (IOException e) {
            Console.warn("Unable to process " + path + " for MD5Sum.\n" + e);
            return "";
        } finally {
            try {
                is.close();
            } catch (IOException e) {
                Console.warn("Unable to close input stream for MD5Sum.\n" + e);
                return "";
            }
        }
    }

    public static byte[] getMD5Digest(String path) throws FileNotFoundException, IOException, NoSuchAlgorithmException {
        byte[] bytes = new byte[0xFFFF];
        int byteCount;

        FileInputStream fis = new FileInputStream(path);
        MessageDigest msgDigestMD5 = MessageDigest.getInstance("MD5");

        while ((byteCount = fis.read(bytes)) > 0) {
            msgDigestMD5.update(bytes, 0, byteCount);
        }
        fis.close();

        return msgDigestMD5.digest();
    }

    public static byte[] getSHA1Digest(String path) throws FileNotFoundException, IOException, NoSuchAlgorithmException {
        byte[] bytes = new byte[0xFFFF];
        int byteCount;

        FileInputStream fis = new FileInputStream(path);
        MessageDigest msgDigestSHA1 = MessageDigest.getInstance("SHA1");

        while ((byteCount = fis.read(bytes)) > 0) {
            msgDigestSHA1.update(bytes, 0, byteCount);
        }
        fis.close();

        return msgDigestSHA1.digest();
    }
}
