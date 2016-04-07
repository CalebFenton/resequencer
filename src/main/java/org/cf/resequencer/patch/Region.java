package org.cf.resequencer.patch;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.cf.resequencer.Console;

/**
 * Contains information about specific region matches within a Smali file.
 * 
 * @author Caleb Fenton
 */
class Region implements Cloneable {
    private String RegionName = "";
    private Pattern StartPattern;
    private Pattern EndPattern;
    private String MatchedLines;
    private Integer StartOffset;
    public Integer EndOffset;
    public ArrayList<Operation> OperationList;

    Region() {
        this("", "", "");
    }

    Region(String name, String start, String end) {
        RegionName = name;
        StartPattern = start.isEmpty() ? null : Pattern.compile(start);
        EndPattern = end.isEmpty() ? null : Pattern.compile(end);
        OperationList = new ArrayList<Operation>();
    }

    public void setName(String regionName) {
        RegionName = regionName;
    }

    public void setStart(String start) {
        StartPattern = Pattern.compile(start);
    }

    public void setEnd(String end) {
        EndPattern = Pattern.compile(end);
    }

    public String getName() {
        return RegionName;
    }

    @Override
    public Region clone() {
        String start = StartPattern == null ? "" : StartPattern.pattern();
        String end = EndPattern == null ? "" : EndPattern.pattern();

        Region rfClone = new Region(RegionName, start, end);

        rfClone.StartOffset = StartOffset;
        rfClone.EndOffset = EndOffset;

        for (Operation op : OperationList) {
            rfClone.OperationList.add(op.clone());
        }

        return rfClone;
    }

    @Override
    public String toString() {
        return RegionName;
    }

    // If region start and end are both blank, assume entire file as range
    // setup this region's offsets with the first region it matches to
    // it will try to match every possible region first
    // we don't store multiple offsets here because at a higher level
    // we just clone the region instance for every matched region
    public boolean match(SmaliFile smaliFile, int startSearch) {
        int start = startSearch;
        boolean foundMatch = false;

        // findRegion() will setup Start and EndOffsets
        while (findRegion(smaliFile, start)) {
            // System.out.println(smaliFile + " " + RegionName + " " + start + " " + EndOffset + " " +
            // smaliFile.FileLines.length());
            foundMatch = true;
            start = EndOffset + 1;

            for (Operation op : OperationList) {
                if (op.getType() == Operation.OpTypes.MATCH) {
                    evaluateOperationAttributes(op);

                    if (!performMatchOperation(op)) {
                        Console.debug("  " + op + " did not match in " + smaliFile.FileName, 2);
                        foundMatch = false;
                        break;
                    }
                }
            }

            if (foundMatch) {
                break;
            }
        }

        if (!foundMatch) {
            return false;
        } else {
            Console.debug("  and MATCHES!", 2);
            return true;
        }
    }

    public void evaluateOperations(SmaliFile smaliFile, int appMinSdk) {
        Console.debug("Evaluating operations for: " + RegionName + " in " + smaliFile.FileName, 3);

        for (Operation op : OperationList) {
            // skip these, we've already done them in match()
            if (op.getType() == Operation.OpTypes.MATCH) {
                continue;
            }

            evaluateOperationAttributes(op);

            switch (op.getType()) {
            case FIND:
                performFindOperation(op);
                break;
            case INSERT:
                performInsertOperation(smaliFile, op);
                break;
            case REPLACE:
                performReplaceOperation(smaliFile, op);
                break;
            default:
                break;
            }
        }
    }

    @SuppressWarnings("unused")
    private ArrayList<Integer[]> findRegions(String regex, CharSequence subSequence) {
        return findRegions(regex, subSequence, 0);
    }

