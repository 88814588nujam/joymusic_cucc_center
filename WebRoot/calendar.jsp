<%@page language="java" import="java.text.SimpleDateFormat,com.joymusic.api.*,com.joymusic.common.*,java.net.*,java.io.*,java.util.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%! 
	private String getRandPic(String path){
		String picPaths = "";
		try{
			List<String> list = new ArrayList<String>();
			File file = new File(path);
			if(file.exists()){
	            File[] files = file.listFiles();
	            for(File fileSon : files){
					list.add(fileSon.getName());
	            }
			}
			if(list.size() > 0){
				Collections.shuffle(list);
				int maxSize = 10;
				if(list.size() < maxSize) maxSize = list.size();
				for(int i = 0; i < maxSize; i++){
					if(i == list.size() - 1) picPaths += "'" + list.get(i) + "'";
					else picPaths += "'" + list.get(i) + "',";
				}
			}
		} catch(Exception e){}
		picPaths = "[" + picPaths + "]";
		return picPaths;
	}
	
	private int getMonth(Date start, Date end){
        if(start.after(end)){
            Date t = start;
            start = end;
            end = t;
        }
		Calendar startCalendar = Calendar.getInstance();
		startCalendar.setTime(start);
		Calendar endCalendar = Calendar.getInstance();
		endCalendar.setTime(end);
		Calendar temp = Calendar.getInstance();
		temp.setTime(end);
		temp.add(Calendar.DATE, 1);
		int year = endCalendar.get(Calendar.YEAR) - startCalendar.get(Calendar.YEAR);
		int month = endCalendar.get(Calendar.MONTH) - startCalendar.get(Calendar.MONTH);
		if((startCalendar.get(Calendar.DATE) == 1) && (temp.get(Calendar.DATE) == 1)){
			return year * 12 + month + 1;
		} else if((startCalendar.get(Calendar.DATE) != 1) && (temp.get(Calendar.DATE) == 1)){
			return year * 12 + month;
		} else if((startCalendar.get(Calendar.DATE) == 1) && (temp.get(Calendar.DATE) != 1)){
			return year * 12 + month;
		} else {
			return (year * 12 + month - 1) < 0 ? 0 : (year * 12 + month);
		}
	}
	
	// 传入行数|列数|总和计算各个元素的左上右下
	public static List<Map<String, Object>> calcuGrid(int row, int col,
			int pageTotals) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		List<String> rest = new ArrayList<String>();
		if (pageTotals > col && pageTotals % col != 0) {
			for (int i = ((int) (Math.floor((double) pageTotals / (double) col) - 1)
					* col + (pageTotals % col)) + 1; i < (int) Math
					.floor(pageTotals / col) * col + 1; i++) {
				rest.add(String.valueOf(i));
			}
		}
		List<String> l = new ArrayList<String>();
		for (int i = 1; i <= (int) Math
				.ceil((double) pageTotals / (double) col); i++) {
			l.add(String.valueOf((i - 1) * col + 1));
		}
		List<String> r = new ArrayList<String>();
		for (int i = 1; i <= (int) Math.ceil((double) pageTotals / (double) col
				- 1); i++) {
			r.add(String.valueOf((i - 1) * col + col));
		}

		for (int i = 1; i <= pageTotals; i++) {
			Map<String, Object> m = new HashMap<String, Object>();
			String cfocus = "";
			// 添加左焦点
			if (l.contains(String.valueOf(i))) {
				cfocus = "0,";
			} else {
				cfocus = (i - 1) + ",";
			}
			// 添加上焦点
			if (i <= col) {
				cfocus += "0,";
			} else {
				cfocus += (i - col) + ",";
			}
			// 添加右焦点
			if (r.contains(String.valueOf(i))) {
				cfocus += "0,";
			} else {
				if (i == pageTotals) {
					if (pageTotals % col == 0) {
						cfocus += "0,";
					} else {
						if (i <= col) {
							cfocus += "0,";
						} else {
							cfocus += (int) Math.floor((double) pageTotals
									/ (double) col)
									* col
									+ 1
									- (col - (pageTotals % col))
									+ ",";
						}
					}
				} else {
					cfocus += (i + 1) + ",";
				}
			}
			// 添加下焦点
			if (rest.contains(String.valueOf(i))) {
				cfocus += pageTotals + "";
			} else {
				if (pageTotals % col == 0 && i > pageTotals - col
						&& i <= pageTotals) {
					cfocus += "0";
				} else {
					if (i <= row * col
							&& i >= (int) Math.floor((double) pageTotals
									/ (double) col)
									* col) {
						cfocus += "0";
					} else {
						cfocus += (i + col) + "";
					}
				}
			}
			m.put("cfocus", cfocus);
			li.add(m);
		}
		return li;
	}
	
	// 获得当月的卡片背景
	private List<Map<String, Object>> getClendarDatePic(String dateStr) {
		List<Map<String, Object>> li = null;
		li = new ArrayList<Map<String, Object>>();
		return li;
	}
	
	// 获得每天活动和专题
    private List<Map<String, Object>> getAlmAndAct(String dtime) {
		List<Map<String, Object>> li = null;
		li = new ArrayList<Map<String, Object>>();
		return li;
	}
	
	// 获得每天活动和专题的总数
	private int getAlmAndActCount(String dtime) {
		int totalRows = 0;
		return totalRows;
	}
