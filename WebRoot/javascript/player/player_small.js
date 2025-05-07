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
// 小视频播放器
var timesIn = false;
var playLeft = 0;
var playTop = 0;
var playWidth = 0;
var playHeight = 0;
var muteFlag = 0;
var playVol = 0;
var nowPlay = 0;
var nowRealPlay = 0;
var playCurTime = 0;
var playDuration = 0;
var joymusicPlayer;
var joymusicPlayerID;
var joymusicPlayerAuto;
try{
	joymusicPlayer = new MediaPlayer();
} catch(e){}

function playNext(l, t, w, h, s){
	timesIn = true;
	playLeft = l;
	playTop = t;
	playWidth = w;
	playHeight = h;
	var pbarH = $g('pbar').offsetHeight;
	$g('pbar').style.left = playLeft + 'px';
	$g('pbar').style.top = Number(playTop + playHeight - pbarH) + 'px';
	getWebUrlResult();
}

function getWebUrlResult(){
	queryRealRes(playList[nowRealPlay].cres);
	var cP = nowPlay + 1;
	if(cP == playList.length) nowPlay = 0;
	else nowPlay++;
}

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
		if(joymusicPlayerAuto > -1){
			clearInterval(joymusicPlayerAuto); 
			joymusicPlayerAuto = -1;
		}
		joymusicPlayerAuto = setInterval('autoRecord()', 500);
	} catch(e){}
}

function autoRecord(){
	if(joymusicPlayer){
		playCurTime = Number(joymusicPlayer.getCurrentPlayTime());
		if(!playCurTime) playCurTime = 0;
		playDuration = Number(joymusicPlayer.getMediaDuration());
		if(!playDuration) playDuration = 0;
	}
	if(playDuration == 0) $g('pbar').style.width = '0px';
	else $g('pbar').style.width = Math.ceil(Number(playCurTime / playDuration * playWidth)) + 'px';
}

function volMute(){
	if(muteFlag == 0){
		playerCore.setMute(true);
		muteFlag = 1;
		showPlyStatus('images/application/player/vol/' + vol_prefix + '/v0.png', 0);
	} else{
		playerCore.setMute(false);
		muteFlag = 0;
		var playVol = playerCore.getVolume();
		playVol = parseInt(playVol / 10 );
		if(playVol >= 10) playVol = 10;
		if(playVol <= 0) playVol = 0;
		showPlyStatus('images/application/player/vol/' + vol_prefix + '/v' + playVol + '.png', 0);
	}
}

function volMute(){
	if(joymusicPlayer){
		if(muteFlag == 0){
			joymusicPlayer.setMuteFlag(1);
			muteFlag = 1;
			showPlyStatus('images/application/player/vol/' + vol_prefix + '/v0.png', 0);
		} else{
			joymusicPlayer.setMuteFlag(0);
			muteFlag = 0;
			var playVol = joymusicPlayer.getVolume();
			playVol = parseInt(playVol / 10 );
			if(playVol >= 10) playVol = 10;
			if(playVol <= 0) playVol = 0;
			showPlyStatus('images/application/player/vol/' + vol_prefix + '/v' + playVol + '.png', 0);
		}
	}
}

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
		showPlyStatus('images/application/player/vol/' + vol_prefix + '/v' + playVol + '.png', 0);
	}
	muteFlag = 0;
}

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
		showPlyStatus('images/application/player/vol/' + vol_prefix + '/v' + playVol + '.png', 0);
	}
	muteFlag = 0;
}

function changeSongN(){
	var cRealP = nowRealPlay + 1;
	if(cRealP == playList.length) nowRealPlay = 0;
	else nowRealPlay++;
	getWebUrlResult();
	var cP = nowPlay + 1;
	if(cP == playList.length) nowPlay = 0;
	else nowPlay++;
}

function changeSongL(){
	var cRealP = nowRealPlay - 1;
	if(cRealP == -1) nowRealPlay = playList.length - 1;
	else nowRealPlay--;
	getWebUrlResult();
	var cP = nowPlay - 1;
	if(cP == -1) nowPlay = playList.length - 1;
	else nowPlay--;
}

function destoryMP(){
	timesIn = false;
	$g('pbar').style.width = '0px';
	if(joymusicPlayer){
    	$g('pbar').style.width = '0px';
    	joymusicPlayer.leaveChannel();
    	joymusicPlayer.stop();
		if(joymusicPlayerID>=0){
			joymusicPlayer.releaseMediaPlayer(joymusicPlayerID);
			joymusicPlayerID = -1;
		}
	}
}

function goUtility(){
	var retdata = -1;
	eval('eventJson = ' + Utility.getEvent());
	var typeStr = eventJson.type;
	switch(typeStr){
		case 'EVENT_MEDIA_ERROR':
			break;
		case 'EVENT_MEDIA_END':
			retdata = 0;
			break;
		case 'EVENT_MEDIA_BEGINING':
			retdata = 1;
			break;
		default:
			retdata = 2;
			break;
	}
	return retdata;
}

var loadPlyStime;
function showPlyStatus(pic, stime){
	if(loadPlyStime > -1){
		clearTimeout(loadPlyStime);
		loadPlyStime = -1;
	}
	var statusPic = 'statusPic';
	var statusPly = 'statusPly';
	if(!$gg(statusPic)){
		var img = new Image();
		img.id = statusPic;
		img.src = pic;
		$g(statusPly).appendChild(img);
	} else $g(statusPic).src = pic;
	var staWidth = $g(statusPic).offsetWidth;
	var staHeight = $g(statusPic).offsetHeight;
	var staLeft = (1280 - staWidth) / 2;
	var staTop = (720 - staHeight) / 2;
	$g(statusPly).style.width = staWidth + 'px';
	$g(statusPly).style.height = staHeight + 'px';
	$g(statusPly).style.left = staLeft + 'px';
	$g(statusPly).style.top = staTop + 'px';
	if(stime < 5000) stime = 5000;
	if(!loadPlyStime || loadPlyStime < 0){
		loadPlyStime = setTimeout(function(){
			$g(statusPly).innerHTML = '';
			$g(statusPly).style.width = '0px';
			$g(statusPly).style.height = '0px';
			$g(statusPly).style.left = '0px';
			$g(statusPly).style.top = '0px';
			clearTimeout(loadPlyStime);
			loadPlyStime = -1;
		}, stime);
	}
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