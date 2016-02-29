package org.cf.resequencer.sequence;

import java.util.Collection;
import java.util.Random;

/**
 * 
 * @author Caleb Fenton
 */
public class StringUtils {

    public static final String ALPHASTR = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
    public static final String NUMSTR = "0123456789";
    public static final String SPECIALSTR = "~`!@#$%^&*()_+-=[]{}\\|;:'\",<.>/?";

    public static String generateSpecialCharString(int len) {
        return generateString(ALPHASTR + NUMSTR + SPECIALSTR, len);

    }

    public static String generateAlphaNumString(int len) {
        return generateString(ALPHASTR + NUMSTR, len);
    }

    public static String generateAlphaNumString(int minLen, int maxLen) {
        return generateString(ALPHASTR + NUMSTR, minLen, maxLen);
    }

    public static String generateAlphaString(int len) {
        return generateString(ALPHASTR, len);
    }

    public static String generateAlphaString(int minLen, int maxLen) {
        return generateString(ALPHASTR, minLen, maxLen);
    }

    public static String generateString(String charSet, int len) {
        return generateString(charSet, len, len);
    }

    public static String generateString(String charSet, int minLen, int maxLen) {
        Random rng = new Random();
        int len = minLen;

        if ((maxLen - minLen) > 0) {
            len += rng.nextInt(maxLen - minLen);
        }

        char[] text = new char[len];
        for (int i = 0; i < len; i++) {
            text[i] = charSet.charAt(rng.nextInt(charSet.length()));
        }
        return new String(text);
    }

    public static String join(Collection<?> items, String delim) {
        if (items.isEmpty()) {
            return "";
        }

        StringBuilder sb = new StringBuilder();

        for (Object o : items) {
            sb.append(o.toString());
            sb.append(delim);
        }

        sb.delete(sb.length() - delim.length(), sb.length());

        return sb.toString();
    }

    public static String toHexString(byte[] bytes) {
        char[] hexArray = { '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'A', 'B', 'C', 'D', 'E', 'F' };
        char[] hexChars = new char[bytes.length * 2];
        int v;
        for (int j = 0; j < bytes.length; j++) {
            v = bytes[j] & 0xFF;
            hexChars[j * 2] = hexArray[v / 16];
            hexChars[(j * 2) + 1] = hexArray[v % 16];
        }
        return new String(hexChars);
    }

}
