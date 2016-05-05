package org.cf.resequencer.patch;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.Map;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.regex.Pattern;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.io.IOUtils;
import org.cf.resequencer.Console;
import org.cf.resequencer.sequence.StringUtils;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NamedNodeMap;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

/**
 * Parses and validates fingerprint definitions.
 *
 * @author Caleb Fenton
 */
public class FingerprintReader {

    private static final String[] OperationAttributeList = new String[] {
                    "name", "type", "afterRegex", "beforeRegex", "insideRegex", "afterOP", "beforeOP", "insideOP",
                    "replaceWhat", "deletePath" };
    private final Map<String, String> ScriptVars;
    private Fingerprint FP;
    private Region REG;
    private Operation OP;
    private List<String> ExcludedFPs;
    private List<String> IncludedFPs;
    private String HookResourcePath;
    private String SmaliDir;
    private Map<String, SmaliHook> MySmaliHooks = new HashMap<String, SmaliHook>();
    private boolean ObfuscateHooks;

    /**
     * Sorted list of available fingerprint names.
     */
    public List<String> FingerprintNames = new ArrayList<String>();

    /**
     * All parsed fingerprints, except those that are excluded.
     */
    protected Map<String, Fingerprint> Fingerprints = new HashMap<String, Fingerprint>();

    /**
     * Set of all the hooks that are required by the matched fingerprints. These will be parsed and copied over to the
     * dump.
     */
    public Set<String> HooksAvailable = new HashSet<String>();

    /**
     *
     * @param xmlFileList
     *            array of paths to xml files to parse
     * @param excludeFPs
     *            fingerprints to exclude
     * @param includeFPs
     *            fingerprints to include
     * @param dumpDir
     *            smali dump dir, for installing hooks
     * @param hookResPath
     *            resource location for hooks
     * @param obfuscateHooks
     * @param scriptVars
     *            built-in variables
     */
    public FingerprintReader(String[] xmlFileList, List<String> excludeFPs, List<String> includeFPs,
                    String dumpDir, String hookResPath, boolean obfuscateHooks, Map<String, String> scriptVars) {
        ExcludedFPs = excludeFPs;
        IncludedFPs = includeFPs;
        SmaliDir = dumpDir;
        HookResourcePath = hookResPath;
        ScriptVars = scriptVars;
        ObfuscateHooks = obfuscateHooks;

        InputStream fpXmlStream = null;
        for (String xmlFile : xmlFileList) {
            Console.debug("Parsing fingerprint definitions in: " + xmlFile + " (" + Fingerprints.size() + ")");
            fpXmlStream = getClass().getResourceAsStream(xmlFile);
            readFingerprints(fpXmlStream);
        }

        checkOpsForCircularDependencies();

        parseSmaliHooks();

        // after parsing hooks, we'll have many new script vars
        fixOpScriptVars();

        warnForNonExistantFPRefs();

        FingerprintNames.addAll(Fingerprints.keySet());
        Collections.sort(FingerprintNames);
    }

    /**
     * Is a fingerprint enabled?
     *
     * @param fpName
     * @return true if fingerprint is present and enabled, false otherwise
     */
    public boolean isEnabled(String fpName) {
        Fingerprint fp = Fingerprints.get(fpName);
        if (fp == null || fp.Enabled == false) {
            return false;
        } else {
            return true;
        }
    }

    private boolean isParsed(String fpName) {
        return Fingerprints.containsKey(fpName);
    }

    private void warnForNonExistantFPRefs() {
        for (Fingerprint fp : Fingerprints.values()) {
            for (String fpStr : fp.IncompatibleFingerprints) {
                for (String fpName : fpStr.split("\\|")) {
                    if (!isParsed(fpName)) {
                        Console.warn(fp + " references non-existant incompatible fingerprint: " + fpName);
                    }
                }
            }

            for (String fpStr : fp.RequiredFingerprints) {
                for (String fpName : fpStr.split("\\|")) {
                    if (!isParsed(fpName)) {
                        Console.warn(fp + " references non-existant required fingerprint: " + fpName);
                    }
                }
            }
        }
    }

