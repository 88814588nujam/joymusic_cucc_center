<%@page language="java" import="java.text.SimpleDateFormat,java.security.*,com.joymusic.api.*,java.util.*,java.net.*,java.io.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%!
	org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger("mydebug");
	
	private int saveUnsubAll(String ip, String uid, String cityN, String result, String description, String sid, String sname, String detail, int platform){
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

	private String getUserOrder(String u) {
		String createtime = "超过半年";
		List<Map<String, Object>> li = null;
		String sql = "SELECT * FROM user_pay_info WHERE uid='" + u + "' ORDER BY id DESC LIMIT 1";
		li = DB.query(sql, false);
		if(li.size() == 0){
			sql = "SELECT * FROM user_pay_info WHERE uid='" + u + "' ORDER BY id DESC LIMIT 1";
			li = DB.query(sql, false);
			if(li.size() > 0) createtime = li.get(0).get("createtime").toString().substring(0, 10);
		} else createtime = li.get(0).get("createtime").toString().substring(0, 10);
		return createtime;
	}

	private int saveUnsub(String uid){
		Integer totalRows = null;
		if (totalRows == null) {
			String sql = "INSERT INTO zone_user_pay_unsub(uid, inline, createtime) VALUE('" + uid + "', 1, NOW())";
			totalRows = DB.update(sql);
		}
		return totalRows;
	}

	// 退订
	private String unsub(String u, String a){
		String rt = "n";
        BufferedReader reader = null;
		try{
			URL url = new URL("http://202.99.114.28:10000/orderProduct");
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
			String serviceId = u;
			String userProvince = getUserProvince(Integer.parseInt(a));
			String productId = "hlgfby010dlrknew@" + a;
			String action = "2";
			String outSource = "1";
			SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmss"); // 设置日期格式
			String time = df.format(new Date());// new Date()为获取当前系统时间
			//sha256(<private key>+<serviceId>+<userProvince>+<type>+<outsource>+<timestamp>)+<timestamp>
			String signature = "huangfei" + serviceId + userProvince + productId + action + outSource + time;
			//System.out.println("//------------" + u + " signature res : " + signature);
			signature = getSHA256StrJava(signature) + time;
			//System.out.println("//------------" + u + " signature pwd : " + signature);
			String jsonStr = "{\"serviceId\":\"" + serviceId + "\",\"userProvince\":\"" + userProvince + "\",\"productId\":\"" + productId + "\",\"action\":\"" + action + "\",\"outSource\":\"" + outSource + "\",\"signature\":\"" + signature + "\"}";
			//System.out.println("//------------" + u + " jsonStr: " + jsonStr);
			outwritestream.write(jsonStr.getBytes());
			outwritestream.flush();
			outwritestream.close();
			if(conn.getResponseCode() == 200){
				reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
				String result = reader.readLine();
				result = result.substring(result.indexOf("\"result\":") + "\"result\":".length());
				result = result.substring(0, result.indexOf(","));
				if(result.equals("0")){
					rt = "y";
				}
				//System.out.println("//------------" + u + " unsub : " + result);
			}
		} catch(Exception e){
			e.printStackTrace();
		}
		return rt;
	}

	// 获取userProvince省份ID
	private String getUserProvince(int id){
		String userProvince = "";
		switch(id){
			case 208:userProvince="10";break;
			case 205:userProvince="11";break;
			case 201:userProvince="13";break;
			case 216:userProvince="17";break;
			case 206:userProvince="18";break;
			case 207:userProvince="19";break;
			case 213:userProvince="30";break;
			case 232:userProvince="31";break;
			case 212:userProvince="34";break;
			case 202:userProvince="36";break;
			case 214:userProvince="38";break;
			case 220:userProvince="50";break;
			case 218:userProvince="51";break;
			case 219:userProvince="59";break;
			case 228:userProvince="70";break;
			case 217:userProvince="71";break;
			case 231:userProvince="74";break;
			case 215:userProvince="75";break;
			case 204:userProvince="76";break;
			case 225:userProvince="79";break;
			case 222:userProvince="81";break;
			case 221:userProvince="83";break;
			case 226:userProvince="84";break;
			case 223:userProvince="85";break;
			case 224:userProvince="86";break;
			case 227:userProvince="87";break;
			case 229:userProvince="88";break;
			case 230:userProvince="89";break;
			case 210:userProvince="90";break;
			case 209:userProvince="91";break;
			case 211:userProvince="97";break;
			default: userProvince="13";break;
		}
		return userProvince;
	}

	private String getSHA256StrJava(String str){
		MessageDigest messageDigest;
		String encodeStr = "";
		try {
			messageDigest = MessageDigest.getInstance("SHA-256");
			messageDigest.update(str.getBytes("UTF-8"));
			encodeStr = byte2Hex(messageDigest.digest());
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return encodeStr;
	}

	private String byte2Hex(byte[] bytes){
		StringBuffer stringBuffer = new StringBuffer();
		String temp = null;
		for(int i = 0; i < bytes.length; i++){
			temp = Integer.toHexString(bytes[i] & 0xFF);
			if(temp.length() == 1){
				//1得到一位的进行补0操作
				stringBuffer.append("0");
			}
			stringBuffer.append(temp);
		}
		return stringBuffer.toString();
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
	// 地区ID
	String areaCode = StringUtils.isBlank(request.getParameter("a")) ? "" : request.getParameter("a");
	// 用户登陆的平台 1:中兴 2:华为
	int platform = Integer.parseInt(StringUtils.isBlank(request.getParameter("f")) ? "1" : request.getParameter("f"));
	// 获取页面名称
	String cname = getCname(Integer.parseInt(pageId), key);
	// 页面全局参数
	String jsdata = request.getParameter("jsdata");

	if(opera == 1){ // 异步退订
		String result = unsub(userid, areaCode);
		if(result.equals("y")){
			// 记录到特殊表里以辨别显示对应按钮
			saveUnsub(userid);
			// 记录到订购相关的全部表里
			saveUnsubAll(userip, userid, cityN, "110", "退订产品成功", "0", "'退订'按钮触发", cname, platform);
		} else saveUnsubAll(userip, userid, cityN, "111", "退订产品失败", "0", "'退订'按钮触发", cname, platform);
		out.print("{\"result\":\"" + result + "\"}");
		return;
	}

	// 用户最近一次订购时间
	String createtime = getUserOrder(userid);
%>
<%if(opera == 0){%>
<!DOCTYPE html>
<html lang='en'>
	<head>
		<meta http-equiv='pragma' content='no-cache'>
		<meta http-equiv='Content-Type' content='text/html;charset=UTF-8' />
		<meta http-equiv='cache-control' content='no-store,no-cache,must-revalidate'>
		<meta http-equiv='expires' content='0'>
		<meta name='page-view-size' content='1280*720'>
		<link rel='shortcut icon' href='<%=request.getContextPath() %>/images/application/utils/icon/joymusic.ico' type='image/x-icon'>
		<title>退订</title>
		<script type='text/javascript' src='javascript/jsdata.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/tools.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/extra.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript' src='javascript/message.js?r=<%=Math.random() %>'></script>
		<script type='text/javascript'>
			var userid = '<%=userid %>'; // 用户ID
			var userip = '<%=userip %>';
			var pageId = <%=pageId %>;
			var cityN = '<%=cityN %>';
			var provinceN = '<%=areaCode %>'; // 用户地区
			var platform = <%=platform %>;
			var nowF = 'ele1';
			var focusIn = 0;
			var isUnsub = false;

			function start(){
				$g(nowF).style.visibility = 'hidden';
				$g('f_' + nowF).style.visibility = 'visible';
			}

			function keyPress(event){
				event = event ? event : window.event;
				if(event.preventDefault) event.preventDefault();
				else event.returnValue = false;
				if(event.stopPropagation) event.stopPropagation();
				else event.cancelBubble = true;
				var keyCode = event.which ? event.which : event.keyCode;

				keyAction(keyCode);
			}
			// 键盘事件
			document.onkeydown = keyPress;

			// 键盘事件
			function keyAction(keyCode){
				if(keyCode == 8 || keyCode == 24 || keyCode == 32){
					if(focusIn == 0) setTimeout('__return()', 500);
					else if(focusIn == 1) hiddenDisDiv();
				} else if(keyCode == 37) move_center('moveL');
				else if(keyCode == 38) move_center('moveU');
				else if(keyCode == 39) move_center('moveR');
				else if(keyCode == 40) move_center('moveD');
				else if(keyCode == 13) move_center('ok');
			}

			// 需要修改的部分
			function move_center(dir){
				if(dir == 'moveL'){
					if(nowF == 'ele2'){
						$g('ele2').style.visibility = 'visible';
						$g('f_ele2').style.visibility = 'hidden';
						$g('ele1').style.visibility = 'hidden';
						$g('f_ele1').style.visibility = 'visible';
						nowF = 'ele1';
					} else if(nowF == 'ele4'){
						$g('ele4').style.visibility = 'visible';
						$g('f_ele4').style.visibility = 'hidden';
						$g('ele3').style.visibility = 'hidden';
						$g('f_ele3').style.visibility = 'visible';
						nowF = 'ele3';
					}
				} else if(dir == 'moveR'){
					if(nowF == 'ele1'){
						$g('ele1').style.visibility = 'visible';
						$g('f_ele1').style.visibility = 'hidden';
						$g('ele2').style.visibility = 'hidden';
						$g('f_ele2').style.visibility = 'visible';
						nowF = 'ele2';
					} else if(nowF == 'ele3'){
						$g('ele3').style.visibility = 'visible';
						$g('f_ele3').style.visibility = 'hidden';
						$g('ele4').style.visibility = 'hidden';
						$g('f_ele4').style.visibility = 'visible';
						nowF = 'ele4';
					}
				} else if(dir == 'ok') doclick();
			}

			function doclick(){
				if(nowF == 'ele1'){
					if(!isUnsub){
						focusIn = 1;
						$g(nowF).style.visibility = 'visible';
						$g('f_' + nowF).style.visibility = 'hidden';
						nowF = 'ele3';
						$g(nowF).style.visibility = 'hidden';
						$g('f_' + nowF).style.visibility = 'visible';
						$g('dispalayDiv').style.display = 'block';
					}
				} else if(nowF == 'ele2') setTimeout('__return()', 500);
				else if(nowF == 'ele3') toUnsub();
				else if(nowF == 'ele4') hiddenDisDiv();
			}

			function hiddenDisDiv(){
				focusIn = 0;
				$g('dispalayDiv').style.display = 'none';
				$g(nowF).style.visibility = 'visible';
				$g('f_' + nowF).style.visibility = 'hidden';
				nowF = 'ele1';
				$g(nowF).style.visibility = 'hidden';
				$g('f_' + nowF).style.visibility = 'visible';
			}

			function toUnsub(){
				var toUrl = 'zone_unsub_201.jsp?o=1&u=' + userid + '&i=' + userip + '&s=0&p=' + pageId + '&k=&c=' + cityN + '&a=' + provinceN + '&f=' + platform;
				ajaxRequest('POST', toUrl, function(){
					if(xmlhttp.readyState == 4){
						if(xmlhttp.status == 200){
							var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
							var jsonStr = eval('(' + retText + ')');
							var result = jsonStr.result;
							if(result == 'y'){
								focusIn = 0;
								$g('ele1').src = 'images/application/unsub/joymusic_cucc_center/5.png';
								$g('f_ele1').src = 'images/application/unsub/joymusic_cucc_center/f_5.png';
								$g('dispalayDiv').style.display = 'none';
								$g(nowF).style.visibility = 'visible';
								$g('f_' + nowF).style.visibility = 'hidden';
								nowF = 'ele1';
								$g(nowF).style.visibility = 'hidden';
								$g('f_' + nowF).style.visibility = 'visible';
								isUnsub = true;
								put('globle','isOrder','y');
								return;
							}
						}
					}
				});
			}
		</script>
	</head>

	<body bgcolor='transparent'>
		<img src='images/application/unsub/joymusic_cucc_center/bj.jpg' style='position:absolute;left:0px;top:0px;width:1280px;height:720px;z-index:-1'>
			<div style='position:absolute;width:250px;height:40px;left:615px;top:280px;color:#FFFFFF;font-size:30px;z-index:1'><%=createtime %></div>
			<div style='position:absolute;width:250px;height:40px;left:615px;top:362px;color:#FFFFFF;font-size:30px;z-index:1'>￥29</div>
			<img id='ele1' src='images/application/utils/common/null.png' style='position:absolute;left:378px;top:545px;width:244px;height:96px;z-index:1;visibility:hidden'>
			<img id='ele2' src='images/application/utils/common/null.png' style='position:absolute;left:660px;top:545px;width:244px;height:96px;z-index:1;visibility:hidden'>
			<img id='f_ele1' src='images/application/unsub/joymusic_cucc_center/f_1.png' style='position:absolute;left:378px;top:545px;width:244px;height:96px;z-index:2;visibility:hidden'>
			<img id='f_ele2' src='images/application/unsub/joymusic_cucc_center/f_2.png' style='position:absolute;left:660px;top:545px;width:244px;height:96px;z-index:2;visibility:hidden'>
			<div id='dispalayDiv' style='display:none'>
				<img src='images/application/unsub/joymusic_cucc_center/back.png' style='position:absolute;left:0px;top:0px;width:1280px;height:720px;z-index:10'>
				<img id='ele3' src='images/application/utils/common/null.png' style='position:absolute;left:450px;top:357px;width:176px;height:75px;z-index:11;visibility:hidden'>
				<img id='ele4' src='images/application/utils/common/null.png' style='position:absolute;left:655x;top:357px;width:176px;height:75px;z-index:11;visibility:hidden'>
				<img id='f_ele3' src='images/application/unsub/joymusic_cucc_center/f_3.png' style='position:absolute;left:450px;top:357px;width:176px;height:75px;z-index:12;visibility:hidden'>
				<img id='f_ele4' src='images/application/unsub/joymusic_cucc_center/f_4.png' style='position:absolute;left:655px;top:357px;width:176px;height:75px;z-index:12;visibility:hidden'>
			</div>
	</body>
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