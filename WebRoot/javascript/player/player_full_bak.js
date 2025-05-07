var vol_prefix = 'circle';
document.write('<img src=\'images/application/player/vol/' + vol_prefix + '/v0.png\' style=\'position:absolute;left:0px;top:0px;z-index:10;visibility:hidden\'>');
document.write('<img src=\'images/application/player/vol/' + vol_prefix + '/v1.png\' style=\'position:absolute;left:0px;top:0px;z-index:10;visibility:hidden\'>');
document.write('<img src=\'images/application/player/vol/' + vol_prefix + '/v2.png\' style=\'position:absolute;left:0px;top:0px;z-index:10;visibility:hidden\'>');
document.write('<img src=\'images/application/player/vol/' + vol_prefix + '/v3.png\' style=\'position:absolute;left:0px;top:0px;z-index:10;visibility:hidden\'>');
document.write('<img src=\'images/application/player/vol/' + vol_prefix + '/v4.png\' style=\'position:absolute;left:0px;top:0px;z-index:10;visibility:hidden\'>');
document.write('<img src=\'images/application/player/vol/' + vol_prefix + '/v5.png\' style=\'position:absolute;left:0px;top:0px;z-index:10;visibility:hidden\'>');
document.write('<img src=\'images/application/player/vol/' + vol_prefix + '/v6.png\' style=\'position:absolute;left:0px;top:0px;z-index:10;visibility:hidden\'>');
document.write('<img src=\'images/application/player/vol/' + vol_prefix + '/v7.png\' style=\'position:absolute;left:0px;top:0px;z-index:10;visibility:hidden\'>');
document.write('<img src=\'images/application/player/vol/' + vol_prefix + '/v8.png\' style=\'position:absolute;left:0px;top:0px;z-index:10;visibility:hidden\'>');
document.write('<img src=\'images/application/player/vol/' + vol_prefix + '/v9.png\' style=\'position:absolute;left:0px;top:0px;z-index:10;visibility:hidden\'>');
document.write('<img src=\'images/application/player/vol/' + vol_prefix + '/v10.png\' style=\'position:absolute;left:0px;top:0px;z-index:10;visibility:hidden\'>');
document.write('<div id=\'statusPly\' style=\'position:absolute;left:0px;top:0px;width:0px;height:0px;z-index:100;text-align:center\'></div>');
document.write('<div id=\'pbar\' style=\'position:absolute;left:0px;top:0px;width:0px;height:4px;z-index:-10;background:#FF8100\'></div>');
// 四川移动播放器得使用embed标签和对应的javascript组件播放
document.write('<script language=\'javascript\' src=\'javascript/player/sichuanCmccPlayer.js\'></script>');
document.write('<div id=\'player\' style=\'position:absolute;left:0px;top:0px;width:0px;height:0px;visibility:hidden;z-index:999\'></div>');
// 全屏播放器
var playLeft = 0; // 播放左边距
var playTop = 0; // 播放上边距
var playWidth = 1280; // 播放宽度
var playHeight = 720; // 播放高度
var playSpeed = 1; // 播放速度,可以通过API获取(1是正常播放速度)
var muteFlag = 0; // 播放是否静音
var playChannel = 0; // 0:原唱 1:伴唱
var playVol = 0; // 播放声音,可以通过API获取
var nowPlay = 0; // 当前播放曲目下标 - 下一个播放曲目下标
var nowRealPlay = 0; // 当前播放曲目真正的下标
var playCurTime = 0; // 当前播放时长
var playDuration = 0; // 当前歌曲总长
var playStat = 1; // 播放状态 0:暂停 1:播放 2:快退 3:快进
var nowMenu = 0; // 0:全部隐藏 1:底部菜单 2:右侧list
var vfocus = 'ele2'; // 焦点选中
var lfocus = 'p1'; // list焦点选中
var isEnd = 0; // 控制弹出菜单的必要控制其二
var mode = 1; // 播放模式 1:全部循环 2:单曲循环 3:随机循环
var tryTime = 0;
var flagEnd = false; // 控制弹出菜单的必要控制其一
var delayTimes;
var delayTimesList;
var delayTimesAuto;
var joymusicPlayer;
var joymusicPlayerID;

