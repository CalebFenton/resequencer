package org.cf.resequencer.patch;

import java.io.File;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.commons.lang3.StringEscapeUtils;
import org.cf.resequencer.Console;
import org.cf.resequencer.sequence.ResourceItem;

import com.memetix.mst.detect.Detect;
import com.memetix.mst.language.Language;
import com.memetix.mst.translate.Translate;

/**
 * 
 * @author Caleb Fenton
 */
public class SmaliHinter {
    public static long HintsAdded = 0;

    public static boolean ShouldTranslate = false;
    private static int TranslateBatchSize = 25;

    static private String[] LineArray;

    public static void enableTranslations() {
        // Microsoft Bing API key
        // the developers use this key: 0B4B2CAA973775DBE72569A29C1A08DA55C88441
        // lolololol but we wont use it because we're nice
        String key = "";
        // key = "0B4B2CAA973775DBE72569A29C1A08DA55C88441";
        Translate.setKey(key);
        Detect.setKey(key);

        ShouldTranslate = true;
    }

    /**
     * 
     * @param sf
     */
    public static void generateHints(SmaliFile sf) {
        generateHints(sf, null);
    }

    /**
     * 
     * @param sf
     * @param appRes
     */
    public static void generateHints(SmaliFile sf, ArrayList<ResourceItem> appRes) {
        File f = new File(sf.FullFilePath);
        Console.debug("Hinting " + sf.FileName + " (" + f.length() + " bytes)");

        LineArray = sf.FileLines.split("[\r\n]");

        if (appRes != null) {
            hintResourceStrings(sf, appRes);
        }

        hintArrayData(sf);
        hintHexLiterals(sf);
        hintClassInitVals(sf);
        hintDebugInfo(sf);

        if (ShouldTranslate) {
            translateStrings(sf);
        }
    }

    private static void hintDebugInfo(SmaliFile sf) {
        Pattern p = Pattern.compile("(?m)^[\\t ]*\\.source ");
        Matcher m = p.matcher(sf.FileLines);

        if (!m.find()) {
            // no .source directive. let's add one.
            String thisClass = "";
            String superClass = "";
            String interfaceClass = "";

            p = Pattern.compile("(?m)^[\\t ]*\\.implements L(\\S+?);\\s*");
            m = p.matcher(sf.FileLines);
            if (m.find()) {
                interfaceClass = m.group(1).replace("/", ".");
            }

            // .*? to account for public, private, static, final etc.
            p = Pattern.compile("(?m)^[\\t ]*\\.class .*?L(\\S+?);\\s*");
            m = p.matcher(sf.FileLines);
            m.find();
            thisClass = m.group(1).substring(m.group(1).lastIndexOf("/") + 1);

            p = Pattern.compile("(?m)^[\\t ]*\\.super L(\\S+?);\\s*");
            m = p.matcher(sf.FileLines);
            m.find();
            superClass = m.group(1).replace("/", ".");

            String insert = ".source \"" + thisClass + "_sup-" + superClass;
            if (!interfaceClass.isEmpty()) {
                insert += "_impl-" + interfaceClass;
            }
            insert += "\"\n\n";

            HintsAdded++;
            sf.addInsert(m.end(), insert);
        }

        p = Pattern.compile("(?m)^[\\t ]*.line \\d+");
        m = p.matcher(sf.FileLines);

        if (!m.find()) {
            // no .line directives. let's add some.

            /*
             * Add .line directive in the following places: - before any invoke-* - before every const - before every
             * if-* - before every check-cast, new-instance - before every iget*, iput* - before every return
             */

            p = Pattern.compile("(?m)^[\\t ]*(invoke|const|if|check-cast|new-instance|iget|iput|return)");
            m = p.matcher(sf.FileLines);

            int line = 1;
            StringBuilder insert = null;
            while (m.find()) {
                insert = new StringBuilder("    .line ");
                insert.append(line);
                insert.append("\n");
                HintsAdded++;
                sf.addInsert(m.start(), insert.toString());

                line++;
            }
        }
    }

    private static void hintClassInitVals(SmaliFile sf) {

    }

