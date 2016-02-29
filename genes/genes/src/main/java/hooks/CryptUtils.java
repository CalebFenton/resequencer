package hooks;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.security.DigestInputStream;
import java.security.MessageDigest;

public class CryptUtils {
    public static String encode(byte[] data) {
        char[] table = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S',
                        'T', 'U', 'V', 'W', 'X', 'Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l',
                        'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4',
                        '5', '6', '7', '8', '9', '+', '/' };

        StringBuilder buffer = new StringBuilder();
        int pad = 0;
        for (int i = 0; i < data.length; i += 3) {
            int b = ((data[i] & 0xFF) << 16) & 0xFFFFFF;
            if ((i + 1) < data.length) {
                b |= (data[i + 1] & 0xFF) << 8;
            } else {
                pad++;
            }
            if ((i + 2) < data.length) {
                b |= (data[i + 2] & 0xFF);
            } else {
                pad++;
            }

            if (((i % 57) == 0) && (i > 0)) {
                buffer.append("\n");
            }

            while ((b & 0xFFFFFF) != 0) {
                int c = (b & 0xFC0000) >> 18;
                buffer.append(table[c]);
                b <<= 6;
            }
        }

        for (int j = 0; j < pad; j++) {
            buffer.append("=");
        }

        return buffer.toString();
    }

    public static byte[] decode(String data) {
        int[] table = { -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,
                        52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8,
                        9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, -1, 26,
                        27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
                        51, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
                        -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 };

        byte[] bytes = data.getBytes();

        StringBuilder buffer = new StringBuilder();
        for (int i = 0; i < bytes.length;) {
            int b = 0;
            if (table[bytes[i]] != -1) {
                b = (table[bytes[i]] & 0xFF) << 18;
            } else {
                // skipping unknown character
                i++;
                continue;
            }

            if (((i + 1) < bytes.length) && (table[bytes[i + 1]] != -1)) {
                b = b | ((table[bytes[i + 1]] & 0xFF) << 12);
            }
            if (((i + 2) < bytes.length) && (table[bytes[i + 2]] != -1)) {
                b = b | ((table[bytes[i + 2]] & 0xFF) << 6);
            }
            if (((i + 3) < bytes.length) && (table[bytes[i + 3]] != -1)) {
                b = b | (table[bytes[i + 3]] & 0xFF);
            }

            while ((b & 0xFFFFFF) != 0) {
                int c = (b & 0xFF0000) >> 16;
                buffer.append((char) c);
                b <<= 8;
            }

            i += 4;
        }

        return buffer.toString().getBytes();
    }

    public static String md5(File f) {
        MessageDigest md = null;
        InputStream is = null;
        try {
            md = MessageDigest.getInstance("MD5");
            is = new FileInputStream(f);
            is = new DigestInputStream(is, md);
            byte[] buffer = new byte[8192];
            while (is.read(buffer) != -1) {
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            try {
                is.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        byte[] digest = md.digest();
        return digest.toString();
    }
}