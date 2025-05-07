<%@page import="com.joymusic.common.*,java.util.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%@include file="adminUser.jsp" %>
<%!
	private static String getCname(int pageId, String key){
		String cname = "";
		if(pageId == 99){ // 自由式专题
			Map<String, Object> gea = InfoData.getEntityAlbum(key);
			cname = "专题_" + gea.get("cname").toString();
		} else if(pageId == 7 || pageId == 8){
			int aid = Integer.parseInt(key);
			Map<String, Object> gabr = InfoData.getEntityArtist(aid);
			cname = (pageId == 7 ? "时尚艺人列表_" : "经典艺人列表_") + gabr.get("cname").toString().replaceAll("'", "\\\\'");
		} else if(pageId == 11 || pageId == 12){
			int defList = Integer.parseInt(key);
			Map<String, Object> gabr = InfoData.getEntityAlbumlist(defList);
			cname = (pageId == 11 ? "时尚专辑列表_" : "经典专辑列表_") + gabr.get("cname").toString().replaceAll("'", "\\\\'");
		} else{
			Map<String, Object> gpd = InfoData.getUiPageDetail(pageId);
			if(!gpd.isEmpty()) cname = gpd.get("cname").toString();
		}
		return cname;
	}
%>
<%
	try{
		// 第一层防止sql注入等问题
		String requestStr = UrlHandle.getRequestString(request);
		boolean sqlFlag = UrlHandle.isRealStr(requestStr);
		if(!sqlFlag){
			response.sendRedirect("adminError.jsp");
			return;
		}
		
		String u = request.getParameter("u"); // 用户ID
		String pn = request.getParameter("pn"); // 用户所属省份编号
		String cn = request.getParameter("cn"); // 用户所属城市编号
		String o = request.getParameter("o"); // 其它可能用到的参数
		String i = request.getParameter("i"); // 用户IP
		String st = request.getParameter("st"); // 用户机顶盒型号
		String sv = request.getParameter("sv"); // 用户机顶盒版本
		String tp = request.getParameter("tp"); // 即将跳转的页面ID
		String tk = request.getParameter("tk"); // 即将跳转页面的关键字
		int p = Integer.parseInt(request.getParameter("p")); // 用户所处的平台
		// rt:鉴权结果 y:鉴权未通过  | 0:鉴权通过
		String rtOrder = "y";
		if(u.contains("browsertest") || u.contains("mobiletest")){
			rtOrder = "0";
		} else{
			rtOrder = authResult(u, "", pn);
		}
		String provinceN = pn;
		String provinceC = getProvinceName(pn);
		String cityC = "天津";
		String cityN = "2200";
		if(pn.equals("204")){
			cityN = getCityNum_204(u);
			cityC = getCityName_204(u);
		} else if(pn.equals("207")){
			cityN = getCityNum_207(u);
			cityC = getCityName_207(u);
		} else if(pn.equals("208")){
			cityN = getCityNum_208(u);
			cityC = getCityName_208(u);
		} else if(pn.equals("211")){
			cityN = getCityNum_211(u);
			cityC = getCityName_211(u);
		} else if(pn.equals("214")){
			cityN = getCityNum_214(u);
			cityC = getCityName_214(u);
		} else if(pn.equals("216")){
			cityN = getCityNum_216(u);
			cityC = getCityName_216(u);
		} else if(pn.equals("217")){
			cityN = getCityNum_217(u);
			cityC = getCityName_217(u);
		} else if(pn.equals("223")){
			cityN = getCityNum_223(u);
			cityC = getCityName_223(u);
		}
		
		Map<String, Object> uif = new HashMap<String, Object>();
		if(StringUtils.isNotBlank(u)) uif = InfoData.getUserInfo(u, p);
		// 首先给用户偏好信息都设置一个默认值
		String preferTheme = "default"; // 用户偏爱主题
		String preferPlayer = "default"; // 用户偏爱阅读器
		int preferList = 0; // 偏好列表
		int preferKeyboard = 0; // 偏好键盘
		int preferBubble = 0; // 偏好气泡
		int preferGuide = 1; // 偏好导读
		int hour = 24;
		int max = 100;
		if(!uif.isEmpty()){ // 老用户
			if(StringUtils.isBlank(i)) i = uif.get("ip").toString();
			preferTheme = uif.get("preferTheme").toString();
			preferPlayer = uif.get("preferPlayer").toString();
			preferList = Integer.parseInt(uif.get("preferList").toString());
			preferKeyboard = Integer.parseInt(uif.get("preferKeyboard").toString());
			preferBubble = Integer.parseInt(uif.get("preferBubble").toString());
			preferGuide = Integer.parseInt(uif.get("preferGuide").toString());
			hour = Integer.parseInt(uif.get("hour").toString());
			max = Integer.parseInt(uif.get("max").toString());
		} else{ // 插入新用户数据
			if(StringUtils.isBlank(i)) i = getRemortIP(request);
			int row = InfoData.addUserInfo(i, u, preferTheme, preferPlayer, preferList, preferKeyboard, preferBubble, preferGuide, hour, max, provinceN, provinceC, cityN, cityC, st, sv, p);
		}
		int animation = 0; // 是否支持动画 0:不支持 1:支持
		int remote = 0; // 是否支持手机遥控 0:不支持 1:支持
		// 获取全局STB配置信息,但可能这些信息不是应用中会使用的(具体配置参数含义请参照config_stb表)
		if(!u.contains("browsertest") && !u.contains("mobiletest")){ // 测试的全部支持
			Map<String, Object> gsc = InfoData.getStbConfig(st);
			if(!gsc.isEmpty()){
				animation = Integer.parseInt(gsc.get("animation").toString());
				remote = Integer.parseInt(gsc.get("remote").toString());
			}
		} else{
			animation = 1;
			remote = 1;
		}
		// 获取页面名称
		int toPageId = Integer.parseInt(tp);
		if(toPageId == 7 || toPageId == 8){
			if(preferList == 0) toPageId = 7;
			else if(preferList == 1) toPageId = 8;
		} else if(toPageId == 11 || toPageId == 12){
			if(preferList == 0) toPageId = 11;
			else if(preferList == 1) toPageId = 12;
		}
		String cname = getCname(toPageId, tk);
		// 记录入口访问信息
		InfoData.addUserFlow(i, u, cityN, toPageId, tk, cname, "");
		// 返回用户个人信息
		out.print("{\"isOrder\":\"" + rtOrder + "\", \"userip\":\"" + i + "\", \"provinceN\":\"" + provinceN + "\", \"provinceC\":\"" + provinceC + "\", \"cityN\":\"" + cityN + "\", \"cityC\":\"" + cityC + "\", \"preferTheme\":\"" + preferTheme + "\", \"preferPlayer\":\"" + preferPlayer + "\", \"preferList\":\"" + preferList + "\", \"preferKeyboard\":\"" + preferKeyboard + "\", \"preferBubble\":\"" + preferBubble + "\", \"preferGuide\":\"" + preferGuide + "\", \"hour\":\"" + hour + "\", \"max\":\"" + max + "\", \"animation\":\"" + animation + "\", \"remote\":\"" + remote + "\"}");
		return;
	} catch(Exception e){
	}
%>