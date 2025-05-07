var picpx = [10, 12, 60];
var timmer = null;
var webscoket = null;
var socketPath = '';
var nowUser = '';
var wxUsersArr = new Array();
var wxUsers = getVal('globle', 'wxUsers');
if(!wxUsers) wxUsers = '';
else{
	if(wxUsers.indexOf(',') > -1) wxUsersArr = wxUsers.split(',');
	else wxUsersArr = [wxUsers];
	for(var i = 0; i < wxUsersArr.length; i++){
		var idx = i + 1;
		var img64 = getVal('globle', 'wx_base_' + wxUsersArr[i]);
		createWxImage(img64, wxUsersArr[i], idx, false);
		nowUser = getVal('globle', 'nowUser');
		if(nowUser == wxUsersArr[i]) objDisabled(wxUsersArr[i], false);
		else objDisabled(wxUsersArr[i], true);
	}
}

// 判断当前浏览器是否支持WebSocket
if('WebSocket' in window){
	var remote = getVal('globle', 'remote');
	if(remote > 0){
		var domainName = getVal('globle', 'domainName');
		var proxyTmp = 'ws';
		if(domainName.indexOf('com') > -1) proxyTmp = 'wss';
		socketPath = proxyTmp + '://' + domainName + '/TXDC/ws?userid=' + userid;
		//$g('test').style.width = '1280px';
		//$g('test').style.height = '150px';
		//$g('test').style.backgroundColor = '#000000';
		//t1('support websocket');
		websocket = new WebSocket(socketPath);
	}
}

