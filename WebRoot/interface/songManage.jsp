<%@page language="java" import="java.util.Date,java.text.SimpleDateFormat,org.apache.poi.ss.util.CellRangeAddress,org.apache.poi.ss.usermodel.*,org.apache.poi.hssf.usermodel.*,com.joymusic.api.*,com.joymusic.common.*,java.net.*,java.util.*,java.io.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF8"%>
<%!private List<Map<String, Object>> getSongInfo(Page page) {
		List<Map<String, Object>> li = null;
		if (li == null) {
			try {
				String sql = "SELECT * FROM entity_song ORDER BY id limit " + page.getStartRow() + "," + page.getPageSize();
				li = DB.query(sql, false);
			} catch (Exception e){
			}
		}
		return li;
	}
	
	private Integer getSongInfoCount() {
		int num = 0;
		if (num == 0) {
			try {
				String sql = "SELECT COUNT(0) FROM entity_song ORDER BY id";
				num = DB.queryCount(sql, false);
			} catch (Exception e){
			}
		}
		return num;
	}
	
	private List<Map<String, Object>> getSongConInfo(String[] cons, Page page) {
		List<Map<String, Object>> li = null;
		if (li == null) {
			try {
				String sql = "SELECT * FROM (";
				for(int i = 0; i < cons.length; i++){
					if(i == cons.length - 1) sql += "(SELECT * FROM entity_song WHERE CONCAT(IFNULL(id, ''), ',', IFNULL(cname,''), ',', IFNULL(abbr,''), ',', IFNULL(artist,'')) LIKE '%" + cons[i] + "%')";
					else sql += "(SELECT * FROM entity_song WHERE CONCAT(IFNULL(id, ''), ',', IFNULL(cname,''), ',', IFNULL(abbr,''), ',', IFNULL(artist,'')) LIKE '%" + cons[i] + "%') UNION";
				}
				sql += ") A ORDER BY A.id limit " + page.getStartRow() + "," + page.getPageSize();
				li = DB.query(sql, false);
			} catch (Exception e){
			}
		}
		return li;
	}
	
	private Integer getSongConInfoCount(String[] cons) {
		int num = 0;
		if (num == 0) {
			try {
				String sql = "SELECT COUNT(0) FROM (";
				for(int i = 0; i < cons.length; i++){
					if(i == cons.length - 1) sql += "(SELECT * FROM entity_song WHERE CONCAT(IFNULL(id, ''), ',', IFNULL(cname,''), ',', IFNULL(abbr,''), ',', IFNULL(artist,'')) LIKE '%" + cons[i] + "%')";
					else sql += "(SELECT * FROM entity_song WHERE CONCAT(IFNULL(id, ''), ',', IFNULL(cname,''), ',', IFNULL(abbr,''), ',', IFNULL(artist,'')) LIKE '%" + cons[i] + "%') UNION";
				}
				sql += ") A;";
				num = DB.queryCount(sql, false);
			} catch (Exception e){
			}
		}
		return num;
	}
	
	private Integer modCline(int entryId, int csort){
		int result = -1;
		String sql = "";
		try {
			sql = "UPDATE entity_song SET csort=" + csort + " WHERE id='" + entryId + "'";
			int row = DB.update(sql);
			if(row > 0){
				result = csort;
			}
		} catch(Exception e){
		}
		return result;
	}
	
	// 判断哪张图片是存在的
	private String getRealPic(String pf, String cname) {
		String rt = "";
		try{
			String[] strs = {"xg.jpg", "xg.png", "xg.gif", "bj.jpg", "bj.png", "bj.gif"};
			for(int i = 0; i < strs.length; i++){
				String pft = pf;
				URL urlStr = new URL(pft + "images/HD/activities/" + cname + "/" + strs[i]);
				HttpURLConnection conn = (HttpURLConnection) urlStr.openConnection();
				int state = conn.getResponseCode();
				if(state == 200){
					rt = strs[i];
					break;
				}
			}
		} catch(Exception e){
		}
		return StringUtils.isBlank(rt) ? "images/HD/photos/boot/joymusic.png" : "images/HD/activities/" +cname + "/" + rt;
	}
	
	private List<Map<String, Object>> getSongOnlineInfo() {
		List<Map<String, Object>> li = null;
		if (li == null) {
			try {
				String sql = "SELECT * FROM entity_song WHERE csort<>0 ORDER BY id";
				li = DB.query(sql, false);
			} catch (Exception e){
			}
		}
		return li;
	}
	
	private List<Map<String, Object>> getSongOfflineInfo() {
		List<Map<String, Object>> li = null;
		if (li == null) {
			try {
				String sql = "SELECT * FROM entity_song WHERE csort=0 ORDER BY id";
				li = DB.query(sql, false);
			} catch (Exception e){
			}
		}
		return li;
	}
	
	// 所有活动信息
	private List<Map<String, Object>> getActInfo() {
		List<Map<String, Object>> li = null;
		if (li == null) {
			try {
				String sql = "SELECT * FROM entity_activity";
				li = DB.query(sql, false);
			} catch (Exception e){
			}
		}
		return li;
	}

	private void createExcel(List<Map<String, Object>> sheetlist, String area, HttpServletResponse response){
		try{
			HSSFWorkbook wb = new HSSFWorkbook();
			for(int a = 0; a < sheetlist.size(); a++){
				Map<String, Object> sheetMap = sheetlist.get(a);
				String cname = sheetMap.get("cname").toString();
				String[] topNames = (String[]) sheetMap.get("topNames");
				String[] mapNames = (String[]) sheetMap.get("mapNames");
				int[] widths = (int[]) sheetMap.get("widths");
				@SuppressWarnings("unchecked") List<Map<String, Object>> resultlist = (List<Map<String, Object>>) sheetMap.get("resultlist");
				HSSFSheet sheet = wb.createSheet(cname);
				// 生成菜单字体对象
				HSSFFont fontTop = wb.createFont();
				fontTop.setFontHeightInPoints((short) 14);
				fontTop.setBold(true);
				fontTop.setFontName("新宋体");
				HSSFCellStyle styleTop = wb.createCellStyle();
				styleTop.setFillForegroundColor(IndexedColors.YELLOW.getIndex());
				styleTop.setFillPattern(FillPatternType.SOLID_FOREGROUND);
				styleTop.setFont(fontTop);
				styleTop.setWrapText(true);
				// 设置居中样式
				styleTop.setAlignment(HorizontalAlignment.CENTER);
				styleTop.setVerticalAlignment(VerticalAlignment.CENTER);
				// 设置底边框
				styleTop.setBorderLeft(BorderStyle.THIN);
				styleTop.setBorderTop(BorderStyle.THIN);
				styleTop.setBorderRight(BorderStyle.THIN);
				styleTop.setBorderBottom(BorderStyle.THIN);
				// 生成单元格字体对象
				HSSFFont font = wb.createFont();
				font.setFontHeightInPoints((short) 11);
				font.setFontName("新宋体");
				HSSFCellStyle style = wb.createCellStyle();
				style.setFont(font); // 调用字体样式对象  
				style.setWrapText(true);
				// 设置居中样式
				style.setAlignment(HorizontalAlignment.CENTER);
				style.setVerticalAlignment(VerticalAlignment.CENTER);
				// 设置底边框
				style.setBorderLeft(BorderStyle.THIN);
				style.setBorderTop(BorderStyle.THIN);
				style.setBorderRight(BorderStyle.THIN);
				style.setBorderBottom(BorderStyle.THIN);
				// 合并单元格CellRangeAddress构造参数依次表示起始行，截至行，起始列， 截至列
				// sheet.addMergedRegion(new CellRangeAddress(0,0,0,9));
				HSSFRow rowTop = sheet.createRow(0);
				for(int i = 0; i < topNames.length; i++){
					HSSFCell cell = rowTop.createCell(i);
					cell.setCellStyle(styleTop);
					cell.setCellValue(topNames[i]);
				}
		        for(int i = 0; i < resultlist.size(); i++){
					HSSFRow rowx = sheet.createRow(i + 1);
					for(int j = 0; j < topNames.length; j++){
						HSSFCell cell = rowx.createCell(j);
						cell.setCellStyle(style);
						Map<String,Object> map = resultlist.get(i);
						String val = map.get(mapNames[j]) == null ? "暂缺" : map.get(mapNames[j]).toString();
						cell.setCellValue(val);
					}
				}
		        if(widths.length > 0){
		        	for(int k = 0; k < widths.length; k++){
						sheet.setColumnWidth(k, widths[k] * 256);
					}
		        } else{
					// 设置为根据内容自动调整列宽
					for(int k = 0; k < resultlist.size(); k++){
						sheet.autoSizeColumn(k);
					}
				}
            }
			// 输出Excel文件
			OutputStream output = response.getOutputStream();
			response.reset();
			SimpleDateFormat format = new SimpleDateFormat("yyyyMMdd");
			String now = format.format(new Date());
			response.setHeader("Content-disposition", "attachment; filename=\"" + new String((area + "最新曲库").getBytes("gbk"), "iso8859-1") + now + ".xls");
			response.setContentType("application/msexcel");
			wb.write(output);
			output.close();
        } catch(Exception e){
		}
    }
    
    private String getRedStr(String str, String[] cons){
    	String redStr = "";
    	for(String con : cons){
    		if(str.toUpperCase().contains(con.toUpperCase())){
    			redStr = con;
    		}
    	}
    	return redStr;
    }
    
    private String getRealStr(String resStr, String redStr){
    	String resStrTmp = resStr.toUpperCase();
    	String redStrTmp = redStr.toUpperCase();
    	String newStr = "";
    	String newStrQz = resStr.substring(0, resStrTmp.indexOf(redStrTmp));
    	String newStrZz = "<font color='red'>" + resStr.substring(resStrTmp.indexOf(redStrTmp), resStrTmp.indexOf(redStrTmp) + redStrTmp.length()) + "</font>";
    	String newStrHz = resStr.substring(resStrTmp.indexOf(redStrTmp) + redStrTmp.length(), resStrTmp.length());
    	newStr = newStrQz + newStrZz + newStrHz;
    	return newStr;
    }%>
