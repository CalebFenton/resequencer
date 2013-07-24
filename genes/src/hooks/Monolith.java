/*
 * TODO:
 * learn to handle reflected constructors:
 * http://www.java2s.com/Code/Java/Language-Basics/
 * ObjectReflectioninvokeconstructorwithparameters.htm
 * Constructor;->newInstance(Object[] arguments);
 */
package hooks;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintStream;
import java.lang.reflect.Field;
import java.security.MessageDigest;
import java.security.SignatureException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Random;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.zip.Checksum;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import android.accounts.Account;
import android.annotation.TargetApi;
import android.bluetooth.BluetoothAdapter;
import android.content.ContentResolver;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.Signature;
import android.net.wifi.WifiInfo;
import android.provider.Settings.Secure;
import android.telephony.TelephonyManager;
import android.util.Log;
import android.view.Gravity;
import android.widget.LinearLayout;
import android.widget.TextView;
import android.widget.Toast;
import dalvik.system.DexFile;

/*
 * TODO:
 * add hook for activity openFileInput
 * learn to handle reflected constructors:
 * http://www.java2s.com/Code/Java/Language-Basics/
 * ObjectReflectioninvokeconstructorwithparameters.htm
 * Constructor;->newInstance(Object[] arguments);
 * write method for Thread.getAllStackTraces() and hook it
 * possibly hook/handle getDigestLength()
 * NOTE:
 * Strings of the for %!SomeString% are replaced when processed by sequencer.
 */

@TargetApi(5)
public class Monolith {
	protected static final boolean DEBUG = true;
	protected static final int DUMP_STACK = 2; // how far back should we dump
												// stacks on log calls?
	protected static FileOutputStream MethodTraceFOS = null;

	public static Context AppContext = null;

	protected static final String MyPrefsFile = "%!RndAlpha%";

	protected static final String MyAppName = "%!AppPackage%";
	protected static final String MyAppVersionName = "%!AppVersionName%";
	protected static final String MyAppVersionCode = "%!AppVersionCode%";

	// myCheckSigsBehavior
	// 0 - always return true if one package is app
	// 1 - be safe and only say package signatures match when the other
	// package is found and does not match
	// 2 - always return signature match, even if package is not found
	// some apps will check for this
	private static final int MyCheckSigsBehavior = Integer
			.parseInt("%!CheckSigsBehavior%");

	// myGetPIBehavior
	// 0 - spoof signature of some apps with this app
	// 1 - do not spoof if app is not installed
	private static final int MyGetPIBehavior = Integer
			.parseInt("%!GetPIBehavior%");

	// mySigVerifyBehavior - Signature.verify
	// 0 - always return true if signature matches
	// 1 - always return actual match
	private static final int MySigVerifyBehavior = Integer
			.parseInt("%!SigVerifyBehavior%");

	// adding hash codes to any objects that should be acted upon
	// specially by other parts of code. i know it sounds vague.
	// ex: note an output stream if it's for a process
	// so whenever the output stream is written to, hook that properly
	private static Process MyWatchedProcess = null;

	// Checksum spoofing stuff
	private static Long CHKSUM_CRC32_App = Long.parseLong("%!ChksumCRC32App%");
	private static Long CHKSUM_ADLER32_App = Long
			.parseLong("%!ChksumAdler32App%");
	private static Long CHKSUM_CRC32_DEX = Long.parseLong("%!ChksumCRC32DEX%");
	private static Long CHKSUM_ADLER32_DEX = Long
			.parseLong("%!ChksumAdler32DEX%");

	// md5 and sha1 checksums are digests (byte arrays) which may contain
	// invalid
	// characters for a string constant. therefore, sequencer will pass them to
	// us
	// here as base64 encoded and it's handled in the constructor
	private static byte[] CHKSUM_MD5_App = null;
	private static byte[] CHKSUM_SHA1_App = null;
	private static byte[] CHKSUM_MD5_DEX = null;
	private static byte[] CHKSUM_SHA1_DEX = null;

	// Whenever messagedigest;->update is called we set this to true
	// then whenever fileinputstream;->read is called and this is true
	// we know we're building a digest on that fileinput stream
	// this is the only way i could think of to correlate digest objects
	// to the file names they are digesting
	protected static boolean BuildingDigest = false;

	// Whenever a checksum or digest or fileinputstream is created, we will need
	// to keep track of it
	// this is so we can make the link from checksum object back to the filename
	// associated with it.
	private static HashMap<Object, String> MyWatchedChecksumsOrDigests = new HashMap<Object, String>();
	private static HashMap<InputStream, String> MyChecksumInputStreams = new HashMap<InputStream, String>();
	private static InputStream LastReadInputStream = null;

