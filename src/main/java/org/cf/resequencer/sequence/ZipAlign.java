package org.cf.resequencer.sequence;

import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Enumeration;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import java.util.zip.ZipOutputStream;

import org.apache.commons.io.IOUtils;

// Experimental and unused
public class ZipAlign {

    // The adjustment is made by altering the size of the "extra" field in the
    // zip Local File Header sections. Existing data in the "extra" fields may
    // be altered by this process.
    public void align(String inApkPath, String outApkPath, int alignment) throws IOException {

        int bias = 0;

        ZipFile inApk = new ZipFile(inApkPath);
        ZipOutputStream outApkStream = new ZipOutputStream(new FileOutputStream(outApkPath));

        outApkStream.setLevel(9);

        // first, copy contents from existing war
        Enumeration<? extends ZipEntry> entries = inApk.entries();
        while (entries.hasMoreElements()) {
            int padding = 0;

            ZipEntry ze = entries.nextElement();
            ZipEntry nextEntry = new ZipEntry(ze.getName());

            // if sizes are the same, then it's not compressed
            if (ze.getSize() == ze.getCompressedSize()) {

            } else {

            }
            System.out.println("copy: " + nextEntry.getName());
            outApkStream.putNextEntry(nextEntry);
            if (!nextEntry.isDirectory()) {
                IOUtils.copy(inApk.getInputStream(nextEntry), outApkStream);
            }
            outApkStream.closeEntry();
        }

        /*
         * // now append some extra content ZipEntry e = new ZipEntry("answer.txt"); System.out.println("append: " +
         * e.getName()); outApkStream.putNextEntry(e); outApkStream.write("42\n".getBytes()); outApkStream.closeEntry();
         */
        // close
        inApk.close();
        outApkStream.close();
    }
}