    private ArrayList<Integer[]> findRegions(String regex, CharSequence subSequence, int limit) {

        Pattern p = Pattern.compile(regex);
        Matcher m = p.matcher(subSequence);
        ArrayList<Integer[]> result = new ArrayList<Integer[]>();

        int count = 0;
        while (((limit == 0) || (count < limit)) && m.find()) {
            Console.debug("  findRegexRegions: " + regex + "\n  matched:" + subSequence.subSequence(m.start(), m.end()),
                            3);
            result.add(new Integer[] { m.start(), m.end() });
            count++;
        }

        return result;
    }

    private boolean allAttributesEmpty(Operation op) {
        return op.getAfterOPStr().isEmpty() && op.getBeforeOPStr().isEmpty() && op.getInsideOPStr().isEmpty()
                        && op.getInsideRegex().isEmpty() && op.getAfterRegex().isEmpty()
                        && op.getBeforeRegex().isEmpty();
    }

    private void evaluateLocalVarDependencies(Operation op) {
        for (Variable var : op.DependentVarsList) {
            Operation depOP = findOpByVar(var);

            // cross-region deps are already eval'ed
            if (!depOP.HasBeenEvaluated) {
                Console.debug("  dependency eval recursion into " + depOP, 3);
                evaluateOperationAttributes(depOP);
                performFindOperation(depOP);
            }
        }
    }

    // get found offsets for operation in terms of a variable
    private ArrayList<Integer[]> getFoundOffsetsForVariable(Variable var) {
        ArrayList<Integer[]> result = new ArrayList<Integer[]>();

        // -1 means give us all offsets
        if (var.Index != -1) {
            result.add(findOpByVar(var).FoundOffsets.get(var.Index));
        } else {
            result.addAll(findOpByVar(var).FoundOffsets);
        }

        return result;
    }

    // set search offsets in operation using attributes
    private void evaluateOperationAttributes(Operation op) {
        Console.debug("Evaluating attributes of operation " + op + ".", 2);
        Console.debug("  dependent on: " + op.DependentVarsList.toString(), 3);

        // If there are no attributes, just set the offsets to min/max

        if (allAttributesEmpty(op)) {
            op.SearchOffsets.add(new Integer[] { 0, MatchedLines.length() });
        } else {
            evaluateLocalVarDependencies(op);
        }

        ArrayList<Integer[]> offsets = new ArrayList<Integer[]>();

        if (!op.getInsideRegex().isEmpty()) {
            op.SearchOffsets = findRegions(op.getInsideRegex(), MatchedLines, op.getLimit());
        } else if (!op.getInsideOPStr().isEmpty()) {
            Variable var = op.getInsideOP();
            op.SearchOffsets = getFoundOffsetsForVariable(var);
        } else {
            ArrayList<Integer[]> rawOffsets = new ArrayList<Integer[]>();

            if (!op.getAfterRegex().isEmpty()) {
                rawOffsets = findRegions(op.getAfterRegex(), MatchedLines, op.getLimit());
            } else if (!op.getBeforeRegex().isEmpty()) {
                rawOffsets = findRegions(op.getBeforeRegex(), MatchedLines, op.getLimit());
            } else if (!op.getAfterOPStr().isEmpty()) {
                Variable var = op.getAfterOP();
                rawOffsets = getFoundOffsetsForVariable(var);
            } else if (!op.getBeforeOPStr().isEmpty()) {
                Variable var = op.getBeforeOP();
                rawOffsets = getFoundOffsetsForVariable(var);
            }

            // rawOffsets contain the offsets for start/stop of each region
            // but that is the same as inside, we want before or after
            if (!op.getAfterRegex().isEmpty() || !op.getAfterOPStr().isEmpty()) {
                // offsets should be end of found region to end of file
                for (Integer[] set : rawOffsets) {
                    offsets.add(new Integer[] { set[1], MatchedLines.length() });
                }
            } else if (!op.getBeforeRegex().isEmpty() || !op.getBeforeOPStr().isEmpty()) {
                // offsets should be from 0 to start of region
                for (Integer[] set : rawOffsets) {
                    offsets.add(new Integer[] { 0, set[0] });
                }
            }

            op.SearchOffsets.addAll(offsets);
        }

        Console.debug("  " + op + "'s evaluated search offsets relative to region:", 2);
        for (Integer[] searchOffsets : op.SearchOffsets) {
            Console.debug("  " + searchOffsets[0] + " - " + searchOffsets[1], 3);
        }

        op.HasBeenEvaluated = true;
    }

