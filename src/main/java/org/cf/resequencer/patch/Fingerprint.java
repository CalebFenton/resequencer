package org.cf.resequencer.patch;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Set;

import org.cf.resequencer.Console;

/**
 * Represents an XML fingerprint and also stores information on matching.
 * 
 * @author Caleb Fenton
 */
class Fingerprint implements Cloneable {
    private String FingerprintName = "";
    public Set<String> IncompatibleFingerprints = new HashSet<String>();
    public Set<String> RequiredFingerprints = new HashSet<String>();
    public Set<String> DeletePaths = new HashSet<String>();
    public Map<Integer, Region> Regions = new HashMap<Integer, Region>();
    public boolean Enabled = true;
    public boolean Notify = true; // notify user when found
    public boolean FindOnce = false;
    public boolean DependenciesTraced = false;
    public String[] SmaliHooksToInstall;

    Fingerprint(String n) {
        FingerprintName = n;
    }

    @Override
    public Fingerprint clone() {
        Fingerprint fpClone = new Fingerprint(FingerprintName);
        fpClone.Notify = Notify;
        fpClone.Enabled = Enabled;
        fpClone.FindOnce = FindOnce;
        fpClone.SmaliHooksToInstall = SmaliHooksToInstall;

        fpClone.IncompatibleFingerprints.addAll(IncompatibleFingerprints);
        fpClone.RequiredFingerprints.addAll(RequiredFingerprints);
        fpClone.DeletePaths.addAll(DeletePaths);

        for (Map.Entry<Integer, Region> integerRegionEntry : Regions.entrySet()) {
            fpClone.addRegion(integerRegionEntry.getValue().clone());
        }

        return fpClone;
    }

    @Override
    public String toString() {
        return FingerprintName;
    }

    public void addIncompatible(String fpName) {
        IncompatibleFingerprints.add(fpName);
    }

    public void addRequired(String fpName) {
        RequiredFingerprints.add(fpName);
    }

    public void addRegion(Region region) {
        Regions.put(region.hashCode(), region);
    }

    public void addDeletePath(String path) {
        DeletePaths.add(path);
    }

    public boolean match(SmaliFile smaliFile) {
        List<Region> addRegions = new ArrayList<Region>();
        Region region;

        Console.debug("Searching for " + FingerprintName + " in " + smaliFile, 2);
        for (Map.Entry<Integer, Region> integerRegionEntry : Regions.entrySet()) {
            region = integerRegionEntry.getValue();
            Console.debug("  region: " + region, 3);

            // region may match multiple times
            // for every match of a region
            // clone it and try again after previous match
            int matchCount = 0;
            int pos = 0;
            while (pos < smaliFile.FileLines.length()) {
                if (region.match(smaliFile, pos)) {
                    if (matchCount >= 1) {
                        addRegions.add(region);
                    }

                    matchCount++;
                    pos = region.EndOffset + 1;
                    region = region.clone();
                } else {
                    break;
                }
            }

            if (matchCount == 0) {
                return false;
            }
        }

        // add multiple regions if they are found
        for (Region r : addRegions) {
            addRegion(r);
        }

        return true;
    }
}
