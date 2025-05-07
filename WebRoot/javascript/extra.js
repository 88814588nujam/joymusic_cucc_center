// 页面级用到的函数,有时候会涉及页面级参数
// 将返回地址入栈
function addToBack(nowStat){
	var jsonR = (getVal('globle', 'return') && getVal('globle', 'return') != '') ? eval('(' + getVal('globle', 'return') + ')') : new Array();
	jsonR.push(eval('(' + nowStat + ')'));
	put('globle', 'return', jsonToStr(jsonR));
}

// json本地格式化成str,由于机顶盒不一定支持JSON.stringify
function jsonToStr(arr){
	var str = '[';
	if(arr){
		for(var i = 0; i < arr.length; i++){
			if(i > 0){
				str += ',';
			}
			str += '{\'back\':[{\'target\':\'';
			str += arr[i].back[0].target + '\'},{\'params\':\'';
			str += arr[i].back[1].params + '\'}]}';
		}
	}
	str += ']';
	return str;
}

// 综合返回
function __return(){
	var returnPage = getVal('globle', 'return');
	if(returnPage){
		var jsonR = eval('(' + returnPage + ')');
		var target = jsonR[jsonR.length - 1].back[0].target;
		put('request', 'params', jsonR[jsonR.length - 1].back[1].params);
		jsonR.pop();
		put('globle', 'return', (jsonR.length == 0) ? '' : jsonToStr(jsonR));
		go(target);
	} else{
		var needQuit = getVal('globle', 'needQuit');
		if(needQuit == 'y') exitApp();
		else{
			// 如果没有返回页面则回到首页
			var toPageId = 1;
			put('request', 'params', 'i=' + toPageId);
			go(toPageId);
		}
	}
}

// AJAX请求
var xmlhttp = null;
function ajaxRequest(mtd, url, listener){
	if(window.XMLHttpRequest){
		xmlhttp = new XMLHttpRequest();
	} else if (window.ActiveXObject){
		xmlhttp = new ActiveXObject('Microsoft.XMLHTTP');
	}
	if(mtd == 'POST' || mtd == 'post'){
		if(url.indexOf('?') > -1){
			var param = url.substring(url.indexOf('?') + 1, url.length);
			url = url.substring(0, url.indexOf('?'));
		}
	}
	xmlhttp.onreadystatechange = listener;
	xmlhttp.open(mtd, url, true);
	xmlhttp.setRequestHeader('cache-control', 'no-cache');
	if(mtd == 'POST' || mtd == 'post'){
		xmlhttp.setRequestHeader('CONTENT-TYPE', 'application/x-www-form-urlencoded');
		xmlhttp.send(param);
	} else{
		xmlhttp.send();
	}
}

// 自动居中页面(pageW,pageH为页面参数)
function autoDivHeight(){
	// 获取浏览器窗口高度
	var winWidth = 0;
	var winHeight = 0;
	if(window.innerWidth){
		winWidth = window.innerWidth;
	} else if((document.body) && (document.body.clientWidth)){
		winWidth = document.body.clientWidth;
	}
	if(window.innerHeight){
		winHeight = window.innerHeight;
	} else if((document.body) && (document.body.clientHeight)){
		winHeight = document.body.clientHeight;
	}
	// 通过深入Document内部对body进行检测，获取浏览器窗口高度
	if(document.documentElement && document.documentElement.clientHeight){
		winHeight = document.documentElement.clientHeight;
	}
	var winDL = Math.floor((winWidth - pageW) / 2);
	var winDT = Math.floor((winHeight - pageH) / 2);
	$g('realDis').style.width = pageW + 'px';
	$g('realDis').style.height = pageH + 'px';
	$g('realDis').style.left = winDL + 'px';
	$g('realDis').style.top = winDT + 'px';
	$g('realDis').style.display = 'block';
}
// 框体变化事件
window.onresize = autoDivHeight; //浏览器窗口发生变化时同时变化DIV高度

// 强制设置居中页面(pageW,pageH为页面参数)
function handleDivHeight(winDL , winDT){
	$g('realDis').style.width = pageW + 'px';
	$g('realDis').style.height = pageH + 'px';
	$g('realDis').style.left = winDL + 'px';
	$g('realDis').style.top = winDT + 'px';
	$g('realDis').style.display = 'block';
}

// 首页中的时钟计时
function getNowFormatDate(twinkle){
	var date = new Date();
	var strHour = date.getHours();
	var strMin = date.getMinutes();
	if(strHour >= 0 && strHour <= 9){
		strHour = '0' + strHour;
	}
	var h1 = (strHour + '').split('')[0];
	var h2 = (strHour + '').split('')[1];
	if(strMin >= 0 && strMin <= 9){
		strMin = '0' + strMin;
	}
	var min1 = (strMin + '').split('')[0];
	var min2 = (strMin + '').split('')[1];
	$g('nTime01').src = 'images/application/utils/timenum/' + h1 + '.png';
	$g('nTime02').src = 'images/application/utils/timenum/' + h2 + '.png';
	$g('twinkle').src = 'images/application/utils/timenum/colon.png';
	$g('nTime03').src = 'images/application/utils/timenum/' + min1 + '.png';
	$g('nTime04').src = 'images/application/utils/timenum/' + min2 + '.png';
	if(twinkle % 2 == 0) $g('twinkle').style.visibility = 'hidden';
	else $g('twinkle').style.visibility = 'visible';
}

