package org.cf.resequencer.patch;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.cf.resequencer.Console;

/**
 * Handles matching fingerprints with smali files.
 * 
 * @author Caleb Fenton
 */
public class SmaliMatcher {

    private final SmaliFile[] SmaliFileList;
    private FingerprintReader myFPReader;
    private ArrayList<SmaliFile> SmaliFileMatches;
    private final int ProgressIncrement = 100;

    /**
     * 
     * @param smaliFiles
     *            array of paths to smali files
     * @param reader
     *            instance of FingerprintReader
     */
    public SmaliMatcher(SmaliFile[] smaliFiles, FingerprintReader reader) {
        SmaliFileList = smaliFiles;
        SmaliFileMatches = new ArrayList<SmaliFile>();
        myFPReader = reader;

        removeDisabledFingerprints();
    }

    /**
     * Performs region and match operations.
     * 
     * @return SmaliFiles with matched regions stored inside.
     */
    public ArrayList<SmaliFile> performMatching() {
        System.out.print("  Matching " + SmaliFileList.length + " files against " + myFPReader.Fingerprints.size()
                        + " fingerprints ");

        int count = 1;
        for (SmaliFile sf : SmaliFileList) {
            for (String fpName : myFPReader.Fingerprints.keySet()) {
                Fingerprint fp = myFPReader.Fingerprints.get(fpName);
                if (fp.FindOnce && wasFingerprintFound(fp.toString())) {
                    Console.debug("    Skipping " + fp + " because it's already been found.", 3);
                    continue;
                }

                Fingerprint fpClone = fp.clone();
                if (!fpClone.match(sf)) {
                    continue;
                }

                Console.debug("    Adding " + fpClone + " to " + sf.FileName);

                sf.Fingerprints.put(fpName, fpClone);
            }

            if (!sf.Fingerprints.isEmpty()) {
                SmaliFileMatches.add(sf);
            }

            // Netbeans calls this "admirably terse" and warns against it.
            // I call it sexy. :D
            if ((count++ % ProgressIncrement) == 0) {
                System.out.print(".");
            }
        }
        System.out.println("");

        displayResults();

        ignoreMatchesWithNoModifications();

        // Require and Incompatible filter
        unfindAllWithUnfoundRequired();
        satisfyUnmatchedIncompatible();
        resolveFingerprintDependencies();

        ignoreSmaliFilesWithNoNotifications();

        return SmaliFileMatches;
    }

    private void ignoreSmaliFilesWithNoNotifications() {
        outer: for (SmaliFile sf : SmaliFileMatches) {
            for (String fpName : sf.Fingerprints.keySet()) {
                Fingerprint fp = sf.Fingerprints.get(fpName);
                if (fp.Notify) {
                    continue outer;
                }
            }

            sf.Notify = false;
        }
    }

    private void displayResults() {
        boolean showedFile = false;
        for (SmaliFile sf : SmaliFileMatches) {
            showedFile = false;
            for (String fpName : sf.Fingerprints.keySet()) {
                Fingerprint fp = sf.Fingerprints.get(fpName);
                if (fp.Notify) {
                    if (!showedFile) {
                        // can't always show this line outside the loop
                        // because every fingerprint may be notify=false
                        System.out.println("\n    In " + sf);
                        showedFile = true;
                    }

                    System.out.println("      found " + fp);
                }
            }

        }
    }

    private void ignoreMatchesWithNoModifications() {
        for (int i = 0; i < SmaliFileMatches.size(); i++) {
            SmaliFile sf = SmaliFileMatches.get(i);

            int opCount = 0;
            for (String fpName : sf.Fingerprints.keySet()) {
                int emptyRegionCount = 0;
                Fingerprint fp = sf.Fingerprints.get(fpName);
                for (Integer key : fp.Regions.keySet()) {
                    Region fr = fp.Regions.get(key);
                    String rName = fr.getName();
                    int rOpCount = 0;
                    for (Operation op : fr.OperationList) {
                        if ((op.getType() == Operation.OpTypes.INSERT) || (op.getType() == Operation.OpTypes.REPLACE)) {
                            opCount++;
                            rOpCount++;
                        }
                    }

                    if (rOpCount == 0) {
                        Console.debug("Ignoring region " + rName + "|" + key + ":" + fpName + " in " + sf.FileName
                                        + " since it does nothing.", 2);
                        emptyRegionCount++;
                    }
                }

                if (emptyRegionCount == fp.Regions.size()) {
                    Console.debug("Ignoring fingerprint " + fpName + " in " + sf.FileName
                                    + " since all regions are ignored.");
                    fp.Notify = false;
                }
            }
        }
    }