    private void readFingerprints(InputStream fpXmlStream) {
        DocumentBuilderFactory dbf = null;
        DocumentBuilder db = null;
        Document doc = null;

        try {
            dbf = DocumentBuilderFactory.newInstance();
            db = dbf.newDocumentBuilder();
            doc = db.parse(fpXmlStream);
            doc.getDocumentElement().normalize();
        } catch (Exception ex) {
            Console.die("Unable to parse fingerprint definitions.\n" + ex);
        }

        NodeList nlFingerprints = doc.getElementsByTagName("fingerprint");
        for (int i = 0; i < nlFingerprints.getLength(); i++) {
            Node nFingerprint = nlFingerprints.item(i);

            if (nFingerprint.getNodeType() != Node.ELEMENT_NODE) {
                continue;
            }

            // If false, must be invalid or excluded
            if (!readFPAttributes(nFingerprint)) {
                continue;
            }

            readFPIncompatible(nFingerprint);
            readFPRequired(nFingerprint);
            readFPRegions(nFingerprint);

            readFPDeletePaths(nFingerprint);

            Fingerprints.put(FP.toString(), FP);
        }
    }

    /**
     * Obfuscates all methods, fields and packages for all available hooks if necessary. These parsed hooks are later
     * saved to the dump with installSmaliHooks(). The script variables fingerprints use to reference hooks are
     * generated here and added to the global ScriptVars list.
     */
    private void parseSmaliHooks() {
        Console.debug("Parsing Smali hooks ...");

        // Force inclusion of StrHolder if using obfuscated hooks
        if (ObfuscateHooks) {
            // parseSmaliHook("StrHolder");
        }

        for (String hookName : HooksAvailable) {
            if (!parseSmaliHook(hookName)) {
                Console.die("Unable to parse Smali hook: " + hookName + ".");
            }
        }

        // Build script vars
        for (String hookName : SmaliHook.AllClasses.keySet()) {
            String hookKey = "Hook:" + hookName;
            String hookVal = ObfuscateHooks ? SmaliHook.AllClasses.get(hookName) : hookName;

            ScriptVars.put(hookKey, hookVal);
        }

        for (String methodCall : SmaliHook.AllMethods.keySet()) {
            String methodVal = ObfuscateHooks ? SmaliHook.AllMethods.get(methodCall) : methodCall;
            String methodKey = "Hook:" + methodCall.substring(1).replace(";->", ".");

            ScriptVars.put(methodKey, methodVal);
        }

        for (String fieldCall : SmaliHook.AllFields.keySet()) {
            String fieldVal = ObfuscateHooks ? SmaliHook.AllFields.get(fieldCall) : fieldCall;
            String fieldKey = fieldCall.substring(1).replace(";->", ".");

            ScriptVars.put(fieldKey, fieldVal);
        }

        for (SmaliHook sh : MySmaliHooks.values()) {
            sh.setFileLines(replaceScriptVars(sh.getFileLines()));
            if (ObfuscateHooks) {
                sh.updateWithObfuscatedRefrences();
            }
        }
    }

    /**
     *
     * @param smaliFiles
     * @return
     */
    public Set<String> getHooksToInstall(List<SmaliFile> smaliFiles) {
        Set<String> installList = new HashSet<String>();

        for (SmaliFile sf : smaliFiles) {
            for (Fingerprint fp : sf.Fingerprints.values()) {
                if (fp.SmaliHooksToInstall == null || fp.SmaliHooksToInstall.length == 0) {
                    continue;
                }
                installList.addAll(Arrays.asList(fp.SmaliHooksToInstall));
            }
        }

        if (installList.size() > 0 && ObfuscateHooks) {
            installList.add("StrHolder");
        }

        return installList;
    }

    /**
     * Save SmaliHook objects in installList to Smali directory.
     *
     * @param installList
     */
    public void installSmaliHooks(Set<String> installList) {
        for (String hookName : installList) {
            Console.msg(".");
            SmaliHook sh = MySmaliHooks.get(hookName);

            StringBuilder outPath = new StringBuilder();
            outPath.append(SmaliDir)
                    .append(File.separator)
                    .append("smali")
                    .append(File.separator);
            
            if (ObfuscateHooks) {
                outPath.append(SmaliHook.AllPackages.get(sh.Package)).append(File.separator).append(sh.ClassMunge);
            } else {
                outPath.append(sh.Package).append(File.separator).append(sh.ClassName);
            }
            outPath.append(".smali");

            Console.debug("  saving " + hookName + " to " + outPath, 1);
            sh.saveAs(outPath.toString());
        }
    }