	// Device ID / Android ID spoof
	// 0 - don't spoof
	// 1 - always random
	// 2 - session random (generated randomly once, saved, and reused until app
	// reinstalled)
	// 3 - session permute (same as session random, but permutation of real id)
	// 4 - emulator (all 0s)
	// 5 - user-defined
	private static final int DeviceIDSpoofType = Integer
			.parseInt("%!DeviceIDSpoofType%");
	private static final String DeviceIDSpoof = "%!DeviceIDSpoof%";

	// Account Name spoof
	// 0 - don't spoof
	// 1 - always random
	// 2 - session random
	// 3 - user defined
	private static final int AccountNameSpoofType = Integer
			.parseInt("%!AccountNameSpoofType%");
	private static final String AccountNameSpoof = "%!AccountNameSpoof%";

	// Network Operator spoof
	private static final String NetworkOperatorSpoof = "%!NetworkOperatorSpoof%";

	// Wireless MAC spoof
	// 0 - don't spoof
	// 1 - always random
	// 2 - session random
	// 3 - user defined
	private static final int WifiMacSpoofType = Integer
			.parseInt("%!WifiMacSpoofType%");
	private static final String WifiMacSpoof = "%!WifiMacSpoof%";

	// Bluetooth MAC spoof
	// 0 - don't spoof
	// 1 - always random
	// 2 - session random
	// 3 - user defined
	private static final int BTMacSpoofType = Integer
			.parseInt("%!BTMacSpoofType%");
	private static final String BTMacSpoof = "%!BTMacSpoof%";

	// ************************** Hard Hook Methods **************************
	// //
	public static void waitForDebugger() {
		try {
			while ( true ) {
				log("  pretending to wait for debugger!");

				// non obvious number keeps 'em guessing
				Thread.sleep(8427);
			}
		}
		catch (InterruptedException e) { /* don't care */
		}
	}

	public static DexFile loadDex(String sourcePathName, String outputPathName,
			int flags) throws IOException {
		log("loadDex() src:" + sourcePathName + " out:" + outputPathName
				+ " flags:" + flags);

		return DexFile.loadDex(sourcePathName, outputPathName, flags);
	}

	public static JarEntry getJarEntry(JarFile jf, String entryName) {
		log("getJarEntry(" + entryName + "), we call getZipEntry()");
		return new JarEntry(getZipEntry(jf, entryName));
	}

	public static ZipEntry getZipEntry(ZipFile zf, String entryName) {
		log("getZipEntry(" + entryName + ")");
		ZipEntry ze = zf.getEntry(entryName);

		if ( entryName.equals("classes.dex") ) {
			log("  spoofing entry info");
			ze.setCrc(Long.parseLong("%!ZipClassesDexCrc%"));
			ze.setSize(Long.parseLong("%!ZipClassesDexSize%"));
			ze.setCompressedSize(Long
					.parseLong("%!ZipClassesDexCompressedSize%"));
		}

		return ze;
	}

	public static int checkSignatures(PackageManager pm, String pkg1,
			String pkg2) {
		log("checkSignatures(" + pkg1 + ", " + pkg2 + ")");
		int result = pm.checkSignatures(pkg1, pkg2);
		log("  real result = " + result);

		if ( result == PackageManager.SIGNATURE_MATCH ) { return result; }

		if ( MyCheckSigsBehavior == 0 ) {
			if ( pkg1.equals(MyAppName) ) {
				result = PackageManager.SIGNATURE_MATCH;
			}
		}
		else if ( MyCheckSigsBehavior == 1 ) {
			// only if package exists and signature does not match
			if ( (result != PackageManager.SIGNATURE_UNKNOWN_PACKAGE)
					&& (result != PackageManager.SIGNATURE_MATCH) ) {
				result = PackageManager.SIGNATURE_MATCH;
			}
		}
		else if ( MyCheckSigsBehavior == 2 ) {
			result = PackageManager.SIGNATURE_MATCH;
		}

		log("  returning: " + result);
		return result;
	}

	public static int checkSignatures(PackageManager pm, int uid1, int uid2) {
		log("checkSignatures(" + uid1 + ", " + uid2
				+ "), calling string version");
		String pkg1 = pm.getPackagesForUid(uid1)[0];
		String pkg2 = pm.getPackagesForUid(uid2)[0];
		return checkSignatures(pm, pkg1, pkg2);
	}

