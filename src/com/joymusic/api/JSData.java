package com.joymusic.api;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class JSData {
	Map<JSDataKey, String> data = new HashMap<JSDataKey, String>();

	public JSData() {
	}

	public JSData(String str) {
		parse(str);
	}

	public int getSize() {
		return data.size();
	}

	public void parse(String str) {
		try {
			JSONArray array = new JSONArray(str);
			for (int i = 0; i < array.length(); i++) {
				JSONObject item = new JSONObject(array.get(i).toString());
				String zone = item.getString("zone");
				String key = item.getString("key");
				String val = item.getString("val");
				if (zone.equals("globle") && key.equals("return")) {
					if (val.equals("[]"))
						val = "";
				}
				if (StringUtils.isNotBlank(val))
					put(item.getString("zone"), item.getString("key"),
							item.getString("val"));
			}
		} catch (JSONException e) {
			e.printStackTrace();
		}
	}

	public void put(String zone, String key, String val) {
		JSDataKey dataKey = new JSDataKey(zone, key);
		data.put(dataKey, val);
	}

	public void putByEncode(String zone, String key, String val)
			throws UnsupportedEncodingException {
		JSDataKey dataKey = new JSDataKey(zone, key);
		data.put(dataKey, URLEncoder.encode(val, "utf-8"));
	}

	public String get(String zone, String key) {
		JSDataKey dataKey = new JSDataKey(zone, key);
		return data.get(dataKey);
	}

	public String getByEncode(String zone, String key)
			throws UnsupportedEncodingException {
		JSDataKey dataKey = new JSDataKey(zone, key);
		String val = data.get(dataKey);
		if (val != null) {
			return URLDecoder.decode(val, "utf-8");
		}
		return null;
	}

	public String getByJson(String zone, String key, String jsonKey) {
		String jsStr = get(zone, key);
		if (jsStr != null) {
			try {
				JSONObject js = new JSONObject(jsStr);
				return js.getString(jsonKey);
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		return null;
	}

	public String getJsdataByEncodedString() {
		try {
			JSONArray array = new JSONArray();
			Iterator<Map.Entry<JSDataKey, String>> iterator = data.entrySet()
					.iterator();
			while (iterator.hasNext()) {
				Map.Entry<JSDataKey, String> entry = iterator.next();
				JSDataKey dataKey = entry.getKey();
				String zone = dataKey.zone;
				String key = dataKey.key;
				String val = entry.getValue();
				JSONObject obj = new JSONObject();
				obj.put("zone", zone);
				obj.put("key", key);
				obj.put("val", val);
				array.put(obj);
			}
			return URLEncoder.encode(array.toString(), "utf-8");
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	public String[] toStringArray() {
		String[] ret = new String[data.size()];
		int i = 0;
		Iterator<Map.Entry<JSDataKey, String>> iterator = data.entrySet()
				.iterator();
		while (iterator.hasNext()) {
			Map.Entry<JSDataKey, String> entry = iterator.next();
			JSDataKey dataKey = entry.getKey();
			String zone = dataKey.zone;
			String key = dataKey.key;
			String val = entry.getValue();
			StringBuffer sb = new StringBuffer();
			sb.append("put(\'").append(zone).append("\',\'").append(key)
					.append("\',\'").append(val).append("\');");
			ret[i++] = sb.toString();
		}
		return ret;
	}
}

class JSDataKey {
	String zone;
	String key;

	public JSDataKey(String zone, String key) {
		this.zone = zone;
		this.key = key;
	}

	public String toString() {
		return zone + key;
	}

	public boolean equals(Object obj) {
		if (obj instanceof JSDataKey) {
			JSDataKey temp = (JSDataKey) obj;
			if (this.zone.equals(temp.zone) && this.key.equals(temp.key)) {
				return true;
			}
		}
		return false;
	}

	public int hashCode() {
		return (zone + key).hashCode();
	}
}