<%
	String areaName = "联通中心";
	// 返回图片用的处理
	String opera = StringUtils.isBlank(request.getParameter("o")) ? "" : request.getParameter("o");
	String docPos = "/home/data/wwwroot/default/tomcat3/joymusic_bs_tjlt/";
	String uri = "http://202.99.114.152:26800/joymusic_bs_tjlt/";
	if(opera.equals("export")){
		String[] topNames = {"曲目ID", "曲目名", "缩写", "艺人名", "艺人头像", "曲目分类", "语种", "时长", "清晰度", "来源", "支付"};
		String[] mapNames = {"id", "cname", "abbr", "artist", "pic", "classification", "clanguage", "duration", "definition", "company", "cfree"};
		int[] widths = {15, 40, 20, 25, 20, 25, 15, 10, 10, 10, 10};
		Map<String, Object> map1 = new HashMap<String, Object>();
		List<Map<String, Object>> resultlist1 = getSongOnlineInfo();
		map1.put("cname", "在线曲目");
		map1.put("topNames", topNames);
		map1.put("mapNames", mapNames);
		map1.put("widths", widths);
		map1.put("resultlist", resultlist1);
		Map<String, Object> map2 = new HashMap<String, Object>();
		List<Map<String, Object>> resultlist2 = getSongOfflineInfo();
		map2.put("cname", "离线曲目(敏感|内容错误)");
		map2.put("topNames", topNames);
		map2.put("mapNames", mapNames);
		map2.put("widths", widths);
		map2.put("resultlist", resultlist2);
		List<Map<String, Object>> sheetlist = new ArrayList<Map<String, Object>>();
		sheetlist.add(map1);
		sheetlist.add(map2);
		createExcel(sheetlist, areaName, response);
		return;
	} else if(opera.equals("display")){
		int songId = Integer.parseInt(StringUtils.isBlank(request.getParameter("i")) ? "10000" : request.getParameter("i"));
		List<Map<String, Object>> li = getActInfo();
		List<Map<String, Object>> liRe = new ArrayList<Map<String, Object>>();
		for(int i = 0; i < li.size(); i++){
			Map<String, Object> map = li.get(i);
			String jspName = map.get("curl").toString();
			File file = new File(docPos + jspName);
			if(file.exists()){
				BufferedReader reader = new BufferedReader(new FileReader(file));
				String line;
				while((line = reader.readLine()) != null){
					if(line.contains("int[] ids") && line.contains("" + songId)){
						Map<String, Object> mapRe = new HashMap<String, Object>();
						mapRe.put("cname", map.get("cname").toString());
						String ptype = getRealPic("http://localhost:8083/joymusic_bs_tjlt/", jspName.replace(".jsp", ""));
						mapRe.put("pic", ptype);
						liRe.add(mapRe);
						break;
					}
					if(line.contains("<!DOCTYPE html>")) break;
	            }
	            reader.close();
			}
		}
		String json = "";
		if(liRe.size() > 0){
			for(int i = 0;i < liRe.size();i++){
				json += "{\"cname\":\"" + liRe.get(i).get("cname") + "\",\"pic\":\"" + liRe.get(i).get("pic") + "\"}";
				if(i < liRe.size() - 1){
					json += ",";
				}
			}
		}
		json = "[" + json + "]";
		out.println(json);
		return;
	} else if(opera.equals("doline")){
		int songId = Integer.parseInt(StringUtils.isBlank(request.getParameter("i")) ? "" : request.getParameter("i"));
		int csort = Integer.parseInt(StringUtils.isBlank(request.getParameter("c")) ? "0" : request.getParameter("c"));
		int result = modCline(songId, csort);
		out.println("{\"result\":" + result + "}");
		return;
	}
	
	int pageSize = Integer.parseInt(StringUtils.isBlank(request.getParameter("ps")) ? "15" : request.getParameter("ps"));
	int pageIndex = Integer.parseInt(StringUtils.isBlank(request.getParameter("pi")) ? "1" : request.getParameter("pi"));
	String contStrs = StringUtils.isBlank(request.getParameter("ct")) ? "" : request.getParameter("ct");
	int totalRows = 0;
	Page pages = null;
	List<Map<String, Object>> liaif = new ArrayList<Map<String, Object>>();
	String[] contStrsArr = null;
	if(StringUtils.isBlank(contStrs)){
		totalRows = getSongInfoCount();
		pages = new Page(totalRows, pageSize);
		pages.setPageIndex(pageIndex);
		liaif = getSongInfo(pages);
	} else{
		contStrs = new String(contStrs.getBytes("iso8859-1"), "utf-8");
		contStrsArr = contStrs.split("\\|");
		totalRows = getSongConInfoCount(contStrsArr);
		pages = new Page(totalRows, pageSize);
		pages.setPageIndex(pageIndex);
		liaif = getSongConInfo(contStrsArr, pages);
	}
	int tdNum = 15;
