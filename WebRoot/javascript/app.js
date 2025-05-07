/*app.js*/
var copyright = '%c';
copyright += ' JJJJJJJJJJJJJJ      OOOOOOOOOO      YYYY      YYYY\n';
copyright += ' JJJJJJJJJJJJJJ    OOOOOOOOOOOOOO     YYYY    YYYY\n';
copyright += '      JJJJ         OOOO      OOOO      YYYY  YYYY\n';
copyright += '      JJJJ         OOOO      OOOO       YYYYYYYY\n';
copyright += '      JJJJ         OOOO      OOOO        YYYYYY\n';
copyright += '      JJJJ         OOOO      OOOO         YYYY\n';
copyright += '      JJJJ         OOOO      OOOO         YYYY\n';
copyright += '    JJJJJJ         OOOOOOOOOOOOOO         YYYY\n';
copyright += '     JJJJJ           OOOOOOOOOO           YYYY\n';
console.log(copyright, 'color:#FF0000;text-shadow:15px 15px 5px #FF9900, 15px 15px 10px #FF9900, 15px 15px 15px #FF9900, 15px 15px 30px #FF9900;font-weight:bolder;font-size:12px');

if(typeof playNext === 'function'){
	// 这是一个含有播放器的页面
}

var exitApp = function(){
	var viewUrl = 'h4', opr = 1;
	// 处理直接进入播放器退出平台没有viewId退不出去异常
	if(typeof viewId == 'undefined'){
		if(userid.indexOf('browsertest') > -1){
			if(navigator.userAgent.indexOf('Firefox') > -1 || navigator.userAgent.indexOf('Chrome') > -1){
				window.location.href = 'about:blank';
				window.close();
			} else{
				window.opener = null;
				window.open('', '_self');
				window.close();
			}
		} else exitAppSTB();
	} else{
		endViewPage(viewUrl, userid, -1, -1, '', viewId, opr, function(){
			if(userid.indexOf('browsertest') > -1){
				if(navigator.userAgent.indexOf('Firefox') > -1 || navigator.userAgent.indexOf('Chrome') > -1){
					window.location.href = 'about:blank';
					window.close();
				} else{
					window.opener = null;
					window.open('', '_self');
					window.close();
				}
			} else exitAppSTB();
		});
	}
}

var exitAppSTB = function(){
	var allStr = GetCookie('allStr');
	allStr = decodeURIComponent(allStr);
	window.location.href = 'http://202.99.114.152:26800/joymusic_bs_tjlt/?' + allStr;
}

var openQrcode = function(){
	msg.type = getVal('globle', 'preferBubble');
	msg.createMsgArea($g('realDis'));
	msg.sendMsg('Coming soon!!!');
}

var postJsonLog = function(ot, or, st, fun){
	var docUrl = 'h5?u=' + userid + '&p=' + provinceN + '&s=' + stbType + '&pf=' + platform + '&ot=' + ot + '&or=' + or + '&st=' + st;
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