// 获取完毕网络资源后返回播放地址从而进行播放
function getWebUrlResult(){
	var cfree = playList[nowRealPlay].cfree;
	if(isOrder != '0' && cfree == '1'){ // 播放每一首歌曲之前首先进行一次鉴权和判断是否免费歌曲 free是否免费  0:免费 1:收费    isOrder 0:是
		goAuthOrder();
		return;
	} else{
		// 通知小程序用户进行底部播放弹出
		var remote = getVal('globle', 'remote');
		if(remote > 0){
			if(typeof websocket == 'object'){
				var msg = JSON.stringify(playList[nowRealPlay]);
				var content = playList[nowRealPlay].songId;
				var cname = playList[nowRealPlay].songName;
				var artist = playList[nowRealPlay].singer;
				var domainName = getVal('globle', 'domainName');
				var picPath = 'https://' + domainName + '/TXDC/';
				var nowPic = playList[nowRealPlay].pic;
				nowPic = nowPic.substring(nowPic.indexOf('artist/'), nowPic.length);
				var pic = picPath + 'images/' + nowPic;
				var jsonInfo = {
					'content' : content,
					'cname' : cname,
					'artist' : artist,
					'pic' : pic
				};
				var newMsg = 'info,' + JSON.stringify(jsonInfo);
				console.log(newMsg);
				WXSendMsg(newMsg);
			}
		}
		allowClick = true;
		var player = $g('player');
		if($gg('radioPlayer')) player.removeChild($g('radioPlayer'));
		var playerEle = document.createElement('embed');
		playerEle.setAttribute('id', 'radioPlayer');
		playerEle.setAttribute('autostart', 'true');
		playerEle.setAttribute('hidden', 'no');
		playerEle.setAttribute('loop', 'false');
		playerEle.setAttribute('width', '1280');
		playerEle.setAttribute('height', '720');
		playerEle.setAttribute('type', 'application/yst-player');
		playerEle.setAttribute('style', 'position:absolute;width:1280px;height:720px;margin-top:0px;margin-left:0px');
		player.appendChild(playerEle);
	}
	if(playList.length > 0){
		queryRealRes(playList[nowRealPlay].cres);
		var innerStr = playList[nowRealPlay].songName;
		if(getBytesLength(innerStr) > 28) $g('np').innerHTML = "<marquee behavior='alternate' scrollamount='1'>" + innerStr + "</marquee>";
		else $g('np').innerHTML = innerStr;
		$g('npa').innerHTML = playList[nowRealPlay].singer;
		$g('cpic').src = playList[nowRealPlay].pic;
		if(collectStr.indexOf(playList[nowRealPlay].songId) > -1){
			$g('ele4_b').src = 'images/application/player/theme/classic/ui_huge/collect0.png';
			$g('ele4').src = 'images/application/player/theme/classic/ui_huge/focus/f_collect0.png';
		} else{
			$g('ele4_b').src = 'images/application/player/theme/classic/ui_huge/collect.png';
			$g('ele4').src = 'images/application/player/theme/classic/ui_huge/focus/f_collect.png';
		}
		var cP = nowRealPlay + 1; // 本首歌曲实际在播放队列的位数(播放下标加1)
		if(cP == playList.length) nowPlay = 0;
		else nowPlay = cP;
		if(mode == 1) $g('ns').innerHTML = words[0] + playList[nowPlay].songName + ' - ' + playList[nowPlay].singer;
		else if(mode == 2) $g('ns').innerHTML = words[1];
	} else{
		$g('begin').style.display = 'none';
		$g('status').style.display = 'none';
		isEnd = 0;
		setTimeout('exitPlayer()', 500);
	}
}

