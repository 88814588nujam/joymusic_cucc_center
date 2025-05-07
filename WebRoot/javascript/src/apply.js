var ifTime = 0;

var startApply = function(){
	var songId = playList[nowRealPlay].songId;
	var toUrl = 'pay.jsp?o=10&u=' + userid + '&i=' + userip + '&s=' + songId + '&p=' + toPageId + '&k=' + key + '&c=' + cityN + '&a=' + provinceN + '&t=' + userToken + '&st=' + stbType + '&f=' + platform;
	var appIfr = document.createElement('iframe');
	appIfr.id = 'appIfr';
	appIfr.src = toUrl;
	appIfr.style.cssText = 'position:absolute;left:0px;top:0px;width:0px;height:0px';
	$g('realDis').appendChild(appIfr);
	setTimeout(function(){ getIfrFirst(); }, 100);
};

var getIfrFirst = function(){
	ifTime++;
	var pvd = '';
	try{
		pvd = window.frames.appIfr.payTypeMap.currentShowType;
	} catch(e){}
	if(!pvd || pvd == ''){
		if(ifTime < 50) setTimeout(function(){ getIfrFirst(); }, 100);
		else clearApply();
	} else{
		ifTime = 0;
		var isSupportBroadBandPay = window.frames.appIfr.isSupportBroadBandPay;
		if(isSupportBroadBandPay == '1'){ // 允许订购用户
			if(provinceN == 207 || provinceN == 208 || provinceN == 211 || provinceN == 217){
				var strCode = encodeURIComponent(frames['appIfr'].document.getElementById('verCodeImg').innerHTML);
				var qz = encodeURIComponent('../epg/sd/orderproduct/images/newOrderPage/verificationCode/');
				var num1 = strCode.substring(strCode.indexOf(qz) + qz.length, strCode.indexOf(qz) + qz.length + 1);
				strCode = strCode.substring(strCode.indexOf(qz) + qz.length);
				var num2 = strCode.substring(strCode.indexOf(qz) + qz.length, strCode.indexOf(qz) + qz.length + 1);
				strCode = strCode.substring(strCode.indexOf(qz) + qz.length);
				var num3 = strCode.substring(strCode.indexOf(qz) + qz.length, strCode.indexOf(qz) + qz.length + 1);
				strCode = strCode.substring(strCode.indexOf(qz) + qz.length);
				var num4 = strCode.substring(strCode.indexOf(qz) + qz.length, strCode.indexOf(qz) + qz.length + 1);
				frames['appIfr'].document.getElementById('verificationCodeValue').innerText = '' + num1 + num2 + num3 + num4;
				frames['appIfr'].keyPressNameHandler('KEY_DOWN');
				frames['appIfr'].keyPressNameHandler('KEY_ENTER');
				setTimeout(function(){ getIfrSecond(); }, 100);
			} else if(provinceN == 214){
				frames['appIfr'].commonKeyDealProcess.keyPressNameHandler('KEY_DOWN');
				frames['appIfr'].commonKeyDealProcess.keyPressNameHandler('KEY_DOWN');
				frames['appIfr'].commonKeyDealProcess.keyPressNameHandler('KEY_RIGHT');
				setTimeout(function(){
					var strCode = encodeURIComponent(frames['appIfr'].document.getElementById('verCode').innerHTML);
					var qz = encodeURIComponent('../epg/sd/orderproduct/images/newOrderPage/verificationCode/');
					var num1 = strCode.substring(strCode.indexOf(qz) + qz.length, strCode.indexOf(qz) + qz.length + 1);
					frames['appIfr'].inputBox(num1);
					strCode = strCode.substring(strCode.indexOf(qz) + qz.length);
					var num2 = strCode.substring(strCode.indexOf(qz) + qz.length, strCode.indexOf(qz) + qz.length + 1);
					frames['appIfr'].inputBox(num2);
					strCode = strCode.substring(strCode.indexOf(qz) + qz.length);
					var num3 = strCode.substring(strCode.indexOf(qz) + qz.length, strCode.indexOf(qz) + qz.length + 1);
					frames['appIfr'].inputBox(num3);
					strCode = strCode.substring(strCode.indexOf(qz) + qz.length);
					var num4 = strCode.substring(strCode.indexOf(qz) + qz.length, strCode.indexOf(qz) + qz.length + 1);
					frames['appIfr'].inputBox(num4);
					frames['appIfr'].commonKeyDealProcess.keyPressNameHandler('KEY_ENTER');
					setTimeout(function(){ getIfrSecond(); }, 100);
				}, 500);
			} else {
				window.frames.appIfr.payTypeMap.currentShowType = 'boradPay';
				var areaCode = getVal('globle','areaCode');
				if(areaCode == 201) frames['appIfr'].sendOrderPageDataNotify(2, 3, 0, 2);
				else frames['appIfr'].sendOrderPageDataNotify(1, 3, 1, 2);
				frames['appIfr'].boPay();
				setTimeout(function(){ getIfrSecond(); }, 100);
			}
		}
	}
}

var getIfrSecond = function(){
	ifTime++;
	var pvd = '';
	try{
		pvd = window.frames.appIfr.CI;
	} catch(e){}
	if(!pvd || pvd == ''){
		if(ifTime < 50) setTimeout(function(){ getIfrSecond(); }, 100);
		else clearApply();
	} else{
		ifTime = 0;
		window.frames.appIfr.CI = 0;
		var tother = frames['appIfr'].location.href;
		tother = tother.substring(0, tother.indexOf('/cap'));
		var urls = tother + '/cap/iptvreinforce/redirect';
		frames['appIfr'].document.action_form.action = urls;
		var inputX = frames['appIfr'].document.createElement('input');
		inputX.id = 'action';
		inputX.name = 'CAS';
		inputX.value = 0;
		frames['appIfr'].document.getElementById('button1_div').appendChild(inputX);
		var action = frames['appIfr'].document.getElementById('action');
		frames['appIfr'].addClasss(action, 'style_none');
		frames['appIfr'].document.getElementById('form_action').click();
		frames['appIfr'].document.getElementById('action').remove();
		setTimeout(function(){ getIfrThird(); }, 100);
	}
}

var getIfrThird = function(){
	ifTime++;
	var pvd = '';
	try{
		pvd = window.frames.appIfr.code;
	} catch(e){}
	if(!pvd || pvd == ''){
		if(ifTime < 15) setTimeout(function(){ getIfrThird(); }, 100);
		else clearApply();
	} else{
		ifTime = 0;
		if(pvd == '0'){
			var nowBt = frames['appIfr'].document.getElementById('btn_ok_focus');
			frames['appIfr'].elementClick(nowBt);
		} else clearApply();
	}
}

var clearApply = function(){
	ifTime = 0;
	// 记得有ifr加载网页的时候，一定要使用该jsp还原显示大小再移除组件
	$g('appIfr').src = 'zone_change_win_1280_720.jsp';
	setTimeout(function() {
		$g('realDis').removeChild($g('appIfr'));
		realStart();
	}, 500);
}