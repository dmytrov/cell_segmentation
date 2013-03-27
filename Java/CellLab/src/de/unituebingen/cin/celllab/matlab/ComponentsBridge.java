package de.unituebingen.cin.celllab.matlab;

import java.lang.reflect.Constructor;
import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;

public class ComponentsBridge {
	public HashMap<String, Class<? extends ComponentUI>> uiClasses;  
	
	public ComponentsBridge() {
		uiClasses = new HashMap<String, Class<? extends ComponentUI>>();
	}
	
	public void registerComponentUI(String matlabClassName, Class<? extends ComponentUI> uiClass) {
		uiClasses.put(matlabClassName, uiClass);
	}
	
	public ComponentUI createUIByMatlabClassName(String matlabClassName) {
		Class<? extends ComponentUI> uiClass = uiClasses.get(matlabClassName);
		if (uiClass != null) {
			Constructor<? extends ComponentUI> ctor;
			try {
				ctor = uiClass.getConstructor();
				try {
					return ctor.newInstance();
				} catch (IllegalArgumentException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (InstantiationException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (IllegalAccessException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} catch (InvocationTargetException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			} catch (SecurityException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (NoSuchMethodException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
		return null;		
	}
}