	public static boolean isDebuggerConnected() {
		log("isDebuggerConnected()? of course not :D");
		return false;
	}

	// spoof installer package name if it is null, which means installed from
	// adb
	public static String getInstallerPackageName(PackageManager pm,
			String packageName) {
		String result = pm.getInstallerPackageName(packageName);

		// lie and say installed from market :D
		if ( result == null ) {
			result = "com.google.android.feedback";
		}
		String real = pm.getInstallerPackageName(packageName);
		log("getInstallerPackageName(" + packageName + ") returning " + result
				+ " but really it's: " + real);
		return result;
	}

	public static int getApplicationEnabledSetting(PackageManager pm,
			String packageName) {
		int result;
		try {
			result = pm.getApplicationEnabledSetting(packageName);
		}
		catch (IllegalArgumentException ex) {
			result = PackageManager.COMPONENT_ENABLED_STATE_DEFAULT;
		}

		// Fake value if it's disabled
		if ( result == PackageManager.COMPONENT_ENABLED_STATE_DISABLED ) {
			result = PackageManager.COMPONENT_ENABLED_STATE_DEFAULT;
		}

		log("getApplicationEnabledSetting(" + packageName + ") = " + result);
		return result;
	}

	@TargetApi(4)
	public static ApplicationInfo getApplicationInfo(Context c) {
		ApplicationInfo ai = c.getApplicationInfo();
		int flag = ApplicationInfo.FLAG_DEBUGGABLE;
		if ( (ai.flags & flag) == flag ) {
			log("application is debuggable, lying and saying it isn't");

			// unset debuggable flag
			ai.flags &= ~ApplicationInfo.FLAG_DEBUGGABLE;
		}

		return ai;
	}

	public static PackageInfo getPackageInfo(PackageManager pm,
			String packageName, int flags) throws NameNotFoundException {

		log("getPackageInfo(" + packageName + ") flags=" + flags);

		// Get regular package info
		PackageInfo pi = null;
		try {
			pi = pm.getPackageInfo(packageName, flags);
		}
		catch (NameNotFoundException e) {
			if ( MyGetPIBehavior == 1 ) {
				log("  app not found, throwing exception");
				setStackTrace(e);
				throw e;
			}

			// Spoof with this package's info
			log("  using package info from " + MyAppName);
			pi = pm.getPackageInfo(MyAppName, flags);
		}

		// Populate with fake signatures if flags ask for it
		if ( (flags & PackageManager.GET_SIGNATURES) == PackageManager.GET_SIGNATURES ) {
			log("  spoofing " + pi.signatures.length + " signatures for "
					+ packageName);
			Signature[] spoofSigs = spoofSignatures();
			System.arraycopy(spoofSigs, 0, pi.signatures, 0,
					pi.signatures.length);
		}

		return pi;
	}

	public static long length(File f) {
		long retVal = f.length();
		if ( isThisApk(f) ) {
			retVal = Long.parseLong("%!OrigApkFileSize%");
			log("length() spoofing file length of " + f.getName() + " with:"
					+ retVal + " real:" + f.length());
		}
		else if ( isThisClassesDex(f) ) {
			retVal = Long.parseLong("%!OrigClassesDexFileSize%");
			log("length() spoofing file length of " + f.getName() + " with:"
					+ retVal + " real:" + f.length());
		}
		else {
			log("length() NOT spoofing file length of " + f.getName()
					+ " with:" + retVal + " real:" + f.length());
		}

		return retVal;
	}

	public static long lastModified(File f) {
		long retVal = f.lastModified();
		if ( isThisApk(f) ) {
			retVal = Long.parseLong("%!OrigApkLastModified%");
			log("lastModified() spoofing of " + f.getName() + " with:" + retVal
					+ " real:" + f.lastModified());
		}
		else if ( isThisClassesDex(f) ) {
			retVal = Long.parseLong("%!OrigClassesDexLastModified%");
			log("lastModified() spoofing of " + f.getName() + " with:" + retVal
					+ " real:" + f.lastModified());
		}
		else {
			log("lastModified() NOT spoofing of " + f.getName() + " with:"
					+ retVal + " real:" + f.lastModified());
		}

		return retVal;
	}

