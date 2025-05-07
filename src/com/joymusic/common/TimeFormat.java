package com.joymusic.common;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.GregorianCalendar;

public class TimeFormat {
	@SuppressWarnings("unused")
	private static final String DEFAULT_FORMAT = "yyyyMMdd HH:mm:ss";
	public static final String LONG_FORMAT = "yyyy-MM-dd HH:mm";
	/**
	 * 获取系统当前日期
	 * @return
	 */
	public static String getCurrentStr() {
		SimpleDateFormat sf = new SimpleDateFormat("yyyyMMdd");
		return sf.format(new Date());
	}
	
	/**
	 * 获取系统当前日期
	 * @return
	 */
	public static String getCurrentDate() {
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd");
		return sf.format(new Date());
	}

	/**
	 * 获取系统当前时间
	 * @return
	 */
	public static String getCurrentTime() {
		SimpleDateFormat sf = new SimpleDateFormat("HH:mm:ss");
		return sf.format(new Date());
	}

	/**
	 * 获取系统当前日期时间
	 * @return
	 */
	public static String getCurrentDateTime() {
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return sf.format(new Date());
	}

	/**
	 * 获取自定义格式的日期
	 * @param pattern 日期格式(默认日期格式为：yyyy-MM-dd HH:mm:ss)
	 * @return
	 */
	public static String getSystemTime(String pattern) {
		SimpleDateFormat sf = new SimpleDateFormat(pattern == null
				|| "".equals(pattern.trim()) ? "yyyy-MM-dd HH:mm:ss" : pattern);
		return sf.format(new Date());
	}
	
	/**
	 * 根据给定的日期间隔计算新的日期
	 * @param baseDate 起始日期
	 * @param interval 日期间隔
	 * @param unit 日历字段 Y-年 M-月 D-日 H-时 m-分 S-秒
	 * @return
	 * @throws ParseException 
	 */
	public static Date calDate(Date baseDate, int interval, String unit) throws ParseException {

		GregorianCalendar mCalendar = new GregorianCalendar();
		mCalendar.setTime(baseDate);
		if (unit.equals("Y")) {//年
			mCalendar.add(Calendar.YEAR, interval);
		}
		if (unit.equals("M")) {//月
			mCalendar.add(Calendar.MONTH, interval);
		}
		if (unit.equals("D")) {//日
			mCalendar.add(Calendar.DATE, interval);
		}
		if(unit.equals("H")){//时
			mCalendar.add(Calendar.HOUR, interval);
		}
		if(unit.equals("m")){//分
			mCalendar.add(Calendar.MINUTE, interval);
		}
		if(unit.equals("S")){//秒
			mCalendar.add(Calendar.SECOND, interval);
		}
		
		String year = String.valueOf(mCalendar.get(Calendar.YEAR));
		String month = String.valueOf(mCalendar.get(Calendar.MONTH)+1);
		String day = String.valueOf(mCalendar.get(Calendar.DATE));
		String hour = String.valueOf(mCalendar.get(Calendar.HOUR_OF_DAY));
		String minute = String.valueOf(mCalendar.get(Calendar.MINUTE));
		String second = String.valueOf(mCalendar.get(Calendar.SECOND));
		
		if(Integer.parseInt(month)<10){
			month = "0"+month;
		}
		if(Integer.parseInt(day)<10){
			day = "0"+day;
		}
		if(Integer.parseInt(hour)<10){
			hour = "0"+hour;
		}
		if(Integer.parseInt(minute)<10){
			minute = "0"+minute;
		}
		if(Integer.parseInt(second)<10){
			second = "0"+second;
		}
		
		SimpleDateFormat sf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		return sf.parse(year+"-"+month+"-"+day+" "+hour+":"+minute+":"+second);
	}
	
