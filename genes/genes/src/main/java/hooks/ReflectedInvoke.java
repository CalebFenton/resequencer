/*
 * Hooks:
 * Adler32
 * - getValue
 * Constructor
 * - newInstance
 * CRC32
 * - getValue
 * PackageManager
 * - getInstallerPackageName
 * - getPackageInfo
 * - getApplicationEnabledSetting
 * - getApplicationInfo
 * - checkSignatures
 * Signature
 * - verify
 * TelephonyManager
 * - getDeviceID (needs context)
 * File
 * - length
 * - lastModified
 * Settings
 * - getString (android_id spoof)
 * Runtime
 * - exec
 * OutputStream/FilterOutputStream/DataOutputStream
 * - write
 * - writeBytes
 * MessageDigest
 * - <init>
 * - digest
 * - update
 * java.lang.reflect.Method
 * - invoke
 * ZipFile
 * - getEntry
 * JarFile
 * - getEntry
 * - getJarEntry
 * Throwable
 * - <init>
 * - fillInStackTrace
 * - printStackTrace
 * - NOT printWriter/printStream
 * Thread
 * - dumpStack
 */
package hooks;

import java.io.File;
import java.lang.reflect.Constructor;
import java.lang.reflect.Method;
import java.security.MessageDigest;
import java.util.jar.JarFile;
import java.util.zip.Checksum;
import java.util.zip.ZipFile;

import android.content.Context;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;

