package org.cf.resequencer.patch;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.util.HashMap;
import java.util.List;
import java.util.SortedSet;
import java.util.TreeSet;
import java.util.regex.Pattern;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.IOUtils;
import org.cf.resequencer.Console;

/**
 * Represents .smali file and handles the details of modification operations and saving.
 * 
 * @author Caleb Fenton
 */
public class SmaliFile {

    class CodeModification implements Comparable {

        public Integer Offset;
        public String ReplaceWhat;
        public String Value;

        CodeModification(Integer o, String r, String v) {
            Offset = o;
            ReplaceWhat = r;
            Value = v;
        }

        @Override
        public boolean equals(Object o) {
            if (o.getClass() != this.getClass()) {
                return false;
            }

            return o.hashCode() == hashCode();
        }

        @Override
        public int hashCode() {
            int hash = 7;
            hash = (67 * hash) + (Offset != null ? Offset.hashCode() : 0);
            hash = (67 * hash) + (ReplaceWhat != null ? ReplaceWhat.hashCode() : 0);
            hash = (67 * hash) + (Value != null ? Value.hashCode() : 0);
            return hash;
        }

        @Override
        // Higher values should come first
        // Because replaces / inserts happen in a loop and editing higher
        // would throw off offsets for replaces/inserts after
        public int compareTo(Object o) {
            CodeModification cm = (CodeModification) o;

            if (Offset == cm.Offset) {
                return 0;
            } else if (Offset > cm.Offset) {
                return -1;
            } else {
                return 1;
            }
        }
    }

    /**
     * Full path file name
     */
    public String FullFilePath;
    /**
     * Path only after smali dump directory
     */
    public String FileName;
    /**
     * File contents
     */
    public String FileLines;
    /**
     * Clones of fingerprints matched against this file. Keys are fingerprint names.
     */
    public HashMap<String, Fingerprint> Fingerprints;
    /**
     * Offsets for regions. Keys are region names.
     */
    public HashMap<String, Integer[]> RegionOffsetList;
    /**
     * List of code modifications to perform
     */
    public SortedSet<CodeModification> CodeModifications;
    /**
     * Notify the user if this file is matched?
     */
    public boolean Notify;

    public SmaliFile() {
        Fingerprints = new HashMap<String, Fingerprint>();
        RegionOffsetList = new HashMap<String, Integer[]>();
        CodeModifications = new TreeSet<CodeModification>();
        Notify = true;
    }

    public SmaliFile(File smaliFile) {
        this();

        if (!smaliFile.exists()) {
            Console.die("Smali file does not exist: " + smaliFile + ".", -1);
        }

        FullFilePath = smaliFile.getPath();
        FileName = smaliFile.getName();

        try {
            // UTF-8 encoding when reading/writing because some obfuscation
            // or languages uses weird characters that wont compile otherwise
            List<String> lines = FileUtils.readLines(smaliFile, "UTF-8");
            StringBuilder buff = new StringBuilder();
            for (String line : lines) {
                buff.append(line).append(System.getProperty("line.separator"));
            }
            FileLines = buff.toString();
            lines.clear();
        } catch (IOException ex) {
            Console.error("Exception reading " + smaliFile + ".\n" + ex);
        }
    }

    public SmaliFile(String fileName) {
        this(new File(fileName));
    }

    public SmaliFile(String fileName, InputStream is) {
        this();

        File f = new File(fileName);

        FullFilePath = fileName;
        FileName = f.getName();

        StringBuilder lines = new StringBuilder();
        List<String> read = null;
        try {
            read = IOUtils.readLines(is);
        } catch (IOException ex) {
            Console.error("Exception reading input stream.\n" + ex);
        }

        for (String s : read) {
            lines.append(s);
        }

        FileLines = lines.toString();
    }

    @Override
    public String toString() {
        // strip beginning of path leading up to and including "smali/"
        int pos = FullFilePath.indexOf("smali" + File.separator) + 6;
        if (pos < 0) {
            pos = 0;
        }
        return FullFilePath.substring(pos);
    }

