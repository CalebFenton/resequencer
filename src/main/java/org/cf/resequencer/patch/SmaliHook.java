package org.cf.resequencer.patch;

import java.io.File;
import java.util.ArrayList;
import java.util.List;
import java.util.Collections;
import java.util.Map;
import java.util.HashMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.cf.resequencer.Console;
import org.cf.resequencer.sequence.StringUtils;

/**
 * TODO: add static vars that house all methods then migrate code to use static vars
 * 
 * @author Caleb Fenton
 */
public class SmaliHook {
    /**
	 *
	 */
    public String ClassName;
    /**
	 *
	 */
    public String ClassMunge;
    /**
	 *
	 */
    public String Package;

    /*
     * If a hook is not to be obfuscated, this should be set to true.
     */
    public boolean ForceNoObfuscation;

    /*
     * Method of anti-decompile protection for baksmali (defunct) is to use invalid file names in Windows. Retained here
     * just in case...
     */
    private static List<String> InvalidWindowsFilenames = new ArrayList<String>();

    private SmaliFile MySmaliFile = new SmaliFile();

    /*
     * Maps original package, class and method name to original package, class and random method name. Does not include
     * parameters. Ex: Lpackage/Class;->foo : Lpackage/Class;->aslkdj3
     */
    /**
	 *
	 */
    public Map<String, String> MyMethods = new HashMap<String, String>();

    /**
	 *
	 */
    public Map<String, String> MyFields = new HashMap<String, String>();

    /**
	 *
	 */
    public static Map<String, String> AllClasses = new HashMap<String, String>();
    /**
	 *
	 */
    public static Map<String, String> AllPackages = new HashMap<String, String>();
    /**
	 *
	 */
    public static Map<String, String> AllMethods = new HashMap<String, String>();
    /**
	 *
	 */
    public static Map<String, String> AllFields = new HashMap<String, String>();

    SmaliHook(String fileLines) {
        this(fileLines, false);
    }

    SmaliHook(String fileLines, boolean forceNoObfuscation) {
        ForceNoObfuscation = forceNoObfuscation;

        if (InvalidWindowsFilenames.isEmpty()) {
            // "CLOCK$" is also invalid, but not good for replace/class
            Collections.addAll(InvalidWindowsFilenames, "CON", "PRN", "AUX", "NUL", "COM0", "COM1", "COM2", "COM3",
                            "COM4", "COM5", "COM6", "COM7", "COM8", "COM9", "LPT0", "LPT1", "LPT2", "LPT3", "LPT4",
                            "LPT5", "LPT6", "LPT7", "LPT8", "LPT9");
        }

        MySmaliFile.FileLines = fileLines;

        // We collect this information so it's available to other hooks
        // that might call methods, etc. in this hook. We'll need to sort out
        // what all the new, obfuscated names for everything will be and replace
        // the old unobfuscated stuff.
        findPackage();
        findMethods();
        findFields();

        // Methods and fields have been munged, but the class
        // names stored with them also need to be updated.
        // They're used for ScriptVars.
        for (Map.Entry<String, String> stringStringEntry : AllMethods.entrySet()) {
            String methodMunge = stringStringEntry.getValue();
            methodMunge = methodMunge.replace(Package + "/" + ClassName, AllPackages.get(Package) + "/" + ClassMunge);

            AllMethods.put(stringStringEntry.getKey(), methodMunge);
            MyMethods.put(stringStringEntry.getKey(), methodMunge);
        }

        for (Map.Entry<String, String> stringStringEntry : AllFields.entrySet()) {
            String fieldMunge = stringStringEntry.getValue();
            fieldMunge = fieldMunge.replace(Package + "/" + ClassName, AllPackages.get(Package) + "/" + ClassMunge);

            AllFields.put(stringStringEntry.getKey(), fieldMunge);
            MyFields.put(stringStringEntry.getKey(), fieldMunge);
        }

        MySmaliFile.FullFilePath = ClassName + ".smali";
        MySmaliFile.FileName = MySmaliFile.FullFilePath;
    }

    @Override
    public String toString() {
        return ClassName;
    }

    /**
     * 
     * @return
     */
    public String getFileLines() {
        return MySmaliFile.FileLines;
    }

    /**
     * 
     * @param lines
     */
    public void setFileLines(String lines) {
        MySmaliFile.FileLines = lines;
    }

    private void findPackage() {
        Pattern p = Pattern.compile("(?m)^[ \\t]*.class (public |private )?(final )?L(.+?);");
        Matcher m = p.matcher(getFileLines());

        if (!m.find()) {
            Console.die("Unable to find package for hook.");
            System.out.println(getFileLines());
        }

        // ex: com/package/Main
        Package = m.group(3);

        // ex: Main
        int pos1 = Package.lastIndexOf("/");
        ClassName = Package.substring(pos1 + 1);

        if (ForceNoObfuscation) {
            ClassMunge = ClassName;
        } else {
            ClassMunge = SmaliHook.getRandomClass();
        }

        // ex: com/package
        Package = Package.substring(0, pos1);

        if (!AllPackages.containsKey(Package)) {
            String packageMunge;
            if (ForceNoObfuscation) {
                packageMunge = Package;
            } else {
                packageMunge = getRandomPackage();
            }

            AllPackages.put(Package, packageMunge);
        }

        // ClassName may be split up amongst multiple files so check before adding
        if (!AllClasses.containsKey(Package + "/" + ClassName)) {
            AllClasses.put(Package + "/" + ClassName, AllPackages.get(Package) + "/" + ClassMunge);
        }
    }

