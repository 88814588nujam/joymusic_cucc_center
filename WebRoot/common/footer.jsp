	<%
	JSData data = new JSData();
	String jsdata = request.getParameter("jsdata");
	if(StringUtils.isNotBlank(jsdata)){
		try {
			if(URLDecoder.decode(jsdata, "UTF-8").indexOf("[{") > -1){
				data.parse(URLDecoder.decode(jsdata, "UTF-8"));
			}
		} catch(Exception e){
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
		} catch(Exception e){
		}
	}
	out.print("\t");
	%></body>
	<script type='text/javascript'>
		start();
	</script>
	<script type='text/javascript' src='javascript/app.js?r=<%=Math.random() %>'></script>
	<script type='text/javascript' src='javascript/ws.js?r=<%=Math.random() %>'></script>
</html>
<%@page language="java" import="com.joymusic.api.*,com.joymusic.common.*,java.net.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>