// 真正播放器需要通过JS API获得播放码才能播放
function queryRealRes(res){
	res = JSON.parse(res);
	res = platform == 1 ? res.zx : res.hw;
	var opt = {
		'id' : 'radioPlayer',
		'url' : res,
		timeout : 120, // 超时时间
		beginTime : 0, // 开始播放时间
		onReady : cathStateReady, // 进入准备状态的回调函数
		onPlay : cathStatePlay, // 进入播放状态的回调函数
		onBuffer : catchStateBuffer, // 进入缓冲状态时的回调函数
		onBufferComplete : catchStateBufferComplete, // 缓冲状态完成时的回调函数
		onPause : catchStatePause, // 进入暂停状态的回调函
		onStop : catchStateStop, // 手动停止视频的回调函数
		onOver : catchStateOver, // 视频播放结束时的回调函数
		onException : catchStateException, // 发生异常时的回调函数
		onError : catchStateErr, // 发生错误时的回调函数
		onStatusChange : catchStateChange 	// 状态改变时的回调函数
	};
	try{
		playerCore.ready(opt);
	} catch(e){}
	if(delayTimesAuto > -1){
		clearInterval(delayTimesAuto); 
		delayTimesAuto = -1;
	}
	delayTimesAuto = setInterval('autoRecord()', 500);
}

function cathStateReady(){
    // 进入准备状态的回调函数 第一次进入视频
    // hide('dataLoad');
};
function cathStatePlay(){
    // 进入播放状态的回调函数
	// hide('dataLoad');
    // hide('playerPauseAd');
};
function catchStateBuffer(){
    // 进入缓冲状态时的回调函数
	// show('dataLoad');
};
function catchStateBufferComplete(){
    // 缓冲状态完成时的回调函数
	// hide('dataLoad');
};
function catchStatePause(){
    // 进入暂停状态的回调函
    // hide('dataLoad');
    // show('playerPauseAd');
};
function catchStateStop(){
    // 手动停止视频的回调函数
};
function catchStateOver(){
    // 视频播放结束时的回调函数
	changeSong();
};
function catchStateException(){
    // 发生异常时的回调函数
    changeSong();
};
function catchStateChange(){
    // 状态改变时的回调函数
};
function catchStateErr(){
    //发生错误时的回调函数
	changeSong();
};

// 计时器
function autoRecord(){
	try{
		playCurTime = Number(playerCore.getCurrentTime());
		if(!playCurTime) playCurTime = 0;
		playDuration = Number(playerCore.getTotalTime());
		if(!playDuration) playDuration = 0;
	    var realFormatTime = formatSeconds(playCurTime) + ' / ' + formatSeconds(playDuration); // 格式化时间倒数计时
	    if(playDuration == 0) $g('pbar').style.width = '0px';
	    else $g('pbar').style.width = Math.ceil(Number(playCurTime / playDuration * 1280)) + 'px';
	    $g('rt').innerHTML = realFormatTime;
	} catch(e){}
	if(playDuration > 0){
		if(!startLog){
			startLog = true;
			startPlayLog(playList[nowRealPlay].songId);
		}
	}
}

// 静音
function volMute(){
	try{
		if(muteFlag == 0){
			playerCore.setMute(true);
			muteFlag = 1;
			showStatus('images/application/player/theme/classic/vol/v0.png', 0);
		} else{
			playerCore.setMute(false);
			muteFlag = 0;
			var playVol = playerCore.getVolume();
			playVol = parseInt(playVol / 10);
			if(playVol >= 10) playVol = 10;
			if(playVol <= 0) playVol = 0;
			showStatus('images/application/player/theme/classic/vol/v' + playVol + '.png', 0);
		}
	} catch(e){}
}

