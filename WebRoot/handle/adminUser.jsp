<%@page import="java.text.SimpleDateFormat,org.json.JSONObject,com.joymusic.api.*,java.util.*,java.net.*,java.io.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%!
	// 获取省份编号
	static String getProvinceNum(String tmpStr){
		return tmpStr;
	}

	// 获取省份中文
	static String getProvinceName(String tmpStr){
		String rtStr = "天津市";
		if(tmpStr.equals("201")){ // 天津市
			rtStr = "天津市";
		} else if(tmpStr.equals("204")){ // 河南省
			rtStr = "河南省";
		} else if(tmpStr.equals("207")){ // 山西省
			rtStr = "山西省";
		} else if(tmpStr.equals("208")){ // 内蒙古自治区
			rtStr = "内蒙古自治区";
		} else if(tmpStr.equals("211")){ // 黑龙江省
			rtStr = "黑龙江省";
		} else if(tmpStr.equals("214")){ // 福建省
			rtStr = "福建省";
		} else if(tmpStr.equals("216")){ // 山东省
			rtStr = "山东省";
		} else if(tmpStr.equals("217")){ // 湖北省
			rtStr = "湖北省";
		} else if(tmpStr.equals("223")){ // 贵州省
			rtStr = "贵州省";
		}
		return rtStr;
	}

	// 获取城市编号204
	static String getCityNum_204(String tmpStr){
		String rtStr = "3710";
		if(tmpStr.startsWith("370")){ // 商丘
			rtStr = "3700";
		} else if(tmpStr.startsWith("371")){ // 郑州
			rtStr = "3710";
		} else if(tmpStr.startsWith("372")){ // 安阳
			rtStr = "3720";
		} else if(tmpStr.startsWith("373")){ // 新乡
			rtStr = "3730";
		} else if(tmpStr.startsWith("374")){ // 许昌
			rtStr = "3740";
		} else if(tmpStr.startsWith("375")){ // 平顶山
			rtStr = "3750";
		} else if(tmpStr.startsWith("376")){ // 信阳
			rtStr = "3760";
		} else if(tmpStr.startsWith("377")){ // 南阳
			rtStr = "3770";
		} else if(tmpStr.startsWith("378")){ // 开封
			rtStr = "3780";
		} else if(tmpStr.startsWith("379")){ // 洛阳
			rtStr = "3790";
		} else if(tmpStr.startsWith("391")){ // 焦作
			rtStr = "3910";
		} else if(tmpStr.startsWith("392")){ // 鹤壁
			rtStr = "3920";
		} else if(tmpStr.startsWith("393")){ // 濮阳
			rtStr = "3930";
		} else if(tmpStr.startsWith("394")){ // 周口
			rtStr = "3940";
		} else if(tmpStr.startsWith("395")){ // 漯河
			rtStr = "3950";
		} else if(tmpStr.startsWith("396")){ // 驻马店
			rtStr = "3960";
		} else if(tmpStr.startsWith("398")){ // 三门峡
			rtStr = "3980";
		} else if(tmpStr.startsWith("399")){ // 济源
			rtStr = "3990";
		}
		return rtStr;
	}

	// 获取城市中文204
	static String getCityName_204(String tmpStr){
		String rtStr = "郑州";
		if(tmpStr.startsWith("370")){ // 商丘
			rtStr = "商丘";
		} else if(tmpStr.startsWith("371")){ // 郑州
			rtStr = "郑州";
		} else if(tmpStr.startsWith("372")){ // 安阳
			rtStr = "安阳";
		} else if(tmpStr.startsWith("373")){ // 新乡
			rtStr = "新乡";
		} else if(tmpStr.startsWith("374")){ // 许昌
			rtStr = "许昌";
		} else if(tmpStr.startsWith("375")){ // 平顶山
			rtStr = "平顶山";
		} else if(tmpStr.startsWith("376")){ // 信阳
			rtStr = "信阳";
		} else if(tmpStr.startsWith("377")){ // 南阳
			rtStr = "南阳";
		} else if(tmpStr.startsWith("378")){ // 开封
			rtStr = "开封";
		} else if(tmpStr.startsWith("379")){ // 洛阳
			rtStr = "洛阳";
		} else if(tmpStr.startsWith("391")){ // 焦作
			rtStr = "焦作";
		} else if(tmpStr.startsWith("392")){ // 鹤壁
			rtStr = "鹤壁";
		} else if(tmpStr.startsWith("393")){ // 濮阳
			rtStr = "濮阳";
		} else if(tmpStr.startsWith("394")){ // 周口
			rtStr = "周口";
		} else if(tmpStr.startsWith("395")){ // 漯河
			rtStr = "漯河";
		} else if(tmpStr.startsWith("396")){ // 驻马店
			rtStr = "驻马店";
		} else if(tmpStr.startsWith("398")){ // 三门峡
			rtStr = "三门峡";
		} else if(tmpStr.startsWith("399")){ // 济源
			rtStr = "济源";
		}
		return rtStr;
	}

	// 获取城市编号207
	static String getCityNum_207(String tmpStr){
		String rtStr = "3510";
		if(tmpStr.startsWith("0349") || tmpStr.startsWith("jst349") || tmpStr.startsWith("sz")){ // 朔州
			rtStr = "3490";
		} else if(tmpStr.startsWith("0350") || tmpStr.startsWith("jst350") || tmpStr.startsWith("xz")){ // 忻州
			rtStr = "3500";
		} else if(tmpStr.startsWith("0351") || tmpStr.startsWith("jst351") || tmpStr.startsWith("ty")){ // 太原
			rtStr = "3510";
		} else if(tmpStr.startsWith("0352") || tmpStr.startsWith("jst352") || tmpStr.startsWith("dt")){ // 大同
			rtStr = "3520";
		} else if(tmpStr.startsWith("0353") || tmpStr.startsWith("jst353") || tmpStr.startsWith("yq")){ // 阳泉
			rtStr = "3530";
		} else if(tmpStr.startsWith("0354") || tmpStr.startsWith("jst354") || tmpStr.startsWith("jz")){ // 晋中
			rtStr = "3540";
		} else if(tmpStr.startsWith("0355") || tmpStr.startsWith("jst355") || tmpStr.startsWith("cz")){ // 长治
			rtStr = "3550";
		} else if(tmpStr.startsWith("0356") || tmpStr.startsWith("jst356") || tmpStr.startsWith("jc")){ // 晋城
			rtStr = "3560";
		} else if(tmpStr.startsWith("0357") || tmpStr.startsWith("jst357") || tmpStr.startsWith("lf")){ // 临汾
			rtStr = "3570";
		} else if(tmpStr.startsWith("0358") || tmpStr.startsWith("jst358") || tmpStr.startsWith("ll")){ // 吕梁
			rtStr = "3580";
		} else if(tmpStr.startsWith("0359") || tmpStr.startsWith("jst359") || tmpStr.startsWith("yc")){ // 运城
			rtStr = "3590";
		}
		return rtStr;
	}

	// 获取城市中文207
	static String getCityName_207(String tmpStr){
		String rtStr = "太原";
		if(tmpStr.startsWith("0349") || tmpStr.startsWith("jst349") || tmpStr.startsWith("sz")){ // 朔州
			rtStr = "朔州";
		} else if(tmpStr.startsWith("0350") || tmpStr.startsWith("jst350") || tmpStr.startsWith("xz")){ // 忻州
			rtStr = "忻州";
		} else if(tmpStr.startsWith("0351") || tmpStr.startsWith("jst351") || tmpStr.startsWith("ty")){ // 太原
			rtStr = "太原";
		} else if(tmpStr.startsWith("0352") || tmpStr.startsWith("jst352") || tmpStr.startsWith("dt")){ // 大同
			rtStr = "大同";
		} else if(tmpStr.startsWith("0353") || tmpStr.startsWith("jst353") || tmpStr.startsWith("yq")){ // 阳泉
			rtStr = "阳泉";
		} else if(tmpStr.startsWith("0354") || tmpStr.startsWith("jst354") || tmpStr.startsWith("jz")){ // 晋中
			rtStr = "晋中";
		} else if(tmpStr.startsWith("0355") || tmpStr.startsWith("jst355") || tmpStr.startsWith("cz")){ // 长治
			rtStr = "长治";
		} else if(tmpStr.startsWith("0356") || tmpStr.startsWith("jst356") || tmpStr.startsWith("jc")){ // 晋城
			rtStr = "晋城";
		} else if(tmpStr.startsWith("0357") || tmpStr.startsWith("jst357") || tmpStr.startsWith("lf")){ // 临汾
			rtStr = "临汾";
		} else if(tmpStr.startsWith("0358") || tmpStr.startsWith("jst358") || tmpStr.startsWith("ll")){ // 吕梁
			rtStr = "吕梁";
		} else if(tmpStr.startsWith("0359") || tmpStr.startsWith("jst359") || tmpStr.startsWith("yc")){ // 运城
			rtStr = "运城";
		}
		return rtStr;
	}

	// 获取城市编号208
	static String getCityNum_208(String tmpStr){
		String rtStr = "4710";
		if(tmpStr.startsWith("0470")){ // 呼伦贝尔
			rtStr = "4700";
		} else if(tmpStr.startsWith("0471")){ // 呼和浩特
			rtStr = "4710";
		} else if(tmpStr.startsWith("0472")){ // 包头
			rtStr = "4720";
		} else if(tmpStr.startsWith("0473")){ // 乌海
			rtStr = "4730";
		} else if(tmpStr.startsWith("0474")){ // 乌兰察布盟
			rtStr = "4740";
		} else if(tmpStr.startsWith("0475")){ // 通辽
			rtStr = "4750";
		} else if(tmpStr.startsWith("0476")){ // 赤峰
			rtStr = "4760";
		} else if(tmpStr.startsWith("0477")){ // 鄂尔多斯
			rtStr = "4770";
		} else if(tmpStr.startsWith("0478")){ // 巴彦淖尔
			rtStr = "4780";
		} else if(tmpStr.startsWith("0479")){ // 锡林郭勒
			rtStr = "4790";
		}
		return rtStr;
	}

	// 获取城市中文208
	static String getCityName_208(String tmpStr){
		String rtStr = "呼和浩特";
		if(tmpStr.startsWith("0470")){ // 呼伦贝尔
			rtStr = "呼伦贝尔";
		} else if(tmpStr.startsWith("0471")){ // 呼和浩特
			rtStr = "呼和浩特";
		} else if(tmpStr.startsWith("0472")){ // 包头
			rtStr = "包头";
		} else if(tmpStr.startsWith("0473")){ // 乌海
			rtStr = "乌海";
		} else if(tmpStr.startsWith("0474")){ // 乌兰察布盟
			rtStr = "乌兰察布盟";
		} else if(tmpStr.startsWith("0475")){ // 通辽
			rtStr = "通辽";
		} else if(tmpStr.startsWith("0476")){ // 赤峰
			rtStr = "赤峰";
		} else if(tmpStr.startsWith("0477")){ // 鄂尔多斯
			rtStr = "鄂尔多斯";
		} else if(tmpStr.startsWith("0478")){ // 巴彦淖尔
			rtStr = "巴彦淖尔";
		} else if(tmpStr.startsWith("0479")){ // 锡林郭勒
			rtStr = "锡林郭勒";
		}
		return rtStr;
	}

	// 获取城市编号211
	static String getCityNum_211(String tmpStr){
		String rtStr = "4510";
		if(tmpStr.startsWith("0451")){ // 哈尔滨
			rtStr = "4510";
		} else if(tmpStr.startsWith("0452")){ // 齐齐哈尔
			rtStr = "4520";
		} else if(tmpStr.startsWith("0453")){ // 牡丹江
			rtStr = "4530";
		} else if(tmpStr.startsWith("0454")){ // 佳木斯
			rtStr = "4540";
		} else if(tmpStr.startsWith("0455")){ // 绥化
			rtStr = "4550";
		} else if(tmpStr.startsWith("0456")){ // 黑河
			rtStr = "4560";
		} else if(tmpStr.startsWith("0457")){ // 大兴安岭
			rtStr = "4570";
		} else if(tmpStr.startsWith("0458")){ // 伊春
			rtStr = "4580";
		} else if(tmpStr.startsWith("0459")){ // 大庆
			rtStr = "4590";
		}
		return rtStr;
	}

	// 获取城市中文211
	static String getCityName_211(String tmpStr){
		String rtStr = "哈尔滨";
		if(tmpStr.startsWith("0451")){ // 哈尔滨
			rtStr = "哈尔滨";
		} else if(tmpStr.startsWith("0452")){ // 齐齐哈尔
			rtStr = "齐齐哈尔";
		} else if(tmpStr.startsWith("0453")){ // 牡丹江
			rtStr = "牡丹江";
		} else if(tmpStr.startsWith("0454")){ // 佳木斯
			rtStr = "佳木斯";
		} else if(tmpStr.startsWith("0455")){ // 绥化
			rtStr = "绥化";
		} else if(tmpStr.startsWith("0456")){ // 黑河
			rtStr = "黑河";
		} else if(tmpStr.startsWith("0457")){ // 大兴安岭
			rtStr = "大兴安岭";
		} else if(tmpStr.startsWith("0458")){ // 伊春
			rtStr = "伊春";
		} else if(tmpStr.startsWith("0459")){ // 大庆
			rtStr = "大庆";
		}
		return rtStr;
	}

	// 获取城市编号214
	static String getCityNum_214(String tmpStr){
		String rtStr = "5910";
		if(tmpStr.startsWith("0591")){ // 福州
			rtStr = "5910";
		} else if(tmpStr.startsWith("0592")){ // 厦门
			rtStr = "5920";
		} else if(tmpStr.startsWith("0593")){ // 宁德
			rtStr = "5930";
		} else if(tmpStr.startsWith("0594")){ // 莆田
			rtStr = "5940";
		} else if(tmpStr.startsWith("0595")){ // 泉州
			rtStr = "5950";
		} else if(tmpStr.startsWith("0596")){ // 漳州
			rtStr = "5960";
		} else if(tmpStr.startsWith("0597")){ // 龙岩
			rtStr = "5970";
		} else if(tmpStr.startsWith("0598")){ // 三明
			rtStr = "5980";
		} else if(tmpStr.startsWith("0599")){ // 南平
			rtStr = "5990";
		}
		return rtStr;
	}

	// 获取城市中文214
	static String getCityName_214(String tmpStr){
		String rtStr = "福州";
		if(tmpStr.startsWith("0591")){ // 福州
			rtStr = "福州";
		} else if(tmpStr.startsWith("0592")){ // 厦门
			rtStr = "厦门";
		} else if(tmpStr.startsWith("0593")){ // 宁德
			rtStr = "宁德";
		} else if(tmpStr.startsWith("0594")){ // 莆田
			rtStr = "莆田";
		} else if(tmpStr.startsWith("0595")){ // 泉州
			rtStr = "泉州";
		} else if(tmpStr.startsWith("0596")){ // 漳州
			rtStr = "漳州";
		} else if(tmpStr.startsWith("0597")){ // 龙岩
			rtStr = "龙岩";
		} else if(tmpStr.startsWith("0598")){ // 三明
			rtStr = "三明";
		} else if(tmpStr.startsWith("0599")){ // 南平
			rtStr = "南平";
		}
		return rtStr;
	}

	// 获取城市编号216
	static String getCityNum_216(String tmpStr){
		String rtStr = "5310";
		if(tmpStr.startsWith("0530")){ // 菏泽
			rtStr = "5300";
		} else if(tmpStr.startsWith("0531")){ // 济南
			rtStr = "5310";
		} else if(tmpStr.startsWith("0532")){ // 青岛
			rtStr = "5320";
		} else if(tmpStr.startsWith("0533")){ // 淄博
			rtStr = "5330";
		} else if(tmpStr.startsWith("0534")){ // 德州
			rtStr = "5340";
		} else if(tmpStr.startsWith("0535")){ // 烟台
			rtStr = "5350";
		} else if(tmpStr.startsWith("0536")){ // 潍坊
			rtStr = "5360";
		} else if(tmpStr.startsWith("0537")){ // 济宁
			rtStr = "5370";
		} else if(tmpStr.startsWith("0538")){ // 泰安
			rtStr = "5380";
		} else if(tmpStr.startsWith("0539")){ // 临沂
			rtStr = "5390";
		} else if(tmpStr.startsWith("0543")){ // 滨州
			rtStr = "5430";
		} else if(tmpStr.startsWith("0546")){ // 东营
			rtStr = "5460";
		} else if(tmpStr.startsWith("0631")){ // 威海
			rtStr = "6310";
		} else if(tmpStr.startsWith("0632")){ // 枣庄
			rtStr = "6320";
		} else if(tmpStr.startsWith("0633")){ // 日照
			rtStr = "6330";
		} else if(tmpStr.startsWith("0634")){ // 莱芜
			rtStr = "6340";
		} else if(tmpStr.startsWith("0635")){ // 聊城
			rtStr = "6350";
		}
		return rtStr;
	}

	// 获取城市中文216
	static String getCityName_216(String tmpStr){
		String rtStr = "济南";
		if(tmpStr.startsWith("0530")){ // 菏泽
			rtStr = "菏泽";
		} else if(tmpStr.startsWith("0531")){ // 济南
			rtStr = "济南";
		} else if(tmpStr.startsWith("0532")){ // 青岛
			rtStr = "青岛";
		} else if(tmpStr.startsWith("0533")){ // 淄博
			rtStr = "淄博";
		} else if(tmpStr.startsWith("0534")){ // 德州
			rtStr = "德州";
		} else if(tmpStr.startsWith("0535")){ // 烟台
			rtStr = "烟台";
		} else if(tmpStr.startsWith("0536")){ // 潍坊
			rtStr = "潍坊";
		} else if(tmpStr.startsWith("0537")){ // 济宁
			rtStr = "济宁";
		} else if(tmpStr.startsWith("0538")){ // 泰安
			rtStr = "泰安";
		} else if(tmpStr.startsWith("0539")){ // 临沂
			rtStr = "临沂";
		} else if(tmpStr.startsWith("0543")){ // 滨州
			rtStr = "滨州";
		} else if(tmpStr.startsWith("0546")){ // 东营
			rtStr = "东营";
		} else if(tmpStr.startsWith("0631")){ // 威海
			rtStr = "威海";
		} else if(tmpStr.startsWith("0632")){ // 枣庄
			rtStr = "枣庄";
		} else if(tmpStr.startsWith("0633")){ // 日照
			rtStr = "日照";
		} else if(tmpStr.startsWith("0634")){ // 莱芜
			rtStr = "莱芜";
		} else if(tmpStr.startsWith("0635")){ // 聊城
			rtStr = "聊城";
		}
		return rtStr;
	}

	// 获取城市编号217
	static String getCityNum_217(String tmpStr){
		String rtStr = "2700";
		if(tmpStr.startsWith("027") || tmpStr.startsWith("710027")){ // 武汉
			rtStr = "2700";
		} else if(tmpStr.startsWith("0710") || tmpStr.startsWith("710710")){ // 襄樊
			rtStr = "7100";
		} else if(tmpStr.startsWith("0711") || tmpStr.startsWith("710711")){ // 鄂州
			rtStr = "7110";
		} else if(tmpStr.startsWith("0712") || tmpStr.startsWith("710712")){ // 孝感
			rtStr = "7120";
		} else if(tmpStr.startsWith("0713") || tmpStr.startsWith("710713")){ // 黄冈
			rtStr = "7130";
		} else if(tmpStr.startsWith("0714") || tmpStr.startsWith("710714")){ // 黄石
			rtStr = "7140";
		} else if(tmpStr.startsWith("0715") || tmpStr.startsWith("710715")){ // 咸宁
			rtStr = "7150";
		} else if(tmpStr.startsWith("0716") || tmpStr.startsWith("710716")){ // 荆州
			rtStr = "7160";
		} else if(tmpStr.startsWith("0717") || tmpStr.startsWith("710717")){ // 宜昌
			rtStr = "7170";
		} else if(tmpStr.startsWith("0718") || tmpStr.startsWith("710718")){ // 恩施
			rtStr = "7180";
		} else if(tmpStr.startsWith("0719") || tmpStr.startsWith("710719")){ // 十堰
			rtStr = "7190";
		} else if(tmpStr.startsWith("0722") || tmpStr.startsWith("710722")){ // 随州
			rtStr = "7220";
		} else if(tmpStr.startsWith("0724") || tmpStr.startsWith("710724")){ // 荆门
			rtStr = "7240";
		} else if(tmpStr.startsWith("0728") || tmpStr.startsWith("710728")){ // 仙桃
			rtStr = "7280";
		}
		return rtStr;
	}

	// 获取城市中文217
	static String getCityName_217(String tmpStr){
		String rtStr = "武汉";
		if(tmpStr.startsWith("027") || tmpStr.startsWith("710027")){ // 武汉
			rtStr = "武汉";
		} else if(tmpStr.startsWith("0710") || tmpStr.startsWith("710710")){ // 襄樊
			rtStr = "襄樊";
		} else if(tmpStr.startsWith("0711") || tmpStr.startsWith("710711")){ // 鄂州
			rtStr = "鄂州";
		} else if(tmpStr.startsWith("0712") || tmpStr.startsWith("710712")){ // 孝感
			rtStr = "孝感";
		} else if(tmpStr.startsWith("0713") || tmpStr.startsWith("710713")){ // 黄冈
			rtStr = "黄冈";
		} else if(tmpStr.startsWith("0714") || tmpStr.startsWith("710714")){ // 黄石
			rtStr = "黄石";
		} else if(tmpStr.startsWith("0715") || tmpStr.startsWith("710715")){ // 咸宁
			rtStr = "咸宁";
		} else if(tmpStr.startsWith("0716") || tmpStr.startsWith("710716")){ // 荆州
			rtStr = "荆州";
		} else if(tmpStr.startsWith("0717") || tmpStr.startsWith("710717")){ // 宜昌
			rtStr = "宜昌";
		} else if(tmpStr.startsWith("0718") || tmpStr.startsWith("710718")){ // 恩施
			rtStr = "恩施";
		} else if(tmpStr.startsWith("0719") || tmpStr.startsWith("710719")){ // 十堰
			rtStr = "十堰";
		} else if(tmpStr.startsWith("0722") || tmpStr.startsWith("710722")){ // 随州
			rtStr = "随州";
		} else if(tmpStr.startsWith("0724") || tmpStr.startsWith("710724")){ // 荆门
			rtStr = "荆门";
		} else if(tmpStr.startsWith("0728") || tmpStr.startsWith("710728")){ // 仙桃
			rtStr = "仙桃";
		}
		return rtStr;
	}
	
	// 获取城市编号223
	static String getCityNum_223(String tmpStr){
		String rtStr = "8510";
		if(tmpStr.startsWith("0851")){ // 贵阳
			rtStr = "8510";
		} else if(tmpStr.startsWith("0852")){ // 遵义
			rtStr = "8520";
		} else if(tmpStr.startsWith("0853")){ // 安顺
			rtStr = "8530";
		} else if(tmpStr.startsWith("0854")){ // 黔南州
			rtStr = "8540";
		} else if(tmpStr.startsWith("0855")){ // 黔东南州
			rtStr = "8550";
		} else if(tmpStr.startsWith("0856")){ // 铜仁
			rtStr = "8560";
		} else if(tmpStr.startsWith("0857")){ // 毕节
			rtStr = "8570";
		} else if(tmpStr.startsWith("0858")){ // 六盘水
			rtStr = "8580";
		} else if(tmpStr.startsWith("0859")){ // 黔西南州
			rtStr = "8590";
		}
		return rtStr;
	}

	// 获取城市中文223
	static String getCityName_223(String tmpStr){
		String rtStr = "贵阳";
		if(tmpStr.startsWith("0851")){ // 贵阳
			rtStr = "贵阳";
		} else if(tmpStr.startsWith("0852")){ // 遵义
			rtStr = "遵义";
		} else if(tmpStr.startsWith("0853")){ // 安顺
			rtStr = "安顺";
		} else if(tmpStr.startsWith("0854")){ // 黔南州
			rtStr = "黔南州";
		} else if(tmpStr.startsWith("0855")){ // 黔东南州
			rtStr = "黔东南州";
		} else if(tmpStr.startsWith("0856")){ // 铜仁
			rtStr = "铜仁";
		} else if(tmpStr.startsWith("0857")){ // 毕节
			rtStr = "毕节";
		} else if(tmpStr.startsWith("0858")){ // 六盘水
			rtStr = "六盘水";
		} else if(tmpStr.startsWith("0859")){ // 黔西南州
			rtStr = "黔西南州";
		}
		return rtStr;
	}

	// 获取使用IP
	static String getRemortIP(HttpServletRequest request){  
		if(request.getHeader("x-forwarded-for") == null){  
			return request.getRemoteAddr();  
		}  
		return request.getHeader("x-forwarded-for");  
	}

	// 包月鉴权正式计费的
	static String authResult(String u, String t, String p){
		String rt = "y";
        BufferedReader reader = null;
		try{
			String spid = "96596";
			String serviceId = "wjyydb,hlgfby020,wjyyby,musicby020";
			if(p.equals("211") || p.equals("217")) serviceId += ",hlgfac030";
			if(!p.equals("201")) u = u + "_" + p;
			String[] serviceIds = serviceId.split(",");
			for(String tmpSer : serviceIds){
				// String authUrl = "http://202.99.114.14:35820/ACS/vas/authorization";
				String authUrl = "http://202.99.114.14:10020/ACS/vas/authorization";
				URL url = new URL(authUrl);
				HttpURLConnection conn = (HttpURLConnection) url.openConnection();
				conn.setRequestMethod("POST");
				conn.setDoOutput(true);
				conn.setDoInput(true);
				conn.setUseCaches(false);
				conn.setRequestProperty("Connection", "Keep-Alive");
				conn.setRequestProperty("Charset", "UTF-8");
				// 设置文件类型
				conn.setRequestProperty("Content-Type","application/json; charset=UTF-8");
				conn.setRequestProperty("accept","application/json");
				// 往服务器里面发送数据
				OutputStream outwritestream = conn.getOutputStream();
				String jsonStr  = "{\"spId\":\"" + spid + "\",\"carrierId\":\"" + p + "\",\"userId\":\"" + u + "\",\"userToken\":\"" + t + "\",\"serviceId\":\"" + tmpSer + "\",\"timeStamp\":\"" + new Date().getTime() + "\"}";
				outwritestream.write(jsonStr.getBytes());
				outwritestream.flush();
				outwritestream.close();
				if(conn.getResponseCode() == 200){
					reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
					String result = reader.readLine();
					// System.out.println("// ========================= ");
					// System.out.println(result);
					result = result.substring(result.indexOf("\"result\":") + "\"result\":".length());
					result = result.substring(0, result.indexOf(","));
					if(result.equals("0")){
						rt = "0";
						break;
					}
				}
				Thread.sleep(500);
			}
		} catch(Exception e){
		}
		return rt;
	}
%>