	public static String getDeviceId() {
		// 0 - don't spoof
		// 1 - always random
		// 2 - session random (generated randomly once, saved, and reused until
		// app reinstalled)
		// 3 - session permute (same as session random, but permutation of real
		// id)
		// 4 - emulator (all 0s)
		// 5 - user-defined

		String spoofID = "319261750826054"; // fallback
		String realID = getRealDeviceID();

		// Get previously stored spoofed ID
		SharedPreferences settings = null;
		String storedID = "";
		if ( AppContext != null ) {
			settings = AppContext.getSharedPreferences(MyPrefsFile,
					Context.MODE_PRIVATE);
			storedID = settings.getString("android_id", "");
		}
		else {
			log("getDeviceID() has no context. can't use session storage. using fallback if necessary.");
		}

		switch ( DeviceIDSpoofType ) {
		case 0:
			spoofID = realID;
			break;
		case 1:
			spoofID = generateRandomDeviceID();
			break;
		case 2:
		case 3:
			if ( AppContext != null ) {
				if ( !storedID.equals("") ) {
					// use what we loaded from settings
					spoofID = storedID;
				}
				else {
					if ( DeviceIDSpoofType == 2 ) {
						spoofID = generateRandomDeviceID();
					}
					else {
						spoofID = getPermutedDeviceID();
					}

					SharedPreferences.Editor editor = settings.edit();
					editor.putString("android_id", spoofID);
					editor.commit();
				}
			}
			// else don't do anything, spoofID has the fall back
			break;
		case 4:
			spoofID = "000000000000000";
			break;
		case 5:
			spoofID = DeviceIDSpoof;
			break;
		}

		log("getDeviceId(" + DeviceIDSpoofType + ") - using: " + spoofID
				+ "  real: " + realID);

		return spoofID;
	}

	public String getSettingsString(ContentResolver cr, String setting) {
		if ( setting.equals(Secure.ANDROID_ID) ) {
			log("getSettingString(" + Secure.ANDROID_ID
					+ ") returning getDeviceID()");
			return getDeviceId();
		}
		else {
			return Secure.getString(cr, Secure.ANDROID_ID);
		}
	}

	public static Process runtimeExec(Runtime rt, String cmd)
			throws IOException {
		String newCmd = fixSysCmd(cmd);

		log("runtimeExec(" + cmd + ") = " + newCmd);

		return rt.exec(newCmd);
	}

	public static void osWrite(OutputStream os, String str) throws IOException {
		osWrite(os, str.getBytes());
	}

	public static void osWrite(OutputStream os, byte[] barr) throws IOException {
		log("osWrite(" + new String(barr).trim() + ")");

		if ( MyWatchedProcess != null ) {
			boolean target = false;

			if ( (os.getClass() == java.io.OutputStream.class)
					&& (os == MyWatchedProcess.getOutputStream()) ) {
				target = true;
			}
			else if ( (os.getClass() == java.io.DataOutputStream.class)
					|| (os.getClass() == java.io.FilterOutputStream.class) ) {
				Field f = null;
				try {
					f = java.io.FilterOutputStream.class
							.getDeclaredField("out");
					f.setAccessible(true);
					OutputStream theOs = (OutputStream) f.get(os);
					if ( theOs == MyWatchedProcess.getOutputStream() ) {
						target = true;
					}
				}
				catch (Exception e) {
					log("osWrite() exception: " + e);
				}
			}

			if ( target ) {
				String newCmd = fixSysCmd(new String(barr));
				log("osWrite() new cmd = " + newCmd);
				barr = newCmd.getBytes();
			}
		}

		os.write(barr);
	}

	public static boolean signatureVerify(java.security.Signature s,
			byte[] signature) throws SignatureException {
		boolean result = true;

		if ( MySigVerifyBehavior != 0 ) {
			result = s.verify(signature);
		}

		log("signatureVerify(2) returning " + result + ". is actually "
				+ s.verify(signature));
		return result;
	}

	public static boolean signatureVerify(java.security.Signature s,
			byte[] signature, int offset, int length) throws SignatureException {
		// it IS different, you can't just pretty it up
		// and send it to the other method
		boolean result = true;
		if ( MySigVerifyBehavior != 0 ) {
			result = s.verify(signature, offset, length);
		}

		log("signatureVerify(4) returning " + result);
		return result;
	}

	public static void setStackTrace(Throwable th) {
		// o needs to be a Throwable or a subclass
		log("setStackTrace() get ready to lie!");
		th.setStackTrace(scrubStackTrace(th.getStackTrace()));
	}

	public static StackTraceElement[] threadGetStackTrace(Thread t) {
		// hook for java.lang.Thread.getStackTrace()
		log("threadGetStackTrace() get ready to lie!");
		return scrubStackTrace(t.getStackTrace());
	}