%>
<%
	// 获取私有页面参数
	String nowFocus = StringUtils.isBlank(DoParam.AnalysisAbb("n", request)) ? "f_free_6" : DoParam.AnalysisAbb("n", request);
	String key = StringUtils.isBlank(DoParam.AnalysisAbb("k", request)) ? "" : DoParam.AnalysisAbb("k", request).toLowerCase();
	int ajaxData = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("d", request)) ? "0" : DoParam.AnalysisAbb("d", request));
	int pageIndex = Integer.parseInt(StringUtils.isBlank(DoParam.AnalysisAbb("p", request)) ? "1" : DoParam.AnalysisAbb("p", request));

	int pageLimit = 12;
	if(ajaxData == 1){ // 歌手歌曲
		int totalRows = InfoData.getFreeSongsCount();
		Page pages = new Page(totalRows, pageLimit);
		pages.setPageIndex(pageIndex);
		List<Map<String, Object>> gfs = InfoData.getFreeSongs(pages);
		String retStr = "{'ifNull':false, 'totalRows':'" + totalRows + "', 'pageTotal':'" + pages.getPageTotal() + "', 'pageSum':'" + gfs.size() + "', 'songList':[";
		if(gfs.size() > 0){
			for(int i = 0; i < gfs.size(); i++){
				int docI = i + 1;
				String cname = gfs.get(i).get("cname").toString();
				int len = getTitleTen(cname);
				if(i == gfs.size() - 1) retStr += "{'sid':'" + gfs.get(i).get("id") + "', 'cname':'" + gfs.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gfs.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cfree':'" + gfs.get(i).get("cfree") + "', 'duration':'" + gfs.get(i).get("duration") + "'}";
				else retStr +=  "{'sid':'" + gfs.get(i).get("id") + "', 'cname':'" + gfs.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gfs.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cfree':'" + gfs.get(i).get("cfree") + "', 'duration':'" + gfs.get(i).get("duration") + "'},";
			}
		}
		retStr += "]}";
		out.print(retStr);
		return;
	} else if(ajaxData == 2){
		List<Map<String, Object>> gsba = InfoData.getSongByIds(key);
		String jsonStr = "";
		if(gsba.size() > 0){
			for(int i = 0; i < gsba.size(); i++){
				jsonStr += "{'sid':'" + gsba.get(i).get("id") + "', 'cname':'" + gsba.get(i).get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + gsba.get(i).get("artist").toString().replaceAll("'", "\\\\'") + "', 'cres1':'" + gsba.get(i).get("cres1") + "', 'cres2':'" + gsba.get(i).get("cres2") + "'}";
				if(i < gsba.size() - 1){
					jsonStr += ",";
				}
			}
		}
		jsonStr = "[" + jsonStr + "]";
		out.print(jsonStr);
		return;
	}