    private String replaceVarsWithNearestValues(String valStr, Integer valOffset, ArrayList<Variable> depVar) {

        // No dependent variables to replace
        if (depVar == null) {
            return valStr;
        }

        Pattern p = Pattern.compile("%.+?%");
        Matcher m = p.matcher(valStr);

        // No more vars unevaluated
        if (!m.find()) {
            return valStr;
        }

        Integer realDiff = Integer.MAX_VALUE;
        Console.debug("Replacing variables in: " + valStr, 3);

        for (Variable var : depVar) {
            Integer smallestAbsDiff = Integer.MAX_VALUE;
            Integer closestIndex = 0;

            Operation op = findOpByVar(var);

            String varVal;
            Console.debug("  getting offsets for var: " + var.toString() + ".", 3);

            // loop through all the places this op was found
            // and find the one with the shortest distance from where we are
            for (int i = 0; i < op.FoundOffsets.size(); i++) {
                Integer[] curOffsets = op.FoundOffsets.get(i);

                // Integer diff = valOffset - curOffsets[0];
                Integer diff = curOffsets[0] - valOffset;
                if (Math.abs(diff) <= smallestAbsDiff) {
                    closestIndex = i;
                    smallestAbsDiff = Math.abs(diff);
                    realDiff = diff;
                }
            }

            if (var.Index >= 0) {
                if (realDiff >= 0) {
                    // we're looking ahead, so for every increase in var index
                    // poke the index up by one
                    closestIndex += var.Index;
                } else {
                    // looking backwards, so subtract max var index and add index
                    closestIndex = (closestIndex - ((op.FoundOffsets.size() / op.SearchOffsets.size()) - 1))
                                    + var.Index;
                }
            }

            Integer[] closestOffsets = op.FoundOffsets.get(closestIndex);
            varVal = MatchedLines.substring(closestOffsets[0], closestOffsets[1]);
            String varRegion = (var.Region.isEmpty() == true) ? "(.+?:)?" : var.Region + ":";
            String varIndex = (var.Index == -1) ? "(:\\d+?)?" : ":" + var.Index;

            // varVal's $'s must be escaped or replaceAll will say "No group 3"
            valStr = valStr.replaceAll("%" + varRegion + Pattern.quote(var.Name) + varIndex + "%",
                            Matcher.quoteReplacement(varVal));
            Console.debug("  " + var.toString() + "'s closest value @" + valOffset + " is @" + closestOffsets[0]
                            + " with: " + varVal, 3);
        }

        return valStr;
    }

    private void performFindOperation(Operation op) {
        Console.debug("Performing FIND operation " + op + ".", 2);

        for (Integer[] offsets : op.SearchOffsets) {
            String subRegion = MatchedLines.substring(offsets[0], offsets[1]);
            Console.debug("  inside region " + offsets[0] + ", " + offsets[1], 2);
            // Console.debug(subRegion, 3);
            ArrayList<Integer[]> foundOffsets = findRegions(op.getValue(), subRegion, op.getLimit());

            // Offset each found offset by region start offset
            for (Integer[] fos : foundOffsets) {
                fos[0] += offsets[0];
                fos[1] += offsets[0];
            }

            op.FoundOffsets.addAll(foundOffsets);
        }

        if (op.FoundOffsets.isEmpty()) {
            Console.debug("  none found!", 2);
        } else {
            Console.debug("  matched offsets:", 2);
            for (Integer[] foundOffsets : op.FoundOffsets) {
                Console.debug("  " + foundOffsets[0] + " - " + foundOffsets[1], 3);
            }
        }
    }

