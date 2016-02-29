package org.cf.resequencer.sequence;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.zip.Deflater;
import java.util.zip.ZipEntry;
import java.util.zip.ZipInputStream;
import java.util.zip.ZipOutputStream;

import org.apache.commons.io.FileUtils;
import org.cf.resequencer.Console;

/**
 * 
 * @author Caleb Fenton
 */
public class ZipUtils {
    private static File renameZipToTemp(File zipFile) throws IOException {
        File tempFile = File.createTempFile("zipapk", null);
        tempFile.delete();
        tempFile.deleteOnExit();

        FileUtils.copyFile(zipFile, tempFile);

        return tempFile;
    }

    public static void deleteZipEntry(final File zipFile, final String entryName) throws IOException {
        deleteZipEntries(zipFile, new String[] { entryName });
    }

    public static void deleteZipEntries(final File zipFile, final String[] entryNames) throws IOException {
        File tempFile = renameZipToTemp(zipFile);

        ZipInputStream zin = new ZipInputStream(new FileInputStream(tempFile));
        ZipOutputStream zout = new ZipOutputStream(new FileOutputStream(zipFile));

        zout.setLevel(Deflater.BEST_COMPRESSION);

        byte[] buf = new byte[1024];
        ZipEntry entry = zin.getNextEntry();

        while (entry != null) {
            String entryName = entry.getName();
            boolean toBeDeleted = false;
            for (String delEntry : entryNames) {
                if (entryName.startsWith(delEntry)) {
                    toBeDeleted = true;
                    break;
                }
            }

            if (!toBeDeleted) {
                // use the same method as original entry
                // to preserve stored/deflated files
                ZipEntry newEntry = new ZipEntry(entryName);
                newEntry.setMethod(entry.getMethod());

                // lie about last modified time
                newEntry.setTime(entry.getTime());

                if (newEntry.getMethod() == ZipEntry.STORED) {
                    newEntry.setSize(entry.getSize());
                    newEntry.setCompressedSize(entry.getCompressedSize());
                    newEntry.setCrc(entry.getCrc());

                    zout.setMethod(ZipOutputStream.STORED);
                    zout.setLevel(Deflater.NO_COMPRESSION);
                } else {
                    zout.setMethod(ZipOutputStream.DEFLATED);
                    zout.setLevel(Deflater.BEST_COMPRESSION);
                }

                zout.putNextEntry(newEntry);
                int len;
                while ((len = zin.read(buf)) > 0) {
                    zout.write(buf, 0, len);
                }
            }

            entry = zin.getNextEntry();
        }

        zin.close();
        zout.close();
        tempFile.delete();
    }

    public static void addFilesToZip(final File zipFile, final File[] files) throws IOException {
        String[] entryNames = new String[files.length];
        System.arraycopy(files, 0, entryNames, 0, files.length);
        addFilesToZip(zipFile, files, entryNames);
    }

