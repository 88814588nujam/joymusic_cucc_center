// 公共iframe:opera,用于异步处理
document.write('<iframe id=\'opera\' src=\'\' style=\'width:0px;height:0px\' frameborder=\'0\'></iframe>');
// 测试打印使用的div
document.write('<div id=\'test\' style=\'position:absolute;left:20px;top:20px;width:0px;height:0px;font-size:24px;color:#FFFFFF;z-index:9999\'></div>');
// 插入公共CSS
var new_element = document.createElement('style');
new_element.innerHTML = ('.btn_focus_visible{transform:scale(1.01);transition:all 0.3s ease-in-out 0s;position:absolute;visibility:visible}');
new_element.innerHTML += ('.btn_focus_hidden{visibility:hidden}');
document.body.appendChild(new_element);

// 返回该id组件对象
function $g(id){
	return document.getElementById(id);
}

// 判断该id组件是否存在
function $gg(id){
	if(!id) return false;
	var obj = document.getElementById(id);
	if(obj) return true;
	else return false;
}

// test_div打印
function t0(str){
	$g('test').innerHTML = str;
}

// test_div中追加打印
function t1(str){
	$g('test').innerHTML += '<br/>' + str;
}

// 改变test_div的css
function tcss(str){
	$g('test').style.cssText = str;
}

// 返回元素所在数组的下标
function getRealIdx(idx, arr){
	var rtIdx = idx;
	for(var i = 0; i < arr.length; i++){
		if(arr[i] == rtIdx){
			return i + 1;
		}
	}
	return rtIdx;
}

// 提取元素中的数字
function getIdx(f, s){
	return Number(f.substr(s.length, f.length - 1));
}

// 删除数组中指定元素
function remove(arr, item){
	var ret = new Array();
	for(var i = 0; i < arr.length; i++){
		if(arr[i] != item){
			ret.push(arr[i]);
		}
	}
	return ret;
}

// 判断数组中是否有指定元素
function exist(arr, item){
	for(var i = 0; i < arr.length; i++){
		if(arr[i] == item){
			return true;
		}
	}
	return false;
}

// 将arr1数组的数据载入arr0中
function addToArr(arr0, arr1){
	for(var i = 0; i < arr1.length; i++){
		arr0.push(arr1[i]);
	}
}

// 设置cookie(尽量减少使用)
function SetCookie(name, value, expires, path, domain, secure) {
	var expDays = expires * 24 * 60 * 60 * 1000;
	var expDate = new Date();
	expDate.setTime(expDate.getTime() + expDays);
	var expString = ((expires == null || expires == 0) ? '' : (';expires=' + expDate.toGMTString()));
	var pathString = ((path == null || path == '') ? '' : (';path=' + path));
	var domainString = ((domain == null || domain == '') ? '' : (';domain=' + domain));
	var secureString = ((secure == true) ? ';secure' : '');
	document.cookie = name + '=' + escape(value) + expString + pathString + domainString + secureString;
}

// 获取cookie
function GetCookie(name) { 
	var result = null;
	var myCookie = document.cookie + ';';
	var searchName = name + '=';
	var startOfCookie = myCookie.indexOf(searchName);
	var endOfCookie;
	if (startOfCookie != -1) {
		startOfCookie += searchName.length;
		endOfCookie = myCookie.indexOf(';', startOfCookie);
		result = unescape(myCookie.substring(startOfCookie, endOfCookie));
	}
	return result;
}

// 清除cookie
function ClearCookie(name) {
	var ThreeDays = 3 * 24 * 60 * 60 * 1000;
	var expDate = new Date();
	expDate.setTime(expDate.getTime() - ThreeDays);
	document.cookie = name + '=;expires=' + expDate.toGMTString();
}

// 格式化时间
function formatSeconds(value) {
	var result = '';
    var seconds = parseInt(value);
    var minutes = 0;
    var hours = 0;
    if(seconds > 60) {
        minutes = parseInt(seconds / 60);
        seconds = parseInt(seconds % 60);
		if(minutes > 60) {
            hours = parseInt(minutes / 60);
            minutes = parseInt(minutes % 60);
		}
    }
	if(seconds < 10){
		result = '0' + parseInt(seconds) + '';
	} else{
		result = '' + parseInt(seconds) + '';
	}
	if(minutes > 0){
		if(minutes < 10){
			result = '0' + parseInt(minutes) + ':' + result;
		} else{
			result = '' + parseInt(minutes) + ':' + result;
		}
	} else{
		result = '00:' + result;
	}
	if(hours > 0){
		result = '' + parseInt(hours) + ':' + result;
	}
	if(result == '00:60') result = '01:00';
	return result;
}

// 横向非动画帧封装
function nextDirectX(id, target, fun){
	var ele = $g(id);
	ele.style.left = target + 'px'; // 直接移动指定位置
	eval(fun());
}

// 横向缓动动画封装
function nextSlideX(id, target, speed, fun){
	var ele = $g(id);
	clearInterval(ele.timer); // 清除历史定时器
	ele.timer = setInterval(function(){
		// 获取步长 确定移动方向(正负值) 步长应该是越来越小的，缓动的算法。
		var step = (target - ele.offsetLeft) / 10;
		// 对步长进行二次加工(大于0向上取整,小于0项下取整)
		step = step > 0 ? Math.ceil(step) : Math.floor(step);
		// 动画原理： 目标位置 = 当前位置 + 步长
		ele.style.left = ele.offsetLeft + step + 'px';
		// 检测缓动动画有没有停止
		if(Math.abs(target - ele.offsetLeft) <= Math.abs(step)){
			ele.style.left = target + 'px'; // 直接移动指定位置
			clearInterval(ele.timer);
			eval(fun());
		}
	}, speed);
}

// 纵向非动画帧封装
function nextDirectY(id, target, fun){
	var ele = $g(id);
	// 联通有盒子top设定值有问题得强行修改
	var stbType = getVal('globle', 'stbType');
	if(stbType.indexOf('EC6108V9') > -1){
		ele.style.height = (720 * 10) + 'px';
		$g("BigDivFather").scrollTop = 0 - target;
	} else ele.style.top = target + 'px'; // 直接移动指定位置
	eval(fun());
}

// 纵向缓动动画封装
function nextSlideY(id, target, speed, fun){
	var ele = $g(id);
	clearInterval(ele.timer); // 清除历史定时器
	ele.timer = setInterval(function(){
		// 获取步长 确定移动方向(正负值) 步长应该是越来越小的，缓动的算法。
		var step = (target - ele.offsetTop) / 10;
		// 对步长进行二次加工(大于0向上取整,小于0项下取整)
		step = step > 0 ? Math.ceil(step) : Math.floor(step);
		// 动画原理： 目标位置 = 当前位置 + 步长
		ele.style.top = ele.offsetTop + step + 'px';
		// 检测缓动动画有没有停止
		if(Math.abs(target - ele.offsetTop) <= Math.abs(step)){
			ele.style.top = target + 'px'; // 直接移动指定位置
			clearInterval(ele.timer);
			eval(fun());
		}
	}, speed);
}