package dexequencelib;

/**
 * 
 * @author Caleb Fenton
 */
public class ResourceItem implements Comparable {
    public String Type;
    public String Name;
    public long ID;
    public String Value;

    ResourceItem(String type, String name, String id) {
        Type = type;
        Name = name;
        if (id.startsWith("0x")) {
            id = id.replaceFirst("0x", "");
        }
        ID = Long.parseLong(id, 16);
    }

    @Override
    public String toString() {
        return Type + " res(" + Name + " / " + ID + ") = " + (Value == null ? "null" : "'" + Value + "'");
    }

    public void setValue(String val) {
        val = val.replace("\n", "\\n");
        val = val.replace("\r", "\\r");
        Value = val;
    }

    public int compareTo(Object o) {
        return (int) (this.ID - ((ResourceItem) o).ID);
    }
}
