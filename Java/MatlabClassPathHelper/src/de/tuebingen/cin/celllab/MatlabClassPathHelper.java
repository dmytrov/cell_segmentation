package de.tuebingen.cin.celllab;

import java.io.File;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.URL;
import java.net.URLClassLoader;

class MatlabClassPathHelper {
	
    public static void addFileToClassPath(String newClassPath) throws Exception  {
		try {
	    	File file = new File(newClassPath);
	    	URL newURL;
			newURL = file.toURI().toURL();
			if(!isInSystemClassLoader(newURL)) {   
				System.out.print("Adding " + newURL.toString() + "...");
		        addToSystemClassLoader(newURL);
		        System.out.println(" done");
	        }
			else {
				System.out.println("File " + newURL.toString() + " is already in the classpath");
			}
		} catch (Exception e) {
			System.out.println(" failed");
			throw e;
		}
    }
    
    private static boolean isInSystemClassLoader(URL newURL) {   
            URLClassLoader systemClassLoader = (URLClassLoader) ClassLoader.getSystemClassLoader();
            URL[] urls = systemClassLoader.getURLs();

            for (URL url : urls) {
                if(url.equals(newURL)) {
                	return true;
                }
            }
        
            return false;
    }
    
    private static void addToSystemClassLoader(URL newURL) throws NoSuchMethodException, SecurityException, IllegalAccessException, IllegalArgumentException, InvocationTargetException {   
            URLClassLoader systemClassLoader = (URLClassLoader) ClassLoader.getSystemClassLoader(); 
            Class<URLClassLoader> classLoaderClass = URLClassLoader.class; 

            Method method = classLoaderClass.getDeclaredMethod("addURL", URL.class);
            method.setAccessible(true); 
	        method.invoke(systemClassLoader, newURL);
    }
}

