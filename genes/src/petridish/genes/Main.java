package petridish.genes;

import hooks.Monolith;
import hooks.ReflectedInvoke;

import java.io.File;
import java.io.OutputStream;
import java.lang.reflect.Method;
import java.security.Signature;
import java.util.Random;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import android.app.Activity;
import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.os.Parcel;

public class Main extends Activity {
	@SuppressWarnings("unused")
	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);

		try {
			if ( 1 == 0 ) {
				callAllMethods();
			}
		}
		catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		setContentView(R.layout.main);

	}

	@SuppressWarnings("unused")
	private void callAllMethods() throws Exception {

		// use some randomness to throw off the optimizer a bit
		Random rnd = new Random(System.currentTimeMillis());

		// must give real parameters instead of null
		// or else eclipse renames all the methods
		// also, nothing evaluating to null must be used
		Context c = this.getBaseContext();
		PackageManager pm = this.getPackageManager();
		Method someC = Main.class.getMethod("callAllMethods", new Class[] {});
		File f = new File("f" + rnd.nextInt());
		Signature s = Signature.getInstance("SHA1withRSA");
		Runtime rt = Runtime.getRuntime();
		Process p = rt.exec("su");
		OutputStream os = p.getOutputStream();
		Parcel par = Parcel.obtain();

		int intResult;
		String strResult;
		boolean bResult;
		long lngResult;

		intResult = Monolith.checkSignatures(pm, rnd.nextInt(), rnd.nextInt());
		intResult = Monolith.checkSignatures(pm, "", "");
		intResult = Monolith.getApplicationEnabledSetting(pm, "");
		ApplicationInfo ai = Monolith.getApplicationInfo(c);
		if ( ai != null ) {
			System.out.println("side effect!");
		}
		strResult = Monolith.getDeviceId();
		strResult = Monolith.getInstallerPackageName(pm, "");
		PackageInfo pi = Monolith.getPackageInfo(pm, "", rnd.nextInt());
		ReflectedInvoke.invokeHook(someC, Main.this, new Object[] {});
		bResult = Monolith.isDebuggerConnected();
		System.out.println(bResult);
		if ( bResult ) {
			intResult++;
		}
		lngResult = Monolith.lastModified(f);
		lngResult = Monolith.length(f);
		Monolith.log(rnd.nextInt());
		Monolith.log(s);
		Monolith.osWrite(os, "");
		Monolith.osWrite(os, new byte[0]);
		p = Monolith.runtimeExec(rt, "");
		Monolith.setAppContext(c);
		bResult = Monolith.signatureVerify(s, new byte[rnd.nextInt()]);
		bResult = Monolith.signatureVerify(s, new byte[rnd.nextInt()],
				rnd.nextInt(), rnd.nextInt());

		Monolith.toast("");
		Monolith.watchProcess(p);
		Monolith.threadDumpStack();
		Throwable t = new Throwable();
		Monolith.setStackTrace(t);
		t.printStackTrace();

		StackTraceElement[] ste = Monolith.threadGetStackTrace(Thread
				.currentThread());

		ZipEntry ze = Monolith.getZipEntry(new ZipFile(f), "classes.dex");
		JarEntry je = Monolith.getJarEntry(new JarFile(f), "classes.dex");
	}
}