	public static void threadDumpStack() {
		// hook java.lang.Thread.dumpStack()
		log("threadDumpStack() get ready to lie!");
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		PrintStream ps = new PrintStream(baos);
		PrintStream origPS = System.err;

		System.setErr(ps);
		Thread.dumpStack();
		System.setErr(origPS);

		String trace = scrubStackTrace(baos.toString());
		System.err.println(trace);
	}

	public static void throwablePrintStackTrace(Throwable t) {
		// hook java.lang.Throwable.printStackTrace()
		log("throwablePrintStack() get ready to lie!");
		ByteArrayOutputStream baos = new ByteArrayOutputStream();
		PrintStream ps = new PrintStream(baos);
		PrintStream origPS = System.err;

		System.setErr(ps);
		t.printStackTrace();
		System.setErr(origPS);

		String trace = scrubStackTrace(baos.toString());
		System.err.println(trace);
	}

	public static byte[] spoofDigest(MessageDigest md) {
		if ( CHKSUM_MD5_App == null ) {
			try {
				CHKSUM_MD5_App = CryptUtils.decode("%!ChksumMD5App%");
				CHKSUM_SHA1_App = CryptUtils.decode("%!ChksumSHA1App%");

				CHKSUM_MD5_DEX = CryptUtils.decode("%!ChksumMD5DEX%");
				CHKSUM_SHA1_DEX = CryptUtils.decode("%!ChksumSHA1DEX%");
			}
			catch (Exception e) {
				e.printStackTrace();
			}
		}

		log("spoofDigest(" + md.getAlgorithm() + ")");

		byte[] result = null;

		if ( MyWatchedChecksumsOrDigests.containsKey(md) ) {
			String fileName = MyWatchedChecksumsOrDigests.get(md);
			switch ( isChecksumFileName(fileName) ) {
			case 1:
				log("  giving APP digest!");
				if ( md.getAlgorithm().equals("MD5") ) {
					result = CHKSUM_MD5_App;
				}
				else {
					result = CHKSUM_SHA1_App;
				}
				break;
			case 2:
				log("  giving classes.dex digest!");
				if ( md.getAlgorithm().equals("MD5") ) {
					result = CHKSUM_MD5_DEX;
				}
				else {
					result = CHKSUM_SHA1_DEX;
				}
				break;
			}
		}
		else {
			log("  don't really know what we're digesting. sending the real thing!");
			result = md.digest();
		}

		log("  result = " + CryptUtils.encode(result));
		return result;
	}

	public static long spoofChecksum(Checksum cs) {
		log("spoofChecksum(" + cs.getClass() + ")");
		long result = cs.getValue();

		if ( MyWatchedChecksumsOrDigests.containsKey(cs) ) {
			// perhaps this input stream is not known. we need to know what
			// file the checksum is for otherwise we don't know correct checksum
			String fileName = MyWatchedChecksumsOrDigests.get(cs);
			switch ( isChecksumFileName(fileName) ) {
			case 1:
				log("  giving APP chksum!");
				if ( cs.getClass() == java.util.zip.Adler32.class ) {
					result = CHKSUM_ADLER32_App;
				}
				else {
					result = CHKSUM_CRC32_App;
				}
				break;
			case 2:
				log("  giving classes.dex chksum!");
				if ( cs.getClass() == java.util.zip.Adler32.class ) {
					result = CHKSUM_ADLER32_DEX;
				}
				else {
					result = CHKSUM_CRC32_DEX;
				}
				break;
			}
		}

		log("  result = " + result);
		return result;
	}

	public static String getAccountName(Account act) {
		String spoofActName = "jrhacker"; // fallback
		String realActName = act.name;

		// Get previously stored spoofed Account Name
		SharedPreferences settings = null;
		String storedID = "";
		if ( AppContext != null ) {
			settings = AppContext.getSharedPreferences(MyPrefsFile,
					Context.MODE_PRIVATE);
			storedID = settings.getString("act_nm", "");
		}
		else {
			log("getAccountName() has no context. can't use session storage. using fallback if necessary.");
		}

		switch ( AccountNameSpoofType ) {
		case 0:
			spoofActName = realActName;
			break;
		case 1:
			spoofActName = generateString(
					"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.",
					10);
			break;
		case 2:
			if ( AppContext != null ) {
				if ( !storedID.equals("") ) {
					// use what we loaded from settings
					spoofActName = storedID;
				}
				else {
					spoofActName = generateString(
							"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.",
							10);

					SharedPreferences.Editor editor = settings.edit();
					editor.putString("act_nm", spoofActName);
					editor.commit();
				}
			}
			// else don't do anything, spoofIActName has the fall back
			break;
		case 3:
			spoofActName = AccountNameSpoof;
			break;
		}

		log("getAccountName(" + AccountNameSpoofType + ") - using: "
				+ spoofActName + "  real: " + realActName);

		return spoofActName;
	}

