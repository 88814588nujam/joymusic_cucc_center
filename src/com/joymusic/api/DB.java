package com.joymusic.api;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import com.joymusic.common.Log;

public class DB {
	private static DataSource ds = null;
	static boolean allowCache = true;

	static Connection getConnection() {
		if (ds == null) {
			try {
				Context ctx = new InitialContext();
				String path = getCurrentClass().getResource("").getPath();
				path = path.substring(0, path.indexOf("/WEB-INF"));
				path = path.substring(path.lastIndexOf("/") + 1);
				// IDE编辑器会把发布工程名自动加上尾缀，需要强行切割
				if (path.contains("_war_exploded"))
					path = path.replace("_war_exploded", "");
				ds = (DataSource) ctx.lookup("java:comp/env/jdbc/" + path);
			} catch (Exception e) {
				Log.LogErr("getConnection 1:" + e.getMessage());
			}
		}

		Connection cn = null;
		try {
			cn = ds.getConnection();
		} catch (Exception e) {
			Log.LogErr("getConnection 2:" + e.getMessage());
		}
		return cn;
	}

	static void close(Connection cn, Statement stmt, ResultSet rs) {
		try {
			rs.close();
		} catch (Exception e) {
		}

		try {
			stmt.close();
		} catch (Exception e) {
		}

		try {
			cn.close();
		} catch (Exception e) {
		}
	}

	@SuppressWarnings("unchecked")
	public static List<Map<String, Object>> query(String sql, boolean iscache) {
		iscache = iscache && allowCache;
		List<Map<String, Object>> li = (List<Map<String, Object>>) Cache
				.get(sql);

		if (iscache && li != null)
			return li;

		Connection cn = null;
		Statement stmt = null;
		ResultSet rs = null;
		ResultSetMetaData m = null;

		li = new ArrayList<Map<String, Object>>();
		try {
			cn = getConnection();
			stmt = cn.createStatement();
			rs = stmt.executeQuery(sql);
			m = rs.getMetaData();
			int columns = m.getColumnCount();
			while (rs.next()) {
				Map<String, Object> map = new HashMap<String, Object>();
				for (int i = 1; i <= columns; i++) {
					map.put(m.getColumnName(i), rs.getObject(i));
				}
				li.add(map);
			}
		} catch (Exception e) {
			Log.LogErr("DB query: sql=" + sql + ";" + e.getMessage());
		} finally {
			close(cn, stmt, rs);
		}
		if (iscache && li.size() > 0)
			Cache.put("default_sql", sql, li);
		return li;
	}

	public static int queryCount(String sql, boolean iscache) {
		iscache = iscache && allowCache;
		Integer count = (Integer) Cache.get(sql);

		if (iscache && count != null)
			return count;

		Connection cn = null;
		Statement stmt = null;
		ResultSet rs = null;
		int retInt = 0;
		try {
			cn = getConnection();
			stmt = cn.createStatement();
			rs = stmt.executeQuery(sql);
			rs.next();
			retInt = Integer.parseInt(rs.getString(1));
		} catch (Exception e) {
			Log.LogErr("DB update: sql=" + sql + ";" + e.getMessage());
		} finally {
			close(cn, stmt, rs);
		}
		if (iscache)
			Cache.put("default_sql", sql, retInt);
		return retInt;
	}

	public static int update(String sql) {
		Connection cn = null;
		Statement stmt = null;
		int count = 0;
		try {
			cn = getConnection();
			stmt = cn.createStatement();
			count = stmt.executeUpdate(sql);
		} catch (Exception e) {
			Log.LogErr("DB update: sql=" + sql + ";" + e.getMessage());
		} finally {
			close(cn, stmt, null);
		}
		return count;
	}

	public static String sqlWrapperByHashMap(String sql,
			HashMap<Object, Object> parameters) {
		Pattern p = Pattern.compile("\\$([\\w_]+)");
		Matcher m = p.matcher(sql);

		StringBuffer bf = new StringBuffer();
		while (m.find()) {
			m.appendReplacement(bf, "'" + parameters.get(m.group(1)) + "'");
		}
		m.appendTail(bf);
		return bf.toString();
	}

	public static String sqlWrapperByParams(String sql, Object... parameters) {
		Pattern p = Pattern.compile("\\$([\\w_]+)");
		Matcher m = p.matcher(sql);

		StringBuffer bf = new StringBuffer();
		int i = 0;
		while (m.find()) {
			if (i == parameters.length)
				break;
			m.appendReplacement(bf, "'" + parameters[i++] + "'");
		}
		m.appendTail(bf);
		return bf.toString();
	}

	@SuppressWarnings("rawtypes")
	private static final Class getCurrentClass() {
		return new Object() {
			public Class getClassForStatic() {
				return this.getClass();
			}
		}.getClassForStatic();
	}
}