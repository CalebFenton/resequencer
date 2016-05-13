package org.cf.resequencer;

import java.io.BufferedReader;
import java.io.File;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.Arrays;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;

/**
 * 
 * @author Caleb Fenton
 */
public final class Console {
    private static final boolean StackTrace = false;
    public static int VerboseLevel;
    public static String LogFile = "console.log";

    private Console () throws InstantiationException {
        throw new InstantiationException("This class is not created for instantiation");
    }

    public static void msgln() {
        System.out.println();
    }

    public static void msgln(final String msg) {
        System.out.println(msg);
    }

    public static void msg(final String msg) {
        System.out.print(msg);
    }

    public static void debug(final String msg) {
        if (VerboseLevel > 0) {
            System.out.println(msg);
        }
    }

    public static void debug(final String msg, final int verboseLevel) {
        if (verboseLevel <= VerboseLevel) {
            debug(msg);
        }
    }

    public static void warn(final String msg) {
        System.err.println("Warning: " + msg);
        if (StackTrace) {
            Thread.dumpStack();
        }
    }

    public static void error(final String msg) {
        System.err.println("Error: " + msg);
        if (StackTrace) {
            Thread.dumpStack();
        }
    }

    public static void die(final Exception ex) {
        die(ex, -1);
    }

    public static void die(final Exception ex, final int exitStatus) {
        if (StackTrace) {
            ex.printStackTrace();
        }
        System.err.println("" + ex);
        System.exit(exitStatus);
    }

    public static void die(final String msg) {
        die(msg, -1);
    }

    public static void die(final String msg, int exitStatus) {
        System.err.println("Fatal error: " + msg);
        if (StackTrace) {
            Thread.dumpStack();
        }
        System.exit(exitStatus);
    }

    // run command and return {result, exit status}
    public static String[] execute(String[] cmd) {
        debug("Executing: " + Arrays.asList(cmd).toString());

        StringBuffer output = new StringBuffer();
        Integer status = null;

        InputStream in = null;
        try {
            Process child = Runtime.getRuntime().exec(cmd);

            BufferedReader stdInput = new BufferedReader(new InputStreamReader(child.getInputStream()));

            String s;
            while ((s = stdInput.readLine()) != null) {
                output.append(s).append('\n');
            }

            status = child.waitFor();

            debug("Exit status: " + status, 2);
        } catch (Exception ex) {
            error("Run command failed.\n" + ex);
        } finally {
            IOUtils.closeQuietly(in);
        }

        return new String[] { output.toString(), String.valueOf(status) };
    }

    public static boolean deleteBestEffort(File path, String whatIsIt) {
        return deleteBestEffort(path, whatIsIt, 3, false);
    }

    public static boolean deleteBestEffort(File path, String whatIsIt, int maxTries) {
        return deleteBestEffort(path, whatIsIt, maxTries, false);
    }

    public static boolean deleteBestEffort(File path, String whatIsIt, int maxTries, boolean quiet) {
        System.gc();

        int tries = 0;
        while (!FileUtils.deleteQuietly(path) && (tries < maxTries)) {
            System.gc();
            tries++;

            if (!quiet) {
                warn("Unable to delete " + whatIsIt + ": " + path + ". Trying again ...");
            }

            try {
                Thread.sleep(3000);
            } catch (InterruptedException ex) {
            }
        }

        return !path.exists();
    }
}