	public static String getNetworkOperator(TelephonyManager tm) {
		String result = NetworkOperatorSpoof;
		if ( NetworkOperatorSpoof.length() == 0 ) {
			result = tm.getNetworkOperator();
		}

		log("getNetworkOperator() - using:" + result + "  real:"
				+ tm.getNetworkOperator());

		return result;
	}

	public static String getWifiMac(WifiInfo wi) {
		String spoofMac = "90:32:A5:75:12:9C"; // fallback
		String realMac = wi.getMacAddress();

		// Get previously stored spoofed Mac
		SharedPreferences settings = null;
		String storedID = "";
		if ( AppContext != null ) {
			settings = AppContext.getSharedPreferences(MyPrefsFile,
					Context.MODE_PRIVATE);
			storedID = settings.getString("wifi_mac", "");
		}
		else {
			log("getWifiMac() has no context. can't use session storage. using fallback if necessary.");
		}

		switch ( WifiMacSpoofType ) {
		case 0:
			spoofMac = realMac;
			break;
		case 1:
			spoofMac = generateRandomMac();
			break;
		case 2:
			if ( AppContext != null ) {
				if ( !storedID.equals("") ) {
					// use what we loaded from settings
					spoofMac = storedID;
				}
				else {
					spoofMac = generateRandomMac();

					SharedPreferences.Editor editor = settings.edit();
					editor.putString("wifi_mac", spoofMac);
					editor.commit();
				}
			}
			// else don't do anything, spoofIMac has the fall back
			break;
		case 3:
			spoofMac = WifiMacSpoof;
			break;
		}

		log("getWifiMac(" + WifiMacSpoofType + ") - using: " + spoofMac
				+ "  real: " + realMac);

		return spoofMac;
	}

	public static String getBTMac(BluetoothAdapter bta) {
		String spoofMac = "90:31:B3:62:44:17"; // fallback
		String realMac = bta.getAddress();

		// Get previously stored spoofed BT Mac
		SharedPreferences settings = null;
		String storedID = "";
		if ( AppContext != null ) {
			settings = AppContext.getSharedPreferences(MyPrefsFile,
					Context.MODE_PRIVATE);
			storedID = settings.getString("bt_mac", "");
		}
		else {
			log("getBTMac() has no context. can't use session storage. using fallback if necessary.");
		}

		switch ( BTMacSpoofType ) {
		case 0:
			spoofMac = realMac;
			break;
		case 1:
			spoofMac = generateRandomMac();
			break;
		case 2:
			if ( AppContext != null ) {
				if ( !storedID.equals("") ) {
					// use what we loaded from settings
					spoofMac = storedID;
				}
				else {
					spoofMac = generateRandomMac();

					SharedPreferences.Editor editor = settings.edit();
					editor.putString("wifi_mac", spoofMac);
					editor.commit();
				}
			}
			// else don't do anything, spoofIMac has the fall back
			break;
		case 3:
			spoofMac = BTMacSpoof;
			break;
		}

		log("getBTMac(" + BTMacSpoofType + ") - using: " + spoofMac
				+ "  real: " + realMac);

		return spoofMac;
	}

	// *********************** End Hard Hook Methods *********************** //

	// ************************* Soft Hook Methods ************************* //
	// soft means we add this in the code somewhere, but it does not directly
	// replace another method. they're helper hooks :D
	public static void watchChecksum(InputStream is, Checksum chk) {
		// add every time we see a Checksum or MessageDigest created
		// link all checksum objects with their actual file name so we know
		// which spoofed checksum to give when asked
		if ( MyWatchedChecksumsOrDigests.containsKey(chk) ) { return; }
		String fileName = MyChecksumInputStreams.get(is);
		if ( fileName == null ) {
			log("  unable to determine filename of checksum!");
		}
		else {
			MyWatchedChecksumsOrDigests.put(chk, fileName);
		}
	}

	public static void watchDigest(MessageDigest md) {
		BuildingDigest = true;

		if ( MyWatchedChecksumsOrDigests.containsKey(md) ) { return; }

		if ( LastReadInputStream == null ) {
			log("  updating message digest, but don't know last read InputStream. should only see this once.");
			return;
		}

		String fileName = MyChecksumInputStreams.get(LastReadInputStream);
		if ( fileName == null ) {
			log("  unable to determine filename of checksum!");
		}
		else {
			log("  watching message digest for " + fileName);
			MyWatchedChecksumsOrDigests.put(md, fileName);
		}
	}

