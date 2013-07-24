/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package dexequencelib;

import java.io.File;
import java.io.FilenameFilter;
import java.util.ArrayList;
import java.util.Arrays;

class SmaliFilenameFilter implements FilenameFilter {
    @Override
    public boolean accept(File dir, String name) {
        return (name.endsWith(".smali"));
    }
}

/**
 * 
 * @author Caleb Fenton
 */
public class SmaliFileFinder {
    public static File[] getSmailFiles(File dir) {
        return getSmaliFiles(dir, true);
    }

    // returns the FULL path to smali files
    public static File[] getSmaliFiles(File dir, boolean recurse) {
        ArrayList<File> smaliFiles = new ArrayList<File>();

        if (!dir.exists() || !dir.canRead()) {
            Console.warn("Smali dir " + dir + " does not exist or is not accessible.");
            return new File[0];
        }

        if (recurse) {
            String[] files = dir.list();
            String child = "";
            for (String file : files) {
                child = dir + File.separator + file;
                File childFile = new File(child);
                if (childFile.isDirectory()) {
                    smaliFiles.addAll(Arrays.asList(getSmaliFiles(childFile, recurse)));
                }
            }
        }

        // Add this directories files, being sure to prepend path name
        String[] filePaths = dir.list(new SmaliFilenameFilter());
        File[] files = new File[filePaths.length];
        for (int i = 0; i < filePaths.length; i++) {
            filePaths[i] = dir + File.separator + filePaths[i];
            files[i] = new File(filePaths[i]);
        }
        smaliFiles.addAll(Arrays.asList(files));

        Object[] o = smaliFiles.toArray();
        return Arrays.copyOf(o, o.length, File[].class);
    }
}