try{
	// 连接成功建立的回调方法
	websocket.onopen = function(evt){
		console.log('WebSocket连接成功');
		// 有些页面必须等待websocket连入成功才能执行下一步
		var isFunction = false;
		try{
			isFunction = typeof(eval(onWebsocketOpen())) == 'function';
		} catch(e){}
		if(isFunction){
			eval(onWebsocketOpen());
		}
		// 只有websocket连入成功了才能展示小程序二维码
		if(pageId == 100) setTimeout('createQrcodePlayer()', 2000);
		else setTimeout('createQrcode()', 2000);
	}

	// 接收到消息的回调方法
	websocket.onmessage = function(evt){
		var dataStr = evt.data;
		console.log(dataStr);
		var dataJson = eval('(' + dataStr + ')');
		var data = dataJson.text;
		// 当前操作的用户
		var dataUser = dataJson.fromUserid;
		var func = data.split(',')[0];
		var entry = data.substr(5);

		// 微信用户扫描绑定登录
		if(func == 'regs'){
			if(wxUsersArr.length == 5 && wxUsers.indexOf(dataUser) == -1){
				websocket.send('{\'fromUserid\':\'' + userid + '\',\'toUserid\':\'' + dataUser + '\',\'text\':\'empt,false\'}');
				return;
			}
			websocket.send('{\'fromUserid\':\'' + userid + '\',\'toUserid\':\'' + dataUser + '\',\'text\':\'empt,true\'}');
			var entryJson = eval('(' + entry + ')');
			var isNew = false;
			if(wxUsers.indexOf(dataUser) == -1){
				isNew = true;
				msg.type = getVal('globle', 'preferBubble');
				msg.createMsgArea($g('realDis'));
				msg.sendMsgWithWX('欢迎 [ ' + entryJson.cname + ' ] 加入欢乐歌房K歌大家庭！现在我们的队伍更壮大了！！！', entryJson.base);
			} else{
				msg.type = getVal('globle', 'preferBubble');
				msg.createMsgArea($g('realDis'));
				msg.sendMsgWithWX('欢迎 [ ' + entryJson.cname + ' ] 回归欢乐歌房K歌大家庭！！！', entryJson.base);
			}
			wxUsers = !wxUsers ? dataUser : (wxUsers.indexOf(dataUser) > -1 ? wxUsers : wxUsers + ',' + dataUser);			
			if(wxUsers.indexOf(',') > -1) wxUsersArr = wxUsers.split(',');
			else wxUsersArr = [wxUsers];
			if(isNew) createWxImage(entryJson.base, dataUser, wxUsersArr.length, true);
			// 操作头像虚化
			objDisabled(nowUser, true);
			// 操作头像实体化
			objDisabled(dataUser, false);
			nowUser = dataUser;
			// 保存一下微信接入用户
			put('globle', 'wxUsers', wxUsers + '');
			put('globle', 'nowUser', nowUser + '');
			put('globle', 'wx_base_' + nowUser, entryJson.base + '');
			put('globle', 'wx_cname_' + nowUser, entryJson.cname + '');
		}
		// 保持回复心跳连接状态
		else if(func == 'pump') websocket.send('{\'fromUserid\':\'' + userid + '\',\'toUserid\':\'' + dataUser + '\',\'text\':\'pump,1\'}');
		// 用户注销
		else if(func == 'quit'){
			var isNull = false;
			if(wxUsers == dataUser){
				isNull = true;
				wxUsers = '';
				wxUsersArr = new Array();
			} else{
				if(wxUsers.indexOf(dataUser) == 0) wxUsers = wxUsers.replace(dataUser + ',', '');
				else wxUsers = wxUsers.replace(',' + dataUser, '');
				if(wxUsers.indexOf(',') > -1) wxUsersArr = wxUsers.split(',');
				else wxUsersArr = [wxUsers];
			}
			var target = pageH;
			var speed = 10;
			var anima = getVal('globle', 'animation');
			if(anima == 0) nextDirectY(dataUser, target, function(){
				var bDiv = $g('bDiv');
				bDiv.removeChild($g(dataUser));
				var realDis = $g('realDis');
				if(isNull) realDis.removeChild(bDiv);
			});
			else nextSlideY(dataUser, target, speed, function(){
				var bDiv = $g('bDiv');
				bDiv.removeChild($g(dataUser));
				var realDis = $g('realDis');
				if(isNull) realDis.removeChild(bDiv);
			});
			for(var i = 0; i < wxUsersArr.length; i++){
				if($gg(wxUsersArr[i])){
					var idxArr = i + 1;
					target = getIdxTop(wxUsersArr.length, idxArr);
					if(anima == 0) nextDirectY(wxUsersArr[i], target, function(){});
					else nextSlideY(wxUsersArr[i], target, speed, function(){});
				}
			}
			msg.type = getVal('globle', 'preferBubble');
			msg.createMsgArea($g('realDis'));
			var img64 = getVal('globle', 'wx_base_' + dataUser);
			var tmpUsr = getVal('globle', 'wx_cname_' + dataUser);
			msg.sendMsgWithWX(' [ ' + tmpUsr + ' ] 暂时离开欢乐歌房K歌大家庭', img64);
			put('globle', 'wxUsers', wxUsers + '');
			put('globle', 'wx_base_' + dataUser, '');
			put('globle', 'wx_cname_' + dataUser, '');
		} else{
			// 上一个操作头像虚化
			objDisabled(nowUser, true);
			// 操作头像实体化
			objDisabled(dataUser, false);
			nowUser = dataUser;
			put('globle', 'nowUser', nowUser + '');
			// 用户发送指令部分
			if(func == 'exit') exitApp();
			else if(func == 'keys') keyAction(entry);
			else if(func == 'popo'){ // 暂停播放
				pauseOrPlay();
			} else if(func == 'cert'){ // 原唱伴唱
				changeChannel();
			} else if(func == 'gifi'){ // 展示表情
				var realDis = $g('realDis');
				if($gg('moodDiv')) realDis.removeChild($g('moodDiv'));
				var moodDiv = document.createElement('div');
				moodDiv.id = 'moodDiv';
				moodDiv.style.cssText = 'position:absolute;width:200px;height:200px;left:0px;top:0px;right:0px;bottom:0px;margin:auto;background-color:#FFFFFF;border-radius:10px;z-index:1001';
				setQrcodeAlpha(moodDiv, 95);
				realDis.appendChild(moodDiv);
				var img64 = getVal('globle', 'wx_base_' + nowUser);
				var imgPic = new Image();
				imgPic.src = img64;
				imgPic.style.cssText = 'position:absolute;width:65px;height:65px;right:165px;bottom:165px;border-radius:50%;box-shadow:0 0 15px #000000;z-index:1003';
				setQrcodeAlpha(imgPic, 90);
				moodDiv.appendChild(imgPic);
				var imgMood = new Image();
				imgMood.src = entry;
				imgMood.style.cssText = 'position:absolute;width:200px;height:200px;left:0px;top:0px;right:0px;bottom:0px;margin:auto;border-radius:10px;z-index:1002';
				moodDiv.appendChild(imgMood);
				setTimeout(function(){
					moodDiv.style.display = 'none';
				}, 3000);
			} else if(func == 'ckpy'){ // 已选列表播放
				if(nowMenu == 1){
					if(delayTimes > -1){
						clearTimeout(delayTimes);
						delayTimes = -1;
					}
					$g('begin').style.display = 'none';
					isEnd = 0;
					flagEnd = false;
					nowMenu = 0;
				} else if(nowMenu == 2){
					if(delayTimesList > -1){
						clearTimeout(delayTimesList);
						delayTimesList = -1;
					}
					$g('list').style.display = 'none';
					$g('f_' + lfocus).style.visibility = 'hidden';
					if(lfocus.indexOf('p') > -1 || lfocus.indexOf('d') > -1){
						var idx = lfocus.replace('p', '').replace('d', '');
						$g('f' + idx).style.visibility = 'hidden';
					}
					nowMenu = 0;
				}
				var sid = entry;
				setTimeout(function(){
					allowClick = true;
					for(var i = 0; i < playList.length; i++){
						if(sid == playList[i].songId){
							if(i == 0) nowRealPlay = playList.length - 1;
							else nowRealPlay = i - 1;
							break;
						}
					}
					changeSong();
				}, 1000);
			} else if(func == 'play'){ // 播放单曲
				// 如果已经在播放器页面则需要加入已选列表，并且直接播放
				if(pageId == 100){
					allowClick = false;
					var sid = entry;
					var hour = getVal('globle', 'hour');
					var max = getVal('globle', 'max');
					var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=3&u=' + userid + '&s=' + sid + '&h=' + hour + '&m=' + max + '\'}]';
					var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
					ajaxRequest('POST', reqUrl, function(){
						if(xmlhttp.readyState == 4){
							if(xmlhttp.status == 200){
								var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
								var contentJson = eval('(' + retText + ')');
								playList = contentJson.playList;
								var songName = playList[0].songName;
								var artistName = playList[0].singer;
								msg.type = getVal('globle', 'preferBubble');
								msg.createMsgArea($g('realDis'));
								var img64 = getVal('globle', 'wx_base_' + nowUser);
								msg.sendMsgWithWX('即将播放 - [' + songName + ' - ' + artistName + ']', img64);
								if(nowMenu == 1){
									if(delayTimes > -1){
										clearTimeout(delayTimes);
										delayTimes = -1;
									}
									$g('begin').style.display = 'none';
									isEnd = 0;
									flagEnd = false;
									nowMenu = 0;
								} else if(nowMenu == 2){
									if(delayTimesList > -1){
										clearTimeout(delayTimesList);
										delayTimesList = -1;
									}
									$g('list').style.display = 'none';
									$g('f_' + lfocus).style.visibility = 'hidden';
									if(lfocus.indexOf('p') > -1 || lfocus.indexOf('d') > -1){
										var idx = lfocus.replace('p', '').replace('d', '');
										$g('f' + idx).style.visibility = 'hidden';
									}
									nowMenu = 0;
								}
								if(mode == 2){ // 从单曲循环切换到全部循环
									mode = 1;
									$g('ns').innerHTML = words[3];
									$g('ele8_b').src = 'images/application/player/theme/classic/ui_huge/mode' + mode + '.png';
									$g('ele8').src = 'images/application/player/theme/classic/ui_huge/focus/f_mode' + mode + '.png';
								}
								setTimeout(function(){
									allowClick = true;
									nowRealPlay = playList.length - 1;
									changeSong();
								}, 1000);
								// 记得给小程序同步消息
								WXSendMsg('adds,' + sid);
							}
						}
					});
				} else{
					var dataUrl = 'h2';
					var sid = entry;
					var hour = getVal('globle', 'hour');
					var max = getVal('globle', 'max');
					var opr = 1;
					operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
						allowClick = false;
						ajaxRequest('POST', dataUrl + '?o=4&s=' + sid, function(){
							if(xmlhttp.readyState == 4){
								if(xmlhttp.status == 200){
									var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
									var contentJson = eval('(' + retText + ')');
									var songName = contentJson.cname.replace('(HD)', '');
									var artistName = contentJson.artist;
									msg.type = getVal('globle', 'preferBubble');
									msg.createMsgArea($g('realDis'));
									var img64 = getVal('globle', 'wx_base_' + nowUser);
									msg.sendMsgWithWX('即将播放 - [' + songName + ' - ' + artistName + ']', img64);
									if($gg('idsCheckedNum')){
										var nowNumInt = Number(json.list_num);
										$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
									}
									setTimeout(function(){
										toPlayer();
									}, 1000);
								}
							}
						});
					});
				}
				WXSendMsg('refr,0');
			} else if(func == 'join'){ // 添加单曲
				// 如果已经在播放器页面则需要加入已选列表
				if(pageId == 100){
					allowClick = false;
					var sid = entry;
					var hour = getVal('globle', 'hour');
					var max = getVal('globle', 'max');
					var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=3&u=' + userid + '&s=' + sid + '&h=' + hour + '&m=' + max + '\'}]';
					var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
					ajaxRequest('POST', reqUrl, function(){
						if(xmlhttp.readyState == 4){
							if(xmlhttp.status == 200){
								var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
								var contentJson = eval('(' + retText + ')');
								playList = contentJson.playList;
								var songName = playList[0].songName;
								var artistName = playList[0].singer;
								msg.type = getVal('globle', 'preferBubble');
								msg.createMsgArea($g('realDis'));
								var img64 = getVal('globle', 'wx_base_' + nowUser);
								msg.sendMsgWithWX('成功添加曲目 [' + songName + ' - ' + artistName + ']', img64);
								if(nowMenu == 1){
									if(delayTimes > -1){
										clearTimeout(delayTimes);
										delayTimes = -1;
									}
									$g('begin').style.display = 'none';
									isEnd = 0;
									flagEnd = false;
									nowMenu = 0;
								} else if(nowMenu == 2){
									if(delayTimesList > -1){
										clearTimeout(delayTimesList);
										delayTimesList = -1;
									}
									$g('list').style.display = 'none';
									$g('f_' + lfocus).style.visibility = 'hidden';
									if(lfocus.indexOf('p') > -1 || lfocus.indexOf('d') > -1){
										var idx = lfocus.replace('p', '').replace('d', '');
										$g('f' + idx).style.visibility = 'hidden';
									}
									nowMenu = 0;
								}
								nowRealPlay = playList.length - 1;
								allowClick = true;
							}
						}
					});
				} else{
					var dataUrl = 'h2';
					var sid = entry;
					var hour = getVal('globle', 'hour');
					var max = getVal('globle', 'max');
					var opr = 1;
					operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
						allowClick = false;
						ajaxRequest('POST', dataUrl + '?o=4&s=' + sid, function(){
							if(xmlhttp.readyState == 4){
								if(xmlhttp.status == 200){
									var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
									var contentJson = eval('(' + retText + ')');
									var songName = contentJson.cname.replace('(HD)', '');
									var artistName = contentJson.artist;
									msg.type = getVal('globle', 'preferBubble');
									msg.createMsgArea($g('realDis'));
									var img64 = getVal('globle', 'wx_base_' + nowUser);
									msg.sendMsgWithWX('成功添加曲目 [' + songName + ' - ' + artistName + ']', img64);
									if($gg('idsCheckedNum')){
										var nowNumInt = Number(json.list_num);
										$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
									}
									allowClick = true;
								}
							}
						});
					});
				}
				WXSendMsg('join,0');
			} else if(func == 'coll'){ // 收藏 || 取消收藏歌曲
				var dataUrl = 'h2';
				var sid = entry;
				var opr = 2;
				var tpy = 1;
				operaCollect(dataUrl, sid, userid, tpy, opr, function(json){
					var operaType = json.opera_type;
					if(pageId == 15){
						var lstNumS = $g('totalRowsS').innerText;
						lstNumS = lstNumS.replace('(', '').replace(')', '');
						var nowNumS = Number(lstNumS);
						operaType == 1 ? nowNumS-- : nowNumS++;
						$g('totalRowsS').innerText = '(' + nowNumS + ')';
					}
					if(pageId == 6 || pageId == 7 || pageId == 8 || pageId == 11
							|| pageId == 12 || pageId == 14 || pageId == 100){
						collectStr = json.list_ids_str;
						if(pageId == 6){
							if(rightDiv == 1 || rightDiv == 3){
								for(var i = 0; i < songList.length; i++){
									if(sid == songList[i].sid){
										var tempF = i + (rightDiv == 1 ? 76 : 124);
										if(operaType == 1){
											$g('search_' + tempF).src = 'images/application/pages/search/song/collect.png';
											$g('f_search_' + tempF).src = 'images/application/pages/search/song/focus/f_collect.png';
										} else{
											$g('search_' + tempF).src = 'images/application/pages/search/song/collect0.png';
											$g('f_search_' + tempF).src = 'images/application/pages/search/song/focus/f_collect0.png';
										}
										break;
									}
								}
							}
						} else if(pageId == 7 || pageId == 11){
							for(var i = 0; i < songListAll.length; i++){
								if(sid == songListAll[i].sid){
									var tempF = i + 1;
									if(operaType == 1){
										$g('collect_' + tempF).src = 'images/application/pages/search/song/collect.png';
										$g('f_collect_' + tempF).src = 'images/application/pages/search/song/focus/f_collect.png';
									} else{
										$g('collect_' + tempF).src = 'images/application/pages/search/song/collect0.png';
										$g('f_collect_' + tempF).src = 'images/application/pages/search/song/focus/f_collect0.png';
									}
									break;
								}
							}
						} else if(pageId == 8 || pageId == 12){
							var pageN = pageId == 8 ? 'artist' : 'list';
							for(var i = 0; i < songList.length; i++){
								if(sid == songList[i].sid){
									var tempF = i + pageLimit + 1;
									if(operaType == 1){
										$g(pageN + '_' + tempF).src = 'images/application/pages/search/song/collect.png';
										$g('f_' + pageN + '_' + tempF).src = 'images/application/pages/search/song/focus/f_collect.png';
									} else{
										$g(pageN + '_' + tempF).src = 'images/application/pages/search/song/collect0.png';
										$g('f_' + pageN + '_' + tempF).src = 'images/application/pages/search/song/focus/f_collect0.png';
									}
									break;
								}
							}
						} else if(pageId == 14){
							if(timmer > -1){
								clearTimeout(timmer); 
								timmer = -1;
							}
							var delayT = 500;
							put('request', 'params', 'i=' + pageId);
							timmer = setTimeout(function(){go(pageId);}, delayT);
						} else if(pageId == 100){
							var sidPly = playList[nowRealPlay].songId;
							if(sidPly == sid){
								if(nowMenu == 2){
									if(delayTimesList > -1){
										clearTimeout(delayTimesList);
										delayTimesList = -1;
									}
									$g('list').style.display = 'none';
									$g('f_' + lfocus).style.visibility = 'hidden';
									var idx = lfocus.replace('p', '').replace('d', '');
									$g('f' + idx).style.visibility = 'hidden';
									nowMenu = 0;
								}
								nowMenu = 1;
								$g('begin').style.display = 'block';
								if(flagEnd){
									isEnd = 1;
								}
								flagEnd = true;
								if(delayTimes > -1){
									clearTimeout(delayTimes); 
									delayTimes = -1;
								}
								delayTimes = setTimeout(function(){
									$g('begin').style.display = 'none';
									isEnd = 0;
									flagEnd = false;
									nowMenu = 0;
								}, 10000);
								$g(vfocus).style.visibility = 'hidden';
								$g(vfocus + '_b').style.visibility = 'visible';
								vfocus = 'ele4';
								$g('ele4').style.visibility = 'visible';
								if(operaType == 1){
									$g('ele4_b').src = 'images/application/player/theme/classic/ui_huge/collect.png';
									$g('ele4').src = 'images/application/player/theme/classic/ui_huge/focus/f_collect.png';
									showStatus('images/application/player/theme/classic/status/sta_clt0.png', 0);
								} else{
									$g('ele4_b').src = 'images/application/player/theme/classic/ui_huge/collect0.png';
									$g('ele4').src = 'images/application/player/theme/classic/ui_huge/focus/f_collect0.png';
									showStatus('images/application/player/theme/classic/status/sta_clt.png', 0);
								}
							} else{
								if(nowMenu == 1){
									if(delayTimes > -1){
										clearTimeout(delayTimes);
										delayTimes = -1;
									}
									$g('begin').style.display = 'none';
									isEnd = 0;
									flagEnd = false;
									nowMenu = 0;
								} else if(nowMenu == 2){
									if(delayTimesList > -1){
										clearTimeout(delayTimesList);
										delayTimesList = -1;
									}
									$g('list').style.display = 'none';
									$g('f_' + lfocus).style.visibility = 'hidden';
									var idx = lfocus.replace('p', '').replace('d', '');
									$g('f' + idx).style.visibility = 'hidden';
									nowMenu = 0;
								}
							}
						}
					}
					ajaxRequest('POST', dataUrl + '?o=4&s=' + sid, function(){
						if(xmlhttp.readyState == 4){
							if(xmlhttp.status == 200){
								var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
								var contentJson = eval('(' + retText + ')');
								var songName = contentJson.cname.replace('(HD)', '');
								var artistName = contentJson.artist;
								msg.type = getVal('globle', 'preferBubble');
								msg.createMsgArea($g('realDis'));
								var msgStr = '';
								if(operaType == 1) msgStr = '成功删除收藏曲目 [' + songName + ' - ' + artistName + ']';
								else msgStr = '成功收藏曲目 [' + songName + ' - ' + artistName + ']';
								var img64 = getVal('globle', 'wx_base_' + nowUser);
								if(pageId == 100){
									var sidPly = playList[nowRealPlay].songId;
									if(sidPly != sid) msg.sendMsgWithWX(msgStr, img64);
								} else msg.sendMsgWithWX(msgStr, img64);
							}
						}
					});
				});
			} else if(func == 'acol'){ // 收藏 || 取消收藏歌手
				var dataUrl = 'h2';
				var sid = entry;
				var opr = 2;
				var tpy = 0;
				operaCollect(dataUrl, sid, userid, tpy, opr, function(json){
					var operaType = json.opera_type;
					if(pageId == 14){
						var lstNumA = $g('totalRowsA').innerText;
						lstNumA = lstNumA.replace('(', '').replace(')', '');
						var nowNumA= Number(lstNumA);
						operaType == 1 ? nowNumA-- : nowNumA++;
						$g('totalRowsA').innerText = '(' + nowNumA + ')';
					}
					ajaxRequest('POST', dataUrl + '?o=5&s=' + sid, function(){
						if(xmlhttp.readyState == 4){
							if(xmlhttp.status == 200){
								var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
								var contentJson = eval('(' + retText + ')');
								var artistName = contentJson.cname;
								msg.type = getVal('globle', 'preferBubble');
								msg.createMsgArea($g('realDis'));
								var msgStr = '';
								if(operaType == 1){
									if(pageId == 7 || pageId == 8){
										$g('artist_100001').src = 'images/application/pages/artist/subscribe.png';
										$g('f_artist_100001').src = 'images/application/pages/artist/focus/f_subscribe.png';
										if(pageId == 7){
											$g('f_artist_100006').src = 'images/application/pages/artist/focus/f_ele_collect.png';
											$g('c_artist_100006').src = 'images/application/pages/artist/focus/c_f_ele_collect.png';
										}
									}
									msgStr = '成功删除收藏歌手 [' + artistName + ']';
								} else{
									if(pageId == 7 || pageId == 8){
										$g('artist_100001').src = 'images/application/pages/artist/subscribe0.png';
										$g('f_artist_100001').src = 'images/application/pages/artist/focus/f_subscribe0.png';
										if(pageId == 7){
											$g('f_artist_100006').src = 'images/application/pages/artist/focus/f_ele_collect0.png';
											$g('c_artist_100006').src = 'images/application/pages/artist/focus/c_f_ele_collect0.png';
										}
									}
									msgStr = '成功收藏歌手 [' + artistName + ']';
								}
								var img64 = getVal('globle', 'wx_base_' + nowUser);
								msg.sendMsgWithWX(msgStr, img64);
								if(pageId == 15){
									if(timmer > -1){
										clearTimeout(timmer); 
										timmer = -1;
									}
									var delayT = 500;
									put('request', 'params', 'i=' + pageId);
									timmer = setTimeout(function(){go(pageId);}, delayT);
								} else if(pageId == 100){
									if(nowMenu == 1){
										if(delayTimes > -1){
											clearTimeout(delayTimes);
											delayTimes = -1;
										}
										$g('begin').style.display = 'none';
										isEnd = 0;
										flagEnd = false;
										nowMenu = 0;
									} else if(nowMenu == 2){
										if(delayTimesList > -1){
											clearTimeout(delayTimesList);
											delayTimesList = -1;
										}
										$g('list').style.display = 'none';
										$g('f_' + lfocus).style.visibility = 'hidden';
										var idx = lfocus.replace('p', '').replace('d', '');
										$g('f' + idx).style.visibility = 'hidden';
										nowMenu = 0;
									}
									
								}
							}
						}
					});
				});
			} else if(func == 'plya'){ // 播放全部
				var entryJson = eval('(' + entry + ')');
				var type = entryJson.type;
				var content = entryJson.content;
				allowClick = false;
				if(type == 1){ // 自由式专题 全部播放
					ajaxRequest('POST', 'wx2?c=' + content + '&u=' + userid, function(){
						if(xmlhttp.readyState == 4){
							if(xmlhttp.status == 200){
								var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
								var contentJson = eval('(' + retText + ')');
								var songList = contentJson.data.songList;
								var sid = '';
								for(var i = 0; i < songList.length; i++) sid += songList[i].content + ',';
								if(sid.indexOf(',') > -1) sid = sid.substr(0, sid.length - 1);
								var cname = contentJson.data.top.cname;
								var dataUrl = 'h2';
								var hour = getVal('globle', 'hour');
								var max = getVal('globle', 'max');
								var opr = 1;
								operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
									msg.type = getVal('globle', 'preferBubble');
									msg.createMsgArea($g('realDis'));
									var img64 = getVal('globle', 'wx_base_' + nowUser);
									msg.sendMsgWithWX('即将播放 [专题：' + cname + '] 中的全部歌曲', img64);
									if($gg('idsCheckedNum')){
										var nowNumInt = Number(json.list_num);
										$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
									}
									if(pageId == 100){
										var delayT = 500;
										put('request', 'params', 'i=' + pageId);
										setTimeout(function(){go(pageId);}, delayT);
									} else toPlayer();
								});
							}
						}
					});
				} else if(type == 2 || type == 3){ // 列表式专题 || 明星曲目列表 全部播放
					var listType = Number(type) + 2;
					ajaxRequest('POST', 'wx5?c=' + content + '&u=' + userid + '&t=' + listType, function(){
						if(xmlhttp.readyState == 4){
							if(xmlhttp.status == 200){
								var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
								var contentJson = eval('(' + retText + ')');
								var songList = contentJson.data.songList;
								var sid = '';
								for(var i = 0; i < songList.length; i++) sid += songList[i].content + ',';
								if(sid.indexOf(',') > -1) sid = sid.substr(0, sid.length - 1);
								var cname = contentJson.data.top.cname;
								var dataUrl = 'h2';
								var hour = getVal('globle', 'hour');
								var max = getVal('globle', 'max');
								var opr = 1;
								operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
									msg.type = getVal('globle', 'preferBubble');
									msg.createMsgArea($g('realDis'));
									var img64 = getVal('globle', 'wx_base_' + nowUser);
									if(type == 2) msg.sendMsgWithWX('即将播放 [' + cname + '] 列表里的全部曲目', img64);
									else if(type == 3) msg.sendMsgWithWX('即将播放 [' + cname + '] 的全部曲目', img64);
									if($gg('idsCheckedNum')){
										var nowNumInt = Number(json.list_num);
										$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
									}
									if(pageId == 100){
										var delayT = 500;
										put('request', 'params', 'i=' + pageId);
										setTimeout(function(){go(pageId);}, delayT);
									} else toPlayer();
								});
							}
						}
					});
				} else if(type == 4){ // 收藏列表全部播放
					var opr = 3;
					var dataUrl = 'h2';
					var hour = getVal('globle', 'hour');
					var max = getVal('globle', 'max');
					var docUrl = dataUrl + '?u=' + userid + '&t=' + hour + '&m=' + max + '&p=14&o=' + opr;
					ajaxRequest('POST', docUrl, function(){
						if(xmlhttp.readyState == 4){
							if(xmlhttp.status == 200){
								allowClick = false;
								var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
								var contentJson = eval('(' + retText + ')');
								var remote = getVal('globle', 'remote');
								if(remote > 0) WXSendMsg('adds,0');
								msg.type = getVal('globle', 'preferBubble');
								msg.createMsgArea($g('realDis'));
								var img64 = getVal('globle', 'wx_base_' + nowUser);
								msg.sendMsgWithWX('即将播放全部收藏曲目', img64);
								if($gg('idsCheckedNum')){
									var nowNumInt = Number(contentJson.list_num);
									$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
								}
								toPlayer();
							}
						}
					});
				}
			} else if(func == 'cola'){
				var dataUrl = 'h2';
				var opr = 2;
				if(entry == 0){ // 删除全部收藏歌曲
					var opr = 2;
					var tpy = 1;
					operaCollect(dataUrl, '', userid, tpy, opr, function(json){
						collectStr = json.list_ids_str;
						var operaType = json.opera_type;
						msg.type = getVal('globle', 'preferBubble');
						msg.createMsgArea($g('realDis'));
						var img64 = getVal('globle', 'wx_base_' + nowUser);
						msg.sendMsgWithWX('已经成功移除全部收藏曲目！', img64);
						if(pageId == 6){
							if(rightDiv == 1 || rightDiv == 3){
								for(var i = 0; i < songList.length; i++){
									var tempF = i + (rightDiv == 1 ? 76 : 124);
									$g('search_' + tempF).src = 'images/application/pages/search/song/collect.png';
									$g('f_search_' + tempF).src = 'images/application/pages/search/song/focus/f_collect.png';
								}
							}
						} else if(pageId == 7 || pageId == 11){
							for(var i = 0; i < songListAll.length; i++){
								var tempF = i + 1;
								$g('collect_' + tempF).src = 'images/application/pages/search/song/collect.png';
								$g('f_collect_' + tempF).src = 'images/application/pages/search/song/focus/f_collect.png';
							}
						} else if(pageId == 8 || pageId == 12){
							var pageN = pageId == 8 ? 'artist' : 'list';
							for(var i = 0; i < songList.length; i++){
								var tempF = i + pageLimit + 1;
								$g(pageN + '_' + tempF).src = 'images/application/pages/search/song/collect.png';
								$g('f_' + pageN + '_' + tempF).src = 'images/application/pages/search/song/focus/f_collect.png';
							}
						} else if(pageId == 15) $g('totalRowsS').innerText = '(0)';
						else if(pageId == 14){
							var delayT = 500;
							put('request', 'params', 'i=' + pageId);
							setTimeout(function(){go(pageId);}, delayT);
						} else if(pageId == 100){
							if(nowMenu == 1){
								if(delayTimes > -1){
									clearTimeout(delayTimes);
									delayTimes = -1;
								}
								$g('begin').style.display = 'none';
								isEnd = 0;
								flagEnd = false;
								nowMenu = 0;
							} else if(nowMenu == 2){
								if(delayTimesList > -1){
									clearTimeout(delayTimesList);
									delayTimesList = -1;
								}
								$g('list').style.display = 'none';
								$g('f_' + lfocus).style.visibility = 'hidden';
								var idx = lfocus.replace('p', '').replace('d', '');
								$g('f' + idx).style.visibility = 'hidden';
								nowMenu = 0;
							}
							$g('ele4_b').src = 'images/application/player/theme/classic/ui_huge/collect.png';
							$g('ele4').src = 'images/application/player/theme/classic/ui_huge/focus/f_collect.png';
							showStatus('images/application/player/theme/classic/status/sta_clt0.png', 0);
						}
					});
				} else if(entry == 1){ // 删除全部收藏歌手
					var opr = 2;
					var tpy = 0;
					operaCollect(dataUrl, '', userid, tpy, opr, function(json){
						collectStr = json.list_ids_str;
						var operaType = json.opera_type;
						if(pageId == 7 || pageId == 8){
							$g('artist_100001').src = 'images/application/pages/artist/subscribe.png';
							$g('f_artist_100001').src = 'images/application/pages/artist/focus/f_subscribe.png';
							if(pageId == 7){
								$g('f_artist_100006').src = 'images/application/pages/artist/focus/f_ele_collect.png';
								$g('c_artist_100006').src = 'images/application/pages/artist/focus/c_f_ele_collect.png';
							}
						}
						msg.type = getVal('globle', 'preferBubble');
						msg.createMsgArea($g('realDis'));
						var img64 = getVal('globle', 'wx_base_' + nowUser);
						msg.sendMsgWithWX('已经成功移除全部收藏歌手！', img64);
						if(pageId == 14) $g('totalRowsA').innerText = '(0)';
						else if(pageId == 15){
							var delayT = 500;
							put('request', 'params', 'i=' + pageId);
							setTimeout(function(){go(pageId);}, delayT);
						} else if(pageId == 100){
							if(nowMenu == 1){
								if(delayTimes > -1){
									clearTimeout(delayTimes);
									delayTimes = -1;
								}
								$g('begin').style.display = 'none';
								isEnd = 0;
								flagEnd = false;
								nowMenu = 0;
							} else if(nowMenu == 2){
								if(delayTimesList > -1){
									clearTimeout(delayTimesList);
									delayTimesList = -1;
								}
								$g('list').style.display = 'none';
								$g('f_' + lfocus).style.visibility = 'hidden';
								var idx = lfocus.replace('p', '').replace('d', '');
								$g('f' + idx).style.visibility = 'hidden';
								nowMenu = 0;
							}
							
						}
					});
				}
			} else if(func == 'dele'){
				allowClick = false;
				var dataUrl = 'h2';
				var sid = entry;
				var hour = getVal('globle', 'hour');
				var max = getVal('globle', 'max');
				if(pageId == 100){
					if(nowMenu == 1){
						if(delayTimes > -1){
							clearTimeout(delayTimes);
							delayTimes = -1;
						}
						$g('begin').style.display = 'none';
						isEnd = 0;
						flagEnd = false;
						nowMenu = 0;
					} else if(nowMenu == 2){
						if(delayTimesList > -1){
							clearTimeout(delayTimesList);
							delayTimesList = -1;
						}
						$g('list').style.display = 'none';
						$g('f_' + lfocus).style.visibility = 'hidden';
						var idx = lfocus.replace('p', '').replace('d', '');
						$g('f' + idx).style.visibility = 'hidden';
						nowMenu = 0;
					}
					var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=2&u=' + userid + '&s=' + sid + '&h=' + hour + '&m=' + max + '\'}]';
					var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
					ajaxRequest('POST', reqUrl, function(){
						if(xmlhttp.readyState == 4){
							if(xmlhttp.status == 200){
								var retText = xmlhttp.responseText.replace(/(\s*$g)/g, '');
								var contentJson = eval('(' + retText + ')');
								var result = contentJson.result;
								if(result > 0){
									var tempPageTotals = contentJson.pageTotals;
									if(tempPageTotals == 0) playList = new Array();
									else playList = contentJson.playList;
									WXSendMsg('dele,1');
									ajaxRequest('POST', dataUrl + '?o=4&s=' + sid, function(){
										if(xmlhttp.readyState == 4){
											if(xmlhttp.status == 200){
												var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
												var contentJson = eval('(' + retText + ')');
												var songName = contentJson.cname.replace('(HD)', '');
												var artistName = contentJson.artist;
												msg.type = getVal('globle', 'preferBubble');
												msg.createMsgArea($g('realDis'));
												var img64 = getVal('globle', 'wx_base_' + nowUser);
												msg.sendMsgWithWX('已经将 [' + songName + ' - ' + artistName + '] 成功移除', img64);
												allowClick = true;
											}
										}
									});
								}
							}
						}
					});
				} else{
					operaChecked(dataUrl, sid, userid, hour, max, 0, function(json){
						ajaxRequest('POST', dataUrl + '?o=4&s=' + sid, function(){
							if(xmlhttp.readyState == 4){
								if(xmlhttp.status == 200){
									var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
									var contentJson = eval('(' + retText + ')');
									var songName = contentJson.cname.replace('(HD)', '');
									var artistName = contentJson.artist;
									msg.type = getVal('globle', 'preferBubble');
									msg.createMsgArea($g('realDis'));
									var img64 = getVal('globle', 'wx_base_' + nowUser);
									msg.sendMsgWithWX('已经将 [' + songName + ' - ' + artistName + '] 成功移除', img64);
									if($gg('idsCheckedNum')){
										var nowNumInt = Number(json.list_num);
										$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
									}
									if(pageId == 13){
										if(timmer > -1){
											clearTimeout(timmer); 
											timmer = -1;
										}
										var delayT = 500;
										put('request', 'params', 'i=' + pageId);
										timmer = setTimeout(function(){go(pageId);}, delayT);
									}
									allowClick = true;
								}
							}
						});
					});
				}
			}
		}
	}

	// 连接发生错误的回调方法
	websocket.onerror = function(evt){
		//t1('websocket error');
		console.log('WebSocket连接发生错误');
		var isFunction = false;
		try{
			isFunction = typeof(eval(onWebsocketError())) == 'function';
		} catch(e){}
		if(isFunction){
			eval(onWebsocketError());
		}
	};
	
	websocket.onclose = function(evt){
		console.log('WebSocket连接断开: Code:' + evt.code + ' Reason:' + evt.reason + ' wasClean:' + evt.wasClean);
	};

	// 监听窗口关闭
	window.onbeforeunload = function(){
		console.log('WebSocket连接断开');
		websocket.close();
	}
} catch(e){}

