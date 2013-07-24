package dexequencelib;

import java.io.File;
import java.io.IOException;
import java.security.DigestException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.Arrays;
import java.util.Random;
import java.util.zip.Adler32;

import org.apache.commons.io.FileUtils;

/**
 * 
 * @author Caleb Fenton
 */
public class DexFile {

    private static final int OFF_LINK_SIZE = 44;
    private static final int OFF_LINK_OFF = 48;
    private static final int INT_SIZE = 4;

    private static final byte[] InvalidRef = new byte[] { 0x4e, 0x01, 0x01, 0x01, 0x00, 0x00 // aput-bool p0, p0, p0;
                                                                                             // nop
    };

    private byte[] DexBytes;
    protected File DexFile;

    DexFile(File dexFile) throws IOException {
        DexFile = dexFile;
        DexBytes = FileUtils.readFileToByteArray(dexFile);
    }

    /*
     * Do whatever we can to the dex file to prevent decompilers from working.
     */
    public void dexLock() {
        /*
         * byte[] header = new byte[0x70]; System.arraycopy(DexBytes, 0, header, 0, 0x70);
         * System.out.println(StringUtils.toHexString(header)); for ( int i = 0; i < header.length; i++ ) {
         * System.out.print(header[i] + " "); }
         * 
         * for ( int i = 0; i < 0x70; i++ ) { System.out.print(DexBytes[i] +" "); } System.exit(0);
         */

        Random rng = new Random();
        byte[] val = new byte[4];

        // 40-43 = endian tag (ignore for now)

        System.arraycopy(DexBytes, OFF_LINK_SIZE, val, 0, INT_SIZE);
        Console.debug("DexLock - link size: " + StringUtils.toHexString(val));

        // only randomize last two bytes (little endian)
        // otherwise it may be too big and install will fail
        val = new byte[] { (byte) (rng.nextInt(15) + 1), 0, 0, 0 };
        System.arraycopy(val, 0, DexBytes, OFF_LINK_SIZE, INT_SIZE);
        Console.debug("DexLock - new link size: " + StringUtils.toHexString(val));

        System.arraycopy(DexBytes, OFF_LINK_OFF, val, 0, INT_SIZE);
        Console.debug("DexLock - link offset: " + StringUtils.toHexString(val));

        // only randomize last byte. otherwise might be too big.
        val = new byte[] { (byte) (rng.nextInt(15) + 1), 0, 0, 0 };

        System.arraycopy(val, 0, DexBytes, OFF_LINK_OFF, INT_SIZE);
        Console.debug("DexLock - new link offset: " + StringUtils.toHexString(val));

        int refPos = 0x70; // start at end of header
        // find every instance of bytes we need to replace
        while ((refPos = indexOf(DexBytes, InvalidRef, refPos)) != -1) {
            Console.debug("DexLock - injecting invalid reference @" + refPos);
            // inject random 21c (minor subset) instruction with wildy bad reference
            val = new byte[] { (byte) (0x60 + rng.nextInt(0xE)), (byte) (0x01 + rng.nextInt(0x75)),
                            (byte) (0x64 + rng.nextInt(0x1F)), (byte) (0x50 + rng.nextInt(0x40)),
                            (byte) rng.nextInt(255), (byte) rng.nextInt(255) };
            System.arraycopy(val, 0, DexBytes, refPos, val.length);
        }

        calcSignature();
        calcChecksum();
        save();
    }

    public void dexUnlock() {
        if (!dexIsLocked()) {
            return;
        }

        Console.msgln("Dex file is locked! Unlocking ...");

        byte[] val = new byte[4];

        System.arraycopy(DexBytes, OFF_LINK_SIZE, val, 0, INT_SIZE);
        Console.debug("DexUnlock - link size: " + StringUtils.toHexString(val));

        val = new byte[] { 0, 0, 0, 0 };
        System.arraycopy(val, 0, DexBytes, OFF_LINK_SIZE, INT_SIZE);
        Console.debug("DexUnlock - new link size: " + StringUtils.toHexString(val));

        System.arraycopy(DexBytes, OFF_LINK_OFF, val, 0, INT_SIZE);
        Console.debug("DexUnlock - link offset: " + StringUtils.toHexString(val));

        val = new byte[] { 0, 0, 0, 0 };
        System.arraycopy(val, 0, DexBytes, OFF_LINK_OFF, INT_SIZE);
        Console.debug("DexUnlock - new link offset: " + StringUtils.toHexString(val));

        calcSignature();
        calcChecksum();
        save();
    }

    public boolean dexIsLocked() {
        byte[] val = new byte[4];
        byte[] goodVal = new byte[] { 0, 0, 0, 0 };

        System.arraycopy(DexBytes, OFF_LINK_SIZE, val, 0, INT_SIZE);
        if (!Arrays.equals(val, goodVal)) {
            return true;
        }

        System.arraycopy(DexBytes, OFF_LINK_OFF, val, 0, INT_SIZE);
        if (!Arrays.equals(val, goodVal)) {
            return true;
        }

        return false;
    }

    private void save() {
        try {
            FileUtils.writeByteArrayToFile(DexFile, DexBytes);
        } catch (IOException ex) {
            Console.warn("Unable to save " + DexFile + ".\n" + ex);
        }
    }

    private void calcSignature() {
        MessageDigest md;

        try {
            md = MessageDigest.getInstance("SHA-1");
        } catch (NoSuchAlgorithmException ex) {
            throw new RuntimeException(ex);
        }

        md.update(DexBytes, 32, DexBytes.length - 32);

        try {
            int amt = md.digest(DexBytes, 12, 20);
            if (amt != 20) {
                throw new RuntimeException("Unexpected digest write: " + amt + " bytes");
            }
        } catch (DigestException ex) {
            throw new RuntimeException(ex);
        }
    }

    /**
     * Calculates the checksum for the <code>.dex</code> file in the given array, and modify the array to contain it.
     * 
     * @param bytes
     *            non-null; the bytes of the file
     */
    private void calcChecksum() {
        Adler32 a32 = new Adler32();

        a32.update(DexBytes, 12, DexBytes.length - 12);

        int sum = (int) a32.getValue();

        DexBytes[8] = (byte) sum;
        DexBytes[9] = (byte) (sum >> 8);
        DexBytes[10] = (byte) (sum >> 16);
        DexBytes[11] = (byte) (sum >> 24);
    }

    private int indexOf(byte[] src, byte[] find, final int fromIndex) {
        boolean found = false;
        int pos;
        for (pos = fromIndex; pos < (src.length - find.length); pos++) {
            if (src[pos] == find[0]) {
                found = true;
                for (int j = 0; j < find.length; j++) {
                    if (src[pos + j] != find[j]) {
                        found = false;
                        break;
                    }
                }
            }
            if (found) {
                break;
            }
        }

        if (!found) {
            return -1;
        }

        return pos;
    }
}