    private static void hintResourceStrings(SmaliFile sf, ArrayList<ResourceItem> appRes) {

        Pattern p = Pattern.compile("(?im)^[ ]*const(/high16)? [vp]\\d+, 0x(7f[0-9a-f]{1,6})");
        Matcher m = p.matcher(sf.FileLines);

        while (m.find()) {
            Long resID = Long.parseLong(m.group(2), 16);

            StringBuilder insert = new StringBuilder("    # res type=");
            if (!appRes.isEmpty()) {
                ResourceItem resItem = findResItemByID(appRes, resID);

                if (resItem != null) {
                    insert.append(resItem.Type);
                    insert.append(" name=");
                    insert.append(resItem.Name);

                    if (resItem.Type.equals("string")) {
                        insert.append(" val=\"");
                        insert.append(resItem.Value);
                        insert.append("\"");
                    }
                } else {
                    insert.append("possibly not resource / unknown res ID");
                }
            } else {
                insert.append("error parsing resources");
            }

            insert.append("\n");

            HintsAdded++;

            String finalInsert = insert.toString().replaceAll("[\\p{Cntrl}&&[^\\n]]", "?");
            sf.addInsert(m.start(), finalInsert);
        }
    }

    private static ResourceItem findResItemByID(ArrayList<ResourceItem> appRes, long resID) {
        for (ResourceItem resItem : appRes) {
            if (resItem.ID == resID) {
                return resItem;
            }
        }

        return null;
    }

    private static void hintArrayData(SmaliFile sf) {
        /*
         * # str value="VT" :array_1 .array-data 0x2 0x56t 0x0t 0x54t 0x0t .end array-data
         */

        Pattern p = Pattern
                        .compile("(?im)^[ ]*:array_[0-9a-f]+\\s+\\.array-data 0x([0-9a-f]+)\\s+((0x[0-9a-f]+t\\s+)+)\\s+\\.end array-data");

        // without looping through each line, sometimes there is a stackoverflow
        // because too many results are found
        int posOffset = 0;
        for (String line : LineArray) {
            Matcher m = p.matcher(line);

            while (m.find()) {
                int wordSize = Integer.parseInt(m.group(1), 16);

                // from chunky to smoooth
                String[] hexVals = m.group(2).replaceAll("0x", "").split("t\\s*");
                int wordCount = hexVals.length / wordSize;
                StringBuilder insert = new StringBuilder("    # str value=\"");
                // baksmali seems to always put this stuff in little endian
                for (int i = 0; i < wordCount; i++) {
                    StringBuilder nextVal = new StringBuilder("");
                    for (int j = wordSize - 1; j >= 0; j--) {
                        nextVal.append(hexVals[(i * wordSize) + j]);
                    }

                    long longVal = 0;
                    try {
                        longVal = Long.parseLong(nextVal.toString(), 16);
                    } catch (NumberFormatException e) {
                        longVal = 0;
                        Console.warn("Array data too big to parse: " + nextVal + " found while hinting "
                                        + sf.FullFilePath);
                    }

                    // insert += String.valueOf((char)longVal);
                    insert.append((char) longVal);
                }

                insert.append("\n");

                HintsAdded++;
                String finalInsert = insert.toString().replaceAll("[\\p{Cntrl}&&[^\\n]]", "");
                sf.addInsert(posOffset + m.start(), finalInsert);
            }
        }
    }

    private static void hintHexLiterals(SmaliFile sf) {
        /*
         * # base10=58 char=':' const/16 v3, 0x3a
         */

        Pattern p = Pattern.compile("(?im)^.*?, (-)?0x([0-9a-f]{2,})[l]?$");

        int posOffset = 0;
        for (String line : LineArray) {
            Matcher m = p.matcher(line);

            while (m.find()) {
                // 1 = possibly negative, 2 = number without 0x
                String strVal = m.group(2).toLowerCase();
                if (m.group(1) != null) {
                    strVal = m.group(1) + strVal;
                }

                // do not add base 10 hint for resource ids
                if (strVal.startsWith("7f") && (strVal.length() == 8)) {
                    continue;
                }

                long longVal = Long.parseLong(strVal, 16);

                // sorry, you should just learn hex
                if ((longVal > -16) && (longVal < 16)) {
                    continue;
                }

                // String insert = "    # base10=" + longVal;
                StringBuilder insert = new StringBuilder("    # base10=");
                insert.append(longVal);

                // printable character range
                if ((longVal >= 0x20) && (longVal <= 0xFFFC)) {
                    insert.append(" char='");
                    insert.append((char) longVal);
                    insert.append("'");
                }

                HintsAdded++;
                sf.addInsert(posOffset + m.start(), insert.toString() + "\n");
            }

            posOffset += line.length() + 1;
        }
    }