// 发送指令
function WXSendMsg(msg){
	var wxUsers = getVal('globle', 'wxUsers');
	if(!wxUsers) return;
	else{
		if(wxUsers.indexOf(',') > -1) wxUsersArr = wxUsers.split(',');
		else wxUsersArr = [wxUsers];
		for(var i = 0; i < wxUsersArr.length; i++){
			var toUserid = wxUsersArr[i];
			if(toUserid != 'SYSTEM_BROADCAST'){
				if(websocket == null){
					console.log('请先连接服务器');
					return;
				}
				var jsonMsg = {
					'fromUserid' : userid,
					'toUserid' : toUserid,
					'text' : msg
				}
				websocket.send(JSON.stringify(jsonMsg));
			}
		}
	}
}

// 生成小程序连接使用二维码
function createQrcode(){
	var img = new Image();
	img.src = 'm1?userid=' + userid + '&platform=' + platform + '&provinceN=' + provinceN;
	var top = 580;
	var delayIn = 15 * 1000;
	var delayOut = 30 * 1000;
	img.style.cssText = 'position:absolute;width:125px;height:125px;left:15px;top:' + top + 'px;box-shadow:0 0 15px #000000;opacity:1;filter:alpha(opacity=100);z-index:999';
	var realDis = $g('realDis');
	realDis.appendChild(img);
	displayQrcode(img, 0, delayIn, delayOut);
}