%><%@include file="common/head.jsp" %>
<%
	String path = new File(application.getRealPath(request.getServletPath())).getParent();
	String picPaths = getRandPic(path + "/images/commonly/free");
	
	Date currentTime = new Date();
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	String dateString = formatter.format(currentTime);
	// 以下是预留做跨月查询的
	Date now = new Date();
	String stime = "2017-01-01"; // 彩虹历开始的第一天
	Date old = formatter.parse(stime);
	Page pages = new Page(getMonth(old, currentTime) + 1, 1);
	String words = request.getParameter("words");
	pageIndex = getMonth(old, currentTime) + 1;
	pages.setPageIndex(pageIndex);
	//获得今天的日期
	Calendar mycal = Calendar.getInstance();
	int year = mycal.get(Calendar.YEAR);
	int month = mycal.get(Calendar.MONTH); // 后面都加过1了,所以获取的时候不要+1
	int te = 0;
	// 先定月数
	month = pageIndex % 12 > 0 ? pageIndex % 12 - 1 : 11;
	// 再定年份
	te = pageIndex % 12 > 0 ? pageIndex / 12 : pageIndex / 12 - 1;
	SimpleDateFormat ft = new SimpleDateFormat("yyyy");
	int oldI = Integer.parseInt(ft.format(old));
	year = oldI + te;
	int nowWeekDay = mycal.get(Calendar.DAY_OF_WEEK) - 1; // 今天是每周的第几天 0:星期天
	String allName = request.getParameter("allName");
	String cmode = request.getParameter("cmode");
	mycal.set(year, month, 1);
	int a = mycal.get(Calendar.DAY_OF_WEEK); // 得到每个月第一天是星期几
	int maxDate = mycal.getActualMaximum(Calendar.DATE);
	double x = maxDate + a - 1; // 饱和行数
	int row = (int) Math.ceil(x / 7); // 页面读取行数
	int pageSize = maxDate; // 页面读取数据上限
	int col = 7;
	int fl = 1;
	int ts = 1;
	int ms = 1;
	int nowNid = 0;
	int realRow = 0;
	int pageTotals = (int) x;
	List<Map<String, Object>> li1 = calcuGrid(row, col, pageTotals);
	List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
	for(int i = 0;i < li1.size();i++){
		if(fl <= maxDate){
			if((a <= i + 1 && i < 7) || (i >= 7)){
				if(ts == 1 && fl == 1) ts = i;
				Map<String, Object> m = new HashMap<String, Object>();
				m.put("p3", null);
				m.put("p2", null);
				String daT = year + "-" + ((month + 1 >= 10) ? (month + 1) : "0" + (month + 1)) + "-" + ((fl >= 10) ? fl : "0" + fl);
				m.put("p1", daT);
				m.put("curl", "main.jsp");
				if(ms == 1 && a > 1) ms = i + 1;
				if(dateString.equals(daT)) nowNid = i + 1;
				m.put("nid", String.valueOf(i + 1));
				m.put("zindex", "1");
				m.put("cfocus", li1.get(i).get("cfocus").toString() + ",n");
				m.put("pic", "play.png");
				m.put("onclick_type", "4");
				li.add(m);
				fl++;
			}
		}
	}
	realRow = (int) Math.ceil(li1.size() / 7.0);
	ts = ts + 7;
	int rsx = 540; // 第一个元素左边距(默认6行)
	int sy = 170; // 第一个元素上边距(默认6行)
	int sw = 70; // 元素宽
	int sh = 65; // 元素高
	int sl = 95; // 左偏移
	int st = 70; // 上偏移
	int bw = 720; // 月底色的宽度
	int bh = 512; // 月底色的高度
	if(realRow == 4){ // 4行位置
		sy = 260;
		bh = 388;
	} else if(realRow == 5){ // 5行位置
		sy = 220;
		bh = 450;
	} 
	int sx = rsx;
	Calendar cal0 = Calendar.getInstance();
	cal0.set(year, month, cal0.getActualMinimum(Calendar.DAY_OF_MONTH));
	int fi = cal0.get(Calendar.DAY_OF_WEEK);
	List<Map<String, Object>> lid = getClendarDatePic(year + ((month + 1) > 10 ? "-" + (month + 1) : "-0" + (month + 1)));
	String style = "";
	