	public static void watchInputStreamReadForDigest(Object is) {
		if ( BuildingDigest ) {
			LastReadInputStream = (InputStream) is;
		}
	}

	public static void watchInputStream(Object is, File f) {
		// add every time FileInputStream is created
		watchInputStream(is, f.getName());
	}

	public static void watchInputStream(Object is, String fileName) {
		// todo: hook FileDescriptor overload, not just file and string
		// parameters
		if ( MyChecksumInputStreams.containsKey(is) ) {
			return;
		}
		else {
			log("watchInputStream(" + fileName + ")");
			MyChecksumInputStreams.put((InputStream) is, fileName);
		}
	}

	public static FileInputStream contextOpenFileInput(Context c, String s)
			throws FileNotFoundException {
		FileInputStream fis = c.openFileInput(s);
		watchInputStream(fis, s);
		return fis;
	}

	public static void watchProcess(Process p) {
		MyWatchedProcess = p;
	}

	public static void setAppContext(Context c) {
		// may be blindly called multiple times, so only set it the first time
		// if every activity's onCreate is hooked to call this, only the first
		// will have its context stored, which is what we want
		if ( AppContext == null ) {
			AppContext = c;
		}
	}

	public static void log(Object o) {
		if ( DEBUG ) {
			Log.d("sequencer", String.valueOf(o));
			Log.d("sequencer", getOurStackDump());
		}
	}

	@SuppressWarnings("unused")
	public static String getOurStackDump() {
		if ( DUMP_STACK > 0 ) {
			StackTraceElement[] ste = Thread.currentThread().getStackTrace();

			String pkg = Monolith.class.getPackage().getName();
			String line;
			String trace = "";
			int traceCount = 0;

			// skip first 3, it's all local stuff
			for ( int i = 3; (i < ste.length) && (traceCount < DUMP_STACK); i++ ) {
				line = ste[i].toString();
				if ( line.contains(pkg) ) {
					continue;
				}
				traceCount++;
				trace += "   >" + ste[i].toString() + "\n";
			}

			return trace;
		}

		return "";
	}

	public static void log(int i) {
		if ( DEBUG ) {
			log(Integer.valueOf(i));
		}
	}

	public static void log(long i) {
		if ( DEBUG ) {
			log(Long.valueOf(i));
		}
	}

	public static void logmt(Object o) {
		if ( DEBUG && (AppContext != null) ) {
			try {
				if ( MethodTraceFOS == null ) {
					MethodTraceFOS = AppContext.openFileOutput("mt.log",
							Context.MODE_APPEND);
				}
				StringBuilder sb = new StringBuilder(String.valueOf(o));
				sb.append("\n");
				sb.append(getOurStackDump());
				MethodTraceFOS.write(sb.toString().getBytes());
			}
			catch (Exception e) {
				Log.d("sequencer", "logmt() exception: " + e);
				e.printStackTrace();
			}
		}
	}

	public static void toast(Object o) {
		if ( AppContext == null ) {
			log("toast() can't happen because no context.");
			return;
		}

		// log("toast(" + o.toString() + ")");

		String str = o.toString();
		Toast t = Toast.makeText(AppContext, str, Toast.LENGTH_LONG);

		// center the toast location
		t.setGravity(Gravity.TOP | Gravity.CENTER, 0, 0);

		// center text inside toast
		((TextView) ((LinearLayout) t.getView()).getChildAt(0))
				.setGravity(Gravity.CENTER_HORIZONTAL);
		t.show();
	}

	// *********************** End Soft Hook Methods ********************** //

	// ************************** Helper Methods ************************** //
	private static int isChecksumFileName(String fileName) {
		// is this a file name we should have a spoofed checksum for?
		// we want checksums for the app's apk and the key's apk if there is one
		// returns: 0 = no, 1 = app (com.some.app), 2 = key
		// (com.some.appkey)

		int result = 0;

		log("isChecksumFileName(" + fileName + ")");

		// sometimes we get someapp-1.apk, if so, stop at '-'
		// otherwise stop at '.'
		int pos = fileName.lastIndexOf("-");
		if ( pos < 0 ) {
			pos = fileName.lastIndexOf(".");
		}
		fileName = fileName.substring(0, pos);

		log("  guessing package = " + fileName);
		if ( fileName.equals(MyAppName) ) {
			result = 1;
		}
		else if ( fileName.equals("classes.dex") ) {
			result = 2;
		}

		return result;
	}

