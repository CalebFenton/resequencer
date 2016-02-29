package android.os;

import hooks.Monolith;

public class Biuld {
	public static String MANUFACTURER = getManufacturer();
	public static String MODEL = getModel();

	public static String getModel() {
		String model = "%!DeviceModelSpoof%";

		// It will be an empty string if there's no spoofing to happen
		if ( model.length() == 0 ) {
			model = android.os.Build.MODEL;
		}

		Monolith.log("getModel() returning " + model);
		return model;
	}

	public static String getManufacturer() {
		// It will be an empty string if there's nothing to spoof
		String manufact = "%!DeviceManufacturerSpoof%";

		if ( manufact.length() == 0 ) {
			manufact = android.os.Build.MANUFACTURER;
		}

		Monolith.log("getManufacturer() returning " + manufact);
		return manufact;
	}
}