%>
		<script type='text/javascript'>
			// 用户ID
			var userid = '<%=userid %>';
			// 用户临时token
			var userToken = '<%=userToken %>';
			// 用户平台
			var platform = <%=platform %>;
			// 用户省份编号
			var provinceN = '<%=provinceN %>';
			// 用户城市编号
			var cityN = '<%=cityN %>';
			// 实际应用显示尺寸
			var pageW = <%=pageW %>;
			var pageH = <%=pageH %>;
			// 机顶盒型号|机顶盒版本
			var stbType = '<%=stbType %>';
			var stbVersion = '<%=stbVersion %>';
			// 当前焦点
			var nowFocus = '<%=nowFocus %>';
			// 当前页码ID
			var pageId = <%=pageId %>;
			// 允许按键
			var allowClick = true;
			// 当前页码
			var pageIndex = <%=pageIndex %>;
			// 当前总页数
			var pageTotal = 0;
			// 当前页面查询出来的内容数
			var pageSum = 0;
			// 查询出来的歌曲总数
			var totalRows = 0;
			// 每个页面总加载上限
			var pageLimit = <%=pageLimit %>;
			// 翻页响应是否在遥控器上
			var answerFlag = false;
			// 异步加载出来的歌曲
			var songList = new Array();
			// 播放队列
			var playList = new Array();
			// 歌曲ID集合
			var songIds = '';
			// 底衬图队列
			var picPaths = <%=picPaths %>;
			// 遥控延迟响应计时器
			var layTimes;
			// 控制是否执行start函数
			var ctlStart = false;

			function start(){
				if(ctlStart) return;
				ctlStart = true;
				if(stbType.indexOf('TEST') > -1) autoDivHeight();
				else handleDivHeight(0, 0);
				// $g(nowFocus).style.visibility = 'visible';
				$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				var tempF = getIdx(nowFocus, 'f_free_');
				displayStat(0, tempF);
				loadSong();
			}

			function loadSong(){
				allowClick = false;
				var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=1&p=' + pageIndex + '\'}]';
				var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
				ajaxRequest('POST', reqUrl, getSongBack);
			}

			function getSongBack(){
				if(xmlhttp.readyState == 4){
					if(xmlhttp.status == 200){
						var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
						var contentJson = eval('(' + retText + ')');
						totalRows = Number(contentJson.totalRows);
						pageTotal = Number(contentJson.pageTotal);
						pageSum = Number(contentJson.pageSum);
						songList = contentJson.songList;
						$g('pageInfo').innerText = '─── 【' +  pageIndex + ' / ' + pageTotal + '】 ───';
						var pLen = picPaths.length;
						var nowPic = pageIndex % pLen;
						for(var i = 1; i <= 12; i++){
							$g('p_f_free_' + i).src = 'images/commonly/free/' + picPaths[nowPic];
						}
						if(answerFlag){
							var tempF = getIdx(nowFocus, 'f_free_');
							if(tempF > 0 && tempF < 13){
								if(pageSum < tempF){
									displayStat(1, tempF);
									$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
									nowFocus = 'f_free_' + pageSum;
									var tempS = getIdx(nowFocus, 'f_free_');
									if(tempS > 12){
										$g('nowPlay').style.visibility = 'hidden';
										$g('nowTips').style.visibility = 'hidden';
									} else{
										$g('nowPlay').style.visibility = 'visible';
										$g('nowTips').style.visibility = 'visible';
									}
									displayStat(0, tempS);
									$g(nowFocus).setAttribute('class', 'btn_focus_visible');
									displayBack();
								}
							}
							answerFlag = false;
						}
						if(pageIndex == 1 && pageTotal > 1){
							$g('il').style.visibility = 'hidden';
							$g('ir').style.visibility = 'visible';
						} else if(pageTotal == pageIndex){
							$g('il').style.visibility = 'visible';
							$g('ir').style.visibility = 'hidden';
						} else if(pageTotal > pageIndex){
							$g('il').style.visibility = 'visible';
							$g('ir').style.visibility = 'visible';
						} else{
							$g('il').style.visibility = 'hidden';
							$g('ir').style.visibility = 'hidden';
						}
						songIds = '';
						for(var i = 1; i <= 12; i++){
							var realIdx = i - 1;
							if(realIdx < songList.length){
								songIds += songList[realIdx].sid + ',';
								$g('s_f_free_' + i).innerText = '[ ' + songList[realIdx].cname.replace('(HD)', '') + ' ]';
								$g('a_f_free_' + i).innerText = '- ' + songList[realIdx].artist + ' -';
								$g('d_f_free_' + i).innerText = formatSeconds(Number(songList[realIdx].duration));
							} else{
								$g('s_f_free_' + i).innerText = '';
								$g('a_f_free_' + i).innerText = '';
								$g('d_f_free_' + i).innerText = '';
							}
						}
						songIds = songIds.substring(0, songIds.length - 1);
						loadSongRes();
					}
				}
			}

			function loadSongRes(){
				allowClick = false;
				var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=2&k=' + songIds + '\'}]';
				var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
				ajaxRequest('POST', reqUrl, loadSongResBack);
			}

			function loadSongResBack(){
				if(xmlhttp.readyState == 4){
					if(xmlhttp.status == 200){
						var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
						var contentJson = eval('(' + retText + ')');
						for(var i = 0; i < songList.length; i++){
							songList[i].cres1 = contentJson[i].cres1;
							songList[i].cres2 = contentJson[i].cres2;
						}
						displayBack();
						allowClick = true;
					}
				}
			}

			function onkeyOK(){
				if(allowClick){
					var delayT = 500;
					var tempF = getIdx(nowFocus, 'f_free_');
				}
			}

			function onkeyBack(){
				if(allowClick){
					destoryMP();
					__return();
				}
			}

			function onkeyLeft(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_free_');
					//$g(nowFocus).style.visibility = 'hidden';
					displayStat(1, tempF);
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if((tempF > 1 && tempF < 5) || (tempF > 5 && tempF < 9) || (tempF > 9 && tempF < 13)){
						var newIdx = tempF - 1;
						nowFocus = 'f_free_' + newIdx;
					} else if(tempF == 1 || tempF == 5 || tempF == 9){
						if(pageIndex > 1){
							answerFlag = true;
							pageIndex--;
							loadSong();
						}
					} else if(tempF == 14) nowFocus = 'f_free_13';
					var tempS = getIdx(nowFocus, 'f_free_');
					if(tempS > 12){
						$g('nowPlay').style.visibility = 'hidden';
						$g('nowTips').style.visibility = 'hidden';
					} else{
						$g('nowPlay').style.visibility = 'visible';
						$g('nowTips').style.visibility = 'visible';
					}
					displayStat(0, tempS);
					//$g(nowFocus).style.visibility = 'visible';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					if(tempF != tempS){
						destoryMP();
						displayBack();
					}
				}
			}

			function onkeyRight(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_free_');
					//$g(nowFocus).style.visibility = 'hidden';
					displayStat(1, tempF);
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if((tempF > 0 && tempF < 4) || (tempF > 4 && tempF < 8) || (tempF > 8 && tempF < 12)){
						var newIdx = tempF + 1;
						if(newIdx <= pageSum) nowFocus = 'f_free_' + newIdx;
						else{
							if(tempF > 4) nowFocus = 'f_free_' + (newIdx - 4);
							else nowFocus = 'f_free_13';
						}
					} else if(tempF == 4 || tempF == 8 || tempF == 12){
						if(pageIndex < pageTotal){
							answerFlag = true;
							pageIndex++;
							loadSong();
						}
					} else if(tempF == 13) nowFocus = 'f_free_14';
					var tempS = getIdx(nowFocus, 'f_free_');
					if(tempS > 12){
						$g('nowPlay').style.visibility = 'hidden';
						$g('nowTips').style.visibility = 'hidden';
					} else{
						$g('nowPlay').style.visibility = 'visible';
						$g('nowTips').style.visibility = 'visible';
					}
					displayStat(0, tempS);
					//$g(nowFocus).style.visibility = 'visible';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					if(tempF != tempS){
						destoryMP();
						displayBack();
					}
				}
			}

			function onkeyUp(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_free_');
					//$g(nowFocus).style.visibility = 'hidden';
					displayStat(1, tempF);
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF > 4 && tempF < 13){
						var newIdx = tempF - 4;
						nowFocus = 'f_free_' + newIdx;
					} else if(tempF < 4) nowFocus = 'f_free_13';
					else if(tempF == 4) nowFocus = 'f_free_14';
					var tempS = getIdx(nowFocus, 'f_free_');
					if(tempS > 12){
						$g('nowPlay').style.visibility = 'hidden';
						$g('nowTips').style.visibility = 'hidden';
					} else{
						$g('nowPlay').style.visibility = 'visible';
						$g('nowTips').style.visibility = 'visible';
					}
					displayStat(0, tempS);
					//$g(nowFocus).style.visibility = 'visible';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					if(tempF != tempS){
						destoryMP();
						displayBack();
					}
				}
			}

			function onkeyDown(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_free_');
					//$g(nowFocus).style.visibility = 'hidden';
					displayStat(1, tempF);
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF > 0 && tempF < 9){
						var newIdx = tempF + 4;
						if(newIdx <= pageSum) nowFocus = 'f_free_' + newIdx;
						else nowFocus = 'f_free_' + pageSum;
					} else if(tempF == 13 || tempF == 14){
						if(pageSum > 4) nowFocus = 'f_free_4';
						else nowFocus = 'f_free_' + pageSum;
					}
					var tempS = getIdx(nowFocus, 'f_free_');
					if(tempS > 12){
						$g('nowPlay').style.visibility = 'hidden';
						$g('nowTips').style.visibility = 'hidden';
					} else{
						$g('nowPlay').style.visibility = 'visible';
						$g('nowTips').style.visibility = 'visible';
					}
					displayStat(0, tempS);
					//$g(nowFocus).style.visibility = 'visible';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					if(tempF != tempS){
						destoryMP();
						displayBack();
					}
				}
			}

			function onKeyOther(key){
				if(key == 0x0300){
					if(goUtility() == 0){
						setTimeout('changeSongN()', 500);
					}
				} else{
					if(allowClick){
						if(key == 0x0103){
							volUp();
						} else if(key == 0x0104){
							volDown();
						} else if(key == 0x0105){
							volMute();
						} else if(key == 219 || key == 33){
							if(pageIndex > 1){
								answerFlag = true;
								pageIndex--;
								loadSong();
							}
						} else if(key == 221 || key == 34){
							if(pageIndex < pageTotal){
								answerFlag = true;
								pageIndex++;
								loadSong();
							}
						}
					}
				}
			}

			function displayStat(n, i){
				if(i > 0 && i < 13){
					var stat = 'hidden';
					if(n == 1) stat = 'visible';
					$g('c_f_free_' + i).style.visibility = stat;
					$g('s_f_free_' + i).style.visibility = stat;
					$g('a_f_free_' + i).style.visibility = stat;
					$g('d_f_free_' + i).style.visibility = stat;
				}
			}

			function displayBack(){
				var tempF = getIdx(nowFocus, 'f_free_');
				if(tempF > 0 && tempF < 13){
					var x = $g('free_' + tempF).offsetLeft;
					var y = $g('free_' + tempF).offsetTop;
					var realIdx = tempF - 1;
					$g('nowPlay').innerText = '正在预览：' + songList[realIdx].cname + ' - ' + songList[realIdx].artist;
					playList[0] = songList[realIdx];
					changeWin(x, y);
				}
			}

			function changeWin(x, y){
				var w = 280;
				var h = 157;
				$g('pageindexbgl').style.width = x + 'px';
				$g('pageindexbgu').style.height = y + 'px';
				$g('imgindexbgr').style.left = Number(0 - x - w) + 'px';
				$g('pageindexbgr').style.left = Number(x + w) + 'px';
				$g('pageindexbgr').style.width = Number(pageW - x - w) + 'px';
				$g('imgindexbgd').style.top = Number(0 - y - h) + 'px';
				$g('pageindexbgd').style.top = Number(y + h) + 'px';
				$g('pageindexbgd').style.height = Number(pageH - y - h) + 'px';
				toPlay();
			}

			function toPlay(){
				var tempF = getIdx(nowFocus, 'f_free_');
				var x = $g('free_' + tempF).offsetLeft;
				var y = $g('free_' + tempF).offsetTop;
				var w = $g('free_' + tempF).offsetWidth;
				var h = $g('free_' + tempF).offsetHeight;
				$g('backDis').style.left = x + 'px';
				$g('backDis').style.top = y + 'px';
				$g('backDis').style.visibility = 'visible';
				if(layTimes > -1){
					clearTimeout(layTimes); 
					layTimes = -1;
				}
				layTimes = setTimeout(function(){
					$g('backDis').style.visibility = 'hidden';
					playNext(x, y, w, h, 0);
				}, 1500);
			}
		</script>
	</head>
	
	<%	HashMap<String, Integer> m = new HashMap<String, Integer>();
		int numC = getAlmAndActCount(year + "-" + ((month + 1 >= 10) ? (month + 1) : "0" + (month + 1)) + "-");
		if(numC > 0){%>
			<%for(int j = 1;j < li.size();j++){
				List<Map<String, Object>> ali = getAlmAndAct(li.get(j).get("p1").toString());
				if(ali.size() > 0){%>
			<%if(StringUtils.isNotBlank(ali.get(0).get("cname").toString())){
				for(int k = 0;k < ali.size();k++){
					m.put(ali.get(k).get("ctime").toString().substring(8, 10) + "|" + ali.get(k).get("ctype").toString(), j);
				}%><%}}}}%>

	<body onload='start()' onunload='destoryMP()' bgcolor='<%if(isOnline.equals("y")){%>transparent<%} else{%>#444444<%}%>'>
		<!-- 方便浏览器居中观看，增加了realDis自适应显示宽高 -->
		<div id='realDis' style='position:absolute;width:<%=pageW %>px;height:<%=pageH %>px;overflow:hidden;display:none'>
			<!-- <div style='width:<%=pageW %>px;height:<%=pageH %>px;background-size:100% 100%;background-image:url(images/commonly/skins/<%=preferTheme %>.png)'></div> -->
			<img src="images/application/pages/calendar/background/calendar/<%=month + 1 %>.jpg" style="position:absolute;left:0px;top:0px;width:1280px;height:720px;z-index:-1">
			<div id="pageInfo" style="position:absolute;left:0px;top:0px;width:0px;height:0px;text-align:center;font-size:24px;color:#FFFFFF;z-index:10;visibility:hidden"></div>
			<img style="position:absolute;left:63px;top:107px;width:306px;height:540px;z-index:1" src="images/application/pages/calendar/left/<%=month + 1 %>.png">
			<img style="position:absolute;left:441px;top:235px;width:42px;height:43px;z-index:1" src="images/application/pages/calendar/spenum/<%=String.valueOf(year).substring(0, 1) %>.png">
			<img style="position:absolute;left:441px;top:278px;width:42px;height:43px;z-index:1" src="images/application/pages/calendar/spenum/<%=String.valueOf(year).substring(1, 2) %>.png">
			<img style="position:absolute;left:441px;top:321px;width:42px;height:43px;z-index:1" src="images/application/pages/calendar/spenum/<%=String.valueOf(year).substring(2, 3) %>.png">
			<img style="position:absolute;left:441px;top:366px;width:42px;height:43px;z-index:1" src="images/application/pages/calendar/spenum/<%=String.valueOf(year).substring(3, 4) %>.png">
			<img style="position:absolute;left:441px;top:409px;width:42px;height:43px;z-index:1" src="images/application/pages/calendar/spenum/y.png">
			<img style="position:absolute;left:441px;top:452px;width:42px;height:43px;z-index:1" src="images/application/pages/calendar/spenum/<%=month + 1 %>.png">
			<img style="position:absolute;left:441px;top:495px;width:42px;height:43px;z-index:1" src="images/application/pages/calendar/spenum/m.png">
			<img style="position:absolute;left:<%=rsx - (bw - (sl + sw)) / 2  %>px;top:<%=st * (realRow - 1) + sh + sy - bh + 35 %>px;width:<%=bw %>px;height:<%=bh %>px;z-index:1" src="images/application/pages/calendar/monnum/<%=month + 1 %>.png">
			<img style="position:absolute;left:<%=rsx - (635 - (sl + sw)) / 2 - 1  %>px;top:<%=st * (realRow - 1) + sh + sy - bh + 60 %>px;width:635px;height:33px;z-index:2" src="images/application/pages/calendar/bar.png"><%if(pageIndex == pages.getPageTotal()){%>
			<img style="position:absolute;left:<%=rsx + 1 + nowWeekDay * 92.5 %>px;top:<%=st * (realRow - 1) + sh + sy - bh + 60%>px;width:15px;height:15px;z-index:3" src="images/application/pages/calendar/now.png"><%}%>
			<%fl = 1;for(int j = 0;j < li1.size();j++){if(fl <= maxDate){if((a <= j + 1 && j < 7) || (j >= 7)){
			SimpleDateFormat df = new SimpleDateFormat("dd");
			String day = df.format(currentTime);
			if(fl == Integer.parseInt(day)){if(pageIndex == pages.getPageTotal()){%><img style="position:absolute;left:<%=sx + 6 %>px;top:<%=sy + 20%>px;width:15px;height:15px;z-index:10" src="images/application/pages/calendar/now.png"><%}}%>
			<%if(m.get((String.valueOf(fl).length() == 2 ? fl : "0" + fl) + "|1") != null && m.get((String.valueOf(fl).length() == 2 ? fl : "0" + fl) + "|0") != null){%><img style="position:absolute;left:<%=sx + sw / 2 + 5 %>px;top:<%=sy + sh / 2 - 25 %>px;width:39px;height:42px;z-index:7" src="images/application/pages/calendar/as.png"><%} else{if(m.get((String.valueOf(fl).length() == 2 ? fl : "0" + fl) + "|1") != null){%>
			<img style="position:absolute;left:<%=sx + sw / 2 + 20 %>px;top:<%=sy + sh / 2 - 25 %>px;width:23px;height:40px;z-index:7" src="images/application/pages/calendar/spe.png"><%} else if(m.get((String.valueOf(fl).length() == 2 ? fl : "0" + fl) + "|0") != null){%><img style="position:absolute;left:<%=sx + sw / 2 + 20 %>px;top:<%=sy + sh / 2 - 25 %>px;width:23px;height:40px;z-index:7" src="images/application/pages/calendar/act.png"><%}}%>
			<%int f = 0;for(int k = 0;k < lid.size();k++){if(lid.get(k).get("ctype").toString().equals("0") && lid.get(k).get("dtime").toString().substring(0, 10).replaceAll("-", "").equals(year + ((month + 1) > 10 ? "" + (month + 1) : "0" + (month + 1)) + (fl > 10 ? "" + fl : "0" + fl))){%><img style="position:absolute;left:<%=sx + 3 %>px;top:<%=sy + 18 %>px;width:<%=sw - 6 %>px;height:<%=sh - 20.5 %>px;z-index:4" src="images/<%=style.split("\\/")[0]%>/photos/recommend/<%=allName%>/festival/<%=year + ((month + 1) > 10 ? "" + (month + 1) : "0" + (month + 1)) + (fl > 10 ? "" + fl : "0" + fl) %>.png">
			<img style="position:absolute;left:<%=sx + sw / 2 - 32 %>px;top:<%=sy + sh / 2 + 6 %>px;width:25px;height:23px;z-index:8" src="images/application/pages/calendar/num/<%=fl %>.png"><%f = 1;}}%>
			<%if(f == 0){%><img style="position:absolute;left:<%=sx + sw / 2 - 32 %>px;top:<%=sy + sh / 2 - 30 %>px;width:64px;height:59px;z-index:5" src="images/application/pages/calendar/num/<%=fl %>.png"><%}f=0;%>
			<img id="<%=allName + (j + 1) %>" style="position:absolute;left:<%=sx %>px;top:<%=sy %>px;width:<%=sw %>px;height:<%=sh %>px;z-index:5" src="images/application/pages/calendar/rl.png">
			<img id="f_<%=allName + (j + 1) %>" style="position:absolute;left:<%=sx %>px;top:<%=sy %>px;width:<%=sw %>px;height:<%=sh %>px;z-index:6;visibility:hidden" src="images/application/pages/calendar/focus/f_rl.png"><%fl++;} sx += sl;if((j + 1) % 7 == 0){sx = rsx;sy += st;}}}%>
			
			
			
			<!-- 优先加载小视频垫图 -->
			<img id='backDis' src='images/application/pages/free/loading.png' style='position:absolute;width:280px;height:157px;visibility:hidden'>
			<script type='text/javascript' src='javascript/player/player_small.js?r=<%=Math.random() %>'></script>
		</div><%@include file="common/footer.jsp" %>