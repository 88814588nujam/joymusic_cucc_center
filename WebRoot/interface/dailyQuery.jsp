<%@page import="java.net.*,java.io.*,org.json.JSONObject,java.security.MessageDigest,java.text.SimpleDateFormat,java.util.*,com.joymusic.api.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%!
	private List<Map<String, Object>> getAllArea() {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM entity_area";
		li = DB.query(sql, true);
		return li;
	}

	private List<Map<String, Object>> getDailyData(String sTime, String eTime, String areaNum, boolean flag) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM valuable_calculation_table WHERE date>='" + sTime + "' AND date<'" + eTime + "' AND cityN=0";
		if(StringUtils.isNotBlank(areaNum)) sql = "SELECT * FROM valuable_calculation_table WHERE date>='" + sTime + "' AND date<'" + eTime + "' AND cityN='" + areaNum + "'";
		li = DB.query(sql, flag);
		return li;
	}
%>
<%
	String areaName = "联通中心";
	Date date = new Date();
	SimpleDateFormat formatF = new SimpleDateFormat("yyyy-MM-dd");
	String timeFront = formatF.format(date);
	Calendar cal = Calendar.getInstance();
	cal.add(Calendar.DATE, -1);
	String yesterday = formatF.format(cal.getTime());
	String stime = request.getParameter("st");
	if(StringUtils.isBlank(stime)){
		stime = yesterday;
	}
	String etime = request.getParameter("se");
	if(StringUtils.isBlank(etime)){
		etime = timeFront;
	}
	String areaNum = request.getParameter("a");
	if(StringUtils.isBlank(areaNum)){
		areaNum = "";
	}
	
	boolean flag = true;
	String url = request.getRequestURL().toString();
	List<Map<String, Object>> gdd = getDailyData(stime, etime, areaNum, flag);
	List<Map<String, Object>> gaa = getAllArea();
	List<Map<String, Object>> province = new ArrayList<Map<String, Object>>();
	String provinceN = "";
	for(int i = 0; i < gaa.size(); i++){
		String provinceN0 = gaa.get(i).get("provinceN").toString();
		String provinceC0 = gaa.get(i).get("provinceC").toString();
		if(!provinceN.equals(provinceN0)){
			provinceN = provinceN0;
			Map<String, Object> map = new HashMap<String, Object>();
			map.put("provinceN", provinceN0);
			map.put("provinceC", provinceC0);
			province.add(map);
		}
	}
	
	int tdNum = 16;
