package com.joymusic.common;

import org.apache.log4j.Logger;

public class Log {
	public static Logger mylog = Logger.getLogger("mylog");
	public static Logger myplay = Logger.getLogger("myplay");
	public static Logger myerror = Logger.getLogger("myerror");
	public static Logger mydebug = Logger.getLogger("mydebug");

	public static void LogUser(String data) {
		mylog.info(data);
	}
	
	public static void LogPlay(String data) {
		myplay.info(data);
	}
	
	public static void LogErr(String data) {
		myerror.info(data);
	}
	
	public static void LogDebug(String data) {
		mydebug.info(data);
	}
}