// 音量+
function volUp(){
	try{
		var playVol;
		playVol = playerCore.getVolume();
		if(playVol <= 100){
			playVol = playVol + 10;
			playerCore.setVolume(playVol);
		}
		playVol = parseInt(playVol / 10);
		if(playVol >= 10) playVol = 10;
		if(playVol <= 0) playVol = 0;
		showStatus('images/application/player/theme/classic/vol/v' + playVol + '.png', 0);
		muteFlag = 0;
	} catch(e){}
}

// 音量-
function volDown(){
	try{
		var playVol;
		playVol = playerCore.getVolume();
		if(playVol >= 0){
			playVol = playVol - 10;
			playerCore.setVolume(playVol);
		}
		playVol = parseInt(playVol / 10);
		if(playVol >= 10) playVol = 10;
		if(playVol <= 0) playVol = 0;
		showStatus('images/application/player/theme/classic/vol/v' + playVol + '.png', 0);
		muteFlag = 0;
	} catch(e){}
}

// 暂停或者播放
function pauseOrPlay(){
	if(playStat == 2 || playStat == 3) resume();
	else if(playStat == 0) resume();
	else pause();
	// 通知小程序用户
	var remote = getVal('globle', 'remote');
	if(remote > 0){
		if(typeof websocket == 'object'){
			// 记得给小程序同步消息
			WXSendMsg('popo,' + playStat);
		}
	}
}

// 暂停
function pause(){
	playerCore.pause();
	playSpeed = 1;
	playStat = 0;
	if(playStat == 1){
		$g('ele2_b').src = 'images/application/player/theme/classic/ui_huge/pause.png';
		$g('ele2').src = 'images/application/player/theme/classic/ui_huge/focus/f_pause.png';
	} else{
		$g('ele2_b').src = 'images/application/player/theme/classic/ui_huge/play.png';
		$g('ele2').src = 'images/application/player/theme/classic/ui_huge/focus/f_play.png';
	}
	showStatus('images/application/player/theme/classic/status/p0.png', 0);
}

// 继续播放
function resume(){
	playerCore.resume();
	playSpeed = 1;
	playStat = 1;
	if(playStat == 1){
		$g('ele2_b').src = 'images/application/player/theme/classic/ui_huge/pause.png';
		$g('ele2').src = 'images/application/player/theme/classic/ui_huge/focus/f_pause.png';
	} else{
		$g('ele2_b').src = 'images/application/player/theme/classic/ui_huge/play.png';
		$g('ele2').src = 'images/application/player/theme/classic/ui_huge/focus/f_play.png';
	}
	showStatus('images/application/player/theme/classic/status/p.png', 0);
}

// 快进
function fastForward(){
	playStat = 3;
	playDuration = Number(playerCore.getTotalTime());
	if(playCurTime < playDuration){
		addTime = Math.ceil(playDuration * 13 / 1280);
		playCurTime = playCurTime + addTime;
		var progressNum = 0;
		if(playDuration == 0) progressNum = 0;
		else progressNum = playCurTime / playDuration * 1280;
		var tempLen = progressNum;
		if(tempLen >= 1280){
			tempLen = 1280;
			$g('pbar').style.width = '1280px';
		} else{
			playerCore.seekByTime(playCurTime);
			$g('pbar').style.width = Math.ceil(Number(progressNum)) + 'px';
		}
	}
	if(playCurTime > playDuration){
		playCurTime = playDuration;
	}
	var realTime = formatSeconds(playCurTime) + ' / ' + formatSeconds(playDuration); // 格式化时间倒数计时
	$g('rt').innerHTML = realTime;
	showStatus('images/application/player/theme/classic/status/n.png', 0);
	if(playSpeed == 1){
		$g('ele2_b').src = 'images/application/player/theme/classic/ui_huge/pause.png';
		$g('ele2').src = 'images/application/player/theme/classic/ui_huge/focus/f_pause.png';
	} else{
		$g('ele2_b').src = 'images/application/player/theme/classic/ui_huge/play.png';
		$g('ele2').src = 'images/application/player/theme/classic/ui_huge/focus/f_play.png';
	}
	playStat = 1;
}

