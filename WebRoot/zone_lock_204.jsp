<%@page import="com.joymusic.api.*,java.util.*,java.net.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%
	String queryString = request.getQueryString();
	int opera = Integer.parseInt(StringUtils.isBlank(request.getParameter("o")) ? "0" : request.getParameter("o").toString()); // 操作类型
	// 用户ID
	String userid = StringUtils.isBlank(request.getParameter("u")) ? "" : request.getParameter("u");
	// 童锁状态
	String lock = StringUtils.isBlank(request.getParameter("l")) ? "" : request.getParameter("l");
	String curl = request.getScheme() + "://" + request.getServerName() + ":8882" + request.getContextPath() + request.getServletPath();
	String jsdata = "";
	
	if(opera == 0){ // 第一次还没开始童锁,准备童锁地址
		// 在跳转前,要将用户的所有信息参数用session临时保存起来
		jsdata = request.getParameter("jsdata");
		if(StringUtils.isNotBlank(jsdata)) session.setAttribute("lock_" + userid, jsdata);
		String returnURL = "http://202.99.114.152:26800/joymusic_cucc_center/zone_lock_204.jsp?o=1&u=" + userid + "&l=" + lock;
		returnURL = URLEncoder.encode(returnURL, "GBK");
		String VchipUrl = "http://202.99.114.14:15081/payLock/lockOpen.html?userID=" + userid + "&productid=hlgfby020@204&originID=tvcenter&returnUrl=" + returnURL;
		if(lock.equals("1")) VchipUrl = "http://202.99.114.14:15081/payLock/lockClose.html?userID=" + userid + "&productid=hlgfby020@204&originID=tvcenter&returnUrl=" + returnURL;
		response.sendRedirect(returnURL); // 需要一次确认界面的时候去掉即可
		return;
	} else if(opera == 1){ // 童锁页面的返回
		String result = request.getParameter("result");

		// 回调回来后要记得接收用户的所有信息参数,并且清空该session
		Enumeration<String> enumNames = session.getAttributeNames();
		while(enumNames.hasMoreElements()){
			String name = enumNames.nextElement();
			if(name.equals("lock_" + userid)){
				jsdata = session.getAttribute("lock_" + userid).toString();
				session.removeAttribute("lock_" + userid);
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
		<title>童锁返回</title>
		<script type='text/javascript' src='javascript/jsdata.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/tools.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/extra.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/message.js?r=<%=Math.random() %>'></script>
		<script type="text/javascript">
			function start(){
				__return();
			}
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