public class ReflectedInvoke {
	public static Object invokeHook(Method method, Object receiver,
			Object[] args) throws Exception {

		String className = "unknown-static";
		String methodName = method.getName();
		if ( receiver != null ) {
			className = receiver.getClass().getName();
		}
		else {
			className = method.getDeclaringClass().getName();
		}

		if ( Monolith.DEBUG ) {
			String logStr = "Invoke hook: " + className + "." + methodName
					+ "(";
			if ( args != null ) {
				String argStr = "";
				for ( Object arg : args ) {
					argStr += arg == null ? arg : arg.getClass().getName()
							+ ":" + arg + ", ";
				}

				if ( argStr.length() >= 2 ) {
					argStr = argStr.substring(0, argStr.length() - 2);
				}
				logStr += argStr;
			}

			Monolith.log(logStr + ")");
			if ( receiver != null ) {
				Monolith.log("  receiver: " + receiver.toString());
			}
		}

		// hide ourselves from stack trace by not including top element
		Throwable t = new Throwable();
		StackTraceElement[] trace = t.getStackTrace();
		StackTraceElement[] newTrace = new StackTraceElement[trace.length - 1];
		System.arraycopy(trace, 1, newTrace, 0, newTrace.length);

		if ( className
				.equals("android.app.ContextImpl$ApplicationPackageManager")
				|| className
						.equals("android.app.ApplicationContext$ApplicationPackageManager")
				|| className.equals("android.content.pm.PackageManager")
				|| (className.startsWith("android.") && className
						.contains("ApplicationPackageManager")) ) {
			if ( methodName.equals("getInstallerPackageName") ) {
				// Hook get installer package name
				return Monolith.getInstallerPackageName(
						(PackageManager) receiver, (String) args[0]);
			}
			else if ( methodName.equals("getPackageInfo") ) {
				// Hook get package info for signatures
				int flags = (Integer) args[1];

				if ( className.equals("android.content.pm.PackageManager") ) { return Monolith
						.getPackageInfo(((PackageManager) receiver),
								(String) args[0], flags); }

				// Cannot simply recast receiver to
				// android.app.ContextImpl$ApplicationPackageManager or we get
				// error

				Object result = null;
				try {
					result = method.invoke(receiver, args);
				}
				catch (Exception e) {
					/*
					 * do not assume if there is a failure we should handle the
					 * exception.
					 * maybe the app is expecting an exception and behaves oddly
					 * if it doesn't
					 * get one.
					 */
					Monolith.log("  invoke failed with " + e);
					// MainHook.log("    fallback to this package for receiver!");
					Monolith.log("    going to return exception:" + e);
					throw e;
				}

				if ( (flags & PackageManager.GET_SIGNATURES) == PackageManager.GET_SIGNATURES ) {
					Signature[] spoofSigs = Monolith.spoofSignatures();
					System.arraycopy(spoofSigs, 0,
							((PackageInfo) result).signatures, 0,
							((PackageInfo) result).signatures.length);
					Monolith.log("  spoofing "
							+ ((PackageInfo) result).signatures
							+ " signatures for "
							+ ((PackageInfo) result).packageName);
				}

				return result;
			}
			else if ( methodName.equals("getApplicationEnabledSetting") ) {
				int result = Monolith.getApplicationEnabledSetting(
						(PackageManager) receiver, (String) args[0]);
				return Integer.valueOf(result);
			}
			else if ( methodName.equals("checkSignatures") ) {
				// This could be detected by comparing a known installed package
				// that will not match signatures. Will deal with that if it
				// ever happens. :D
				if ( args[0].getClass().equals(String.class) ) {
					return Monolith.checkSignatures((PackageManager) receiver,
							(String) args[0], (String) args[1]);
				}
				else {
					return Monolith.checkSignatures((PackageManager) receiver,
							((Integer) args[0]).intValue(),
							((Integer) args[1]).intValue());
				}
			}

		}
		else if ( className.contains("jce.provider.JDKDigestSignature") ) {
			// initVerify may throw InvalidKeyException, just return
			// but also hook update to not do anything
			if ( methodName.equals("initVerify") ) {
				return null;
			}
			else if ( methodName.equals("update") ) {
				return null;
			}
			else if ( methodName.equals("verify") ) { return true; }
		}
		else if ( className.equals("java.io.File") ) {
			if ( Monolith.isThisApk((File) receiver) ) {
				if ( methodName.equals("length") ) {
					return Monolith.length((File) receiver);
				}
				else if ( methodName.equals("lastModified") ) { return Monolith
						.lastModified((File) receiver); }
			}
		}
		else if ( className.equals("android.content.Context") ) {
			if ( methodName.equals("getApplicationInfo") ) { return Monolith
					.getApplicationInfo((Context) receiver); }
		}
		else if ( className.equals("android.os.Debug") ) {
			if ( methodName.equals("isDebuggerConnected") ) { return Monolith
					.isDebuggerConnected(); }
		}
		else if ( className.startsWith("java.security.Signature") ) {
			if ( className.equals("java.security.Signature") ) {
				if ( methodName.equals("verify") ) {
					if ( args.length == 4 ) {
						return Monolith.signatureVerify(
								(java.security.Signature) receiver,
								(byte[]) args[0], (int) (Integer) args[1],
								(int) (Integer) args[2]);
					}
					else if ( args.length == 1 ) { return Monolith
							.signatureVerify(
									(java.security.Signature) receiver,
									(byte[]) args[0]); }
				}
			}
			else if ( className.equals("java.security.MessageDigest") ) {
				if ( methodName.equals("update") ) {
					if ( Monolith.DEBUG && !Monolith.BuildingDigest ) {
						Monolith.log("  building message digest");
					}

					Monolith.BuildingDigest = true;
				}
				// this will actually never call because Android uses
				// org.apache.harmony.xnet.provider.jsse.OpenSSLMessageDigestJDK$MD5.digest()
				else if ( methodName.equals("digest") ) { return Monolith
						.spoofDigest((MessageDigest) receiver); }
			}
		}
		else if ( className
				.startsWith("org.apache.harmony.xnet.provider.jsse.OpenSSLMessageDigestJDK$") ) {
			Thread.dumpStack();

			if ( methodName.equals("digest") ) { return Monolith
					.spoofDigest((MessageDigest) receiver); }
		}
		else if ( className.equals("android.telephony.TelephonyManager") ) {
			if ( methodName.equals("getDeviceId") ) {
				Monolith.log("  invoking getDeviceId()");
				return Monolith.getDeviceId();
			}
		}
		else if ( receiver instanceof java.lang.Throwable ) {
			if ( methodName.equals("fillInStackTrace") ) {
				Monolith.log("  invoking fillInStackTrace normally then scrubbing");
				method.invoke(receiver, args);
				Monolith.setStackTrace((Throwable) receiver);
				return null;
			}
			else if ( methodName.equals("printStackTrace") ) {
				Monolith.throwablePrintStackTrace((Throwable) receiver);
				return null;
			}
		}
		else if ( className.startsWith("java.lang.") ) {
			if ( className.equals("java.lang.Thread") ) {
				if ( methodName.equals("dumpStack") ) {
					Monolith.log("  running threadDumpStack()");
					Monolith.threadDumpStack();
					return null;
				}
				else if ( methodName.equals("getStackTrace") ) { return Monolith
						.threadGetStackTrace((Thread) receiver); }
			}
			else if ( className.equals("java.lang.reflect.Method") ) {
				if ( methodName.equals("invoke") ) {
					Monolith.log("  invoking an invoke! sneaky sneaky :D!");
					return invokeHook((Method) receiver, args[0],
							(Object[]) args[1]);
				}
			}
			else if ( className.equals("java.lang.Runtime") ) {
				if ( methodName.equals("exec") ) { return Monolith.runtimeExec(
						(Runtime) receiver, (String) args[0]); }
			}
		}
		else if ( className.startsWith("java.util.") ) {
			if ( className.equals("java.util.zip.ZipFile") ) {
				if ( methodName.equals("getEntry") ) { return Monolith
						.getZipEntry((ZipFile) receiver, (String) args[0]); }
			}
			else if ( className.equals("java.util.jar.JarFile") ) {
				if ( methodName.equals("getEntry") ) {
					return Monolith.getZipEntry((ZipFile) receiver,
							(String) args[0]);
				}
				else if ( methodName.equals("getJarEntry") ) { return Monolith
						.getJarEntry((JarFile) receiver, (String) args[0]); }
			}
			else if ( className.equals("java.util.zip.Adler32")
					|| className.equals("java.util.zip.CRC32") ) {
				if ( methodName.equals("getValue") ) { return Monolith
						.spoofChecksum((Checksum) receiver); }
			}
		}
		else if ( className.startsWith("java.lang.reflect.Constructor") ) {
			if ( methodName.equals("newInstance") ) { return ReflectedConstructor
					.constructorNewInstance((Constructor<?>) receiver, args); }
		}
		else if ( className.startsWith("dalvik.system.DexFile") ) {
			if ( methodName.equals("loadDex") ) { return Monolith.loadDex(
					(String) args[0], (String) args[1], (Integer) args[2]); }
		}

		// No hooks, work as normal
		Monolith.log("  hook not handled, invoke normally.");
		return method.invoke(receiver, args);
	}
}
