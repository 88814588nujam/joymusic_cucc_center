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
// document.write('<div id=\'statusPly\' style=\'position:absolute;left:0px;top:0px;width:0px;height:0px;z-index:100;text-align:center\'></div>');
// document.write('<div id=\'pbar\' style=\'position:absolute;left:0px;top:0px;width:0px;height:4px;z-index:-10;background:#FF8100\'></div>');
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
var authTimer;
var joymusicPlayer;
var joymusicPlayerID;
try{
	joymusicPlayer = new MediaPlayer();
} catch(e){}

// 获取完毕网络资源后返回播放地址从而进行播放
function getWebUrlResult(){
	allowClick = true;
	var cfree = playList[nowRealPlay].cfree;
	// 播放每一首歌曲之前首先进行一次鉴权和判断
	if(isOrder == '0' || cfree == '0'){
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
	} else{
		// 收费曲目免费观看x秒
		$g('wait').style.visibility = 'visible';
		if(authTimer > -1) clearTimeout(authTimer);
		authTimer = setTimeout(function(){
			$g('wait').style.visibility = 'hidden';
			// 没订购的试看也要结束记录到点播记录里
			endPlayLog(1, playCurTime, function(){
				goAuthOrder();
			});
		}, 30 * 1000);
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
	playMedia(res);
}

function playMedia(url){
	try{
		joymusicPlayer = new MediaPlayer();
		joymusicPlayerID = joymusicPlayer.getNativePlayerInstanceID();
		var playListFlag = 0;
		var videoDisplayMode = 1;
		var tmpMuteFlag = 0;
		var useNativeUIFlag = 0;
		var subtitleFlag = 0;
		var videoAlpha = 0;
		var cycleFlag = 1;
		var randomFlag = 0;
		var autoDelFlag = 0;
		joymusicPlayer.initMediaPlayer(joymusicPlayerID, playListFlag, videoDisplayMode, playHeight, playWidth, playLeft, playTop, tmpMuteFlag, useNativeUIFlag, subtitleFlag, videoAlpha, cycleFlag, randomFlag, autoDelFlag);
		joymusicPlayer.setAllowTrickmodeFlag(0);
		joymusicPlayer.setMuteUIFlag(0); // 不显示静音默认icon
		joymusicPlayer.setAudioVolumeUIFlag(0); // 不显示加减音量的UI
		joymusicPlayer.setAudioTrackUIFlag(0); // 不显示快进快退

		var flag = supportHttpUrl();
		if(!flag) url = url.replace("http://", "rtsp://");
		var json = '';
		json += '[{mediaUrl:"' + url + '",';
		json += 'mediaCode: "jsoncode1",';
		json += 'mediaType:2,';
		json += 'audioType:1,';
		json += 'videoType:1,';
		json += 'streamType:1,';
		json += 'drmType:1,';
		json += 'fingerPrint:0,';
		json += 'copyProtection:1,';
		json += 'allowTrickmode:1,';
		json += 'startTime:0,';
		json += 'endTime:20000.3,';
		json += 'entryID:"jsonentry1"}]';
		joymusicPlayer.setSingleMedia(json);
		joymusicPlayer.setVideoDisplayMode(0);
		joymusicPlayer.setVideoDisplayArea(playLeft, playTop, playWidth, playHeight);
		joymusicPlayer.refreshVideoDisplay();
		joymusicPlayer.playFromStart();
		if(delayTimesAuto > -1){
			clearInterval(delayTimesAuto); 
			delayTimesAuto = -1;
		}
		delayTimesAuto = setInterval('autoRecord()', 500);
	} catch(e){}
}

// 计时器
function autoRecord(){
	try{
		if(joymusicPlayer){
			playCurTime = Number(joymusicPlayer.getCurrentPlayTime());
			if(!playCurTime) playCurTime = 0;
			playDuration = Number(joymusicPlayer.getMediaDuration());
			if(!playDuration) playDuration = 0;
		}
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
	if(joymusicPlayer){
		if(muteFlag == 0){
			joymusicPlayer.setMuteFlag(1);
			muteFlag = 1;
			showStatus('images/application/player/vol/' + vol_prefix + '/v0.png', 0);
		} else{
			joymusicPlayer.setMuteFlag(0);
			muteFlag = 0;
			var playVol = joymusicPlayer.getVolume();
			playVol = parseInt(playVol / 10 );
			if(playVol >= 10) playVol = 10;
			if(playVol <= 0) playVol = 0;
			showStatus('images/application/player/vol/' + vol_prefix + '/v' + playVol + '.png', 0);
		}
	}
}

// 音量+
function volUp(){
	var playVol;
	if(joymusicPlayer){
		playVol = joymusicPlayer.getVolume();
		if(playVol <= 100){
			playVol = playVol + 10;
			joymusicPlayer.setVolume(playVol);
		}
		playVol = parseInt(playVol / 10) ;
		if(playVol >= 10) playVol = 10;
		if(playVol <= 0) playVol = 0;
		showStatus('images/application/player/vol/' + vol_prefix + '/v' + playVol + '.png', 0);
	}
	muteFlag = 0;
}

// 音量-
function volDown(){
	var playVol;
	if(joymusicPlayer){
		playVol = joymusicPlayer.getVolume();
		if(playVol >= 0){
			playVol = playVol - 10;
			joymusicPlayer.setVolume(playVol);
		}
		playVol = parseInt(playVol / 10 );
		if(playVol >= 10) playVol = 10;
		if(playVol <= 0) playVol = 0;
		showStatus('images/application/player/vol/' + vol_prefix + '/v' + playVol + '.png', 0);
	}
	muteFlag = 0;
}

// 暂停或者播放
function pauseOrPlay(){
	if(seekTimer > -1) clearInterval(seekTimer);
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
	if(productType == 'cs') joymusic.playPauseAndReusme();
	else{
		if(joymusicPlayer) joymusicPlayer.pause();
	}
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
	if(productType == 'cs') joymusic.playPauseAndReusme();
	else{
		if(joymusicPlayer) joymusicPlayer.resume();
	}
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

var seekTimer = null;
var baseTime = 1;
//设置播放进度
function setPlayCurTime(playSpeed){
	var nowTime = Number(joymusicPlayer.getCurrentPlayTime());
    var changeTime = playSpeed * baseTime; // 改变时长= 快进快退倍数 x 基准时间
    var newTime = 0;
    if(playStat == 2){ // 快退
    	if(changeTime > 0) changeTime = 0 - changeTime;
        if((changeTime + nowTime) <= 0){
        	newTime = 0;
        	if(seekTimer > -1) clearInterval(seekTimer);
        	replay();
        } else newTime = nowTime + changeTime;
    } else if(playStat == 3){ // 快进
        if((changeTime + nowTime) >= playDuration){
        	newTime = playDuration;
        	if(seekTimer > -1) clearInterval(seekTimer);
        	changeSong();
        } else newTime = nowTime + changeTime;
    }
	// $g('test').innerHTML = "" + changeTime + "";
    joymusicPlayer.playByTime(1, newTime);
    // 设置完更新当前播放时间
    playCurTime = Number(joymusicPlayer.getCurrentPlayTime());
}

// 快进
function fastForward(){
	if(seekTimer > -1) clearInterval(seekTimer);
	if(playStat != 3) playSpeed = 1;
	if(playSpeed < 64) playSpeed = playSpeed * 2;
	if(playSpeed > 32){
		playSpeed = 1;
		playStat = 1;
		resume();
	} else{
		playStat = 3;
		seekTimer = setInterval(function() {
			setPlayCurTime(playSpeed);
		}, 1000);
	}
	showStatus('images/application/player/theme/classic/status/f' + playSpeed + '.png', 0);
	if(playSpeed == 1){
		$g('ele2_b').src = 'images/application/player/theme/classic/ui_huge/pause.png';
		$g('ele2').src = 'images/application/player/theme/classic/ui_huge/focus/f_pause.png';
	} else{
		$g('ele2_b').src = 'images/application/player/theme/classic/ui_huge/play.png';
		$g('ele2').src = 'images/application/player/theme/classic/ui_huge/focus/f_play.png';
	}
}

// 快退
function fastRewind(){
	if(seekTimer > -1) clearInterval(seekTimer);
	if(playStat != 2) playSpeed = 1;
	if(playSpeed > -64) playSpeed = playSpeed * -2;
	if(playSpeed < -32){
		playSpeed = 1;
		playStat = 1;
		resume();
	} else{
		playStat = 2;
		seekTimer = setInterval(function() {
			setPlayCurTime(playSpeed);
		}, 1000);
	}
	showStatus('images/application/player/theme/classic/status/r' + Math.abs(playSpeed) + '.png', 0);
	if(playSpeed == 1){
		$g('ele2_b').src = 'images/application/player/theme/classic/ui_huge/pause.png';
		$g('ele2').src = 'images/application/player/theme/classic/ui_huge/focus/f_pause.png';
	} else{
		$g('ele2_b').src = 'images/application/player/theme/classic/ui_huge/play.png';
		$g('ele2').src = 'images/application/player/theme/classic/ui_huge/focus/f_play.png';
	}
}


// 原伴唱切换
function changeChannel(){
	if(productType == 'cs'){
		if(playChannel == 0){ // 从原唱切换到伴唱
			playChannel = 1;
			try{
				joymusic.playChangeModel(2);
			} catch(e){
				t1("切换报错了====2");
			}
			showStatus('images/application/player/theme/classic/status/sta_channel.png', 0);
			$g('ele5_b').src = 'images/application/player/theme/classic/ui_huge/channel.png';
			$g('ele5').src = 'images/application/player/theme/classic/ui_huge/focus/f_channel.png';
		} else if(playChannel == 1){ // 从伴唱切换到原唱
			playChannel = 0;
			try{
				joymusic.playChangeModel(1);
			} catch(e){
				t1("切换报错了====1");
			}
			showStatus('images/application/player/theme/classic/status/sta_channel0.png', 0);
			$g('ele5_b').src = 'images/application/player/theme/classic/ui_huge/channel0.png';
			$g('ele5').src = 'images/application/player/theme/classic/ui_huge/focus/f_channel0.png';
		}
	} else{
		if(joymusicPlayer) joymusicPlayer.getCurrentAudioChannel();
		showStatus('images/application/player/theme/classic/status/sta_channel.png', 0);
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
		if(productType == 'cs') joymusic.closePop();
		else{
			if(joymusicPlayer){
				if(playChannel == 1){
					playChannel = 0;
					joymusicPlayer.switchAudioChannel();
				}
				joymusicPlayer.stop();
				if(joymusicPlayerID>=0){
					joymusicPlayer.releaseMediaPlayer(joymusicPlayerID);
					joymusicPlayerID = -1;
				}
			}
		}
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
		try{
			//joymusic.PlayReplay();
			getWebUrlResult();
		} catch(e){}
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

function supportHttpUrl(){
	var stbType = getVal('globle', 'stbType');
	var banHttpUrl = ['EC6109_pub_jljlt', 'IP903H_54U2', 'IP903H_54U3M', 'E910',
		'EC6106V6', 'EC6109U_nmglt', 'E900', 'IP903H_05U1', 'E900V21C', 'IPBS9506',
		'IP108H-R_54U1', 'E909', 'DT741', 'EC6108V8U_pub_sdllt', 'B760H', 'Q21_hnylt',
		'EC6109U_hnylt', 'EC6108V8U_pub_sdqdlt', 'B760EV3', 'Q21_hbjlt', 'S-010W-A',
		'EC6108V9U_pub_tjjlt', 'S65', 'EC2106V1H_pub', 'EC2106V2H_pub', 'EC6108V9A', 'IP108H','IP108H_U', 
		'NL-5101'
	];
	for(var i = 0; i < banHttpUrl.length; i++){
		if(stbType == banHttpUrl[i]){
			return false;
		}
	}
	return true;
}