    private void performInsertOperation(SmaliFile sf, Operation op) {
        Console.debug("Performing INSERT operation " + op + ".", 2);

        if (!allDependentOpsFound(op)) {
            Console.debug(" Skipping. Not all dependent ops found.", 2);
            return;
        }

        for (Integer[] offsets : op.SearchOffsets) {
            String modValue = op.getValue();
            Integer modOffset = (!op.getBeforeRegex().isEmpty() || !op.getBeforeOPStr().isEmpty()) ? offsets[1]
                            : offsets[0];
            modValue = replaceVarsWithNearestValues(modValue, modOffset, op.DependentVarsList);

            sf.addInsert(StartOffset + modOffset, modValue);
        }
    }

    private void performReplaceOperation(SmaliFile sf, Operation op) {
        Console.debug("Performing REPLACE operation " + op + ".", 2);

        if (!allDependentOpsFound(op)) {
            Console.debug(" Skipping. Not all dependent ops found.", 2);
            return;
        }

        for (Integer[] offsets : op.SearchOffsets) {
            String replaceWhat = op.getReplaceWhat();
            String modValue = op.getValue();
            Integer modOffset = (!op.getBeforeRegex().isEmpty() || !op.getBeforeOPStr().isEmpty()) ? offsets[1]
                            : offsets[0];

            // Rather wasteful since it may not need to be called multiple times
            // ALWAYS use offsets[0] because that's the start of the region
            // and we want to replace stuff with indexes starting at the beginning
            // not right to left (makes perfect sense)
            replaceWhat = replaceVarsWithNearestValues(replaceWhat, modOffset, op.DependentVarsList);
            modValue = replaceVarsWithNearestValues(modValue, modOffset, op.DependentVarsList);

            // TODO: change addreplace to take beginning and end offset?
            sf.addReplace(StartOffset + modOffset, replaceWhat, modValue);
        }
    }

    private boolean performMatchOperation(Operation op) {
        Console.debug("Performing MATCH operation " + op + ".", 2);

        // look inside RegionLines
        ArrayList<Integer[]> offsets = findRegions(op.getValue(), MatchedLines, op.getLimit());

        if (offsets.isEmpty()) {
            return false;
        }

        op.FoundOffsets = offsets;

        return true;
    }

    private boolean allDependentOpsFound(Operation op) {
        Operation depOP;
        for (Variable var : op.DependentVarsList) {
            depOP = findOpByVar(var);
            if (depOP.FoundOffsets.isEmpty()) {
                return false;
            }
        }

        return true;
    }

    private boolean findRegion(SmaliFile sf, int start) {
        Matcher m;

        if (start >= sf.FileLines.length()) {
            return false;
        }

        // If a region has no start or end pattern, this will always return true
        // and MatchedLines will include the entire file.
        if (StartPattern != null) {
            // Get where the region starts, or we can't find it (return false)
            // Assuming there are not multiple regions!!
            m = StartPattern.matcher(sf.FileLines.substring(start));
            if (m.find()) {
                StartOffset = m.start() + start;
            } else {
                return false;
            }
        } else {
            StartOffset = 0;
        }

        if (EndPattern != null) {
            // Get where the region starts, or we can't find it (return false)
            // Assuming there are not multiple regions!!
            m = EndPattern.matcher(sf.FileLines.subSequence(StartOffset, sf.FileLines.length()));
            if (m.find()) {
                EndOffset = StartOffset + m.end();
            } else {
                return false;
            }
        } else {
            EndOffset = sf.FileLines.length();
        }

        Console.debug("Region " + RegionName + " starts:" + StartOffset + " ends:" + EndOffset, 2);

        MatchedLines = sf.FileLines.substring(StartOffset, EndOffset);

        return true;
    }

    public Operation findOpByVar(Variable var) {
        // TODO: Must have highest resolution
        for (Operation op : OperationList) {
            if (op.getName().equals(var.Name)) {
                return op;
            }
        }

        return null;
    }
}