%>
<!DOCTYPE html>
<html>
<head>
	<title><%=areaName %>曲目管理</title>
	<link rel='shortcut icon' href='<%=request.getContextPath() %>/images/application/utils/icon/joymusic.ico' type='image/x-icon'>
	<style type="text/css">
		.tdFont{font-family:Arial;font-size:18px;font-style:normal;font-weight:normal;letter-spacing:-1px;line-height:1.7em;border-collapse:collapse;text-align:center}
		table.contCore{font-family:Arial;font-size:18px;font-style:normal;font-weight:normal;letter-spacing:-1px;line-height:1.7em;text-align:center;border-collapse:collapse;}
		.contCore thead th{padding:6px 10px;text-transform:uppercase;color:#444;font-weight:bold;text-shadow:1px 1px 1px #fff;border-bottom:5px solid #444;background-color:#7FD2FF;} 
		.contCore tfoot th{padding:6px 10px;text-transform:uppercase;color:#444;font-weight:bold;text-shadow:1px 1px 1px #fff;border-top:5px solid #444;background-color:#7FD2FF;}
		.contCore thead th:empty{background:transparent;border:none;} 
		.contCore tfoot th:empty{background:transparent;border:none;}
		.contCore thead :nth-child(1){-moz-border-radius:8px 0px 0px 0px;-webkit-border-top-left-radius:8px;border-top-left-radius:8px;}
		.contCore thead :nth-child(<%=tdNum%>){-moz-border-radius:0px 8px 0px 0px;-webkit-border-top-right-radius:8px;border-top-right-radius:8px;}
		.contCore tfoot :nth-child(1){-moz-border-radius:0px 0px 8px 8px;-webkit-border-bottom-left-radius:8px;border-bottom-left-radius:8px;-webkit-border-bottom-right-radius:8px;border-bottom-right-radius:8px;}
		.contCore tbody td{padding:10px;}
		.contCore tbody td:nth-child(even){background-color:#444;color:#444;border-bottom:1px solid #444;background:-webkit-gradient(linear,left bottom,left top,color-stop(0.39, rgb(189,189,189)),color-stop(0.7, rgb(224,224,224)));background:-moz-linear-gradient(center bottom,rgb(189,189,189) 39%,rgb(224,224,224) 70%);text-shadow:1px 1px 1px #fff;}
		.contCore tbody td:nth-child(odd){background-color:#555;color:#f0f0f0;border-bottom:1px solid #444;background:-webkit-gradient(linear,left bottom,left top,color-stop(0.39, rgb(85,85,85)),color-stop(0.7, rgb(105,105,105)));background:-moz-linear-gradient(center bottom,rgb(85,85,85) 39%,rgb(105,105,105) 70%);text-shadow:1px 1px 1px #000;}
		.contCore tbody td:nth-last-child(1){border-right:1px solid #222;}
		.button, .button:visited{display:inline-block;padding:5px 10px 6px;color:#fff;text-decoration:none;-moz-border-radius:6px;-webkit-border-radius:6px;-moz-box-shadow:0 1px 3px rgba(0,0,0,0.6);-webkit-box-shadow:0 1px 3px rgba(0,0,0,0.6);text-shadow:0 -1px 1px rgba(0,0,0,0.25);border-bottom:1px solid rgba(0,0,0,0.25);position:relative;cursor:pointer}
		.button:hover{background-color:#111;color:#fff;}
		.button:active{top:1px;}
		.tab.button, .tab.button:visited{font-size:16px;font-weight:bold;line-height:1;text-shadow:0 -1px 1px rgba(0,0,0,0.25);}
		.blue.button, .magenta.button:visited{background-color:#2981e4;}
		.blue.button:hover{background-color:#2575cf;}
		.pink.button, .magenta.button:visited{background-color:#e22092;}
		.pink.button:hover{background-color:#c81e82;}
		.green.button, .magenta.button:visited{background-color:#94CE46;}
		.green.button:hover{background-color:#AFDA6F;}
    </style>
    <script type="text/javascript">
    	// 返回该命名标签元素
		function $(id){
			return document.getElementById(id);
		}

		function $$(id){
			return document.getElementsByName(id);
		}

    	function start(){
    	}
    	
    	var nowIdx = 0;
    	function disAbbrPic(e, i){
    		nowIdx = e;
    		var str = $('z' + nowIdx).innerHTML;
    		if(str == '开启'){
	    		var reqUrl = "songManage.jsp?o=display&i=" + i;
				postRequest('POST', reqUrl, onChangePageBack);
			} else{
				$('p' + nowIdx).innerHTML = "";
				$('z' + nowIdx).innerHTML = "开启";
			}
    	}
    	
    	function onChangePage(d){
    		var nextPageIdx = 0;
    		if(d == "up"){
				nextPageIdx = <%=pageIndex - 1 %>;
    			if(nextPageIdx < 1){
    				return;
    			}
    		} else if(d == "down"){
    			nextPageIdx = <%=pageIndex + 1 %>;
    			if(nextPageIdx > <%=pages.getPageTotal() %>){
    				return;
    			}
    		} else if(d == "query") nextPageIdx = 1;
    		var turnForm = document.createElement("form");
			document.body.appendChild(turnForm);
			turnForm.method = 'post';
			turnForm.action = 'songManage.jsp';
			var newElement1 = document.createElement("input");
			newElement1.setAttribute("name", "d");
			newElement1.setAttribute("type", "hidden");
			newElement1.setAttribute("value", "");
			var newElement2 = document.createElement("input");
			newElement2.setAttribute("name", "ps");
			newElement2.setAttribute("type", "hidden");
			newElement2.setAttribute("value", "<%=pageSize%>");
			var newElement3 = document.createElement("input");
			newElement3.setAttribute("name", "pi");
			newElement3.setAttribute("type", "hidden");
			newElement3.setAttribute("value", nextPageIdx);
			var contStrs = $('contStrs').value;
			var newElement4 = document.createElement("input");
			newElement4.setAttribute("name", "ct");
			newElement4.setAttribute("type", "hidden");
			newElement4.setAttribute("value", contStrs);
			turnForm.appendChild(newElement1);
			turnForm.appendChild(newElement2);
			turnForm.appendChild(newElement3);
			turnForm.appendChild(newElement4);
			turnForm.submit();
    	}
    	
    	function exportData(){
    		var turnForm = document.createElement("form");
			document.body.appendChild(turnForm);
			turnForm.method = 'post';
			turnForm.action = 'songManage.jsp';
			var newElement1 = document.createElement("input");
			newElement1.setAttribute("name", "o");
			newElement1.setAttribute("type", "hidden");
			newElement1.setAttribute("value", "export");
			turnForm.appendChild(newElement1);
			turnForm.submit();
    	}
    	
    	function copyText(text, callback){ // text: 要复制的内容， callback: 回调
		    var tag = document.createElement('input');
		    tag.setAttribute('id', 'cp_hgz_input');
		    tag.value = decodeURIComponent(text);
		    document.getElementsByTagName('body')[0].appendChild(tag);
		    document.getElementById('cp_hgz_input').select();
		    document.execCommand('copy');
		    document.getElementById('cp_hgz_input').remove();
		    if(callback){
		    	callback(text);
		    }
		}

		function onChangePageBack(){
			if(xmlhttp.readyState == 4){ // 4 = "loaded"
				if(xmlhttp.status == 200){ // 200 = "OK"
					var retText = xmlhttp.responseText.replace(/(\s*$)/g, ""); //返回内容
					jsonStr = eval('(' + retText + ')');
					$('p' + nowIdx).innerHTML = "<td id='div" + nowIdx + "' colspan='<%=tdNum%>'></td>";
					if(jsonStr.length > 0){
						for(var i  = 0 ; i < jsonStr.length; i++){
							$('div' + nowIdx).innerHTML += "<img src='../" + jsonStr[i].pic + "' style='width:320px;height:180px' title='" + jsonStr[i].cname + "' />&nbsp;&nbsp;";
						}
					} else{
						$('div' + nowIdx).innerHTML = "<font color='red' size='6'>暂无专题活动引用此曲目</font>";
					}
					$('z' + nowIdx).innerHTML = "关闭";
					return;
				}
			}
		}
    	
    	// AJAX请求
		var xmlhttp = null;
		function postRequest(mtd, url, listener){
			if(window.XMLHttpRequest){ // code for Firefox, Opera, IE7, etc.
				xmlhttp = new XMLHttpRequest();
			} else if (window.ActiveXObject){ // code for IE6, IE5
				xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
			}
			if(mtd == 'POST' || mtd == 'post'){
				var param = url.substring(url.indexOf("?") + 1, url.length);
				url = url.substring(0, url.indexOf("?"));
			}
			xmlhttp.onreadystatechange = listener;
			xmlhttp.open(mtd, url, true);
			xmlhttp.setRequestHeader("cache-control", "no-cache");
			if(mtd == 'POST' || mtd == 'post'){
				xmlhttp.setRequestHeader("CONTENT-TYPE", "application/x-www-form-urlencoded");
				xmlhttp.send(param);
			} else{
				xmlhttp.send();
			}
		}
		
		function getRecUrl(e, i){
			var str = $('g' + e).innerHTML;
    		if(str == '呈现'){
				$('u' + e).innerHTML = "<td id='div" + e + "' colspan='<%=tdNum%>'></td>";
				var u1 = "http://36.133.61.142:8888/joymusic_cmcc_sichuan/?p=100&k=" + i;
				$('div' + e).innerHTML = "<a style='cursor:pointer' onClick='openNewWin(" + e + ", \"" + u1 + "&loadpic=y\")' ><font color='#FFAA1E'>附带引导图配置入口</font>：" + u1 + "&loadpic=y</a><br/><a style='cursor:pointer' onClick='openNewWin(" + e + ", \"" + u1 + "&loadpic=n\")' ><font color='#FFAA1E'>不带引导图配置入口</font>：" + u1 + "&loadpic=n</a>";
				$('g' + e).innerHTML = "隐藏";
			} else{
				$('u' + e).innerHTML = "";
				$('g' + e).innerHTML = "呈现";
			}
		}
		
		function openNewWin(i, u){
    		var v = $('ra' + i).value;
    		if(v == 1){
	    		var width = 1284;  
            	var height = 722;
            	var top = Math.round((window.screen.height - height) / 2);  
            	var left = Math.round((window.screen.width - width) / 2);  
            	var tmp = window.open(u, "newwindow", "height=" + height + ", width=" + width + ", top=" + top + ", left= " + left + ", toolbar=no, menubar=no, scrollbars=no, resizable=no,location=n o, status=no"); 
				tmp.focus();
			} else{
				alert('注意！该曲目并未标记为上线状态！');
			}
    	}
    	
    	var nowEntryId = 0;
    	function doLine(e, c, i){
    		nowIdx = e;
    		nowEntryId = i;
    		var reqUrl = "songManage.jsp?o=doline&i=" + i + "&c=" + c;
			postRequest('POST', reqUrl, doLineBack);
    	}
    	
    	function doLineBack(){
			if(xmlhttp.readyState == 4){ // 4 = "loaded"
				if(xmlhttp.status == 200){ // 200 = "OK"
					var retText = xmlhttp.responseText.replace(/(\s*$)/g, ""); //返回内容
					var jsonStr = eval('(' + retText + ')');
					var result = jsonStr.result;
					if(result == -1) alert('更新失败，请刷新页面后重试！');
					else if(result == 0){
						alert('下线该曲目成功');
						$('s' + nowIdx).innerHTML = "<a class=\"tab button green\" onclick=\"doLine(" + nowIdx + ", 1, '" + nowEntryId + "')\">上线</a>";
						$('d' + nowIdx).innerHTML = '<font color="red">●</font>';
						$('opera').src = '../h0';
					} else if(result == 1){
						alert('上线该曲目成功');
						$('s' + nowIdx).innerHTML = "<a class=\"tab button pink\" onclick=\"doLine(" + nowIdx + ", 0, '" + nowEntryId + "')\">下线</a>";
						$('d' + nowIdx).innerHTML = '<font color="green">●</font>';
						$('opera').src = '../h0';
					}
				}
			}
		}
    </script>
</head>

<body style="background:#1B1B1B" onload="start()">
	<table style="margin:0 auto" border=0>
		<tr>
			<td>
				<a class="tab button blue" onclick="exportData()">导出全部曲目信息至Excel</a>
			</td>
			<td>
				<div class="milky">&nbsp;&nbsp;&nbsp;&nbsp;<font color='#7FD2FF'>查询关键字:</font></div>
			</td>
			<td>
				<div class="case">
					<input id="contStrs" type="text" width="350px" placeholder="多词以'|'分隔,支持各ID" value="<%=contStrs %>">
				</div>
			</td>
			<td>
				<a class="tab button blue" onclick="onChangePage('query')">开始查询</a>
			</td>
		</tr>
	</table>
	<table id="myTable" class="contCore" style="margin:0 auto">
		<thead>
			<tr>
				<th style='width:110px'>复制曲目ID</th>
				<th style='width:70px'>曲目ID</th>
				<th style='width:350px'>曲目名</th>
				<th style='width:110px'>缩写</th>
				<th style='width:120px'>艺人名</th>
				<th style='width:150px'>艺人头像</th>
				<th style='width:165px'>曲目分类</th>
				<th style='width:70px'>语种</th>
				<th style='width:70px'>曲目时长</th>
				<th style='width:70px'>清晰度</th>
				<th style='width:70px'>来源</th>
				<th style='width:70px'>支付</th>
				<th style='width:70px'>外推连接</th>
				<th style='width:70px'>设置状态</th>
				<th style='width:60px'>状态</th>
			</tr>
		</thead>
		<tbody><%if(liaif.size() > 0){ for(int i = 0; i < liaif.size(); i++){%>
			<tr>
				<td><a class="tab button blue" onclick="copyText('<%=liaif.get(i).get("id") %>', function(){alert('复制 <%=liaif.get(i).get("id") %>:<%=liaif.get(i).get("cname") %>-<%=liaif.get(i).get("artist") %> 成功')})">一键复制</a></td>
				<td><%if(StringUtils.isBlank(contStrs)){%><%=liaif.get(i).get("id") %><%} else{String resStr1 = liaif.get(i).get("id").toString(); String redStr1 = getRedStr(resStr1, contStrsArr);%><%=getRealStr(resStr1, redStr1) %><%}%></td>
				<td><%if(StringUtils.isBlank(contStrs)){%><%=liaif.get(i).get("cname") %><%} else{String resStr1 = liaif.get(i).get("cname").toString(); String redStr1 = getRedStr(resStr1, contStrsArr);%><%=getRealStr(resStr1, redStr1) %><%}%></td>
				<td><%if(StringUtils.isBlank(contStrs)){%><%=liaif.get(i).get("abbr") %><%} else{String resStr1 = liaif.get(i).get("abbr").toString(); String redStr1 = getRedStr(resStr1, contStrsArr);%><%=getRealStr(resStr1, redStr1) %><%}%></td>
				<td><%if(StringUtils.isBlank(contStrs)){%><%=liaif.get(i).get("artist") %><%} else{String resStr1 = liaif.get(i).get("artist").toString(); String redStr1 = getRedStr(resStr1, contStrsArr);%><%=getRealStr(resStr1, redStr1) %><%}%></td>
				<td><%=liaif.get(i).get("artist_pic") == null ? "暂缺" : liaif.get(i).get("artist_pic") %></td>
				<td><%=liaif.get(i).get("classification") %></td>
				<td><%=liaif.get(i).get("clanguage") %></td>
				<td><%=liaif.get(i).get("duration") %></td>
				<td><%=liaif.get(i).get("definition") %></td>
				<td><%=liaif.get(i).get("company") %></td>
				<td><%if("0".equals(liaif.get(i).get("cfree").toString())){%>免费<%} else{ %>收费<%} %></td>
				<td><a id="g<%=i + 1%>" class="tab button blue" onclick="getRecUrl(<%=i + 1%>, '<%=liaif.get(i).get("id") %>')">呈现</a></td>
				<td id="s<%=i + 1%>"><%String csort = liaif.get(i).get("csort").toString(); if(csort.equals("0")){%><a class="tab button green" onclick="doLine(<%=i + 1%>, 1, '<%=liaif.get(i).get("id") %>')">上线</a><%} else{%><a class="tab button pink" onclick="doLine(<%=i + 1%>, 0, '<%=liaif.get(i).get("id") %>')">下线</a><%}%></td>
				<td><div id="d<%=i + 1%>"><%if(csort.equals("0")){%><font color="red">●</font><input id="ra<%=i + 1%>" type="hidden" value="0" /><%} else{%><font color="green">●</font><input id="ra<%=i + 1%>" type="hidden" value="1" /><%}%></div></td>
			</tr>
			<tr id="p<%=i + 1%>"></tr>
			<tr id="u<%=i + 1%>"></tr><%}} else{%>
			<tr>
				<td class="tdFont" colspan="<%=tdNum%>">
					<div style="text-align:center;font-size:24px;color:red;background-color:black;text-shadow:rgba(255,255,255,0.3) 0px 5px 6px,rgba(255,255,255,0) 0px 1px 1px;-webkit-background-clip:text">暂无此组关键字( <%=contStrs %> )的曲目信息！！！</div>
				</td>
			</tr><%}%>
		</tbody>
		<tfoot>
			<tr>
				<th colspan="<%=tdNum%>"><%if(liaif.size() > 0){%><a class="tab button blue" onclick="onChangePage('up')">上一页</a>&nbsp;&nbsp;&nbsp;<%=pages.getPageIndex() %> / <%=pages.getPageTotal() %>&nbsp;&nbsp;&nbsp;<a class="tab button blue" onclick="onChangePage('down')">下一页</a><%}%></th>
			</tr>
		</tfoot>
	</table>
	<iframe id="opera" src="" style="width:0px;height:0px" frameborder="0"></iframe>
</body>
</html>