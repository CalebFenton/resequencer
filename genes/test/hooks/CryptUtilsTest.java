package hooks;

import java.util.Arrays;

import junit.framework.TestCase;

public class CryptUtilsTest extends TestCase {
    private static final String Plaintext = "It is by will alone I set my mind in motion.!@#$%^&*()_+<>:\"{};:'";
    private static final String Encoded = "SXQgaXMgYnkgd2lsbCBhbG9uZSBJIHNldCBteSBtaW5kIGluIG1vdGlvbi4hQCMkJV4mKigpXys8\n"
                    + "Pjoie307Oic=";

    public void testEncode() {
        String encoded = CryptUtils.encode(Plaintext.getBytes());

        assert encoded.equals(Encoded);
    }

    public void testDecode() {
        byte[] decoded = CryptUtils.decode(Encoded);

        assert Arrays.equals(decoded, Plaintext.getBytes());
    }

}