// 播放器生成二维码
function createQrcodePlayer(){
	var img = new Image();
	img.src = 'm1?userid=' + userid + '&platform=' + platform + '&provinceN=' + provinceN;
	img.style.cssText = 'position:absolute;width:125px;height:125px;left:1080px;top:55px;opacity:1;filter:alpha(opacity=100);z-index:1';
	var imgBar = new Image();
	imgBar.src = 'images/application/utils/common/qrbar.gif';
	imgBar.style.cssText = 'position:absolute;width:317px;height:255px;left:1000px;top:14px;opacity:1;filter:alpha(opacity=100);z-index:2';
	var realDis = $g('realDis');
	realDis.appendChild(img);
	realDis.appendChild(imgBar);
	qrcodeFadeIn(img);
	qrcodeFadeIn(imgBar);
}

function displayQrcode(obj, num, delayIn, delayOut){
	if(num % 2 == 1) obj.style.left = '1140px';
	else obj.style.left = '15px';
	qrcodeFadeIn(obj);
	setTimeout(function(){
		qrcodeFadeOut(obj);
		setTimeout(function(){
			num++;
			displayQrcode(obj, num, delayIn, delayOut);
		}, delayIn);
	}, delayOut);
}

function setQrcodeAlpha(obj, level){
	if(obj.filters){ 
		obj.style.filter = 'alpha(opacity=' + level + ')';
	} else{ 
		obj.style.opacity = level / 100;
	}
}

