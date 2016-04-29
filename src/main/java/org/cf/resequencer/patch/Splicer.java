package org.cf.resequencer.patch;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

import org.cf.resequencer.Console;

/**
 * Central class for performing all region operations on smali file matches.
 * 
 * @author Caleb Fenton
 */
public class Splicer {
    private ArrayList<SmaliFile> SmaliFileMatches;
    private String SmaliDir;
    private int AppMinSDK = 1;

    /**
     * Expects result from SmaliMatcher.performMatching()
     * 
     * @param fileMatches
     * @param smaliDir
     * @param appMinSdk
     */
    public Splicer(ArrayList<SmaliFile> fileMatches, String smaliDir, int appMinSdk) {
        SmaliFileMatches = fileMatches;
        SmaliDir = smaliDir;
        AppMinSDK = appMinSdk;
    }

    /**
     * Loops through all operations in SmaliFileMatches and performs them. When it's finished it saves all the
     * SmaliFiles.
     * 
     * @return true if it did stuff, false if it did nothing
     */
    public boolean splice() {
        if (SmaliFileMatches.size() <= 0) {
            System.out.println("  Nothing to do!\n" + "  No fingerprints matched or they had no operations.");
            return false;
        }

        performDeleteOps();

        for (SmaliFile sf : SmaliFileMatches) {
            HashMap<String, Integer> appliedFPs = new HashMap<String, Integer>();

            if (sf.Notify) {
                System.out.print("\n  " + sf.FullFilePath + " ..");
            }

            for (String fpName : sf.Fingerprints.keySet()) {
                Fingerprint fp = sf.Fingerprints.get(fpName);

                if (fp.Notify) {
                    appliedFPs.put(fpName, 0);
                }

                for (Integer key : fp.Regions.keySet()) {
                    Region fr = fp.Regions.get(key);

                    fr.evaluateOperations(sf, AppMinSDK);

                    // may be applied multiple times, so keep track
                    if (fp.Notify) {
                        appliedFPs.put(fpName, appliedFPs.get(fpName) + 1);
                        System.out.print(".");
                    }
                }
            }

            boolean success = sf.doModificationsAndSave();
            if (sf.Notify) {
                if (success) {
                    System.out.println(" success.");
                    System.out.println("    Applied:");
                    for (Map.Entry<String, Integer> stringIntegerEntry : appliedFPs.entrySet()) {
                        String out = "      - " + stringIntegerEntry.getKey();
                        // also show number of times it was applied
                        if (stringIntegerEntry.getValue() > 1) {
                            out += " (" + stringIntegerEntry.getValue() + ")";
                        }
                        System.out.println(out);
                    }
                } else {
                    System.out.println(" failure!");
                }
            }
        }

        System.out.println();

        return true;
    }

    private void performDeleteOps() {
        Set<String> delPaths = new HashSet<String>();
        for (SmaliFile sf : SmaliFileMatches) {
            for (String fpName : sf.Fingerprints.keySet()) {
                Fingerprint fp = sf.Fingerprints.get(fpName);
                delPaths.addAll(fp.DeletePaths);
            }
        }

        for (String path : delPaths) {
            File delMe = new File(SmaliDir + File.separator + path);
            if (delMe.exists()) {
                if (!Console.deleteBestEffort(delMe, "deletePath")) {
                    ;
                }
                Console.warn("Unable to delete " + delMe + ".");
            } else {
                Console.debug("Can't delete non-existant path: " + delMe + ".", 3);
            }
        }
    }
}
