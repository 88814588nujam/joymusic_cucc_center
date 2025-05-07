<%@page language="java" import="com.joymusic.api.*" pageEncoding="GBK"%>
<%
	try{
		Cache.OpenCache(application);
		// 清除首页模板缓存
		//String belong = "index";
		//String sql1 = "SELECT * FROM page_structure WHERE belong=$belong";
		//sql1 = DB.sqlWrapperByParams(sql1, new Object[] { belong });
		//Cache.clear("default_sql", sql1);
		
		// 清除首页版块子元素缓存
		//String pid = "10000";
		//String sql2 = "SELECT * FROM ui_pub WHERE pid=$pid";
		//sql2 = DB.sqlWrapperByParams(sql2, new Object[] { pid });
		//Cache.clear("default_sql", sql2);
		
		Cache.clearAll();
	} catch(Exception e){
		out.print(e.toString());
		e.printStackTrace();
	}
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>清理缓存</title>
	<meta http-equiv="Content-Type" content="text/html; charset=gb2312">
	<meta name="page-view-size" content="1280*720">
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-store,no-cache,must-revalidate">
	<meta http-equiv="expires" content="0">
	<link rel='shortcut icon' href='<%=request.getContextPath() %>/images/application/utils/icon/joymusic.ico' type='image/x-icon'>
	<style type="text/css">
		* {margin:0px;padding:0px;}
		body {width:1280px;height:720px;margin-top:0px;margin-left:0px}
	</style>
	<script type="text/javascript">
		// 按键事件
		window.document.onkeypress = document.onirkeypress = function(event) {
			event = event ? event : window.event;
			var keyCode = event.which ? event.which : event.keyCode;
	
			if(keyCode == 8 || keyCode == 24 || keyCode == 32){
				__return();
				return false;
			}
		};
	</script>
</head>
<body bgcolor="transparent">
	<div style="position:absolute;left:0px;top:0px;width:1280px;height:720px;background-color:black"></div>
	<div style="position:absolute;left:490px;top:385px;width:300px;height:50px;font-size:26px;text-align:center;color:white;z-index:1">缓存已经被成功清理完毕请按'返回'键退出</div>
</body>
</html>