    private boolean wasFingerprintFound(String fpName) {
        // return true if fingerprint is found anywhere
        boolean found = false;
        for (SmaliFile sf : SmaliFileMatches) {
            if (fpName.contains("|")) {
                List<String> strs = Arrays.asList(fpName.split("\\|"));
                for (String str : strs) {
                    if (sf.Fingerprints.get(str) != null) {
                        return true;
                    }
                }
            } else {
                if (sf.Fingerprints.get(fpName) != null) {
                    return true;
                }
            }
        }

        return found;
    }

    private void unfindAllWithUnfoundRequired() {

        Fingerprint fp = null;
        HashSet<String> removeFPNames = new HashSet<String>();
        boolean runAgain;

        do {
            runAgain = false;
            removeFPNames.clear();

            for (SmaliFile sf : SmaliFileMatches) {
                for (String fpName : sf.Fingerprints.keySet()) {
                    fp = sf.Fingerprints.get(fpName);
                    String[] reqFPNames = fp.RequiredFingerprints.toArray(new String[fp.RequiredFingerprints.size()]);

                    for (String reqFPName : reqFPNames) {
                        if (!wasFingerprintFound(reqFPName)) {
                            /*
                             * this FP has unmet requirement "unfind" it and we'll need to run this loop at least once
                             * more to ensure anything that requires this fp will also be unfound
                             */
                            removeFPNames.add(fpName);
                            runAgain = true;
                        }
                    }
                }
            }

            // "unfind" all that had unmet requirements
            for (SmaliFile sf : SmaliFileMatches) {
                for (String remFPName : removeFPNames) {
                    if (sf.Fingerprints.containsKey(remFPName)) {
                        sf.Fingerprints.remove(remFPName);
                        Console.debug("Removing FP: " + remFPName + " due to unmet requirements.");
                    }
                }
            }
        } while (runAgain);
    }

    private void satisfyUnmatchedIncompatible() {
        /*
         * For every fingerprint, purge incompatible list of all fingerprints that were not found.
         */
        Fingerprint fp = null;
        for (SmaliFile sf : SmaliFileMatches) {
            for (String fpName : sf.Fingerprints.keySet()) {
                fp = sf.Fingerprints.get(fpName);

                String[] incompatFPNames = fp.IncompatibleFingerprints.toArray(new String[fp.IncompatibleFingerprints
                                .size()]);
                for (String incompatFPName : incompatFPNames) {
                    if (!wasFingerprintFound(incompatFPName)) {
                        fp.IncompatibleFingerprints.remove(incompatFPName);
                    }
                    continue;
                }
            }
        }
    }

    private void resolveFingerprintDependencies() {
        // Resolve all independent fingerprints
        Fingerprint fp = null;
        while ((fp = getIndependentFingerprint()) != null) {
            resolveFoundFingerprint(fp.toString());
        }

        /*
         * Anything that remains at this point has something in the incompatible list (the fingerprint was found) and/or
         * something in the requires list (the fingerprint was not found). So they are not to be acted upon.
         */
        ArrayList<Fingerprint> removeFPs = new ArrayList<Fingerprint>();
        for (SmaliFile sf : SmaliFileMatches) {
            for (String fpName : sf.Fingerprints.keySet()) {
                fp = sf.Fingerprints.get(fpName);
                if (!fp.RequiredFingerprints.isEmpty() || !fp.IncompatibleFingerprints.isEmpty()) {
                    removeFPs.add(fp);
                }
            }
        }

        for (SmaliFile sf : SmaliFileMatches) {
            for (Fingerprint fp2 : removeFPs) {
                if (sf.Fingerprints.containsKey(fp2.toString())) {
                    sf.Fingerprints.remove(fp2.toString());
                    Console.debug("Removing fingerprint " + fp2 + " from " + sf + " for unsatisfied requirements.", 1);
                    if (!fp.RequiredFingerprints.isEmpty()) {
                        Console.debug("  Requires: " + fp.RequiredFingerprints, 2);
                    }
                    if (!fp.IncompatibleFingerprints.isEmpty()) {
                        Console.debug("  Incompatible: " + fp.IncompatibleFingerprints, 2);
                    }
                }
            }
        }

        if (!ensureAllDependenciesResolved()) {
            Console.die("Unable to resolve fingerprint dependencies.", -1);
        }

        Console.debug("Resolved dependencies with " + SmaliFileMatches.size() + " matches remaining.", 2);
    }