    private static void translateStrings(SmaliFile sf) {
        /*
         * # trans="Initializing..." lang=Japanese const-string v1, "\u521d\u671f\u5316\u4e2d\u3067\u3059..."
         */

        Pattern p = Pattern.compile("(?im)^[ \\t]*const-string [vp]\\d+, \\\"(.*?)\\\"$");

        ArrayList<String> foundStrings = new ArrayList<String>();
        ArrayList<String> foundStringsOrig = new ArrayList<String>();
        ArrayList<Integer> foundPos = new ArrayList<Integer>();

        int posOffset = 0;
        for (String line : LineArray) {
            Matcher m = p.matcher(line);

            while (m.find()) {
                // group0 = const-string v1, "\u521d\u671f\u5316\u4e2d\u3067\u3059..."
                // group1 = \u521d\u671f\u5316\u4e2d\u3067\u3059...

                String strVal = StringEscapeUtils.unescapeJava(m.group(1).trim());

                // don't attempt to translate small strings
                String cleanStrVal = removeNonLetters(strVal);
                if (cleanStrVal.length() <= 3) {
                    continue;
                }

                // for now, only translate strings with non-english letters
                boolean hasNonLatinChar = false;
                for (int i = 0; i < cleanStrVal.length(); i++) {
                    if (Character.UnicodeBlock.of(cleanStrVal.charAt(i)) != Character.UnicodeBlock.BASIC_LATIN) {
                        hasNonLatinChar = true;
                        break;
                    }
                }

                if (!hasNonLatinChar) {
                    continue;
                }

                // System.out.println(" trans: " + m.group(1));

                foundStrings.add(strVal);
                foundStringsOrig.add(m.group(1).trim());
                foundPos.add(posOffset + m.start());
            }

            posOffset += line.length() + 1;
        }

        if (foundStrings.isEmpty()) {
            return;
        }

        System.out.println("Translating strings in " + sf);

        // We ASSUME every string in the file is of the same language
        // Get the language here so we can put it in all the comments later
        System.out.println("  Detecting language ...");
        Language detectedLang = Language.AUTO_DETECT;
        int tries = 0;
        System.out.println("testing replace: " + removeNonLetters("This Is .. A TEST!"));

        while (tries < foundStrings.size()) {
            try {
                detectedLang = Detect.execute(foundStrings.get(tries));
                System.out.println("looking at  " + foundStrings.get(tries));
                System.out.println("detected lang  " + detectedLang);
                System.out.println("autodetect val?= " + Language.AUTO_DETECT);
                if (detectedLang == null) {
                    tries++;
                    continue;
                }
                break;
            } catch (Exception ex) {
                Console.warn("Problem detecting language: " + ex + " -- retrying with another string..");
                tries++;
            }
        }

        System.out.println(detectedLang);
        System.out.println(Language.AUTO_DETECT);
        if (detectedLang.equals(Language.AUTO_DETECT)) {
            Console.warn("Unable to detect language. Skipping.");
            return;
        }

        if (detectedLang.equals(Language.ENGLISH)) {
            System.out.println("  Appears to be english. Skipping.");
            return;
        }

        System.out.println("  Running translation of " + foundStrings.size() + " items ...");

        // Translate all strings in bulk
        // But anything >25ish starts to time out or something
        for (int i = 0; i < foundStrings.size(); i += TranslateBatchSize) {
            int remaining = 20;
            if ((foundStrings.size() - i) < 20) {
                remaining = foundStrings.size() - i;
            }

            String[] toTranslate = new String[remaining];
            for (int j = 0; j < remaining; j++) {
                toTranslate[j] = foundStrings.get(i + j);
            }

            String[] translations = null;
            tries = 0;
            while (tries < 1) {
                try {
                    translations = Translate.execute(toTranslate, detectedLang, Language.ENGLISH);
                    break;
                } catch (Exception ex) {
                    Console.warn("Problem getting translation:\n" + ex + " - retrying.");
                    tries++;
                }
            }

            if (translations == null) {
                Console.warn("Unable to get translations. Skipping this batch.");
                continue;
            }

            for (int j = 0; j < remaining; j++) {
                String strVal = foundStrings.get(i + j);
                Integer pos = foundPos.get(i + j);

                String insert = "";

                // System.out.println(foundStringsOrig.get(i+j) + " = " + translations[j]);

                // If original string was unicode escaped, show the actual symbols in comments
                insert = "    #";
                if (foundStringsOrig.get(i + j).matches(".*?(\\\\u[a-fA-f0-9]{4}?).*?")) {
                    insert += " orig=\"" + strVal + "\"";
                }
                try {
                    insert += " lang=" + detectedLang.getName(Language.ENGLISH);
                } catch (Exception ex) {
                    Console.warn("  Odd, I can't figure out what language this is: " + detectedLang);
                }

                insert += "\n";
                insert += "    # trans=\"" + translations[j] + "\"";

                HintsAdded++;
                sf.addInsert(pos, insert + "\n");
            }
        }
    }

    private static String removeNonLetters(String line) {
        // remove all non-letters (e.g. numbers, puncutation)
        // but keep spaces, underscores and hyphens
        return line.replaceAll("[^\\p{L}\\-_ ]", "");
    }
}
