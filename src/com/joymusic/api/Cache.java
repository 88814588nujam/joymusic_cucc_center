package com.joymusic.api;

import java.util.HashMap;
import javax.servlet.ServletContext;

public class Cache {
	private static String CNAME = "RBCACHE";
	private static ServletContext app = null;

	public static void OpenCache(ServletContext app) {
		if (app != null) {
			Cache.app = app;
		}
	}

	public static void closeCache() {
		if (app != null)
			app = null;
	}

	public static void closeAndClearCache() {
		if (app != null) {
			app.setAttribute(CNAME, null);
			app = null;
		}
	}

	@SuppressWarnings("unchecked")
	private static HashMap<Object, Object> getZone(String zone) {
		if (app != null) {
			HashMap<String, Object> appdata = (HashMap<String, Object>) app.getAttribute(CNAME);
			if (appdata == null) {
				appdata = new HashMap<String, Object>();
				app.setAttribute(CNAME, appdata);
			}
			HashMap<Object, Object> cache = (HashMap<Object, Object>) appdata.get(zone);
			if (cache == null) {
				cache = new HashMap<Object, Object>();
				appdata.put(zone, cache);
			}
			return cache;
		}
		return null;
	}

	public static void put(String zone, Object key, Object val) {
		HashMap<Object, Object> hm = getZone(zone);
		if (hm != null)
			hm.put(key, val);
		else
			return;
	}

	public static Object get(String zone, Object key) {
		HashMap<Object, Object> hm = getZone(zone);
		if (hm != null)
			return hm.get(key);
		else
			return null;
	}

	public static Object get(Object sql) {
		HashMap<Object, Object> hm = getZone("default_sql");
		if (hm != null)
			return hm.get(sql);
		else
			return null;
	}
	
	public static void clear(String zone, Object key) {
		HashMap<Object, Object> hm = getZone(zone);
		if (hm != null)
			hm.remove(key);
		else
			return;
	}

	@SuppressWarnings("unchecked")
	public static void clearZone(String zone) {
		if (app != null) {
			HashMap<String, Object> appdata = (HashMap<String, Object>) app.getAttribute(CNAME);
			appdata.remove(zone);
		}
	}

	public static void clearAll() {
		if (app != null)
			app.setAttribute(CNAME, null);
	}
}