<%@page language="java" import="com.joymusic.api.*,java.util.*,org.apache.commons.lang3.StringUtils,java.net.URLDecoder,java.net.URLEncoder" pageEncoding="UTF-8"%>
<%!
	org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger("mydebug");
	
	private int saveOrderInfo(String ip, String uid, String cityN, String purchase, String sid, String sname, String detail, int platform){
		Integer totalRows = null;
		if(totalRows == null){
			String sql = "INSERT INTO user_pay_info(ip, uid, cityN, fee, purchase, id_content, content, detail, platform, createtime) VALUE(\"" + ip + "\", \"" + uid + "\", \"" + cityN + "\", 1900, \"" + purchase + "\", \"" + sid + "\", \"" + sname + "\", \"" + detail + "\", " + platform + ", NOW())";
			totalRows = DB.update(sql);
		}
		return totalRows;
	}
	
	private int saveOrderAll(String ip, String uid, String cityN, String result, String description, String sid, String sname, String detail, int platform){
		Integer totalRows = null;
		if(totalRows == null){
			String sql = "INSERT INTO user_pay_all(ip, uid, cityN, result, cdes, id_content, content, detail, platform, createtime) VALUE(\"" + ip + "\", \"" + uid + "\", \"" + cityN + "\", \"" + result + "\", \"" + description + "\", \"" + sid + "\", \"" + sname + "\",\"" + detail + "\", " + platform + ", NOW())";
			totalRows = DB.update(sql);
		}
		return totalRows;
	}
	
	private static String getCname(int pageId, String key){
		String cname = "";
		if(pageId == -1){
			cname = "终端大厅";
		} else if(pageId == 99){ // 自由式专题
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
	int opera = Integer.parseInt(StringUtils.isBlank(request.getParameter("o")) ? "0" : request.getParameter("o").toString()); // 操作类型
	// 用户ID
	String userid = StringUtils.isBlank(request.getParameter("u")) ? "" : request.getParameter("u");
	// 获取盒子ip
	String userip = StringUtils.isBlank(request.getParameter("i")) ? "" : request.getParameter("i");
	// 曲目id
	String songId = StringUtils.isBlank(request.getParameter("s")) ? "" : request.getParameter("s");
	// 当前页面ID
	String pageId = StringUtils.isBlank(request.getParameter("p")) ? "-1" : request.getParameter("p");
	// 页面关键字
	String key = StringUtils.isBlank(request.getParameter("k")) ? "" : request.getParameter("k");
	// 使用设备城市编号
	String cityN = StringUtils.isBlank(request.getParameter("c")) ? "" : request.getParameter("c");
	// 用户登陆的平台 1:中兴 2:华为
	int platform = Integer.parseInt(StringUtils.isBlank(request.getParameter("f")) ? "1" : request.getParameter("f"));
	// 获取页面名称
	String cname = getCname(Integer.parseInt(pageId), key);
	String curl = request.getScheme() + "://" + request.getServerName() + ":8888" + request.getContextPath() + request.getServletPath();
	String jsdata = "";
	String success = "";

	if(opera == 0){
		// 在跳转前,要将用户的所有信息参数用session临时保存起来
		jsdata = request.getParameter("jsdata");
		if(StringUtils.isNotBlank(jsdata)) session.setAttribute("pay_" + userid, jsdata);
		List<Map<String, Object>> li = InfoData.getSongByIds(songId);
		String disN = "";
		if(li.size() > 0) disN = li.get(0).get("cname") == null ? "N/A" : li.get(0).get("cname").toString() + " - " + li.get(0).get("artist").toString();
		saveOrderAll(userip, userid, cityN, "-1", "发起订购", songId, disN, cname, platform);
		String payUrl = request.getParameter("payUrl");
		payUrl = URLDecoder.decode(payUrl, "UTF-8");
		String payGoUrl = "";
		String backUrl = curl + "?o=1&u=" + userid + "&i=" + userip + "&s=" + songId + "&p=" + pageId + "&k=" + key + "&c=" + cityN + "&f=" + platform;
		backUrl = URLEncoder.encode(backUrl, "GBK");
		if(payUrl.contains("?")){
			payGoUrl = payUrl + "&backUrl=" + backUrl;
		} else{
			payGoUrl = payUrl + "?backUrl=" + backUrl;
		}
		response.sendRedirect(payGoUrl);
		return;
	} else if(opera == 1){ // 订购成功通知
		success = request.getParameter("success"); // 订购成功与否标志
		List<Map<String, Object>> li = InfoData.getSongByIds(songId);
		String disN = "";
		if(li.size() > 0) disN = li.get(0).get("cname") == null ? "N/A" : li.get(0).get("cname").toString() + " - " + li.get(0).get("artist").toString();
		if("1".equals(success)){
			String productId = request.getParameter("productId"); // 购买产品包
			saveOrderInfo(userip, userid, cityN, productId, songId, disN, cname, platform);
			saveOrderAll(userip, userid, cityN, "0", "订购成功", songId, disN, cname, platform);
		} else saveOrderAll(userip, userid, cityN, "-100", "订购失败或者返回", songId, disN, cname, platform);
		// 回调回来后要记得接收用户的所有信息参数,并且清空该session
		Enumeration<String> enumNames = session.getAttributeNames();
		while(enumNames.hasMoreElements()){
			String name = enumNames.nextElement();
			if(name.equals("pay_" + userid)){
				jsdata = session.getAttribute("pay_" + userid).toString();
				session.removeAttribute("pay_" + userid);
			}
		}
	}
%>
<%if(opera == 1){%> 
<!DOCTYPE html>
<html lang='en'>
	<head>
		<meta http-equiv='pragma' content='no-cache'>
		<meta http-equiv='Content-Type' content='text/html;charset=UTF-8' />
		<meta http-equiv='cache-control' content='no-store,no-cache,must-revalidate'>
		<meta http-equiv='expires' content='0'>
		<meta name='page-view-size' content='1280*720'>
		<link rel='shortcut icon' href='<%=request.getContextPath() %>/images/application/utils/icon/joymusic.ico' type='image/x-icon'>
		<title>订购返回</title>
		<script type='text/javascript' src='javascript/jsdata.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/tools.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/extra.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/message.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript'>
			function start(){<%if("1".equals(success)){%>
				put('globle', 'isOrder', '0'); // 用户是否订购 y:否 0:是
				var toPageId = 100;
				put('request', 'params', 'i=' + toPageId);
				go(toPageId);
			<%} else{%>
				put('globle', 'nowRealPlay', '0');
				__return();
			<%}%>}
		</script>
</head>

<body bgcolor="transparent"></body>
<%
	JSData data = new JSData();
	if(StringUtils.isNotBlank(jsdata)){
		try {
			if(URLDecoder.decode(jsdata, "UTF-8").indexOf("[{") > -1){
				data.parse(URLDecoder.decode(jsdata, "UTF-8"));
			}
		} catch(Exception ex){
		}
	}
	if(data.getSize() > 0){
		try{
			out.println("\n\t\t<script type='text/javascript'>");
			String[] array = data.toStringArray();
			for(String str : array){
				str = str.replaceAll("\"", "\\\\'");
				if(str.indexOf("request") < 0) out.println("\t\t\t" + str);
			}
			out.println("\t\t</script>");
		} catch(Exception ex){
		}
	}
	out.print("\t\t");
}%>
	<script type='text/javascript'>
		start();
	</script>
</html>