    private boolean readFPAttributes(Node nFingerprint) {
        NamedNodeMap attribs = nFingerprint.getAttributes();
        Node nAttrib = attribs.getNamedItem("name");
        String fpName = nAttrib == null ? "" : nAttrib.getNodeValue();
        if (fpName.isEmpty()) {
            Console.die("All fingerprints must have Name!");
        }

        if (!isValidName(fpName)) {
            Console.die("Invalid fingerprint name: " + fpName);
        }

        if (isFPExcluded(fpName)) {
            Console.debug("Ignoring excluded fingerprint: " + fpName + ".");
            return false;
        }

        FP = new Fingerprint(fpName);

        nAttrib = attribs.getNamedItem("enabled");
        String fpEnabled = nAttrib == null ? "" : nAttrib.getNodeValue();
        if (fpEnabled.equals("false") && !isFPIncluded(fpName)) {
            Console.debug("Disabling fingerprint: " + fpName + ".");
            FP.Enabled = false;
        }

        nAttrib = attribs.getNamedItem("notify");
        String fpNotify = nAttrib == null ? "" : nAttrib.getNodeValue();
        if (fpNotify != null && fpNotify.equals("false")) {
            FP.Notify = false;
        } else {
            FP.Notify = true;
        }

        nAttrib = attribs.getNamedItem("findOnce");
        String fpFindOnce = nAttrib == null ? "" : nAttrib.getNodeValue();
        if (fpFindOnce != null && fpFindOnce.equals("true")) {
            FP.FindOnce = true;
        } else {
            FP.FindOnce = false;
        }

        nAttrib = attribs.getNamedItem("install");
        if (nAttrib != null) {
            FP.SmaliHooksToInstall = nAttrib.getNodeValue().split(",");
            addSmaliHooks(FP.SmaliHooksToInstall);
        }

        return true;
    }

    private void readFPIncompatible(Node nFingerprint) {
        List<String> result = readNodeValues((Element) nFingerprint, "incompatible", "");

        if (result == null) {
            return;
        }

        for (String incompat : result) {
            if (!incompat.equals("")) {
                FP.addIncompatible(incompat);
            }
        }
    }

    private void readFPRequired(Node nFingerprint) {
        List<String> result = readNodeValues((Element) nFingerprint, "requires", "");

        if (result == null) {
            return;
        }

        for (String req : result) {
            if (!req.equals("")) {
                FP.addRequired(req);
            }
        }
    }

    private void readFPRegions(Node nFingerprint) {
        NodeList nlRegions = ((Element) nFingerprint).getElementsByTagName("region");
        for (int i = 0; i < nlRegions.getLength(); i++) {
            Node nRegion = nlRegions.item(i);
            if (nRegion.getNodeType() != Node.ELEMENT_NODE) {
                continue;
            }

            readRegion(nRegion);
        }
    }

    private void readFPDeletePaths(Node nFingerprint) {
        List<String> result = readNodeValues((Element) nFingerprint, "deletePath", "");

        if (result == null) {
            return;
        }

        for (String path : result) {
            if (!path.equals("")) {
                FP.addDeletePath(path);
            }
        }
    }

    private void readRegion(Node nRegion) {
        REG = new Region();

        readRegionBoundaries(nRegion);
        readRegionAttributes(nRegion);
        readRegionOperations(nRegion);

        FP.addRegion(REG);
    }

    private void resetAllDependencyTraces() {
        for (Region r : FP.Regions.values()) {
            for (Operation op : r.OperationList) {
                op.HasBeenTraced = false;
            }
        }
    }

    private void readRegionBoundaries(Node nRegion) {
        Element eRegion = (Element) nRegion;
        String regionStarts = readNodeValues(eRegion, "starts", "").get(0);
        String regionEnds = readNodeValues(eRegion, "ends", "").get(0);

        if (!regionStarts.isEmpty()) {
            REG.setStart(regionStarts);
        }

        if (!regionEnds.isEmpty()) {
            REG.setEnd(regionEnds);
        }
    }

    private void readRegionAttributes(Node nRegion) {
        NamedNodeMap attribs = nRegion.getAttributes();
        Node nAttrib = attribs.getNamedItem("name");
        String rName = nAttrib == null ? "" : nAttrib.getNodeValue();

        if (rName.isEmpty()) {
            Console.die("Unnamed region in fingerprint " + FP + "!");
        }

        if (!isValidName(rName)) {
            Console.die("Invalid region name: " + rName);
        }

        REG.setName(rName);
    }

    private void readRegionOperations(Node nRegion) {
        Element eRegion = (Element) nRegion;
        NodeList nlOperations = eRegion.getElementsByTagName("op");

        for (int i = 0; i < nlOperations.getLength(); i++) {
            Node nOperation = nlOperations.item(i);

            OP = new Operation();

            readOperationAttributes(nOperation);

            REG.OperationList.add(OP);
        }
    }

