package org.cf.resequencer.patch;

import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.cf.resequencer.Console;

/**
 * Represents information necessary for operations.
 * 
 * @author Caleb Fenton
 */
class Operation implements Cloneable {
    /**
     * Operation types
     */
    public enum OpTypes {
        MATCH,
        FIND,
        INSERT,
        REPLACE
    }

    private String RegionName;
    private OpTypes OpType;
    private int OpLimit;
    private String Value;
    private String AfterRegex;
    private String BeforeRegex;
    private String InsideRegex;
    private String AfterOPStr;
    private String BeforeOPStr;
    private String InsideOPStr;
    private Variable AfterOP;
    private Variable BeforeOP;
    private Variable InsideOP;
    private String ReplaceWhat;

    /**
     * List of start and end offsets this operation has been found.
     */
    public ArrayList<Integer[]> FoundOffsets;
    /**
	 *
	 */
    public ArrayList<Integer[]> SearchOffsets;
    /**
	 *
	 */
    public boolean HasBeenEvaluated;
    /**
     * Used for dependency tracing.
     */
    public boolean HasBeenTraced;
    /**
	 *
	 */
    public ArrayList<Variable> DependentVarsList;

    Operation() {
        FoundOffsets = new ArrayList<Integer[]>();
        SearchOffsets = new ArrayList<Integer[]>();
        HasBeenEvaluated = false;
        HasBeenTraced = false;
        DependentVarsList = new ArrayList<Variable>();
        OpLimit = 0;
    }

    Operation(String name, OpTypes opType, int opLimit, String value, String afterRegex, String beforeRegex,
                    String insideRegex, String afterFind, String beforeFind, String insideFind, String replaceWhat) {
        this();
        RegionName = name;
        OpType = opType;
        OpLimit = opLimit;
        Value = value;
        AfterRegex = afterRegex;
        BeforeRegex = beforeRegex;
        InsideRegex = insideRegex;
        AfterOPStr = afterFind;
        BeforeOPStr = beforeFind;
        InsideOPStr = insideFind;
        ReplaceWhat = replaceWhat;
    }

    @Override
    public Operation clone() {
        Operation roClone = new Operation(RegionName, OpType, OpLimit, Value, AfterRegex, BeforeRegex, InsideRegex,
                        AfterOPStr, BeforeOPStr, InsideOPStr, ReplaceWhat);

        for (Integer[] offsets : FoundOffsets) {
            roClone.FoundOffsets.add(new Integer[] { offsets[0], offsets[1] });
        }

        for (Integer[] offsets : SearchOffsets) {
            roClone.SearchOffsets.add(new Integer[] { offsets[0], offsets[1] });
        }

        for (Variable fv : DependentVarsList) {
            roClone.DependentVarsList.add(fv.clone());
        }

        // these should be the same across all instances
        // of the same operation
        roClone.AfterOP = AfterOP;
        roClone.BeforeOP = BeforeOP;
        roClone.InsideOP = InsideOP;

        return roClone;
    }

    @Override
    public String toString() {
        return RegionName;
    }

    public String getValue() {
        return Value;
    }

    public String getName() {
        return RegionName;
    }

    public OpTypes getType() {
        return OpType;
    }

    public int getLimit() {
        return OpLimit;
    }

    public String getAfterRegex() {
        return AfterRegex;
    }

    public String getBeforeRegex() {
        return BeforeRegex;
    }

    public String getInsideRegex() {
        return InsideRegex;
    }

    public String getAfterOPStr() {
        return AfterOPStr;
    }

    public String getBeforeOPStr() {
        return BeforeOPStr;
    }

    public String getInsideOPStr() {
        return InsideOPStr;
    }

    public String getReplaceWhat() {
        return ReplaceWhat;
    }

    public Variable getAfterOP() {
        return AfterOP;
    }

    public Variable getBeforeOP() {
        return BeforeOP;
    }

    public Variable getInsideOP() {
        return InsideOP;
    }

    public void setValue(String value) {
        Value = value;
    }

    public void setName(String name) {
        RegionName = name;
    }

    public void setAfterRegex(String regex) {
        AfterRegex = regex;
    }

    public void setBeforeRegex(String regex) {
        BeforeRegex = regex;
    }

    public void setInsideRegex(String regex) {
        InsideRegex = regex;
    }

    public void setAfterOP(String findName) {
        AfterOPStr = findName;
    }