    private Fingerprint getIndependentFingerprint() {
        /*
         * Initially, all incompatible lists of all fingerprints are purged of any fingerprints not found. Then, as
         * dependencies are traced, required fingerprints that are found are removed from the required list of all
         * fingerprints. An independent fingerprint is any FP that has neither incompatible or required fingerprints
         * remaining.
         */
        for (SmaliFile sf : SmaliFileMatches) {
            for (String fpName : sf.Fingerprints.keySet()) {
                Fingerprint fp = sf.Fingerprints.get(fpName);
                if (!fp.DependenciesTraced && fp.IncompatibleFingerprints.isEmpty()
                                && fp.RequiredFingerprints.isEmpty()) {
                    fp.DependenciesTraced = true;
                    return fp;
                }
            }
        }

        return null;
    }

    private void resolveFoundFingerprint(String depFPName) {
        Console.debug("Resolving fingerprint dependencies for " + depFPName + ".", 2);

        ArrayList<Fingerprint> removeFPs = new ArrayList<Fingerprint>();

        // find all matches that require this fingerprint: depFPName
        // and remove them from the required list
        // and if found in any incompatible list, remove that fingerprint
        // from the list of matches

        for (SmaliFile sf : SmaliFileMatches) {
            for (String fpName : sf.Fingerprints.keySet()) {
                Fingerprint fp = sf.Fingerprints.get(fpName);
                String reqFPStr;
                while ((reqFPStr = findFPStrThatContains(fp.RequiredFingerprints, depFPName)) != null) {
                    // required depFP was found, remove entire string since multiple
                    // requirements are OR based
                    fp.RequiredFingerprints.remove(reqFPStr);
                    Console.debug("  Satisfying dependency for " + reqFPStr + " on " + fp + ".", 2);
                }

                String incompatFPStr = findFPStrThatContains(fp.IncompatibleFingerprints, depFPName);
                if (incompatFPStr != null) {
                    fp.IncompatibleFingerprints.remove(incompatFPStr);

                    // one incompatible was found, remove it from fpStr and update
                    incompatFPStr = incompatFPStr.replace(depFPName, "");
                    incompatFPStr = incompatFPStr.replace("||", "|");

                    if (incompatFPStr.equals("")) {
                        removeFPs.add(fp);
                    } else {
                        fp.IncompatibleFingerprints.add(incompatFPStr);
                    }
                }
                if (fp.IncompatibleFingerprints.contains(depFPName)) {
                    removeFPs.add(fp);
                }
            }
        }

        for (SmaliFile sf : SmaliFileMatches) {
            for (Fingerprint removeFP : removeFPs) {
                sf.Fingerprints.remove(removeFP.toString());
            }
        }
    }

    private String findFPStrThatContains(Set<String> FPs, String fpName) {
        // fingerprints may be in the form "FP1|FP2"
        // OR, in the case of requires
        // AND, in the case of incompatible
        for (String fpStr : FPs) {
            if (fpStr.contains("|")) {
                List<String> strs = Arrays.asList(fpStr.split("\\|"));
                if (strs.contains(fpName)) {
                    return fpStr;
                }
            } else if (fpStr.contains(fpName)) {
                return fpStr;
            }
        }

        return null;
    }

    private boolean ensureAllDependenciesResolved() {
        Fingerprint fp;
        ArrayList<SmaliFile> removeSF = new ArrayList<SmaliFile>();

        for (SmaliFile sf : SmaliFileMatches) {
            if (sf.Fingerprints.isEmpty()) {
                removeSF.add(sf);
                continue;
            }

            // Could maybe check each fp in incompatible was not found
            for (String fpName : sf.Fingerprints.keySet()) {
                fp = sf.Fingerprints.get(fpName);
                if (!fp.RequiredFingerprints.isEmpty()) {
                    return false;
                }
            }
        }

        SmaliFileMatches.removeAll(removeSF);

        return true;
    }

    private void removeDisabledFingerprints() {
        Fingerprint fp;
        ArrayList<Fingerprint> removeFPs = new ArrayList<Fingerprint>();

        for (String fpName : myFPReader.Fingerprints.keySet()) {
            fp = myFPReader.Fingerprints.get(fpName);
            if (!fp.Enabled) {
                removeFPs.add(fp);
            }
        }

        for (Fingerprint remFP : removeFPs) {
            myFPReader.Fingerprints.remove(remFP.toString());
        }
    }
}