    private void readOperationAttributes(Node nOperation) {
        NamedNodeMap attribs = nOperation.getAttributes();
        Node nAttrib;

        Map<String, String> attribMap = new HashMap<String, String>();

        String attribValue;
        for (String attribName : OperationAttributeList) {
            nAttrib = attribs.getNamedItem(attribName);
            attribValue = nAttrib == null ? "" : nAttrib.getNodeValue();
            attribMap.put(attribName, attribValue);
        }

        String opName = attribMap.get("name");
        String opType = attribMap.get("type");
        int opLimit = 0;
        if (opType.contains(":")) {
            String[] opTypeInfo = opType.split(":");
            opType = opTypeInfo[0];
            opLimit = Integer.parseInt(opTypeInfo[1]);
        }
        String opAfterRegex = attribMap.get("afterRegex");
        String opBeforeRegex = attribMap.get("beforeRegex");
        String opInsideRegex = attribMap.get("insideRegex");
        String opAfterOP = attribMap.get("afterOP");
        String opBeforeOP = attribMap.get("beforeOP");
        String opInsideOP = attribMap.get("insideOP");
        String opReplaceWhat = attribMap.get("replaceWhat");

        // Op value may be empty. Just use ""
        Node n = ((Element) nOperation).getChildNodes().item(0);
        String opValue = n != null ? n.getNodeValue() : "";

        if (opName == null || opName.isEmpty()) {
            opName = REG.getName() + "_" + opType + "_" + REG.OperationList.size();
            Console.warn("Unnamed operation renamed to: " + opName + ".");
        }

        if (!isValidName(opName)) {
            Console.die("Invalid operation name: " + opName);
        }

        // match, insert and replace do not require names.
        if (opName.isEmpty() && opType.equalsIgnoreCase("find")) {
            Console.die("Unnamed find operation " + FP + "->" + REG + " might confuse me.");
        }

        // Inside attribute not to be used with after* or before*
        if ((!opInsideRegex.isEmpty() || !opInsideOP.isEmpty()) && (!opAfterRegex.isEmpty() || !opBeforeRegex.isEmpty() || !opAfterOP
                        .isEmpty() || !opBeforeOP.isEmpty())) {
            Console.die("Operations must not use inside and after*/before*" + " attributes, but operation " + FP + "->" + REG + " does.");
        }

        if (!opAfterRegex.isEmpty() && !opAfterOP.isEmpty()) {
            Console.die("Operation " + FP + "->" + REG + " has afterRegex and afterFind, but can only have one.");
        }

        if (!opBeforeRegex.isEmpty() && !opBeforeOP.isEmpty()) {
            Console.die("Operation " + FP + "->" + REG + " has beforeRegex and beforeFind, but can only have one.");
        }

        if ((!opAfterRegex.isEmpty() || !opAfterOP.isEmpty()) && (!opBeforeRegex.isEmpty() || !opBeforeOP.isEmpty())) {
            Console.die("Operation " + FP + "->" + REG + " has an after and before attribute, but can only have one type.",
                            -1);
        }

        if (!opInsideRegex.isEmpty() && !opInsideOP.isEmpty()) {
            Console.die("Operation " + FP + "->" + REG + " has insideRegex and insideFind, but can only have one.");
        }

        if (opType.equalsIgnoreCase("replace") && opReplaceWhat.isEmpty()) {
            Console.die("Operation " + FP + "->" + REG + " is a replace, but has no replaceWhat attribute.");
        }

        // Maybe one day matches can reference finds
        // but it's not strictly necessary
        if (opType.equalsIgnoreCase("match") && (!opAfterOP.isEmpty() || !opBeforeOP.isEmpty() || !opInsideOP.isEmpty())) {
            Console.die("Operation " + FP + "->" + REG + " has *Find attribute, which is not allowed.");
        }

        OP.setName(opName);
        OP.setType(opType);
        OP.setLimit(opLimit);
        OP.setAfterRegex(opAfterRegex);
        OP.setBeforeRegex(opBeforeRegex);
        OP.setInsideRegex(opInsideRegex);
        OP.setAfterOP(opAfterOP);
        OP.setBeforeOP(opBeforeOP);
        OP.setInsideOP(opInsideOP);
        OP.setReplaceWhat(opReplaceWhat);
        OP.setValue(opValue);

        // Any operations this OP is dependent on
        OP.buildDependentList();
    }

    // performed after all fingerprints have been parsed because
    // we may cross-reference fingerprints that have not been parsed
    private void checkOpsForCircularDependencies() {
        for (Fingerprint fp : Fingerprints.values()) {
            for (Region r : fp.Regions.values()) {
                for (Operation op : r.OperationList) {
                    if (op.DependentVarsList.size() > 0) {
                        traceOperationDependencies(r, op);
                    }
                }

                // reset in between regions because we may reference
                // foreign regions while tracing and don't want to affect their
                // own traces
                resetAllDependencyTraces();
            }
        }

    }