    private void findMethods() {
        Pattern p = Pattern.compile("(?m)^[ \\t]*\\.method .+");
        Matcher m = p.matcher(getFileLines());

        String classPackage = "L" + Package + "/" + ClassName + ";";

        while (m.find()) {
            String matchedLine = getFileLines().substring(m.start(), m.end());

            // skip native, abstract and <init> <clinit> methods
            if (matchedLine.contains("native ") || matchedLine.contains("abstract ") || matchedLine.contains("<")) {
                continue;
            }

            String[] found = matchedLine.split("\\s");
            StringBuilder methodCall = new StringBuilder(found[found.length - 1]);
            methodCall.append(methodCall.substring(0, methodCall.indexOf("(")))
                    .append(classPackage).append("->").append(methodCall);

            if (MyMethods.containsKey(methodCall)) {
                continue;
            }

            Console.debug("found method: " + methodCall, 2);

            StringBuilder methodMunge = new StringBuilder();
            if (ForceNoObfuscation) {
                methodMunge = methodCall;
            } else {
                methodMunge.append(classPackage).append("->").append(SmaliHook.getRandomMethod());
            }

            String methodCallStr = methodCall.toString();
            String methodMungeStr = methodMunge.toString();
            MyMethods.put(methodCallStr, methodMungeStr);
            AllMethods.put(methodCallStr, methodMungeStr);
        }
    }

    private void findFields() {
        // .field public a:Ljava/lang/String;
        Pattern p = Pattern.compile("(?m)^[ \\t]*\\.field .+");
        Matcher m = p.matcher(getFileLines());

        String classPackage = "L" + Package + "/" + ClassName + ";";

        while (m.find()) {
            String[] found = m.group().split("\\s");

            // .field static final synthetic $assertionsDisabled:Z = false
            StringBuilder fieldCall = new StringBuilder();
            if (found[found.length - 2].equals("=")) {
                fieldCall.append(found[found.length - 3]);
            } else {
                fieldCall.append(found[found.length - 1]);
            }

            fieldCall.append(fieldCall.substring(0, fieldCall.indexOf(":"))).append(classPackage).append("->").append(fieldCall);

            if (MyFields.containsKey(fieldCall)) {
                continue;
            }

            Console.debug("found field: " + fieldCall, 2);

            StringBuilder fieldMunge = new StringBuilder();
            if (ForceNoObfuscation) {
                fieldMunge = fieldCall;
            } else {
                fieldMunge.append(classPackage).append("->").append(SmaliHook.getRandomField());
            }

            String fieldCallStr = fieldCall.toString();
            String fieldMungeStr = fieldMunge.toString();
            MyFields.put(fieldCallStr, fieldMungeStr);
            AllFields.put(fieldCallStr, fieldMungeStr);
        }
    }

    /**
	 *
	 */
    public void updateWithObfuscatedRefrences() {
        updatePackages();
        updateMethods();
        updateFields();
    }

    private void updatePackages() {
        for (Map.Entry<String, String> stringStringEntry : AllClasses.entrySet()) {
            String classMunge = stringStringEntry.getValue();
            Console.debug("Renaming class: " + stringStringEntry.getKey() + " to " + classMunge, 2);

            Pattern p = Pattern.compile("(?m)^[ \\t]*\\.class (public |private |protected )?" + "(static )?(final )?L"
                            + Pattern.quote(stringStringEntry.getKey()) + ";");
            Matcher m = p.matcher(getFileLines());

            if (m.find() && !stringStringEntry.getKey().equals(classMunge)) {
                MySmaliFile.addReplace(m.start(), stringStringEntry.getKey(), classMunge);
            }

            // there could be other places class name would need to be replaced
            // but not in my hooks
            p = Pattern.compile("(?m)^[ \\t]*const-class [vp]\\d+, L" + Pattern.quote(stringStringEntry.getKey()) + ";");
            m = p.matcher(getFileLines());

            if (m.find() && !stringStringEntry.getKey().equals(classMunge)) {
                MySmaliFile.addReplace(m.start(), stringStringEntry.getKey(), classMunge);
            }

            // Must perform modifications because file lines gets edited later
            MySmaliFile.doModifications();
        }
    }

