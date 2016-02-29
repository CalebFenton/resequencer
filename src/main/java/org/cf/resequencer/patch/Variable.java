package org.cf.resequencer.patch;

/**
 * Represents a variable inside a fingerprint such as %VarName%.
 * 
 * @author Caleb Fenton
 */
class Variable implements Cloneable {
    public final static String LegalChars = "A-z0-9_\\- ";

    public String Fingerprint;
    public String Region;
    public String Name;
    public int Index;

    Variable(String f, String r, String n, int i) {
        // Region and/or fingerprint may be empty strings
        Fingerprint = f;
        Region = r;
        Name = n;

        // Index may be -1
        Index = i;
    }

    @Override
    public Variable clone() {
        return new Variable(Fingerprint, Region, Name, Index);
    }

    @Override
    public String toString() {
        return Fingerprint + ":" + Region + ":" + Name + ":" + Index;
    }

    public boolean equals(Variable var2) {
        return this.toString().equals(var2.toString());
    }
}