%>
<!DOCTYPE html>
<html>
<head>
	<title><%=areaName %>日常查询</title>
	<link rel='shortcut icon' href='<%=request.getContextPath() %>/images/application/utils/icon/joymusic.ico' type='image/x-icon'>
	<style type="text/css">
		.tdFont{font-family:Arial;font-size:18px;font-style:normal;font-weight:normal;letter-spacing:-1px;line-height:1.7em;border-collapse:collapse;text-align:center}
		table.contCore{font-family:Arial;font-size:18px;font-style:normal;font-weight:normal;letter-spacing:-1px;line-height:1.7em;border-collapse:collapse;}
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
		.button,.button:visited{display:inline-block;padding:5px 10px 6px;color:#fff;text-decoration:none;-moz-border-radius:6px;-webkit-border-radius:6px;-moz-box-shadow:0 1px 3px rgba(0,0,0,0.6);-webkit-box-shadow:0 1px 3px rgba(0,0,0,0.6);text-shadow:0 -1px 1px rgba(0,0,0,0.25);border-bottom:1px solid rgba(0,0,0,0.25);position:relative;cursor:pointer}
		.button:hover{background-color:#111;color:#fff;}
		.button:active{top:1px;}
		.tab.button,.tab.button:visited{font-size:16px;font-weight:bold;line-height:1;text-shadow:0 -1px 1px rgba(0,0,0,0.25);}
		.blue.button,.magenta.button:visited{background-color:#2981e4;}
		.blue.button:hover{background-color:#2575cf;}
		.text{border: 1px solid #ccc;padding: 7px 0px;border-radius:3px;padding-left:5px;font-family:Arial;font-size:16px;font-style:normal;font-weight:normal;}
		.milky{font-size:18px;color:#333333;font-weight:bold}
    </style>
	<script type="text/javascript">
		function onChangePage(d){
			var tempSt = document.getElementById('ECalendar_case1').value;
			var tempEt = document.getElementById('ECalendar_case2').value;
			var tempA = document.getElementById('ECalendar_case3').value;
    		var turnForm = document.createElement("form");
			document.body.appendChild(turnForm);
			turnForm.method = 'post';
			turnForm.action = 'dailyQuery.jsp';
			var newElement1 = document.createElement("input");
			newElement1.setAttribute("name", "st");
			newElement1.setAttribute("type", "hidden");
			newElement1.setAttribute("value", tempSt);
			var newElement2 = document.createElement("input");
			newElement2.setAttribute("name", "se");
			newElement2.setAttribute("type", "hidden");
			newElement2.setAttribute("value", tempEt);
			var newElement3 = document.createElement("input");
			newElement3.setAttribute("name", "a");
			newElement3.setAttribute("type", "hidden");
			newElement3.setAttribute("value", tempA);
			turnForm.appendChild(newElement1);
			turnForm.appendChild(newElement2);
			turnForm.appendChild(newElement3);
			turnForm.submit();
    	}
    </script>
</head>

<body style="background:#1B1B1B">
	<table style="margin:0 auto" border=0>
		<tr>
			<td>
				<div class="milky">开始时间:</div>
			</td>
			<td>
				<div class="case">
					<div class="calendarWarp">
						<input id="ECalendar_case1" type="text" class='ECalendar' value="<%=stime%>">
					</div>
				</div>
			</td>
			<td>
				<div class="milky">&nbsp;&nbsp;结束时间:</div>
			</td>
			<td>
				<div class="case">
					<div class="calendarWarp">
						<input id="ECalendar_case2" type="text" class='ECalendar' value="<%=etime%>">
					</div>
				</div>
			</td>
			<td>
				<div class="milky">查询地区:</div>
			</td>
			<td>
				<div class="case">
					<div class="calendarWarp">
						<select id="ECalendar_case3" class='ECalendar'>
							<optgroup label="全部查询">
								<option value=""<%if(StringUtils.isBlank(areaNum)){%> SELECTED<%}%>>全部地区</option>
							</optgroup><%for(int j = 0; j < province.size(); j++){
								String provinceN0 = province.get(j).get("provinceN").toString();
								String provinceC0 = province.get(j).get("provinceC").toString();
							%>
								<optgroup label="<%=provinceC0 %>"><%for(int i = 0; i < gaa.size(); i++){
										String provinceN1 = gaa.get(i).get("provinceN").toString();
										String areaNum0 = gaa.get(i).get("cityN").toString();
										if(provinceN1.equals(provinceN0)){%>
									<option value="<%=areaNum0 %>"<%if(areaNum0.equals(areaNum)){%> SELECTED<%}%>><%=gaa.get(i).get("cityC") %></option><%}}%>
								</optgroup><%}%>
						</select>
					</div>
				</div>
			</td>
			<td>
				<a class="tab button blue" onclick="onChangePage('up')">开始查询</a>
			</td>
		</tr>
	</table>
	<table class="contCore" style="margin:0 auto">
		<thead>
			<tr>
				<th style='width:135px'>日期</th>
				<th style='width:125px'>访问人数</th>
				<th style='width:135px'>新访问人数</th>
				<th style='width:135px'>入口访问量</th>
				<th style='width:145px'>页面访问量</th>
				<th style='width:185px'>页面访问总时长</th>
				<th style='width:135px'>点播用户数</th>
				<th style='width:110px'>点播量</th>
				<th style='width:135px'>播放用户数</th>
				<th style='width:110px'>播放量</th>
				<th style='width:135px'>播放时长</th>
				<th style='width:185px'>发起订购用户数</th>
				<th style='width:135px'>订购用户数</th>
				<th style='width:140px;line-height:15px'>订购失败或取消订购用户数</th>
				<th style='width:140px;line-height:15px'>弹出订购直接退出平台用户数</th>
				<th style='width:135px;line-height:15px'>策略用户数</th>
			</tr>
		</thead>
		<tbody><%if(gdd.size() > 0){ for(int i = 0; i < gdd.size(); i++){%>
			<tr>
				<td class="tdFont"><%=gdd.get(i).get("date") %></td>
				<td class="tdFont"><%=gdd.get(i).get("flow_view_user") %></td>
				<td class="tdFont"><%=gdd.get(i).get("new_user") %></td>
				<td class="tdFont"><%=gdd.get(i).get("flow_view_count") %></td>
				<td class="tdFont"><%=gdd.get(i).get("view_count") %></td>
				<td class="tdFont"><%=gdd.get(i).get("view_sum") %></td>
				<td class="tdFont"><%=gdd.get(i).get("check_user") %></td>
				<td class="tdFont"><%=gdd.get(i).get("check_count") %></td>
				<td class="tdFont"><%=gdd.get(i).get("play_user") %></td>
				<td class="tdFont"><%=gdd.get(i).get("play_count") %></td>
				<td class="tdFont"><%=gdd.get(i).get("play_sum") %></td>
				<td class="tdFont"><%=gdd.get(i).get("pay_start") %></td>
				<td class="tdFont"><%=gdd.get(i).get("pay_user") %></td>
				<td class="tdFont"><%=gdd.get(i).get("pay_error") %></td>
				<td class="tdFont"><%=gdd.get(i).get("pay_quit") %></td>
				<td class="tdFont"><%=gdd.get(i).get("pay_user_apply") %></td>
			</tr><%}} else{%>
			<tr>
				<td class="tdFont" colspan="<%=tdNum%>">
					<div style="text-align:center;font-size:24px;color:red;background-color:black;text-shadow:rgba(255,255,255,0.3) 0px 5px 6px,rgba(255,255,255,0) 0px 1px 1px;-webkit-background-clip:text">该周期内暂无此地区数据！！！</div>
				</td>
			</tr><%}%>
		</tbody>
		<tfoot>
			<tr>
				<th colspan="<%=tdNum%>"><%=stime %> 至 <%=etime %> 日常查询</th>
			</tr>
		</tfoot>
	</table>
</body>
</html>