    private void updateMethods() {
        for (Map.Entry<String, String> stringStringEntry : AllMethods.entrySet()) {
            String methodMunge = stringStringEntry.getValue();
            String methodName = stringStringEntry.getKey().substring(stringStringEntry.getKey().indexOf("->") + 2);

            if (!getFileLines().contains(methodName)) {
                continue;
            }

            String methodMungeName = methodMunge.substring(methodMunge.indexOf("->") + 2);

            Pattern p;
            Matcher m;

            // only redefine methods if they're in this class
            if (stringStringEntry.getKey().contains(Package + "/" + ClassName)) {
                p = Pattern.compile("(?m)^[ \\t]*\\.method (public |private |protected )?"
                                + "(static )?(final )?(synthetic )?" + Pattern.quote(methodName) + "\\(.$*");
                m = p.matcher(getFileLines());

                while (m.find() && !methodName.equals(methodMungeName)) {
                    // String rep = m.group().replace(methodName + "(", methodMungeName + "(");
                    Console.debug("Fixing method def: " + m.group().trim() + "\n" + "  with: " + methodMungeName + "(",
                                    3);
                    MySmaliFile.addReplace(m.start(), methodName + "(", methodMungeName + "(");
                }
            }

            p = Pattern.compile("(?m)^[ \\t]*invoke.*?" + Pattern.quote(stringStringEntry.getKey()) + "\\(.*$");
            m = p.matcher(getFileLines());

            // if munge and name are the same, might need to use start int
            while (m.find() && !stringStringEntry.getKey().equals(methodMunge)) {
                // String rep = m.group().replace(methodCall + "(", methodMunge + "(");
                Console.debug("Fixing method invoke: " + m.group().trim() + "\n" + "  with: " + methodMunge + "(", 3);
                MySmaliFile.addReplace(m.start(), stringStringEntry.getKey() + "(", methodMunge + "(");
            }
        }
    }

    private void updateFields() {
        for (Map.Entry<String, String> stringStringEntry : AllFields.entrySet()) {
            String fieldMunge = stringStringEntry.getValue();
            String fieldName = stringStringEntry.getKey().substring(stringStringEntry.getKey().indexOf("->") + 2);

            Pattern p;
            Matcher m;

            if (stringStringEntry.getKey().contains(Package + "/" + ClassName)) {
                String fieldMungeName = fieldMunge.substring(fieldMunge.indexOf("->") + 2);
                p = Pattern.compile("(?m)^[ \\t]*\\.field (public |private |protected )?"
                                + "(static )?(final )?(synthetic )?" + Pattern.quote(fieldName) + ":.*");
                m = p.matcher(getFileLines());

                while (m.find() && !fieldName.equals(fieldMungeName)) {
                    Console.debug("  replacing field definition: " + m.group().trim() + "\n" + "  with: "
                                    + fieldMungeName, 3);
                    MySmaliFile.addReplace(m.start(), fieldName + ":", fieldMungeName + ":");
                }
            }

            p = Pattern.compile("(?m)^[ \\t]*\\S(put|get).*?" + Pattern.quote(stringStringEntry.getKey()) + ":.*");
            m = p.matcher(getFileLines());

            // if munge and name are the same, might need to use start int
            while (m.find() && !stringStringEntry.getKey().equals(fieldMunge)) {
                Console.debug("  replacing field invoke: " + m.group().trim() + "\n" + "  with: " + fieldMunge, 3);
                MySmaliFile.addReplace(m.start(), stringStringEntry.getKey() + ":", fieldMunge + ":");
            }
        }
    }

    /**
     * 
     * @param outPath
     */
    public void saveAs(String outPath) {
        // File name is too long. Shorten and add unique number.
        if (outPath.length() >= 199) {
            int offset = 0;
            // include directories and 16 characters of file
            int pos = outPath.lastIndexOf(File.separatorChar);
            outPath = outPath.substring(0, pos + 16) + ".smali";

            // make sure there are no collisions with file names
            while (new File(outPath).exists()) {
                outPath += "-" + ++offset;
            }
        } else if (InvalidWindowsFilenames.contains(MySmaliFile.FileName)) {
            // Uses an invalid windows file name, use something else.
            outPath = outPath.replace(".smali", "-.smali");
        }

        MySmaliFile.FullFilePath = outPath;
        File outFile = new File(MySmaliFile.FullFilePath);
        MySmaliFile.FileName = outFile.getName();

        MySmaliFile.doModificationsAndSave();
    }

    /**
     * 
     * @return
     */
    public static String getRandomPackage() {
        return StringUtils.generateAlphaString(1) + StringUtils.generateAlphaNumString(8, 12);
    }

    /**
     * 
     * @return
     */
    public static String getRandomClass() {
        /*
         * no longer using invalid windows file names. baksmali does not break. if ( InvalidWindowsFilenames.size() > 0
         * ) { Random rng = new Random(); int rndIndex = rng.nextInt(InvalidWindowsFilenames.size()); return
         * InvalidWindowsFilenames.remove(rndIndex); }
         */

        // Maximum file length is around 255
        // Cheap shot, yes I know. Fuck you.
        return StringUtils.generateAlphaString(1) + StringUtils.generateAlphaNumString(257, 257);
    }

    /**
     * 
     * @return
     */
    public static String getRandomMethod() {
        return StringUtils.generateAlphaString(1) + StringUtils.generateAlphaNumString(8, 18);
    }

    /**
     * 
     * @return
     */
    public static String getRandomField() {
        return StringUtils.generateAlphaString(1) + StringUtils.generateAlphaNumString(8, 18);
    }
}