// 快退
function fastRewind(){
	playStat = 2;
	playDuration = Number(playerCore.getTotalTime());
	if(playCurTime > 0){
		var sexTime = playCurTime - 10;
		addTime = Math.ceil(playDuration * 13 / 1280);
		playCurTime = playCurTime - addTime;
		var progressNum = 0;
		if(playDuration == 0) progressNum = 0;
		else progressNum = playCurTime / playDuration * 1280;
		var tempLen = progressNum;
		if(tempLen >= 1280){
			tempLen = 1280;
			$g('pbar').style.width = '0px';
		} else{
			playerCore.seekByTime(playCurTime);
			$g('pbar').style.width = Math.ceil(Number(progressNum)) + 'px';
		}
	}
	showStatus('images/application/player/theme/classic/status/l.png', 0);
	if(playSpeed == 1){
		$g('ele2_b').src = 'images/application/player/theme/classic/ui_huge/pause.png';
		$g('ele2').src = 'images/application/player/theme/classic/ui_huge/focus/f_pause.png';
	} else{
		$g('ele2_b').src = 'images/application/player/theme/classic/ui_huge/play.png';
		$g('ele2').src = 'images/application/player/theme/classic/ui_huge/focus/f_play.png';
	}
	playStat = 1;
}

// 设置播放进度
function setPlayCurTime(nowTime, playStat, playSpeed){
	var changeTime = playSpeed * baseTime; //改变时长= 快进快退倍数 x 基准时间
	var newTime = 0;
	if(playStat == 2){ // 快退
		if(changeTime >= nowTime) newTime = 0;
		else newTime = nowTime - changeTime;
		playerCore.seekByTime(newTime);
	} else if(playStat == 3){ // 快进
		if((changeTime + nowTime) >= playDuration) newTime = playDuration;
		else newTime = nowTime + changeTime;
		playerCore.seekByTime(newTime);
	}
	//设置完更新当前播放时间
	playCurTime = Number(playerCore.getCurrentPlayTime());
}

// 循环迭代声道
function setRealChannel(tarChannel){
	tryTime++;
	if(tryTime == 10){
		tryTime = 0;
		return;
	}
	try{
		var curChannel = playerCore.getCurrentAudioChannel();
		if(curChannel != tarChannel){
			playerCore.switchAudioChannel();
			setRealChannel(tarChannel);
		} else tryTime = 0;
	} catch(e){}
}

// 原伴唱切换
function changeChannel(){
	if(playChannel == 0){ // 从原唱切换到伴唱
		playChannel = 1;
		setRealChannel('Left');
		showStatus('images/application/player/theme/classic/status/sta_channel.png', 0);
		$g('ele5_b').src = 'images/application/player/theme/classic/ui_huge/channel.png';
		$g('ele5').src = 'images/application/player/theme/classic/ui_huge/focus/f_channel.png';
	} else if(playChannel == 1){ // 从伴唱切换到原唱
		playChannel = 0;
		setRealChannel('Right');
		showStatus('images/application/player/theme/classic/status/sta_channel0.png', 0);
		$g('ele5_b').src = 'images/application/player/theme/classic/ui_huge/channel0.png';
		$g('ele5').src = 'images/application/player/theme/classic/ui_huge/focus/f_channel0.png';
	}
}