// 歌曲异步加入已选队列
function operaChecked(curl, sid, uid, tim, max, opr, fun){
	var docUrl = curl + '?s=' + sid + '&u=' + uid + '&t=' + tim + '&m=' + max + '&o=' + opr;
	ajaxRequest('POST', docUrl, function(){
		if(xmlhttp.readyState == 4){
			if(xmlhttp.status == 200){
				var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
				var contentJson = eval('(' + retText + ')');
				eval(fun(contentJson));
				// 同步websocket上绑定用户的已选
				var remote = getVal('globle', 'remote');
				if(remote > 0){
					if(opr == 0){
						if(sid) WXSendMsg('dele,1');
						else WXSendMsg('dela,1');
					} else if(opr == 1){
						if(sid) WXSendMsg('adds,0');
						else WXSendMsg('adda,0');
					}
				}
			}
		}
	});
}

// 歌曲|歌手异步加入收藏队列
function operaCollect(curl, sid, uid, tpy, opr, fun){
	var docUrl = curl + '?s=' + sid + '&u=' + uid + '&c=' + tpy + '&o=' + opr;
	ajaxRequest('POST', docUrl, function(){
		if(xmlhttp.readyState == 4){
			if(xmlhttp.status == 200){
				var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
				var contentJson = eval('(' + retText + ')');
				eval(fun(contentJson));
				// 同步websocket上绑定用户的收藏
				var remote = getVal('globle', 'remote');
				if(remote > 0){
					if(tpy == 0){
						if(sid) WXSendMsg('acol,' + sid);
						else WXSendMsg('cola,1');
					} else if(tpy == 1){
						if(sid) WXSendMsg('coll,' + sid);
						else WXSendMsg('cola,0');
					}
				}
			}
		}
	});
}

// 记录用户开始访问某页面
function startViewPage(curl, uip, uid, cty, pid, key, otr, opr, fun){
	var docUrl = curl + '?i=' + uip + '&u=' + uid + '&c=' + cty + '&p=' + pid + '&k=' + key + '&m=' + otr + '&o=' + opr;
	ajaxRequest('POST', docUrl, function(){
		if(xmlhttp.readyState == 4){
			if(xmlhttp.status == 200){
				var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
				var contentJson = eval('(' + retText + ')');
				eval(fun(contentJson));
			}
		}
	});
}

// 记录用户结束访问某页面
function endViewPage(curl, uid, idx, pid, key, viw, opr, fun){
	var docUrl = curl + '?u=' + uid + '&f=' + idx + '&p=' + pid + '&k=' + key + '&v=' + viw + '&o=' + opr;
	ajaxRequest('POST', docUrl, function(){
		if(xmlhttp.readyState == 4){
			if(xmlhttp.status == 200){
				var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
				var contentJson = eval('(' + retText + ')');
				eval(fun(contentJson));
			}
		}
	});
}

// 按照指定顺序获取播放队列
function getSongSids(arr, idx){
	var ids = '';
	for(var i = 0; i < arr.length; i++){
		if(i >= idx) ids += arr[i].sid + ',';
	}
	for(var i = 0; i < arr.length; i++){
		if(i < idx) ids += arr[i].sid + ',';
	}
	if(ids.indexOf(',') > -1) ids = ids.substr(0, ids.length - 1);
	return ids;
}

// 安装APK版
function installApk(appName, className, apkUrl, info, flag){
	tcss('position:absolute;left:20px;top:20px;width:400px;height:40px;font-size:24px;line-height:40px;color:#FFFFFF;background:#000000;z-index:9999');
	t0('Start_to_install_APK......');
	var jsdata= '{\'intentType\':0,\'appName\': \'' + appName + '\',\'className\': \'' + className + '\',\'extra\': [{\'name\': \'INFO\',\'value\': \'' + info + '\'}]}'; 
	if(STBAppManager.isAppInstalled(appName) && !flag){ // 已安装APK则直接打开APK
		t0('Starting_APK......');
		STBAppManager.startAppByIntent(jsdata); 
	} else{ // 未安装APK则安装APK
		t0('Installing_APK......');
		STBAppManager.installApp(apkUrl);
		var time = setInterval(function(){
			if(STBAppManager.isAppInstalled(appName)){
				clearInterval(time);
				STBAppManager.startAppByIntent(jsdata);
			} else{
				t0('Loading_APK......');
				// tcss('position:absolute;left:20px;top:20px;width:0px;height:0px;font-size:24px;color:#FFFFFF;z-index:9999');
			}
		}, 1000);
	}
}