function qrcodeFadeIn(obj){
	setQrcodeAlpha(obj, 0);
	for(var i = 0; i <= 20; i++){
		(function(){
			var level = i * 5;
			setTimeout(function(){
				setQrcodeAlpha(obj, level);
			}, i * 100);
		})(i);
	}
}

function qrcodeFadeOut(obj){
	for(var i = 0; i <= 20; i++){
		(function(){
			var level = 100 - i * 5;
			setTimeout(function(){
				setQrcodeAlpha(obj, level);
			}, i * 100);
		})(i);
	}
}

function objDisabled(id, type){
	if($gg(id)){
		// 上一个头像虚化
		setQrcodeAlpha($g(id), type ? 50 : 100);
		$g(id).style.border = type ? 'thick solid #E7686A' : 'thick solid #AED0EE';
		$g(id).style.boxShadow = type ? '0 0 10px #E7686A' : '0 0 10px #AED0EE';
	}
}

function createWxImage(img64, id, idx, flag){
	// 接入小程序的用户左边显示区域
	if(!$gg('bDiv')){
		var bDiv = document.createElement('div');
		bDiv.id = 'bDiv';
		bDiv.style.cssText = 'position:absolute;width:117px;height:720px;left:0px;top:0px;background-image:url(images/application/utils/common/leftB.png);z-index:990';
		var realDis = $g('realDis');
		realDis.appendChild(bDiv);
	}
	var img = new Image();
	img.src = img64;
	img.id = id;
	img.style.cssText = 'position:absolute;width:65px;height:65px;left:20px;top:0px;border-radius:50%;box-shadow:0 0 10px #AED0EE;z-index:991';
	var bDiv = $g('bDiv');
	bDiv.appendChild(img);
	resetPos(idx, flag);
}

function resetPos(idx, flag){
	if(idx == wxUsersArr.length){
		for(var i = 0; i < idx; i++){
			var idxArr = i + 1;
			if($gg(wxUsersArr[i])){
				var id = wxUsersArr[i];
				var target = getIdxTop(wxUsersArr.length, idxArr);
				var speed = 10;
				var anima = getVal('globle', 'animation');
				if(anima == 0) nextDirectY(id, target, function(){});
				else nextSlideY(id, target, speed, function(){});
			}
		}
	}
}

function getIdxTop(len, idx){
	return topPx = (pageH - (len * (picpx[2] + picpx[0]) + (len + 1) * picpx[1])) / 2 + ((idx * picpx[1]) + (idx - 1) * (picpx[2] + picpx[0]));
}