// 显示状态
var loadStime;
function showStatus(pic, stime){
	if(loadStime > -1){
		clearTimeout(loadStime);
		loadStime = -1;
	}
	var temp = "<img id='statusPic' src='" + pic + "'>";
	$g('status').innerHTML = temp;
	var staWidth = $g('statusPic').offsetWidth;
	var staHeight = $g('statusPic').offsetHeight;
	var staLeft = (1280 - staWidth) / 2;
	var staTop = (720 - staHeight) / 2;
	$g('status').style.width = staWidth + 'px';
	$g('status').style.height = staHeight + 'px';
	$g('status').style.left = staLeft + 'px';
	$g('status').style.top = staTop + 'px';
	if(stime < 5000) stime = 5000;
	if(!loadStime || loadStime < 0){
		loadStime = setTimeout(function(){
			$g('status').innerHTML = '';
			$g('status').style.width = '0px';
			$g('status').style.height = '0px';
			$g('status').style.left = '0px';
			$g('status').style.top = '0px';
			clearTimeout(loadStime);
			loadStime = -1;
		}, stime);
	}
}

// 销毁播放器
function destoryMP(){
	try{
		playerCore.stop();
	} catch(e){}
}

// 盒子捕获媒体播放完毕事件
// 由虚拟按键事件捕获，0x0300
function goUtility(){
	var retdata = -1;
	eval('eventJson = ' + Utility.getEvent());
	var typeStr = eventJson.type;
	switch(typeStr){
		case 'EVENT_MEDIA_ERROR':
			break;
		case 'EVENT_MEDIA_END':
			retdata = 0; // 如果媒体播放完成或出错
			break;
		case 'EVENT_MEDIA_BEGINING':
			resume();
			retdata = 1; // 快退到头了
			break;
		default:
			retdata = 2;
			break;
	}
	return retdata;
}

// 切换曲目
function changeSong(){
	endPlayLog(1, playCurTime, function(){
		realChangeSong();
	});
}

// 真正切换曲目
function realChangeSong(){
	if(mode != 2){ // 非单曲循环模式就要改一下播放下标
		var cRealP = nowRealPlay + 1; // 本首歌曲实际在播放队列的位数(播放下标加1)
		if(cRealP == playList.length) nowRealPlay = 0;
		else nowRealPlay++;
	}
	getWebUrlResult();
}

// 重唱
function replay(){
	endPlayLog(1, playCurTime, function(){
		getWebUrlResult();
	});
}

// 收藏歌曲
function collectSong(){
	var dataUrl = 'h2';
	var sid = playList[nowRealPlay].songId;
	var opr = 2;
	var tpy = 1;
	operaCollect(dataUrl, sid, userid, tpy, opr, function(json){
		collectStr = json.list_ids_str;
		var operaType = json.opera_type;
		if(operaType == 1){
			$g('ele4_b').src = 'images/application/player/theme/classic/ui_huge/collect.png';
			$g('ele4').src = 'images/application/player/theme/classic/ui_huge/focus/f_collect.png';
			showStatus('images/application/player/theme/classic/status/sta_clt0.png', 0);
		} else{
			$g('ele4_b').src = 'images/application/player/theme/classic/ui_huge/collect0.png';
			$g('ele4').src = 'images/application/player/theme/classic/ui_huge/focus/f_collect0.png';
			showStatus('images/application/player/theme/classic/status/sta_clt.png', 0);
		}
		allowClick = true;
	});
}

// 切换播放模式
function changeMode(){
	if(mode == 1){ // 从全部循环切换到单曲循环
		mode = 2;
		$g('ns').innerHTML = words[4];
	} else if(mode == 2){ // 从单曲循环切换到全部循环
		mode = 1;
		$g('ns').innerHTML = words[3];
	}
	$g('ele8_b').src = 'images/application/player/theme/classic/ui_huge/mode' + mode + '.png';
	$g('ele8').src = 'images/application/player/theme/classic/ui_huge/focus/f_mode' + mode + '.png';
}

// 获取歌曲名字的长度
function getBytesLength(str){
	var byteLen = 0, len = str.length;
	if(str){
		for(var i = 0; i < len; i++){
			if(str.charCodeAt(i) > 255) byteLen += 2;
            else byteLen++;
		}
		return byteLen;
	} else return 0;
}