	// Fix rewrite commands to be what we want them to be
	private static String fixSysCmd(String cmd) {
		log("fixSysCmd(" + cmd.trim() + ")");

		String[] args = cmd.trim().split(" ");
		String newCmd = cmd;

		if ( args.length >= 2 ) {
			if ( args[0].contains("md5sum") ) {
				// ex: /system/xbin/md5sum /data/app/com.someapp-1.apk
				if ( args[1].endsWith(".apk") ) {
					newCmd = "echo ";
					newCmd += "%!MD5Sum%	" + args[1] + "\n";
				}
			}
		}

		return newCmd;
	}

	protected static boolean isThisApk(File f) {
		boolean result = false;

		if ( f.exists() ) {
			result = false;
		}

		if ( f.getName().contains(MyAppName) && f.getName().endsWith(".apk") ) {
			result = true;
		}

		return result;
	}

	protected static boolean isThisClassesDex(File f) {
		return f.exists() && f.getName().equals("classes.dex");
	}

	private static String getPermutedDeviceID() {
		// this is a permutation with a loss of information
		// prevent anyone from knowing the id even if they knew the mapping
		// TODO: make this randomly generated at install time
		final int[] p = { 8, 4, 10, 0, 14, 12, 3, 3, 13, 2, 5, 9, 6, 8, 11 };

		String deviceId = getRealDeviceID();
		String result = "";
		if ( deviceId != null ) {
			for ( int i : p ) {
				result += deviceId.charAt(i);
			}
		}

		return result;
	}

	private static String getRealDeviceID() {
		final TelephonyManager tm = (TelephonyManager) AppContext
				.getSystemService(Context.TELEPHONY_SERVICE);

		return tm.getDeviceId();
	}

	private static String generateRandomDeviceID() {
		// device id is 15 digit number with seemingly no pattern
		// only changed by factory reset or with root
		// ex: 359881030314356 (emulators use all 0s)
		return generateString("0123456789", 15);
	}

	private static String generateRandomMac() {
		// ex: 00:11:22:AA:BB:CC
		// must be upper-case at least for bluetooth
		String mac = "";
		for ( int i = 0; i < 6; i++ ) {
			mac += generateString("0123456789ABCDEF", 2) + ":";
		}
		return mac.substring(0, mac.length() - 1);
	}

	protected static Signature[] spoofSignatures() {
		log("spoofSignatures() called!");

		final int certCount = Integer.parseInt("%!CertCount%");
		Signature[] result = new Signature[certCount];

		// Usually check signature of package and not individual files
		// This will only fool checks of entire package
		// Individual files would require a lot of smali generation
		final String replace = "%!SignatureChars%";

		for ( int i = 0; i < certCount; i++ ) {
			result[i] = new Signature(replace);
		}

		return result;
	}

	private static StackTraceElement[] scrubStackTrace(StackTraceElement[] ste) {
		// remove this class from any stack trace we're given
		ArrayList<StackTraceElement> newStackList = new ArrayList<StackTraceElement>();
		for ( StackTraceElement e : ste ) {
			if ( !mentionsOurPackage(e.getClassName()) ) {
				newStackList.add(e);
			}
		}
		StackTraceElement[] newStack = new StackTraceElement[newStackList
				.size()];
		return newStackList.toArray(newStack);
	}

	private static String scrubStackTrace(String stackTrace) {
		String[] lines = stackTrace.split("\n");
		String result = "";
		for ( String line : lines ) {
			if ( !mentionsOurPackage(line) ) {
				result += line + '\n';
			}
		}

		return result;
	}

	private static boolean mentionsOurPackage(String someStr) {
		// for use when scrubbing stack traces
		String pkg = Monolith.class.getName();
		pkg = pkg.substring(0, pkg.indexOf('.') + 1);
		return someStr.contains(pkg);
	}

	protected static String generateString(int length) {
		return generateString("ABCDEFGHIJKLMNOPQRSTUVWXYZ"
				+ "abcdefghijklmnopqrstuvwxyz" + "1234567890"
				+ "!@#$%^&*()_+-=[]{}\\|;':\",./<>?~`", length);
	}

	protected static String generateString(String charSet, int length) {
		Random rng = new Random();
		char[] text = new char[length];
		for ( int i = 0; i < length; i++ ) {
			text[i] = charSet.charAt(rng.nextInt(charSet.length()));
		}

		return new String(text);
	}
	// *********************** End Helper Methods *********************** //
}