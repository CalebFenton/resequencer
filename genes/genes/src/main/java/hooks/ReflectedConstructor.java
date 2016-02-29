package hooks;

import java.io.File;
import java.io.InputStream;
import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;

public class ReflectedConstructor {
	public static Object constructorNewInstance(Constructor<?> c,
			Object[] initargs) throws IllegalArgumentException,
			InstantiationException, IllegalAccessException,
			InvocationTargetException {
		String cnstrClassName = c.getDeclaringClass().getName();

		/*
		 * constructorNewInstance() of javax.crypto.spec.SecretKeySpec
		 * toGenericString: public
		 * javax.crypto.spec.SecretKeySpec(byte[],java.lang.String)
		 */
		Monolith.log("Constructor hook for class: " + cnstrClassName);

		Object newObj = c.newInstance(initargs);

		// Should we watch this FileInputStream?
		if ( cnstrClassName.equals("java.io.FileInputStream") ) {
			String className = initargs[0].getClass().getName();
			if ( className.equals("java.io.File") ) {
				Monolith.watchInputStream((InputStream) newObj,
						(File) initargs[0]);
			}
			else if ( className.equals("java.lang.String") ) {
				Monolith.watchInputStream((InputStream) newObj,
						(String) initargs[0]);
			}
			else {
				Monolith.log("  unable to hook. Maybe using file descriptors.");
			}
		}

		return newObj;
	}
}