    public void setBeforeOP(String findName) {
        BeforeOPStr = findName;
    }

    public void setInsideOP(String findName) {
        InsideOPStr = findName;
    }

    public void setReplaceWhat(String replaceWhat) {
        ReplaceWhat = replaceWhat;
    }

    public void setType(String type) {
        if (type.equalsIgnoreCase("match")) {
            OpType = OpTypes.MATCH;
        } else if (type.equalsIgnoreCase("find")) {
            OpType = OpTypes.FIND;
        } else if (type.equalsIgnoreCase("insert")) {
            OpType = OpTypes.INSERT;
        } else if (type.equalsIgnoreCase("replace")) {
            OpType = OpTypes.REPLACE;
        }
    }

    public void setLimit(int limit) {
        OpLimit = limit;
    }

    public void buildDependentList() {
        Console.debug("Building dependent operation list for operation " + RegionName + ".", 2);

        if (!AfterOPStr.isEmpty()) {
            AfterOP = parseVariableString(AfterOPStr);
            addDependentVar(AfterOP);
        }

        if (!BeforeOPStr.isEmpty()) {
            BeforeOP = parseVariableString(BeforeOPStr);
            addDependentVar(BeforeOP);
        }

        if (!InsideOPStr.isEmpty()) {
            InsideOP = parseVariableString(InsideOPStr);
            addDependentVar(InsideOP);
        }

        if (!Value.isEmpty()) {
            ArrayList<String> varStrs = parseStringForVariables(Value);
            if (!varStrs.isEmpty()) {
                for (String varStr : varStrs) {
                    addDependentVar(parseVariableString(varStr));
                }
            }
        }

        if (!ReplaceWhat.isEmpty()) {
            ArrayList<String> varStrs = parseStringForVariables(ReplaceWhat);
            if (!varStrs.isEmpty()) {
                for (String varStr : varStrs) {
                    addDependentVar(parseVariableString(varStr));
                }
            }
        }

        Console.debug("  depends on " + DependentVarsList.toString(), 3);
    }

    private void addDependentVar(Variable var) {
        if (var == null) {
            return;
        }

        if (!DependentVarsList.contains(var)) {
            for (Variable depVar : DependentVarsList) {
                if (depVar.equals(var)) {
                    return;
                }
            }

            DependentVarsList.add(var);
        }
    }

    private static ArrayList<String> parseStringForVariables(String str) {
        ArrayList<String> result = new ArrayList<String>();

        Console.debug("Parsing for variables: " + str, 3);

        // find variables in "some string %region:someVar:index%"
        Pattern p = Pattern.compile("%[^!][" + Variable.LegalChars + ":" + Variable.LegalChars + "]+?%");
        Matcher m = p.matcher(str);

        int pos = 0;
        while ((pos < (str.length() - 3)) && m.find(pos)) {
            // remove leading and trailing %'s
            String varStr = str.substring(m.start() + 1, m.end() - 1);
            result.add(varStr);
            pos = m.end() + 1;
        }

        Console.debug("  found variables: " + result + ".", 3);
        return result;
    }

    // split regionName:findName:index to create new variable
    private static Variable parseVariableString(String varStr) {
        String varFingerprint = "";
        String varRegion = "";
        String varName = "";
        int varIndex = -1; // default -1 means apply to every found region

        String[] varSplit = varStr.split(":");

        switch (varSplit.length) {
        case 1:
            varName = varSplit[0];
            break;
        case 2:
            // name:index
            varName = varSplit[0];
            varIndex = Integer.valueOf(varSplit[1]);
            break;
        case 3:
            // ???:name:index or fingerprint:region:name
            try {
                Integer.parseInt(varSplit[2]);
            } catch (NumberFormatException e) {
                Console.die("Invalid variable reference: " + varStr + ".\n"
                                + "If last part is numeric, fingerprint and region are required.");
            }

            // must be fingerprint:region:name
            varFingerprint = varSplit[0];
            varRegion = varSplit[1];
            varName = varSplit[2];
            break;
        case 4:
            // fingerprint:region:name:index
            varFingerprint = varSplit[0];
            varRegion = varSplit[1];
            varName = varSplit[2];
            varIndex = Integer.valueOf(varSplit[3]);
            break;
        }

        return new Variable(varFingerprint, varRegion, varName, varIndex);
    }
}