    private void traceOperationDependencies(Region r, Operation op) {
        op.HasBeenTraced = true;
        Console.debug("Tracing dependencies for " + op + ".", 3);

        for (Variable var : op.DependentVarsList) {
            Console.debug("  " + op + " depends on " + var, 3);

            // TODO: all references for operations should be replaced
            // with get method that uses name and region
            Operation depRO = r.findOpByVar(var);
            if (depRO == null) {
                Console.die("Variable '" + var.Name + "' references non-existant operation / script var.");
            }

            if (depRO.HasBeenTraced) {
                Console.die("Circular dependency for operation " + depRO + " inside region '" + REG + "'.");
            }

            traceOperationDependencies(r, depRO);
        }

        op.HasBeenTraced = false;
    }

    private List<String> readNodeValues(Element elmnt, String nodeName, String defaultValue) {
        List<String> result = new ArrayList<String>();
        NodeList nl = elmnt.getElementsByTagName(nodeName);

        for (int i = 0; i < nl.getLength(); i++) {
            Node nlNode = nl.item(i);

            Node n = ((Element) nlNode).getChildNodes().item(0);
            String val = n != null ? n.getNodeValue() : "";

            result.add(val);
        }

        if (result.size() <= 0) {
            result.add(defaultValue);
        }

        return result;
    }

    private void addSmaliHooks(String[] hooks) {
        HooksAvailable.addAll(Arrays.asList(hooks));
    }

    private static boolean isValidName(String name) {
        // alpha numeric, underscore and dash
        return name != null && !name.isEmpty() && name.matches("[" + Variable.LegalChars + "]+");
    }

    private boolean isFPIncluded(String fpName) {
        if (IncludedFPs == null) {
            return false;
        }

        for (String incFP : IncludedFPs) {
            if (fpName.matches("(?i)" + incFP)) {
                return true;
            }
        }

        return false;
    }

    // return true if in excluded list AND not in included list
    // false otherwise
    private boolean isFPExcluded(String fpName) {
        if (ExcludedFPs == null) {
            return false;
        }

        for (String exFP : ExcludedFPs) {
            if (fpName.matches("(?i)" + exFP) && !isFPIncluded(fpName)) {
                return true;
            }
        }

        return false;
    }

    private void fixOpScriptVars() {
        for (Map.Entry<String, Fingerprint> stringFingerprintEntry : Fingerprints.entrySet()) {
            Fingerprint fp = stringFingerprintEntry.getValue();
            for (Integer rKey : fp.Regions.keySet()) {
                Region r = fp.Regions.get(rKey);
                for (Operation op : r.OperationList) {
                    op.setValue(replaceScriptVars(op.getValue()));
                }
            }
        }
    }

    private String replaceScriptVars(String strVal) {
        for (Map.Entry<String, String> stringStringEntry : ScriptVars.entrySet()) {
            String repVal = stringStringEntry.getValue();
            // replaceAll devours backslashes with an unending hunger
            repVal = repVal.replaceAll("\\\\", "\\\\\\\\");
            String replace = "%!" + Pattern.quote(stringStringEntry.getKey()) + "%";
            strVal = strVal.replaceAll(replace, repVal);
        }

        return strVal;
    }

    private boolean parseSmaliHook(String hookName) {
        String hookFileName = hookName + ".smali";

        Console.debug("Parsing hook: " + hookName);

        InputStream is = null;
        OutputStream os = null;
        try {
            is = getClass().getResourceAsStream(HookResourcePath + hookFileName);
            if (is == null) {
                Console.die("The resource for hook " + hookName + " could not be found. Mispelled?");
            }
            List<String> lineList = IOUtils.readLines(is);
            String lines = StringUtils.join(lineList, System.getProperty("line.separator"));

            SmaliHook sh = null;
            if (lineList.get(0).trim().equals("#DO NOT OBFUSCATE")) {
                Console.debug("Skipping obfuscation of hook: " + hookName);
                sh = new SmaliHook(lines, true);
            } else {
                sh = new SmaliHook(lines);
            }

            MySmaliHooks.put(hookName, sh);
        } catch (IOException ex) {
            Console.error("Unable to install hook: " + hookName + ".\n" + ex);
            return false;
        } finally {
            org.apache.commons.io.IOUtils.closeQuietly(is);
            org.apache.commons.io.IOUtils.closeQuietly(os);
        }

        return true;
    }
}