    /**
     * When regions are matched, they are added here.
     * 
     * @param regionName
     *            name of the region
     * @param regionStarts
     *            offset in file for start of region
     * @param regionEnds
     *            offset in file for end of region
     */
    public void addRegion(String regionName, int regionStarts, int regionEnds) {
        RegionOffsetList.put(regionName, new Integer[] { regionStarts, regionEnds });
    }

    /**
     * Add matched insert operation to list of modifications to perform.
     * 
     * @param offset
     *            offset to insert
     * @param codeInsert
     *            what to actually insert
     */
    public void addInsert(Integer offset, String codeInsert) {
        // DoModifcations knows to simply insert if second param empty ""
        addModification(new CodeModification(offset, "", codeInsert));
    }

    /**
     * Add matched replace operation to list of modifications to perform.
     * 
     * @param offset
     *            offset to start replace
     * @param replaceWhat
     *            regex of what to replace
     * @param replaceWith
     *            what to actually replace it with
     */
    public void addReplace(Integer offset, String replaceWhat, String replaceWith) {
        addModification(new CodeModification(offset, replaceWhat, replaceWith));
    }

    /**
     * Performs all inserts/replacements and then saves the lines.
     * 
     * @return true on successful modification and file doModificationsAndSave, false otherwise
     */
    public boolean doModificationsAndSave() {
        // Must do all inserts at once, because offsets will change
        if (!doModifications()) {
            return false;
        }

        try {
            Console.debug("Writing " + FileLines.length() + " chars to " + FullFilePath, 2);

            File newF = new File(FullFilePath);
            FileUtils.writeStringToFile(newF, FileLines, "UTF-8");

            if (!newF.exists()) {
                Console.die("Was able to save " + FileName + " but it does not exist and no exception was thrown.");
            }
        } catch (IOException ex) {
            Console.die("Unable to save " + FileName + ".\n" + ex);
            return false;
        }

        return true;
    }

    private void addModification(CodeModification aCM) {
        Console.debug("Setting modify in " + FileName + ": " + aCM.Value, 2);
        CodeModifications.add(aCM);
    }

    /**
     * 
     * @return
     */
    protected boolean doModifications() {
        // StringBuilder origLines = new StringBuilder(FileLines);
        StringBuilder sb = new StringBuilder(FileLines);
        boolean success = true;

        for (CodeModification cm : CodeModifications) {
            if (cm.ReplaceWhat.isEmpty()) {
                Console.debug("Inserting @" + cm.Offset + ": " + cm.Value, 2);

                sb.insert(cm.Offset, cm.Value);

                // FileLines = FileLines.substring(0, cm.Offset)
                // + cm.Value + FileLines.substring(cm.Offset, FileLines.length());

                if (sb.length() == FileLines.length()) {
                    Console.warn(FileName + ": Unable to insert @" + cm.Offset + ": " + cm.Value);
                    success = false;
                }
            } else {
                Console.debug("Replacing @" + cm.Offset + ":\n" + cm.ReplaceWhat + " with " + cm.Value, 2);

                int hashCode = sb.toString().hashCode();

                String safeReplaceWhat = Pattern.quote(cm.ReplaceWhat);
                String toReplace = sb.substring(cm.Offset);
                String replaced = toReplace.replaceFirst(safeReplaceWhat, cm.Value);
                sb.replace(cm.Offset, sb.length(), replaced);

                // FileLines = FileLines.substring(0, cm.Offset)
                // + FileLines.substring(cm.Offset).replaceFirst(
                // safeReplaceWhat, cm.Value);

                if (sb.toString().hashCode() == hashCode) {
                    Console.warn(FileName + ": Replace possibly did nothing @" + cm.Offset + ":\n" + cm.ReplaceWhat + " with " + cm.Value);
                    // success = false;
                }
            }
        }

        FileLines = sb.toString();

        CodeModifications.clear();
        return success;
    }
}