    // rebuild zip file, skipping anything in files and then adding updated
    // version at the end
    // limited - cannot Store files in zip, only deflate
    public static void addFilesToZip(final File zipFile, final File[] files, final String[] entryNames)
                    throws IOException {
        File tempFile = renameZipToTemp(zipFile);

        ZipInputStream zin = new ZipInputStream(new FileInputStream(tempFile));
        ZipOutputStream zout = new ZipOutputStream(new FileOutputStream(zipFile));

        zout.setLevel(Deflater.BEST_COMPRESSION);

        byte[] buf = new byte[1024];
        ZipEntry entry;
        while ((entry = zin.getNextEntry()) != null) {
            String entryName = entry.getName();
            boolean inFiles = false;
            for (String addEntry : entryNames) {
                if (addEntry.equals(entryName)) {
                    inFiles = true;
                    break;
                }
            }

            if (!inFiles) {
                ZipEntry newEntry = new ZipEntry(entryName);
                newEntry.setMethod(entry.getMethod());

                // lie about last modified time
                newEntry.setTime(entry.getTime());

                if (newEntry.getMethod() == ZipEntry.STORED) {
                    zout.setMethod(ZipOutputStream.STORED);
                    zout.setLevel(Deflater.NO_COMPRESSION);

                    newEntry.setSize(entry.getSize());
                    newEntry.setCompressedSize(entry.getCompressedSize());
                    newEntry.setCrc(entry.getCrc());
                } else {
                    zout.setMethod(ZipOutputStream.DEFLATED);
                    zout.setLevel(Deflater.BEST_COMPRESSION);
                }

                zout.putNextEntry(newEntry);

                int len;
                while ((len = zin.read(buf)) > 0) {
                    zout.write(buf, 0, len);
                }
            }
        }

        zin.close();

        zout.setMethod(ZipOutputStream.DEFLATED);
        zout.setLevel(Deflater.BEST_COMPRESSION);

        for (int i = 0; i < files.length; i++) {
            // entry may be directory, determined by entryNames
            ZipEntry e;
            if ((entryNames != null) && (i < entryNames.length)) {
                e = new ZipEntry(entryNames[i]);
            } else {
                e = new ZipEntry(files[i].getName());
            }
            zout.putNextEntry(e);

            if (e.isDirectory()) {
                continue;
            }

            InputStream in = new FileInputStream(files[i]);

            int len;
            while ((len = in.read(buf)) > 0) {
                zout.write(buf, 0, len);
            }
            zout.closeEntry();
            in.close();
        }

        zout.close();
        tempFile.delete();
    }

    // destination name will be entryName
    public static void extractZipEntry(final File zipFile, final String entryName) {
        extractZipEntries(zipFile, new String[] { entryName }, null);
    }

    public static void extractZipEntry(final File zipFile, final String entryName, final String destPath) {
        extractZipEntries(zipFile, new String[] { entryName }, new String[] { destPath });
    }

    public static void extractZipEntries(final File zipFile, final String[] files, final String[] destPaths) {
        try {
            ZipInputStream zin = new ZipInputStream(new FileInputStream(zipFile));
            FileOutputStream fos;

            byte[] buf = new byte[1024];
            ZipEntry entry = zin.getNextEntry();
            while (entry != null) {
                int inFilesIndex = -1;
                for (int i = 0; i < files.length; i++) {
                    if (files[i].equals(entry.getName())) {
                        inFilesIndex = i;
                    }
                }

                if (inFilesIndex >= 0) {
                    File newFile = new File(entry.getName());
                    String directory = newFile.getParent();

                    if (directory == null) {
                        if (newFile.isDirectory()) {
                            break;
                        }
                    }

                    String destPath;
                    if ((destPaths == null) || (destPaths.length < inFilesIndex)) {
                        destPath = entry.getName();
                    } else {
                        destPath = destPaths[inFilesIndex];
                    }

                    makeDestDirectory(new File(destPath));

                    fos = new FileOutputStream(destPath);
                    int n;
                    while ((n = zin.read(buf, 0, 1024)) > -1) {
                        fos.write(buf, 0, n);
                    }

                    fos.close();
                    zin.closeEntry();
                }

                entry = zin.getNextEntry();
            }

            zin.close();
        } catch (Exception ex) {
            Console.error("Problem while extracting file from " + zipFile.getPath() + ": " + ex + ".");
        }
    }

    public static boolean zipEntryExists(final File zipFile, final String entryName) {
        try {
            ZipInputStream zin = new ZipInputStream(new FileInputStream(zipFile));
            ZipEntry entry = zin.getNextEntry();
            while (entry != null) {
                if (entry.getName().equals(entryName)) {
                    zin.close();
                    return true;
                }
                entry = zin.getNextEntry();
            }

            zin.close();
        } catch (Exception ex) {
            Console.error("Problem checking if zip entry exists for " + zipFile.getPath() + ": " + ex + ".");
        }

        return false;
    }

    private static void makeDestDirectory(File outf) {
        if (outf.isDirectory()) {
            if (!outf.exists()) {
                outf.mkdirs();
            }
        } else {
            File parent = outf.getParentFile();
            if (!parent.exists()) {
                parent.mkdirs();
            }
        }
    }
}