	/**
	 * 计算日期差
	 * @param startDate 起始日期
	 * @param endDate 终止日期
	 * @param unit 日历字段 Y-年 M-月 D-日
	 * @return
	 */
	public static int calInterval(Date startDate, Date endDate, String unit) {
		int interval = 0;

		GregorianCalendar sCalendar = new GregorianCalendar();
		sCalendar.setTime(startDate);
		int sYears = sCalendar.get(Calendar.YEAR);
		int sMonths = sCalendar.get(Calendar.MONTH);
		int sDays = sCalendar.get(Calendar.DAY_OF_MONTH);
		int sDaysOfYear = sCalendar.get(Calendar.DAY_OF_YEAR);

		GregorianCalendar eCalendar = new GregorianCalendar();
		eCalendar.setTime(endDate);
		int eYears = eCalendar.get(Calendar.YEAR);
		int eMonths = eCalendar.get(Calendar.MONTH);
		int eDays = eCalendar.get(Calendar.DAY_OF_MONTH);
		int eDaysOfYear = eCalendar.get(Calendar.DAY_OF_YEAR);
		// 计算年差
		if (unit.equals("Y")) {
			interval = eYears - sYears;
			if (eMonths < sMonths) {
				interval--;
			} else {
				if (eMonths == sMonths && eDays < sDays) {
					interval--;
					if (eMonths == 1) {// 如果同是2月，校验润年问题
						if ((sYears % 4) == 0 && (eYears % 4) != 0) {// 如果起始年是润年，终止年不是润年
							if (eDays == 28) {// 如果终止年不是润年，且2月的最后一天28日，那么补一
								interval++;
							}
						}
					}
				}
			}
		}
		// 计算月差
		if (unit.equals("M")) {
			interval = eYears - sYears;
			interval *= 12;
			interval += eMonths - sMonths;
			if (eDays < sDays) {
				interval--;
				// eDays如果是月末，则认为是满一个月
				int maxDate = eCalendar.getActualMaximum(Calendar.DATE);
				if (eDays == maxDate) {
					interval++;
				}
			}
		}
		// 计算日差
		if (unit.equals("D")) {
			interval = eYears - sYears;
			interval *= 365;
			interval += eDaysOfYear - sDaysOfYear;
			// 处理润年
			int n = 0;
			eYears--;
			if (eYears > sYears) {
				int i = sYears % 4;
				if (i == 0) {
					sYears++;
					n++;
				}
				int j = (eYears) % 4;
				if (j == 0) {
					eYears--;
					n++;
				}
				n += (eYears - sYears) / 4;
			}
			if (eYears == sYears) {
				int i = sYears % 4;
				if (i == 0) {
					n++;
				}
			}
			interval += n;
		}
		return interval;
	}

	public static Date format(String format, Date date) {
		if ((format == null) || (format.trim().length() <= 0)) {
			format = "yyyyMMdd HH:mm:ss";
		}
		SimpleDateFormat sdf = new SimpleDateFormat(format);
		String dataStr = formatString(format, date);
		try {
			return sdf.parse(dataStr);
		} catch (ParseException localParseException) {
		}
		return null;
	}

	public static String formatString(String format, Date date) {
		if ((format == null) || (format.trim().length() <= 0)) {
			format = "yyyyMMdd HH:mm:ss";
		}
		SimpleDateFormat sdf = new SimpleDateFormat(format);

		return sdf.format(date);
	}

	public static int getHour() {
		Calendar start = Calendar.getInstance();
		return start.get(11);
	}

	public static Calendar getQueryStart() {
		Calendar start = Calendar.getInstance();
		Date endDate = format(null, start.getTime());
		start.setTime(endDate);

		return start;
	}

	public static Calendar getQueryEnd() {
		Calendar start = Calendar.getInstance();
		Date endDate = format(null, start.getTime());
		long cha = endDate.getTime() + 28800L;
		endDate.setTime(cha);
		start.setTime(endDate);

		return start;
	}

	public static Calendar getYestodayEnd() {
		Calendar start = Calendar.getInstance();
		start.add(5, -1);
		start.set(11, 23);
		start.set(12, 59);
		start.set(13, 59);
		start.set(14, 999);
		Date endDate = format(null, start.getTime());
		start.setTime(endDate);

		return start;
	}

	public static String getWeekDayOfFirst() {
		Calendar now = Calendar.getInstance();
		now.setFirstDayOfWeek(2);
		now.set(7, 2);
		now.set(11, 0);
		now.set(12, 0);
		now.set(13, 0);
		now.set(14, 0);
		Date date = now.getTime();

		return formatString("yyyy-MM-dd HH:mm", date);
	}

	public static String getWeekDayOfLast() {
		Calendar now = Calendar.getInstance();
		now.setFirstDayOfWeek(2);
		now.set(7, 1);
		now.set(11, 23);
		now.set(12, 59);
		now.set(13, 59);
		now.set(14, 999);
		Date date = now.getTime();

		return formatString("yyyy-MM-dd HH:mm", date);
	}
}