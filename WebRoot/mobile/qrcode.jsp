<%@page language="java" import="com.joymusic.common.*,java.util.*,org.apache.commons.lang3.StringUtils,java.awt.image.BufferedImage,javax.imageio.ImageIO" pageEncoding="UTF-8"%>
<%
	out.clear();
	out = pageContext.pushBody();
	String userid = request.getParameter("userid");
	String platform = request.getParameter("platform");
	String locpath = request.getContextPath();
	String provinceN = request.getParameter("provinceN");
	locpath = locpath.replace("/", "");
	String grul = request.getRequestURL().toString();
	String prefixPath = "http://192.168.100.101:8082/" + locpath + "/";
	// 局域网终端测试地址
	//if(grul.contains("localhost")) prefixPath = "http://localhost:8082" + request.getContextPath() + "/";
	//else if(grul.contains("127.0.0.1")) prefixPath = "http://127.0.0.1:8082" + request.getContextPath() + "/";
	//else if(grul.contains("localhost")) prefixPath = "http://localhost:8082" + request.getContextPath() + "/";
	if(StringUtils.isNotBlank(userid)){
		String addPicPath = "/home/data/wwwroot/tomcat1/" + locpath + "/images/application/utils/icon/joymusic.ico";
		if(grul.contains("localhost")) addPicPath = "http://localhost:8082" + request.getContextPath() + "/images/application/utils/icon/joymusic.ico";
		// String content = "{\"stbid\":\"" + userid + "\", \"platform\":\"" + platform + "\", \"locpath\":\"" + locpath + "\", \"provinceN\":\"" + provinceN + "\"}";
		String content = "http://weixin.qq.com/r/bi7cxKjE_fWGreyn93t8?s=" + userid + "," + platform + "," + locpath + "," + provinceN;
		BufferedImage bufferedImage = QrCodeUtil.genBarcode(content, addPicPath, 500, 500);
		response.setContentType("image/png");
		ImageIO.write(bufferedImage, "png", response.getOutputStream());
	}
%>