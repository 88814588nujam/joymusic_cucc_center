<%@page import="com.joymusic.api.*,java.util.*" pageEncoding="UTF-8"%>
<%!
	// 查询apply概率和需要订购产品包
	public static Map<String, Object> getAppConfig(String cityN){
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM config_apply WHERE cityN='" + cityN + "'";
		li = DB.query(sql, false);
		if(li.size() > 0){
			map = li.get(0);
		}
		return map;
	}

	// 查询是否黑名单用户
	private boolean isBlackUser(String uid){
		int row = 0;
		boolean flag = false;
		try{
			String sql = "SELECT count(*) FROM user_permit_black WHERE uid='" + uid + "'";
			row = DB.queryCount(sql, false);
			if(row == 0){
				flag = true;	
			}
		} catch(Exception e){
		}
		return flag;
	}
	 
	// 查询是否白名单用户
	private boolean isWhiteUser(String uid){
		boolean flag = false;
		try {
			String sql = "SELECT permit FROM user_permit_white WHERE uid='" + uid + "'";
			List<Map<String, Object>> li = DB.query(sql, false);
			if(li.size() > 0){
				flag = true;
			}
		} catch(Exception e){
		}
		return flag;
	}
	
	// 查询当前省份总订购数
	private int isPaySumProvince(String provinceN){
		int rt = 0;
		try {
			String sql = "SELECT COUNT(0) FROM user_pay_info A, entity_area B WHERE TO_DAYS(A.createtime)=TO_DAYS(NOW()) AND A.cityN=B.cityN AND B.provinceN='" + provinceN + "'";
			rt = DB.queryCount(sql, false);
		} catch(Exception e){
		}
		return rt;
	}
	
	// 查询当前城市总订购数
	private int isPaySumCity(String cityN){
		int rt = 0;
		try {
			String sql = "SELECT COUNT(0) FROM user_pay_info WHERE TO_DAYS(createtime)=TO_DAYS(NOW()) AND cityN='" + cityN + "'";
			rt = DB.queryCount(sql, false);
		} catch(Exception e){
		}
		return rt;
	}

	private boolean needSkipApply(String uid){
		boolean flag = false;
		// 正式用户是以iptv开头的
		if(uid.startsWith("cutv")) flag = true;
		return flag;
	}
	
	// 策略判断
	private String getApplyPercent(String provinceN, String cityN, String uid){
		int percent = 0; // 概率
		int payN = 0; // 产品包
		int stime = 0; // 开始时间
		int etime = 24; // 结束时间
		int sumPercent = 0; // 获取总的订购概率
		int sumCount = 0; // 总订购上限
		int count = 0; // 分市区的订购上限
		boolean flag = false;
		// 1.先获取当前账号是否正常账号
		if(needSkipApply(uid)){
			// 2.获取某省份总订购上限数和省份总概率
			Map<String, Object> sumConfigProvince = getAppConfig(provinceN);
			int sumPercentProvince = Integer.parseInt(sumConfigProvince.get("percent").toString());
			// 省份总概率必须大于0才允许开始工作
			if(sumPercentProvince > 0){
				int sumCountProvince = Integer.parseInt(sumConfigProvince.get("total").toString());
				int isSumProvince = isPaySumProvince(provinceN);
				// 当天订购数量没有超过省份总订购上限数
				if(isSumProvince < sumCountProvince){
					// 3.获取某城市总订购上限数和城市总概率
					Map<String, Object> sumConfigCity = getAppConfig(cityN);
					int sumPercentCity = Integer.parseInt(sumConfigCity.get("percent").toString());
					// 城市概率必须大于0才允许开始工作
					if(sumPercentCity > 0){
						int sumCountCity = Integer.parseInt(sumConfigCity.get("total").toString());
						int isSumCity = isPaySumCity(cityN);
						// 当天订购数量没有超过城市总订购上限数
						if(isSumCity < sumCountCity){
							//4.判断是否在概率内
							int min = 1, max = 100;
							Random random = new Random();
							int sr = random.nextInt(max) % (max - min + 1) + min;
							if(sr <= percent){
								//5.判断是否在时间段内
								int nowTime = Calendar.getInstance().get(Calendar.HOUR_OF_DAY);
								stime = Integer.parseInt(sumConfigCity.get("startTime").toString());
								etime = Integer.parseInt(sumConfigCity.get("entTime").toString());
								if(nowTime >= stime && nowTime <= etime){
									//6.判断是否黑名单账号
									if(isBlackUser(uid)){
										flag = true;
										payN = Integer.parseInt(sumConfigCity.get("payN").toString());
									}
								}
							}
						}
					}
				}
			}
		}
		String rt = "{\"bindUer\":" + flag + ", \"payN\":" + payN + "}";
		return rt;
	}
%>