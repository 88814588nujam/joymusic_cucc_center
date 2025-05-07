			function start(){
				if(ctlStart) return;
				ctlStart = true;
				if(stbType.indexOf('TEST') > -1) autoDivHeight();
				else handleDivHeight(0, 0);
				if(rightDiv > 0){
					allowClick = false;
					$g('tips').style.visibility = 'hidden';
					$g('inputWords').innerHTML = speedstr;
					$g('right_default').style.display = 'none';
					if(rightDiv == 2) $g('right_artist_y').style.display = 'block';
					else if(rightDiv == 4) $g('right_artist_n').style.display = 'block';
					var viewUrl = 'h4', opr = 0;
					startViewPage(viewUrl, userip, userid, cityN, pageId, '', '', opr, function(data){
						viewId = data.viewId;
						getContent();
					});
				} else{
					loadContentSong(0);
					loadContentArtist(1);
					var viewUrl = 'h4', opr = 0;
					startViewPage(viewUrl, userip, userid, cityN, pageId, '', '', opr, function(data){ viewId = data.viewId; });
				}
				$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				var tempS = getIdx(nowFocus, 'f_search_');
				var tmpRow = 0;
				if(tempS > 67 && tempS < 76) tmpRow = tempS - 67;
				else if(tempS > 75 && tempS < 84) tmpRow = tempS - 75;
				else if(tempS > 83 && tempS < 92) tmpRow = tempS - 83;
				if(tmpRow > 0) $g('back_' + tmpRow).style.visibility = 'visible';
				var tmpRow1 = 0;
				if(tempS > 119 && tempS < 124) tmpRow1 = tempS - 119;
				else if(tempS > 123 && tempS < 128) tmpRow1 = tempS - 123;
				else if(tempS > 127 && tempS < 132) tmpRow1 = tempS - 127;
				if(tmpRow1 > 0) $g('back_e_' + tmpRow1).style.visibility = 'visible';
			}

			function loadContentSong(idx){
				if(!loadFlag[idx]){
					allowClick = false;
					for(var i = 1; i <= jsonSong.length; i++){
						var realIdx = jsonSong.length - i;
						$g('s_' + i).innerText = jsonSong[realIdx].cname.replace('(HD)', '') + ' - ' + jsonSong[realIdx].artist;
						if(jsonSong[realIdx].cfree == 0) $g('free_s_' + i).style.visibility = 'visible';
					}
				}
				loadFlag[idx] = true;
			}

			function loadContentArtist(idx){
				if(!loadFlag[idx]){
					allowClick = false;
					for(var i = 1; i <= jsonArtist.length; i++){
						var realIdx = jsonArtist.length - i;
						$g('ap_' + i).src = 'images/commonly/artist/c_' + jsonArtist[realIdx].pic;
						$g('at_' + i).innerText = jsonArtist[realIdx].cname;
						if(i == jsonArtist.length) allowClick = true;
					}
				}
				loadFlag[idx] = true;
			}

			function getEleInfo(idx){
				var jsonStr = null;
				for(var i = 0; i < jsonRec.length; i++){
					if(idx == i){
						jsonStr = jsonRec[i];
					}
				}
				return jsonStr;
			}

			function onkeyOK(){
				if(allowClick){
					if(t9pop > 0){
						if(searchFlag){
							allowClick = false;
							var words = '';
							if(t9pop == 2) words = 'B';
							else if(t9pop == 3) words = 'E';
							else if(t9pop == 4) words = 'H';
							else if(t9pop == 5) words = 'K';
							else if(t9pop == 6) words = 'O';
							else if(t9pop == 7) words = 'Q';
							else if(t9pop == 8) words = 'U';
							else if(t9pop == 9) words = 'X';
							$g('tips').style.visibility = 'hidden';
							$g('inputWords').innerHTML += words;
							speedstr += words;
							t9pop = 0;
							$g('c_' + nowFocus).style.visibility = 'hidden';
							$g('t9bottom').style.visibility = 'visible';
							$g(nowFocus).setAttribute('class', 'btn_focus_visible');
							pageIndex = 1;
							getContent();
						}
						return;
					}
					var tempF = getIdx(nowFocus, 'f_search_');
					if(tempF == 1){
						if(searchFlag){
							allowClick = false;
							var words = '1';
							$g('tips').style.visibility = 'hidden';
							$g('inputWords').innerHTML += words;
							speedstr += words;
							pageIndex = 1;
							getContent();
						}
					} else if(tempF > 1 && tempF < 10){
						if(searchFlag){
							t9pop = tempF;
							$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
							$g('t9bottom').style.visibility = 'hidden';
							$g('c_' + nowFocus).style.visibility = 'visible';
						}
					} else if(tempF == 10){
						if(searchFlag){
							allowClick = false;
							var words = '0';
							$g('tips').style.visibility = 'hidden';
							$g('inputWords').innerHTML += words;
							speedstr += words;
							pageIndex = 1;
							getContent();
						}
					} else if(tempF > 10 && tempF < 47){
						if(searchFlag){
							allowClick = false;
							var picPath = $g(nowFocus).src;
							var words = picPath.substring(picPath.lastIndexOf('/') + 1, picPath.length);
							words = words.replace('f_', '').replace('.png', '');
							$g('tips').style.visibility = 'hidden';
							$g('inputWords').innerHTML += words;
							speedstr += words;
							pageIndex = 1;
							getContent();
						}
					} else if(tempF == 47){
						if(preferKeyboard == 1){
							preferKeyboard = 0;
							$g('allDiv').style.display = 'none';
							$g('t9Div').style.display = 'block';
							$g('c_f_search_48').style.visibility = 'hidden';
							put('globle', 'preferKeyboard', preferKeyboard + '');
							var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=1&k=' + preferKeyboard + '&u=' + userid + '\'}]';
							var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
							ajaxRequest('POST', reqUrl, null);
						}
					} else if(tempF == 48){
						if(preferKeyboard == 0){
							preferKeyboard = 1;
							$g('t9Div').style.display = 'none';
							$g('allDiv').style.display = 'block';
							$g('c_f_search_47').style.visibility = 'hidden';
							put('globle', 'preferKeyboard', preferKeyboard + '');
							var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=1&k=' + preferKeyboard + '&u=' + userid + '\'}]';
							var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
							ajaxRequest('POST', reqUrl, null);
						}
					} else if(tempF == 49){
						var len = Number($g('inputWords').innerText.length);
						if(len > 0){
							searchFlag = true;
							allowClick = false;
							var str = $g('inputWords').innerText;
							$g('inputWords').innerText = str.substring(0, str.length - 1);
							len = Number($g('inputWords').innerText.length);
							if(len == 0) $g('tips').style.visibility = 'visible';
							$g('inputWords').style.color = '#FFFFFF';
							speedstr = $g('inputWords').innerText;
							pageIndex = 1;
							if(rightDiv == 3){
								rightDiv = 1;
								$g('right_song_n').style.display = 'none';
								$g('right_song_y').style.display = 'block';
							} else if(rightDiv == 4){
								rightDiv = 2;
								$g('right_artist_n').style.display = 'none';
								$g('right_artist_y').style.display = 'block';
							}
							getContent();
						}
					} else if(tempF == 50){
						var len = Number($g('inputWords').innerText.length);
						if(len > 0){
							searchFlag = true;
							allowClick = false;
							$g('inputWords').innerText = '';
							$g('tips').style.visibility = 'visible';
							$g('inputWords').style.color = '#FFFFFF';
							speedstr = '';
							pageIndex = 1;
							if(rightDiv == 3){
								rightDiv = 1;
								$g('right_song_n').style.display = 'none';
								$g('right_song_y').style.display = 'block';
							} else if(rightDiv == 4){
								rightDiv = 2;
								$g('right_artist_n').style.display = 'none';
								$g('right_artist_y').style.display = 'block';
							}
							getContent();
						}
					} else if(tempF == 51){
						var toPageId = 14;
						put('request', 'params', 'i=' + toPageId);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&o=' + rightDiv + '&k=' + speedstr + '&p=' + pageIndex + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF == 52){
						var toPageId = 13;
						put('request', 'params', 'i=' + toPageId);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&o=' + rightDiv + '&k=' + speedstr + '&p=' + pageIndex + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF > 52 && tempF < 61){
						var realIdx = 60 - tempF;
						var dataUrl = 'h2';
						var sid = jsonSong[realIdx].sid;
						var hour = getVal('globle', 'hour');
						var max = getVal('globle', 'max');
						var opr = 1;
						operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
							allowClick = false;
							var songName = jsonSong[realIdx].cname;
							var artistName = jsonSong[realIdx].artist;
							msg.type = getVal('globle', 'preferBubble');
							msg.createMsgArea($g('realDis'));
							msg.sendMsg('即将播放 - [' + songName + ' - ' + artistName + ']');
							var nowNumInt = Number(json.list_num);
							$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
							toPlayer();
						});
					} else if(tempF > 60 && tempF < 66){
						var realIdx = 65 - tempF;
						var toPageId = 7;
						if(preferList == 1) toPageId = 8;
						put('request', 'params', 'i=' + toPageId + '&k=' + jsonArtist[realIdx].aid);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, jsonArtist[realIdx].aid);
					} else if(tempF > 67 && tempF < 76){
						var realIdx = tempF - 68;
						var dataUrl = 'h2';
						var sid = songList[realIdx].sid;
						var hour = getVal('globle', 'hour');
						var max = getVal('globle', 'max');
						var opr = 1;
						operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
							allowClick = false;
							var songName = songList[realIdx].cname;
							var artistName = songList[realIdx].artist;
							msg.type = getVal('globle', 'preferBubble');
							msg.createMsgArea($g('realDis'));
							msg.sendMsg('即将播放 - [' + songName + ' - ' + artistName + ']');
							var nowNumInt = Number(json.list_num);
							$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
							toPlayer();
						});
					} else if(tempF > 75 && tempF < 84){
						var realIdx = tempF - 76;
						var dataUrl = 'h2';
						var sid = songList[realIdx].sid;
						var opr = 2;
						var tpy = 1;
						operaCollect(dataUrl, sid, userid, tpy, opr, function(json){
							collectStr = json.list_ids_str;
							var operaType = json.opera_type;
							var songName = songList[realIdx].cname;
							var artistName = songList[realIdx].artist;
							msg.type = getVal('globle', 'preferBubble');
							msg.createMsgArea($g('realDis'));
							var msgStr = '';
							if(operaType == 1){
								$g('search_' + tempF).src = 'images/application/pages/search/song/collect.png';
								$g('f_search_' + tempF).src = 'images/application/pages/search/song/focus/f_collect.png';
								msgStr = '成功删除收藏曲目 [' + songName + ' - ' + artistName + ']';
							} else{
								$g('search_' + tempF).src = 'images/application/pages/search/song/collect0.png';
								$g('f_search_' + tempF).src = 'images/application/pages/search/song/focus/f_collect0.png';
								msgStr = '成功收藏曲目 [' + songName + ' - ' + artistName + ']';
							}
							msg.sendMsg(msgStr);
						});
					} else if(tempF > 83 && tempF < 92){
						var realIdx = tempF - 84;
						var dataUrl = 'h2';
						var sid = songList[realIdx].sid;
						var hour = getVal('globle', 'hour');
						var max = getVal('globle', 'max');
						var opr = 1;
						operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
							var songName = songList[realIdx].cname;
							var artistName = songList[realIdx].artist;
							msg.type = getVal('globle', 'preferBubble');
							msg.createMsgArea($g('realDis'));
							msg.sendMsg('成功添加曲目 [' + songName + ' - ' + artistName + ']');
							var nowNumInt = Number(json.list_num);
							$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
						});
					} else if(tempF == 66 || tempF == 106 || tempF == 118 || tempF == 135){
						if(rightDiv != 1 && rightDiv != 3){
							allowClick = false;
							pageIndex = 1;
							rightDiv = 1;
							$g('right_default').style.display = 'none';
							$g('rtDiv').style.visibility = 'visible';
							$g('right_artist_y').style.display = 'none';
							$g('right_artist_n').style.display = 'none';
							getContent();
						}
					} else if(tempF == 67 || tempF == 107 || tempF == 119 || tempF == 136){
						if(rightDiv != 2 && rightDiv != 4){
							allowClick = false;
							pageIndex = 1;
							rightDiv = 2;
							$g('right_default').style.display = 'none';
							$g('rtDiv').style.visibility = 'visible';
							$g('right_song_y').style.display = 'none';
							$g('right_song_n').style.display = 'none';
							getContent();
						}
					} else if(tempF == 92 || tempF == 104){
						if(pageIndex > 1){
							allowClick = false;
							answerFlag = false;
							pageIndex--;
							getContent();
						}
					} else if(tempF == 93 || tempF == 105){
						if(pageIndex < pageTotal){
							allowClick = false;
							answerFlag = false;
							pageIndex++;
							getContent();
						}
					} else if(tempF > 107 && tempF < 118){
						var realIdx = tempF - 108;
						var toPageId = 7;
						if(preferList == 1) toPageId = 8;
						put('request', 'params', 'i=' + toPageId + '&k=' + artistList[realIdx].aid);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&o=' + rightDiv + '&k=' + speedstr + '&p=' + pageIndex + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, artistList[realIdx].aid);
					} else if(tempF > 119 && tempF < 124){
						var realIdx = tempF - 120;
						var dataUrl = 'h2';
						var sid = songList[realIdx].sid;
						var hour = getVal('globle', 'hour');
						var max = getVal('globle', 'max');
						var opr = 1;
						operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
							allowClick = false;
							var songName = songList[realIdx].cname;
							var artistName = songList[realIdx].artist;
							msg.type = getVal('globle', 'preferBubble');
							msg.createMsgArea($g('realDis'));
							msg.sendMsg('即将播放 - [' + songName + ' - ' + artistName + ']');
							var nowNumInt = Number(json.list_num);
							$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
							toPlayer();
						});
					} else if(tempF > 123 && tempF < 128){
						var realIdx = tempF - 124;
						var dataUrl = 'h2';
						var sid = songList[realIdx].sid;
						var opr = 2;
						var tpy = 1;
						operaCollect(dataUrl, sid, userid, tpy, opr, function(json){
							collectStr = json.list_ids_str;
							var operaType = json.opera_type;
							var songName = songList[realIdx].cname;
							var artistName = songList[realIdx].artist;
							msg.type = getVal('globle', 'preferBubble');
							msg.createMsgArea($g('realDis'));
							var msgStr = '';
							if(operaType == 1){
								$g('search_' + tempF).src = 'images/application/pages/search/song/collect.png';
								$g('f_search_' + tempF).src = 'images/application/pages/search/song/focus/f_collect.png';
								msgStr = '成功删除收藏曲目 [' + songName + ' - ' + artistName + ']';
							} else{
								$g('search_' + tempF).src = 'images/application/pages/search/song/collect0.png';
								$g('f_search_' + tempF).src = 'images/application/pages/search/song/focus/f_collect0.png';
								msgStr = '成功收藏曲目 [' + songName + ' - ' + artistName + ']';
							}
							msg.sendMsg(msgStr);
						});
					} else if(tempF > 127 && tempF < 132){
						var realIdx = tempF - 128;
						var dataUrl = 'h2';
						var sid = songList[realIdx].sid;
						var hour = getVal('globle', 'hour');
						var max = getVal('globle', 'max');
						var opr = 1;
						operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
							var songName = songList[realIdx].cname;
							var artistName = songList[realIdx].artist;
							msg.type = getVal('globle', 'preferBubble');
							msg.createMsgArea($g('realDis'));
							msg.sendMsg('成功添加曲目 [' + songName + ' - ' + artistName + ']');
							var nowNumInt = Number(json.list_num);
							$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
						});
					} else if((tempF > 131 && tempF < 135) || (tempF > 141 && tempF < 145)){
						tempF = tempF < 142 ? tempF - 132 : tempF - 142;
						var jsonStr = getEleInfo(tempF);
						var onclick_type = Number(jsonStr.onclick_type);
						var curl = jsonStr.curl;
						var params = jsonStr.params;
						if(onclick_type == 1){ // 专题_自由式
							var toPageId = curl;
							put('request', 'params', 'i=' + toPageId + '&' + params);
							var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&o=' + rightDiv + '&k=' + speedstr + '&p=' + pageIndex + '\'}]}';
							addToBack(nowInfo);
							toOtrPage(tempF, toPageId, '');
						} else if(onclick_type == 2){ // 专题_列表式
							var toPageId = 11;
							if(preferList == 1) toPageId = 12;
							put('request', 'params', 'i=' + toPageId + '&' + params);
							var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&o=' + rightDiv + '&k=' + speedstr + '&p=' + pageIndex + '\'}]}';
							addToBack(nowInfo);
							toOtrPage(tempF, toPageId, '');
						} else if(onclick_type == 3){ // 单曲点播
							var dataUrl = 'h2';
							var sid = params;
							var hour = getVal('globle', 'hour');
							var max = getVal('globle', 'max');
							var opr = 1;
							operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
								allowClick = false;
								ajaxRequest('POST', dataUrl + '?o=4&s=' + sid, function() {
									if(xmlhttp.readyState == 4){
										if(xmlhttp.status == 200){
											var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
											var contentJson = eval('(' + retText + ')');
											var songName = contentJson.cname.replace('(HD)', '');
											var artistName = contentJson.artist;
											msg.type = getVal('globle', 'preferBubble');
											msg.createMsgArea($g('realDis'));
											msg.sendMsg('即将播放 - [' + songName + ' - ' + artistName + ']');
											toPlayer();
										}
									}
								});
							});
						}
					} else if(tempF > 136 && tempF < 142){
						var realIdx = tempF - 137;
						var toPageId = 7;
						if(preferList == 1) toPageId = 8;
						put('request', 'params', 'i=' + toPageId + '&k=' + artistList[realIdx].aid);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&o=' + rightDiv + '&k=' + speedstr + '&p=' + pageIndex + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, artistList[realIdx].aid);
					}
				}
			}

			function onkeyBack(){
				if(allowClick){
					if(t9pop > 0){
						t9pop = 0;
						$g('c_' + nowFocus).style.visibility = 'hidden';
						$g('t9bottom').style.visibility = 'visible';
						$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					} else{
						var toPageId = 1;
						var key = '';
						var returnPage = getVal('globle', 'return');
						if(returnPage){
							var jsonR = eval('(' + returnPage + ')');
							toPageId = jsonR[jsonR.length - 1].back[0].target;
							var params = jsonR[jsonR.length - 1].back[1].params;
							if(params.indexOf('k=') > -1){
								params = params.substr(params.indexOf('k=') + ('k='.length));
								if(params.indexOf('&') > -1) key = params.substr(0, params.indexOf('&'));
								else key = params;
							}
						}
						var viewUrl = 'h4', opr = 1;
						endViewPage(viewUrl, userid, -1, toPageId, key, viewId, opr, function(){
							__return();
						});
					}
				}
			}

			function onkeyLeft(){
				if(allowClick){
					if(t9pop > 0){
						if(searchFlag){
							allowClick = false;
							var words = '';
							if(t9pop == 2) words = 'A';
							else if(t9pop == 3) words = 'D';
							else if(t9pop == 4) words = 'G';
							else if(t9pop == 5) words = 'J';
							else if(t9pop == 6) words = 'M';
							else if(t9pop == 7) words = 'P';
							else if(t9pop == 8) words = 'T';
							else if(t9pop == 9) words = 'W';
							$g('tips').style.visibility = 'hidden';
							$g('inputWords').innerHTML += words;
							speedstr += words;
							t9pop = 0;
							$g('c_' + nowFocus).style.visibility = 'hidden';
							$g('t9bottom').style.visibility = 'visible';
							$g(nowFocus).setAttribute('class', 'btn_focus_visible');
							pageIndex = 1;
							getContent();
						}
						return;
					}
					var tempF = getIdx(nowFocus, 'f_search_');
					if(tempF == 48 && preferKeyboard == 1) $g('c_' + nowFocus).style.visibility = 'visible';
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if((tempF > 1 && tempF < 4) || (tempF > 4 && tempF < 7) || (tempF > 7 && tempF < 10) || (tempF > 11 && tempF < 17) || (tempF > 17 && tempF < 23)
						|| (tempF > 23 && tempF < 29) || (tempF > 29 && tempF < 35) || (tempF > 35 && tempF < 41) || (tempF > 41 && tempF < 47) || tempF == 48){
						var newIdx = tempF - 1;
						nowFocus = 'f_search_' + newIdx;
					} else if(tempF == 52) nowFocus = 'f_search_51';
					else{
						if(preferKeyboard == 0){
							if(tempF == 10) nowFocus = 'f_search_49';
							else if(tempF == 50) nowFocus = 'f_search_10';
							else{
								if(rightDiv == 0){
									if(tempF == 51) nowFocus = 'f_search_48';
									else if(tempF == 53 || tempF == 54) nowFocus = 'f_search_3';
									else if(tempF == 55 || tempF == 56) nowFocus = 'f_search_6';
									else if(tempF > 56 && tempF < 61){
										var newIdx = tempF - 4;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 61) nowFocus = 'f_search_50';
									else if(tempF > 61 && tempF < 66){
										var newIdx = tempF - 1;
										nowFocus = 'f_search_' + newIdx;
									}
								} else if(rightDiv == 1){
									if(tempF == 51) nowFocus = 'f_search_67';
									else if(tempF == 67) nowFocus = 'f_search_66';
									else if(tempF == 66 || tempF == 68 || tempF == 69) nowFocus = 'f_search_3';
									else if(tempF == 70 || tempF == 71) nowFocus = 'f_search_6';
									else if(tempF == 72 || tempF == 73) nowFocus = 'f_search_9';
									else if(tempF == 74 || tempF == 75) nowFocus = 'f_search_50';
									else if(tempF > 75 && tempF < 92){
										var newIdx = tempF - 8;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 92){
										if(pageSum >= 3) nowFocus = 'f_search_86';
										else{
											var newIdx = pageSum + 83;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 93){
										if(pageSum >= 5) nowFocus = 'f_search_88';
										else{
											var newIdx = pageSum + 83;
											nowFocus = 'f_search_' + newIdx;
										}
									}
								} else if(rightDiv == 2){
									if(tempF == 51) nowFocus = 'f_search_107';
									else if(tempF == 107) nowFocus = 'f_search_106';
									else if(tempF == 106 || tempF == 108) nowFocus = 'f_search_3';
									else if(tempF == 113) nowFocus = 'f_search_9';
									else if((tempF > 108 && tempF < 113) || (tempF > 113 && tempF < 118)){
										var newIdx = tempF - 1;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 104){
										if(pageSum >= 5) nowFocus = 'f_search_112';
										else{
											var newIdx = pageSum + 107;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 105){
										if(pageSum >= 10) nowFocus = 'f_search_117';
										else{
											var newIdx = pageSum + 107;
											nowFocus = 'f_search_' + newIdx;
										}
									}
								} else if(rightDiv == 3){
									if(tempF == 51) nowFocus = 'f_search_119';
									else if(tempF == 119) nowFocus = 'f_search_118';
									else if(tempF == 118 || tempF == 120 || tempF == 121) nowFocus = 'f_search_3';
									else if(tempF == 122 || tempF == 123) nowFocus = 'f_search_6';
									else if(tempF == 132) nowFocus = 'f_search_50';
									else if(tempF > 123 && tempF < 132){
										var newIdx = tempF - 4;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF > 132 && tempF < 135){
										var newIdx = tempF - 1;
										nowFocus = 'f_search_' + newIdx;
									}
								} else if(rightDiv == 4){
									if(tempF == 51) nowFocus = 'f_search_136';
									else if(tempF == 136) nowFocus = 'f_search_135';
									else if(tempF == 135 || tempF == 137) nowFocus = 'f_search_3';
									else if(tempF == 142) nowFocus = 'f_search_50';
									else if((tempF > 137 && tempF < 142) || (tempF > 142 && tempF < 145)){
										var newIdx = tempF - 1;
										nowFocus = 'f_search_' + newIdx;
									}
								}
							}
						} else{
							if(tempF == 50) nowFocus = 'f_search_49';
							else{
								if(rightDiv == 0){
									if(tempF == 51) nowFocus = 'f_search_48';
									else if(tempF == 53 || tempF == 54) nowFocus = 'f_search_16';
									else if(tempF == 55) nowFocus = 'f_search_22';
									else if(tempF == 56) nowFocus = 'f_search_28';
									else if(tempF > 56 && tempF < 61){
										var newIdx = tempF - 4;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 61) nowFocus = 'f_search_50';
									else if(tempF > 61 && tempF < 66){
										var newIdx = tempF - 1;
										nowFocus = 'f_search_' + newIdx;
									}
								} else if(rightDiv == 1){
									if(tempF == 51) nowFocus = 'f_search_67';
									else if(tempF == 67) nowFocus = 'f_search_66';
									else if(tempF == 66) nowFocus = 'f_search_16';
									else if(tempF > 67 && tempF < 74){
										var newIdx = (tempF - 68) * 6 + 16;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 74 || tempF == 75) nowFocus = 'f_search_50';
									else if(tempF > 75 && tempF < 92){
										var newIdx = tempF - 8;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 92){
										if(pageSum >= 3) nowFocus = 'f_search_86';
										else{
											var newIdx = pageSum + 83;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 93){
										if(pageSum >= 5) nowFocus = 'f_search_88';
										else{
											var newIdx = pageSum + 83;
											nowFocus = 'f_search_' + newIdx;
										}
									}
								} else if(rightDiv == 2){
									if(tempF == 51) nowFocus = 'f_search_107';
									else if(tempF == 107) nowFocus = 'f_search_106';
									else if(tempF == 106 || tempF == 108) nowFocus = 'f_search_16';
									else if(tempF == 113) nowFocus = 'f_search_40';
									else if((tempF > 108 && tempF < 113) || (tempF > 113 && tempF < 118)){
										var newIdx = tempF - 1;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 104){
										if(pageSum >= 5) nowFocus = 'f_search_112';
										else{
											var newIdx = pageSum + 107;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 105){
										if(pageSum >= 10) nowFocus = 'f_search_117';
										else{
											var newIdx = pageSum + 107;
											nowFocus = 'f_search_' + newIdx;
										}
									}
								} else if(rightDiv == 3){
									if(tempF == 51) nowFocus = 'f_search_119';
									else if(tempF == 119) nowFocus = 'f_search_118';
									else if(tempF == 118 || tempF == 120) nowFocus = 'f_search_16';
									else if(tempF == 121) nowFocus = 'f_search_22';
									else if(tempF == 122) nowFocus = 'f_search_28';
									else if(tempF == 123) nowFocus = 'f_search_34';
									else if(tempF == 132) nowFocus = 'f_search_50';
									else if(tempF > 123 && tempF < 132){
										var newIdx = tempF - 4;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF > 132 && tempF < 135){
										var newIdx = tempF - 1;
										nowFocus = 'f_search_' + newIdx;
									}
								} else if(rightDiv == 4){
									if(tempF == 51) nowFocus = 'f_search_136';
									else if(tempF == 136) nowFocus = 'f_search_135';
									else if(tempF == 135 || tempF == 137) nowFocus = 'f_search_16';
									else if(tempF == 142) nowFocus = 'f_search_50';
									else if((tempF > 137 && tempF < 142) || (tempF > 142 && tempF < 145)){
										var newIdx = tempF - 1;
										nowFocus = 'f_search_' + newIdx;
									}
								}
							}
						}
					}
					var tempS = getIdx(nowFocus, 'f_search_');
					if(tempS == 47 && preferKeyboard == 0) $g('c_' + nowFocus).style.visibility = 'hidden';
					else if(tempS == 48 && preferKeyboard == 1) $g('c_' + nowFocus).style.visibility = 'hidden';
					if(rightDiv == 1){
						if(tempF == 67){
							$g('search_' + tempS).style.visibility = 'hidden';
							$g('search_' + tempF).style.visibility = 'visible';
						} else if(tempF == 66) $g('search_' + tempF).style.visibility = 'visible';
						else{
							if(tempS == 67) $g('search_' + tempS).style.visibility = 'hidden';
						}
						if((tempS == 75 || tempS == 83 || tempS == 91) && pageTotal > pageIndex) $g('nextPS').style.visibility = 'visible';
						else $g('nextPS').style.visibility = 'hidden';
					} else if(rightDiv == 2){
						if(tempF == 107){
							$g('search_' + tempS).style.visibility = 'hidden';
							$g('search_' + tempF).style.visibility = 'visible';
						} else if(tempF == 106) $g('search_' + tempF).style.visibility = 'visible';
						else{
							if(tempS == 107) $g('search_' + tempS).style.visibility = 'hidden';
						}
						if((tempS > 112 && tempS < 118) && pageTotal > pageIndex) $g('nextPA').style.visibility = 'visible';
						else $g('nextPA').style.visibility = 'hidden';
					} else if(rightDiv == 3){
						if(tempF == 119){
							$g('search_' + tempS).style.visibility = 'hidden';
							$g('search_' + tempF).style.visibility = 'visible';
						} else if(tempF == 118) $g('search_' + tempF).style.visibility = 'visible';
						else{
							if(tempS == 119) $g('search_' + tempS).style.visibility = 'hidden';
						}
					} else if(rightDiv == 4){
						if(tempF == 136){
							$g('search_' + tempS).style.visibility = 'hidden';
							$g('search_' + tempF).style.visibility = 'visible';
						} else if(tempF == 135) $g('search_' + tempF).style.visibility = 'visible';
						else{
							if(tempS == 136) $g('search_' + tempS).style.visibility = 'hidden';
						}
					}
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					displayBack(tempF, tempS);
				}
			}

			function onkeyRight(){
				if(allowClick){
					if(t9pop > 0){
						if(searchFlag){
							allowClick = false;
							var words = '';
							if(t9pop == 2) words = 'C';
							else if(t9pop == 3) words = 'F';
							else if(t9pop == 4) words = 'I';
							else if(t9pop == 5) words = 'L';
							else if(t9pop == 6) words = 'N';
							else if(t9pop == 7) words = 'R';
							else if(t9pop == 8) words = 'V';
							else if(t9pop == 9) words = 'Y';
							$g('tips').style.visibility = 'hidden';
							$g('inputWords').innerHTML += words;
							speedstr += words;
							t9pop = 0;
							$g('c_' + nowFocus).style.visibility = 'hidden';
							$g('t9bottom').style.visibility = 'visible';
							$g(nowFocus).setAttribute('class', 'btn_focus_visible');
							pageIndex = 1;
							getContent();
						}
						return;
					}
					var tempF = getIdx(nowFocus, 'f_search_');
					if(tempF == 47 && preferKeyboard == 0) $g('c_' + nowFocus).style.visibility = 'visible';
					else if(tempF == 48 && preferKeyboard == 1) $g('c_' + nowFocus).style.visibility = 'visible';
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if((tempF > 0 && tempF < 3) || (tempF > 3 && tempF < 6) || (tempF > 6 && tempF < 9) || (tempF > 10 && tempF < 16) || (tempF > 16 && tempF < 22)
						|| (tempF > 22 && tempF < 28) || (tempF > 28 && tempF < 34) || (tempF > 34 && tempF < 40) || (tempF > 40 && tempF < 46) || tempF == 47){
						var newIdx = tempF + 1;
						nowFocus = 'f_search_' + newIdx;
					} else if(tempF == 51) nowFocus = 'f_search_52';
					else{
						if(preferKeyboard == 0){
							if(tempF == 10) nowFocus = 'f_search_50';
							else if(tempF == 49) nowFocus = 'f_search_10';
							else{
								if(rightDiv == 0){
									if(tempF == 48) nowFocus = 'f_search_53';
									else if(tempF == 3) nowFocus = 'f_search_54';
									else if(tempF == 6) nowFocus = 'f_search_56';
									else if(tempF == 9 || tempF == 50) nowFocus = 'f_search_61';
									else if(tempF > 52 && tempF < 57){
										var newIdx = tempF + 4;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF > 60 && tempF < 65){
										var newIdx = tempF + 1;
										nowFocus = 'f_search_' + newIdx;
									}
								} else if(rightDiv == 1){
									if(tempF == 48) nowFocus = 'f_search_66';
									else if(tempF == 66) nowFocus = 'f_search_67';
									else if(tempF == 67) nowFocus = 'f_search_68';
									else if(tempF == 3){
										if(pageSum >= 2) nowFocus = 'f_search_69';
										else{
											var newIdx = pageSum + 67;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 6){
										if(pageSum >= 4) nowFocus = 'f_search_71';
										else{
											var newIdx = pageSum + 67;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 9){
										if(pageSum >= 6) nowFocus = 'f_search_73';
										else{
											var newIdx = pageSum + 67;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 50){
										if(pageSum >= 8) nowFocus = 'f_search_75';
										else{
											var newIdx = pageSum + 67;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF > 67 && tempF < 84){
										var newIdx = tempF + 8;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF > 83 && tempF < 88){
										if(pageTotal > 1) nowFocus = 'f_search_92';
									} else if(tempF > 87 && tempF < 92){
										if(pageTotal > 1) nowFocus = 'f_search_93';
									}
								} else if(rightDiv == 2){
									if(tempF == 48) nowFocus = 'f_search_106';
									else if(tempF == 106) nowFocus = 'f_search_107';
									else if(tempF == 107){
										if(pageSum > 2) nowFocus = 'f_search_110';
										else if(pageSum == 2) nowFocus = 'f_search_109';
										else nowFocus = 'f_search_51';
									} else if(tempF == 3 || tempF == 6) nowFocus = 'f_search_108';
									else if(tempF == 9 || tempF == 50){
										if(pageSum >= 6) nowFocus = 'f_search_113';
										else nowFocus = 'f_search_108';
									} else if((tempF > 107 && tempF < 112) || (tempF > 112 && tempF < 117)){
										var tmpRow = tempF - 107;
										if(pageSum > tmpRow){
											var newIdx = tempF + 1;
											nowFocus = 'f_search_' + newIdx;
										} else{
											if(tempF > 107 && tempF < 112){
												if(pageTotal > 1) nowFocus = 'f_search_104';
											} else if(tempF > 112 && tempF < 117){
												if(pageTotal > 1) nowFocus = 'f_search_105';
												else{
													var newIdx = tempF - 4;
													nowFocus = 'f_search_' + newIdx;
												}
											}
										}
									} else if(tempF == 112){
										if(pageTotal > 1) nowFocus = 'f_search_104';
									} else if(tempF == 117){
										if(pageTotal > 1) nowFocus = 'f_search_105';
									}
								} else if(rightDiv == 3){
									if(tempF == 48) nowFocus = 'f_search_118';
									else if(tempF == 118) nowFocus = 'f_search_119';
									else if(tempF == 119) nowFocus = 'f_search_120';
									else if(tempF == 3) nowFocus = 'f_search_121';
									else if(tempF == 6) nowFocus = 'f_search_123';
									else if(tempF == 9 || tempF == 50) nowFocus = 'f_search_132';
									else if(tempF > 119 && tempF < 128){
										var newIdx = tempF + 4;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF > 131 && tempF < 134){
										var newIdx = tempF + 1;
										nowFocus = 'f_search_' + newIdx;
									}
								} else if(rightDiv == 4){
									if(tempF == 48) nowFocus = 'f_search_135';
									else if(tempF == 135) nowFocus = 'f_search_136';
									else if(tempF == 136) nowFocus = 'f_search_139';
									else if(tempF == 3 || tempF == 6) nowFocus = 'f_search_137';
									else if(tempF == 9 || tempF == 50) nowFocus = 'f_search_142';
									else if((tempF > 136 && tempF < 141) || (tempF > 141 && tempF < 144)){
										var newIdx = tempF + 1;
										nowFocus = 'f_search_' + newIdx;
									}
								}
							}
						} else{
							if(tempF == 49) nowFocus = 'f_search_50';
							else{
								if(rightDiv == 0){
									if(tempF == 48) nowFocus = 'f_search_53';
									else if(tempF == 16) nowFocus = 'f_search_54';
									else if(tempF == 22) nowFocus = 'f_search_55';
									else if(tempF == 28 || tempF == 34) nowFocus = 'f_search_56';
									else if(tempF == 40 || tempF == 46 || tempF == 50) nowFocus = 'f_search_61';
									else if(tempF > 52 && tempF < 57){
										var newIdx = tempF + 4;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF > 60 && tempF < 65){
										var newIdx = tempF + 1;
										nowFocus = 'f_search_' + newIdx;
									}
								} else if(rightDiv == 1){
									if(tempF == 48) nowFocus = 'f_search_66';
									else if(tempF == 66) nowFocus = 'f_search_67';
									else if(tempF == 67 || tempF == 16) nowFocus = 'f_search_68';
									else if(tempF == 22){
										if(pageSum >= 2) nowFocus = 'f_search_69';
										else{
											var newIdx = pageSum + 67;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 28){
										if(pageSum >= 3) nowFocus = 'f_search_70';
										else{
											var newIdx = pageSum + 67;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 34){
										if(pageSum >= 4) nowFocus = 'f_search_71';
										else{
											var newIdx = pageSum + 67;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 40){
										if(pageSum >= 5) nowFocus = 'f_search_72';
										else{
											var newIdx = pageSum + 67;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 46){
										if(pageSum >= 6) nowFocus = 'f_search_73';
										else{
											var newIdx = pageSum + 67;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 50){
										if(pageSum >= 8) nowFocus = 'f_search_75';
										else{
											var newIdx = pageSum + 67;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF > 67 && tempF < 84){
										var newIdx = tempF + 8;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF > 83 && tempF < 88){
										if(pageTotal > 1) nowFocus = 'f_search_92';
									} else if(tempF > 87 && tempF < 92){
										if(pageTotal > 1) nowFocus = 'f_search_93';
									}
								} else if(rightDiv == 2){
									if(tempF == 48) nowFocus = 'f_search_106';
									else if(tempF == 106) nowFocus = 'f_search_107';
									else if(tempF == 107){
										if(pageSum > 2) nowFocus = 'f_search_110';
										else if(pageSum == 2) nowFocus = 'f_search_109';
										else nowFocus = 'f_search_51';
									} else if(tempF == 16 || tempF == 22 || tempF == 28) nowFocus = 'f_search_108';
									else if(tempF == 34 || tempF == 40 || tempF == 46 || tempF == 50){
										if(pageSum >= 6) nowFocus = 'f_search_113';
										else nowFocus = 'f_search_108';
									} else if((tempF > 107 && tempF < 112) || (tempF > 112 && tempF < 117)){
										var tmpRow = tempF - 107;
										if(pageSum > tmpRow){
											var newIdx = tempF + 1;
											nowFocus = 'f_search_' + newIdx;
										} else{
											if(tempF > 107 && tempF < 112){
												if(pageTotal > 1) nowFocus = 'f_search_104';
											} else if(tempF > 112 && tempF < 117){
												if(pageTotal > 1) nowFocus = 'f_search_105';
												else{
													var newIdx = tempF - 4;
													nowFocus = 'f_search_' + newIdx;
												}
											}
										}
									} else if(tempF == 112){
										if(pageTotal > 1) nowFocus = 'f_search_104';
									} else if(tempF == 117){
										if(pageTotal > 1) nowFocus = 'f_search_105';
									}
								} else if(rightDiv == 3){
									if(tempF == 48) nowFocus = 'f_search_118';
									else if(tempF == 118) nowFocus = 'f_search_119';
									else if(tempF == 119 || tempF == 16) nowFocus = 'f_search_120';
									else if(tempF == 22) nowFocus = 'f_search_121';
									else if(tempF == 28) nowFocus = 'f_search_122';
									else if(tempF == 34) nowFocus = 'f_search_123';
									else if(tempF == 40 || tempF == 46 || tempF == 50) nowFocus = 'f_search_132';
									else if(tempF > 119 && tempF < 128){
										var newIdx = tempF + 4;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF > 131 && tempF < 134){
										var newIdx = tempF + 1;
										nowFocus = 'f_search_' + newIdx;
									}
								} else if(rightDiv == 4){
									if(tempF == 48) nowFocus = 'f_search_135';
									else if(tempF == 135) nowFocus = 'f_search_136';
									else if(tempF == 136) nowFocus = 'f_search_139';
									else if(tempF == 16 || tempF == 22 || tempF == 28 || tempF == 34) nowFocus = 'f_search_137';
									else if(tempF == 40 || tempF == 46 || tempF == 50) nowFocus = 'f_search_142';
									else if((tempF > 136 && tempF < 141) || (tempF > 141 && tempF < 144)){
										var newIdx = tempF + 1;
										nowFocus = 'f_search_' + newIdx;
									}
								}
							}
						}
					}
					var tempS = getIdx(nowFocus, 'f_search_');
					if(tempS == 48 && preferKeyboard == 1) $g('c_' + nowFocus).style.visibility = 'hidden';
					if(rightDiv == 1){
						if(tempF == 66){
							$g('search_' + tempS).style.visibility = 'hidden';
							$g('search_' + tempF).style.visibility = 'visible';
						} else if(tempF == 67) $g('search_' + tempF).style.visibility = 'visible';
						else{
							if(tempS == 66) $g('search_' + tempS).style.visibility = 'hidden';
						}
						if((tempS == 75 || tempS == 83 || tempS == 91) && pageTotal > pageIndex) $g('nextPS').style.visibility = 'visible';
						else $g('nextPS').style.visibility = 'hidden';
					} else if(rightDiv == 2){
						if(tempF == 106){
							$g('search_' + tempS).style.visibility = 'hidden';
							$g('search_' + tempF).style.visibility = 'visible';
						} else if(tempF == 107) $g('search_' + tempF).style.visibility = 'visible';
						else{
							if(tempS == 106) $g('search_' + tempS).style.visibility = 'hidden';
						}
						if((tempS > 112 && tempS < 118) && pageTotal > pageIndex) $g('nextPA').style.visibility = 'visible';
						else $g('nextPA').style.visibility = 'hidden';
					} else if(rightDiv == 3){
						if(tempF == 118){
							$g('search_' + tempS).style.visibility = 'hidden';
							$g('search_' + tempF).style.visibility = 'visible';
						} else if(tempF == 119) $g('search_' + tempF).style.visibility = 'visible';
						else{
							if(tempS == 118) $g('search_' + tempS).style.visibility = 'hidden';
						}
					} else if(rightDiv == 4){
						if(tempF == 135){
							$g('search_' + tempS).style.visibility = 'hidden';
							$g('search_' + tempF).style.visibility = 'visible';
						} else if(tempF == 136) $g('search_' + tempF).style.visibility = 'visible';
						else{
							if(tempS == 135) $g('search_' + tempS).style.visibility = 'hidden';
						}
					}
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					displayBack(tempF, tempS);
				}
			}

			function onkeyUp(){
				if(allowClick){
					if(t9pop > 0){
						if(searchFlag){
							allowClick = false;
							var words = t9pop;
							$g('tips').style.visibility = 'hidden';
							$g('inputWords').innerHTML += words;
							speedstr += words;
							t9pop = 0;
							$g('c_' + nowFocus).style.visibility = 'hidden';
							$g('t9bottom').style.visibility = 'visible';
							$g(nowFocus).setAttribute('class', 'btn_focus_visible');
							pageIndex = 1;
							getContent();
						}
						return;
					}
					var tempF = getIdx(nowFocus, 'f_search_');
					if(tempF == 67 && rightDiv == 1) $g('search_' + tempF).style.visibility = 'visible';
					else if(tempF == 106 && rightDiv == 2) $g('search_' + tempF).style.visibility = 'visible';
					else if(tempF == 119 && rightDiv == 3) $g('search_' + tempF).style.visibility = 'visible';
					else if(tempF == 135 && rightDiv == 4) $g('search_' + tempF).style.visibility = 'visible';
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF > 3 && tempF < 10){
						var newIdx = tempF - 3;
						nowFocus = 'f_search_' + newIdx;
					} else if(tempF > 16 && tempF < 47){
						var newIdx = tempF - 6;
						nowFocus = 'f_search_' + newIdx;
					} else{
						if(preferKeyboard == 0){
							if(tempF == 1) nowFocus = 'f_search_47';
							else if(tempF == 2 || tempF == 3) nowFocus = 'f_search_48';
							else if(tempF == 10) nowFocus = 'f_search_8';
							else if(tempF == 49) nowFocus = 'f_search_7';
							else if(tempF == 50) nowFocus = 'f_search_9';
							else{
								if(rightDiv == 0){
									if(tempF == 53 || tempF == 57) nowFocus = 'f_search_51';
									else if((tempF > 53 && tempF < 57) || (tempF > 57 && tempF < 61)){
										var newIdx = tempF - 1;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 61 || tempF == 62 || tempF == 63) nowFocus = 'f_search_56';
									else if(tempF == 64 || tempF == 65) nowFocus = 'f_search_60';
								} else if(rightDiv == 1){
									if((tempF > 68 && tempF < 76) || (tempF > 76 && tempF < 84) || (tempF > 84 && tempF < 92) || tempF == 93){
										var newIdx = tempF - 1;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 92){
										if(pageSum >= 2) nowFocus = 'f_search_85';
										else{
											var newIdx = pageSum + 83;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 66 || tempF == 67) nowFocus = 'f_search_51';
									else if(tempF == 68 || tempF == 76 || tempF == 84) nowFocus = 'f_search_67';
								} else if(rightDiv == 2){
									if(tempF > 112 && tempF < 118){
										var newIdx = tempF - 5;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 105) nowFocus = 'f_search_104';
									else if(tempF == 106 || tempF == 107) nowFocus = 'f_search_51';
									else if(tempF == 108) nowFocus = 'f_search_106';
									else if(tempF > 108 && tempF < 113) nowFocus = 'f_search_107';
									else if(tempF == 104){
										if(pageSum >= 5) nowFocus = 'f_search_112';
										else{
											var newIdx = pageSum + 107;
											nowFocus = 'f_search_' + newIdx;
										}
									}
								} else if(rightDiv == 3){
									if((tempF > 120 && tempF < 124) || (tempF > 124 && tempF < 128) || (tempF > 128 && tempF < 132)){
										var newIdx = tempF - 1;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 118 || tempF == 119) nowFocus = 'f_search_51';
									else if(tempF == 120 || tempF == 124 || tempF == 128) nowFocus = 'f_search_119';
									else if(tempF == 132 || tempF == 133) nowFocus = 'f_search_123';
									else if(tempF == 134) nowFocus = 'f_search_131';
								} else if(rightDiv == 4){
									if(tempF == 137) nowFocus = 'f_search_135';
									else if(tempF > 137 && tempF < 142) nowFocus = 'f_search_136';
									else if(tempF == 142) nowFocus = 'f_search_137';
									else if(tempF == 143) nowFocus = 'f_search_139';
									else if(tempF == 144) nowFocus = 'f_search_141';
									else if(tempF == 135 || tempF == 136) nowFocus = 'f_search_51';
								}
							}
						} else{
							if(tempF == 11 || tempF == 12 || tempF == 13) nowFocus = 'f_search_47';
							else if(tempF == 14 || tempF == 15 || tempF == 16) nowFocus = 'f_search_48';
							else if(tempF == 49) nowFocus = 'f_search_41';
							else if(tempF == 50) nowFocus = 'f_search_46';
							else{
								if(rightDiv == 0){
									if(tempF == 53 || tempF == 57) nowFocus = 'f_search_51';
									else if((tempF > 53 && tempF < 57) || (tempF > 57 && tempF < 61)){
										var newIdx = tempF - 1;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 61 || tempF == 62 || tempF == 63) nowFocus = 'f_search_56';
									else if(tempF == 64 || tempF == 65) nowFocus = 'f_search_60';
								} else if(rightDiv == 1){
									if((tempF > 68 && tempF < 76) || (tempF > 76 && tempF < 84) || (tempF > 84 && tempF < 92) || tempF == 93){
										var newIdx = tempF - 1;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 92){
										if(pageSum >= 2) nowFocus = 'f_search_85';
										else{
											var newIdx = pageSum + 83;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 66 || tempF == 67) nowFocus = 'f_search_51';
									else if(tempF == 68 || tempF == 76 || tempF == 84) nowFocus = 'f_search_67';
								} else if(rightDiv == 2){
									if(tempF > 112 && tempF < 118){
										var newIdx = tempF - 5;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 105) nowFocus = 'f_search_104';
									else if(tempF == 106 || tempF == 107) nowFocus = 'f_search_51';
									else if(tempF == 108) nowFocus = 'f_search_106';
									else if(tempF > 108 && tempF < 113) nowFocus = 'f_search_107';
									else if(tempF == 104){
										if(pageSum >= 5) nowFocus = 'f_search_112';
										else{
											var newIdx = pageSum + 107;
											nowFocus = 'f_search_' + newIdx;
										}
									}
								} else if(rightDiv == 3){
									if((tempF > 120 && tempF < 124) || (tempF > 124 && tempF < 128) || (tempF > 128 && tempF < 132)){
										var newIdx = tempF - 1;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 118 || tempF == 119) nowFocus = 'f_search_51';
									else if(tempF == 120 || tempF == 124 || tempF == 128) nowFocus = 'f_search_119';
									else if(tempF == 132 || tempF == 133) nowFocus = 'f_search_123';
									else if(tempF == 134) nowFocus = 'f_search_131';
								} else if(rightDiv == 4){
									if(tempF == 137) nowFocus = 'f_search_135';
									else if(tempF > 137 && tempF < 142) nowFocus = 'f_search_136';
									else if(tempF == 142) nowFocus = 'f_search_137';
									else if(tempF == 143) nowFocus = 'f_search_139';
									else if(tempF == 144) nowFocus = 'f_search_141';
									else if(tempF == 135 || tempF == 136) nowFocus = 'f_search_51';
								}
							}
						}
					}
					var tempS = getIdx(nowFocus, 'f_search_');
					if((tempS == 47 && preferKeyboard == 0) || (tempS == 48 && preferKeyboard == 1)) $g('c_' + nowFocus).style.visibility = 'hidden';
					if(rightDiv == 1){
						if(tempS == 66 || tempS == 67) $g('search_' + tempS).style.visibility = 'hidden';
						else{
							if(tempF == 66 || tempF == 67) $g('search_' + tempF).style.visibility = 'visible';
						}
						if((tempS == 75 || tempS == 83 || tempS == 91) && pageTotal > pageIndex) $g('nextPS').style.visibility = 'visible';
						else $g('nextPS').style.visibility = 'hidden';
					} else if(rightDiv == 2){
						if(tempS == 106 || tempS == 107) $g('search_' + tempS).style.visibility = 'hidden';
						else{
							if(tempF == 106 || tempF == 107) $g('search_' + tempF).style.visibility = 'visible';
						}
						if((tempS > 112 && tempS < 118) && pageTotal > pageIndex) $g('nextPA').style.visibility = 'visible';
						else $g('nextPA').style.visibility = 'hidden';
					} else if(rightDiv == 3){
						if(tempS == 118 || tempS == 119) $g('search_' + tempS).style.visibility = 'hidden';
						else{
							if(tempF == 118 || tempF == 119) $g('search_' + tempF).style.visibility = 'visible';
						}
					} else if(rightDiv == 4){
						if(tempS == 135 || tempS == 136) $g('search_' + tempS).style.visibility = 'hidden';
						else{
							if(tempF == 135 || tempF == 136) $g('search_' + tempF).style.visibility = 'visible';
						}
					}
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					displayBack(tempF, tempS);
				}
			}

			function onkeyDown(){
				if(allowClick){
					if(t9pop > 0){
						if(searchFlag){
							var words = '';
							if(t9pop == 7) words = 'S';
							else if(t9pop == 9) words = 'Z';
							if(words != ''){
								allowClick = false;
								$g('tips').style.visibility = 'hidden';
								$g('inputWords').innerHTML += words;
								speedstr += words;
								t9pop = 0;
								$g('c_' + nowFocus).style.visibility = 'hidden';
								$g('t9bottom').style.visibility = 'visible';
								$g(nowFocus).setAttribute('class', 'btn_focus_visible');
								pageIndex = 1;
								getContent();
							}
						}
						return;
					}
					var tempF = getIdx(nowFocus, 'f_search_');
					if((tempF == 47 && preferKeyboard == 0) || (tempF == 48 && preferKeyboard == 1)) $g('c_' + nowFocus).style.visibility = 'visible';
					if(tempF == 67 && rightDiv == 1) $g('search_' + tempF).style.visibility = 'visible';
					else if(tempF == 106 && rightDiv == 2) $g('search_' + tempF).style.visibility = 'visible';
					else if(tempF == 119 && rightDiv == 3) $g('search_' + tempF).style.visibility = 'visible';
					else if(tempF == 135 && rightDiv == 4) $g('search_' + tempF).style.visibility = 'visible';
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF > 0 && tempF < 7){
						var newIdx = tempF + 3;
						nowFocus = 'f_search_' + newIdx;
					} else if(tempF > 10 && tempF < 41){
						var newIdx = tempF + 6;
						nowFocus = 'f_search_' + newIdx;
					} else{
						if(preferKeyboard == 0){
							if(tempF == 47) nowFocus = 'f_search_1';
							else if(tempF == 48) nowFocus = 'f_search_3';
							else if(tempF == 7) nowFocus = 'f_search_49';
							else if(tempF == 8) nowFocus = 'f_search_10';
							else if(tempF == 9) nowFocus = 'f_search_50';
							else{
								if(rightDiv == 0){
									if(tempF == 51 || tempF == 52) nowFocus = 'f_search_57';
									else if((tempF > 52 && tempF < 56) || (tempF > 56 && tempF < 60)){
										var newIdx = tempF + 1;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 56) nowFocus = 'f_search_61';
									else if(tempF == 60) nowFocus = 'f_search_64';
								} else if(rightDiv == 1){
									if((tempF > 67 && tempF < 75) || (tempF > 75 && tempF < 83) || (tempF > 83 && tempF < 91)){
										var tmpRow = 0;
										if(tempF > 67 && tempF < 75) tmpRow = tempF - 67;
										else if(tempF > 75 && tempF < 83) tmpRow = tempF - 75;
										else if(tempF > 83 && tempF < 91) tmpRow = tempF - 83;
										if(tmpRow < pageSum){
											var newIdx = tempF + 1;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 93){
										if(pageSum >= 6) nowFocus = 'f_search_89';
										else{
											var newIdx = pageSum + 83;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 51 || tempF == 52) nowFocus = 'f_search_67';
									else if(tempF == 66 || tempF == 67) nowFocus = 'f_search_68';
									else if(tempF == 92) nowFocus = 'f_search_93';
									else if(tempF == 75 || tempF == 83 || tempF == 91){
										if(pageIndex < pageTotal){
											allowClick = false;
											answerFlag = true;
											pageIndex++;
											getContent();
										}
									}
								} else if(rightDiv == 2){
									if(tempF > 107 && tempF < 113){
										var tmpRow = tempF - 107 + 5;
										if(pageSum >= tmpRow){
											var newIdx = tempF + 5;
											nowFocus = 'f_search_' + newIdx;
										} else if(pageSum > 5 && pageSum < tmpRow){
											var newIdx = pageSum + 107;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 104) nowFocus = 'f_search_105';
									else if(tempF == 105){
										if(pageSum >= 10) nowFocus = 'f_search_117';
										else if(pageSum > 5 && pageSum < 10){
											var newIdx = pageSum + 107;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 106) nowFocus = 'f_search_108';
									else if(tempF == 107){
										if(pageSum >= 2) nowFocus = 'f_search_109';
										else nowFocus = 'f_search_108';
									} else if(tempF == 51 || tempF == 52) nowFocus = 'f_search_107';
									else if(tempF > 112 && tempF < 118){
										if(pageIndex < pageTotal){
											allowClick = false;
											answerFlag = true;
											pageIndex++;
											getContent();
										}
									}
								} else if(rightDiv == 3){
									if((tempF > 119 && tempF < 123) || (tempF > 123 && tempF < 127) || (tempF > 127 && tempF < 131)){
										var newIdx = tempF + 1;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 51 || tempF == 52) nowFocus = 'f_search_119';
									else if(tempF == 118 || tempF == 119) nowFocus = 'f_search_120';
									else if(tempF == 123 || tempF == 127 || tempF == 131) nowFocus = 'f_search_134';
								} else if(rightDiv == 4){
									if(tempF == 51 || tempF == 52) nowFocus = 'f_search_136';
									else if(tempF == 135) nowFocus = 'f_search_137';
									else if(tempF == 136) nowFocus = 'f_search_138';
									else if(tempF == 137 || tempF == 138) nowFocus = 'f_search_142';
									else if(tempF == 139) nowFocus = 'f_search_143';
									else if(tempF == 140 || tempF == 141) nowFocus = 'f_search_144';
								}
							}
						} else{
							if(tempF == 47) nowFocus = 'f_search_11';
							else if(tempF == 48) nowFocus = 'f_search_16';
							else if(tempF == 41 || tempF == 42 || tempF == 43) nowFocus = 'f_search_49';
							else if(tempF == 44 || tempF == 45 || tempF == 46) nowFocus = 'f_search_50';
							else{
								if(rightDiv == 0){
									if(tempF == 51 || tempF == 52) nowFocus = 'f_search_57';
									else if((tempF > 52 && tempF < 56) || (tempF > 56 && tempF < 60)){
										var newIdx = tempF + 1;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 56) nowFocus = 'f_search_61';
									else if(tempF == 60) nowFocus = 'f_search_64';
								} else if(rightDiv == 1){
									if((tempF > 67 && tempF < 75) || (tempF > 75 && tempF < 83) || (tempF > 83 && tempF < 91)){
										var tmpRow = 0;
										if(tempF > 67 && tempF < 75) tmpRow = tempF - 67;
										else if(tempF > 75 && tempF < 83) tmpRow = tempF - 75;
										else if(tempF > 83 && tempF < 91) tmpRow = tempF - 83;
										if(tmpRow < pageSum){
											var newIdx = tempF + 1;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 93){
										if(pageSum >= 6) nowFocus = 'f_search_89';
										else{
											var newIdx = pageSum + 83;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 51 || tempF == 52) nowFocus = 'f_search_67';
									else if(tempF == 66) nowFocus = 'f_search_68';
									else if(tempF == 67) nowFocus = 'f_search_68';
									else if(tempF == 92) nowFocus = 'f_search_93';
									else if(tempF == 75 || tempF == 83 || tempF == 91){
										if(pageIndex < pageTotal){
											allowClick = false;
											answerFlag = true;
											pageIndex++;
											getContent();
										}
									}
								} else if(rightDiv == 2){
									if(tempF > 107 && tempF < 113){
										var tmpRow = tempF - 107 + 5;
										if(pageSum >= tmpRow){
											var newIdx = tempF + 5;
											nowFocus = 'f_search_' + newIdx;
										} else if(pageSum > 5 && pageSum < tmpRow){
											var newIdx = pageSum + 107;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 104) nowFocus = 'f_search_105';
									else if(tempF == 105){
										if(pageSum >= 10) nowFocus = 'f_search_117';
										else if(pageSum > 5 && pageSum < 10){
											var newIdx = pageSum + 107;
											nowFocus = 'f_search_' + newIdx;
										}
									} else if(tempF == 106) nowFocus = 'f_search_108';
									else if(tempF == 107){
										if(pageSum >= 2) nowFocus = 'f_search_109';
										else nowFocus = 'f_search_108';
									} else if(tempF == 51 || tempF == 52) nowFocus = 'f_search_107';
									else if(tempF > 112 && tempF < 118){
										if(pageIndex < pageTotal){
											allowClick = false;
											answerFlag = true;
											pageIndex++;
											getContent();
										}
									}
								} else if(rightDiv == 3){
									if((tempF > 119 && tempF < 123) || (tempF > 123 && tempF < 127) || (tempF > 127 && tempF < 131)){
										var newIdx = tempF + 1;
										nowFocus = 'f_search_' + newIdx;
									} else if(tempF == 51 || tempF == 52) nowFocus = 'f_search_119';
									else if(tempF == 118 || tempF == 119) nowFocus = 'f_search_120';
									else if(tempF == 123 || tempF == 127 || tempF == 131) nowFocus = 'f_search_134';
								} else if(rightDiv == 4){
									if(tempF == 51 || tempF == 52) nowFocus = 'f_search_136';
									else if(tempF == 135) nowFocus = 'f_search_137';
									else if(tempF == 136) nowFocus = 'f_search_138';
									else if(tempF == 137 || tempF == 138) nowFocus = 'f_search_142';
									else if(tempF == 139) nowFocus = 'f_search_143';
									else if(tempF == 140 || tempF == 141) nowFocus = 'f_search_144';
								}
							}
						}
					}
					var tempS = getIdx(nowFocus, 'f_search_');
					if(rightDiv == 1){
						if(tempS == 66 || tempS == 67) $g('search_' + tempS).style.visibility = 'hidden';
						else{
							if(tempF == 66 || tempF == 67) $g('search_' + tempF).style.visibility = 'visible';
						}
						if((tempS == 75 || tempS == 83 || tempS == 91) && pageTotal > pageIndex) $g('nextPS').style.visibility = 'visible';
						else $g('nextPS').style.visibility = 'hidden';
					} else if(rightDiv == 2){
						if(tempS == 106 || tempS == 107) $g('search_' + tempS).style.visibility = 'hidden';
						else{
							if(tempF == 106 || tempF == 107) $g('search_' + tempF).style.visibility = 'visible';
						}
						if((tempS > 112 && tempS < 118) && pageTotal > pageIndex) $g('nextPA').style.visibility = 'visible';
						else $g('nextPA').style.visibility = 'hidden';
					} else if(rightDiv == 3){
						if(tempS == 118 || tempS == 119) $g('search_' + tempS).style.visibility = 'hidden';
						else{
							if(tempF == 118 || tempF == 119) $g('search_' + tempF).style.visibility = 'visible';
						}
					} else if(rightDiv == 4){
						if(tempS == 135 || tempS == 136) $g('search_' + tempS).style.visibility = 'hidden';
						else{
							if(tempF == 135 || tempF == 136) $g('search_' + tempF).style.visibility = 'visible';
						}
					}
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					displayBack(tempF, tempS);
				}
			}

			function onKeyOther(key){
				if(allowClick){
					if(rightDiv == 1 || rightDiv == 2){
						if(key == 258 || key == 219 || key == 33){
							if(pageIndex > 1){
								allowClick = false;
								answerFlag = true;
								pageIndex--;
								getContent();
							}
						} else if(key == 257 || key == 221 || key == 34){
							if(pageIndex < pageTotal){
								allowClick = false;
								answerFlag = true;
								pageIndex++;
								getContent();
							}
						}
					}
				}
			}

			function displayBack(tempF, tempS){
				if(rightDiv == 1){
					var tmpRow1 = 0;
					if(tempF > 67 && tempF < 76) tmpRow1 = tempF - 67;
					else if(tempF > 75 && tempF < 84) tmpRow1 = tempF - 75;
					else if(tempF > 83 && tempF < 92) tmpRow1 = tempF - 83;
					var tmpRow2 = 0;
					if(tempS > 67 && tempS < 76) tmpRow2 = tempS - 67;
					else if(tempS > 75 && tempS < 84) tmpRow2 = tempS - 75;
					else if(tempS > 83 && tempS < 92) tmpRow2 = tempS - 83;
					if(tmpRow1 != tmpRow2){
						if(tmpRow1 > 0) $g('back_' + tmpRow1).style.visibility = 'hidden';
						if(tmpRow2 > 0) $g('back_' + tmpRow2).style.visibility = 'visible';
					}
				} else if(rightDiv == 3){
					var tmpRow1 = 0;
					if(tempF > 119 && tempF < 124) tmpRow1 = tempF - 119;
					else if(tempF > 123 && tempF < 128) tmpRow1 = tempF - 123;
					else if(tempF > 127 && tempF < 132) tmpRow1 = tempF - 127;
					var tmpRow2 = 0;
					if(tempS > 119 && tempS < 124) tmpRow2 = tempS - 119;
					else if(tempS > 123 && tempS < 128) tmpRow2 = tempS - 123;
					else if(tempS > 127 && tempS < 132) tmpRow2 = tempS - 127;
					if(tmpRow1 != tmpRow2){
						if(tmpRow1 > 0) $g('back_e_' + tmpRow1).style.visibility = 'hidden';
						if(tmpRow2 > 0) $g('back_e_' + tmpRow2).style.visibility = 'visible';
					}
				}
			}

			function getContent(){
				$g('right_default').style.display = 'none';
				$g('rtDiv').style.visibility = 'visible';
				if(rightDiv == 0 || rightDiv == 3) rightDiv = 1;
				else if(rightDiv == 4) rightDiv = 2;
				var dtype = rightDiv + 1;
				var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=' + dtype + '&k=' + speedstr + '&p=' + pageIndex + '\'}]';
				var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
				if(rightDiv == 1) ajaxRequest('POST', reqUrl, getSongBack);
				else if(rightDiv == 2) ajaxRequest('POST', reqUrl, getArtistBack);
			}

			function getArtistBack(){
				if(xmlhttp.readyState == 4){
					if(xmlhttp.status == 200){
						var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
						var contentJson = eval('(' + retText + ')');
						ifNull = contentJson.ifNull;
						totalRowsS = Number(contentJson.totalRowsS);
						totalRowsA = Number(contentJson.totalRowsA);
						pageTotal = Number(contentJson.pageTotal);
						pageSum = Number(contentJson.pageSum);
						artistList = contentJson.artistList;
						if(!ifNull){
							rightDiv = 2;
							$g('right_artist_n').style.display = 'none';
							$g('right_artist_y').style.display = 'block';
							$g('search_106').style.visibility = 'visible';
							$g('totalRowsSA').innerText = '(' + (totalRowsS > 1000 ?  (totalRowsS / 1000).toFixed(2) + 'k' : totalRowsS) + ')';
							$g('totalRowsAA').innerText = '(' + (totalRowsA > 1000 ?  (totalRowsA / 1000).toFixed(2) + 'k' : totalRowsA) + ')';
							if(answerFlag){
								var tempF = getIdx(nowFocus, 'f_search_');
								if(tempF > 107 && tempF < 118){
									var tmpRow = tempF - 107;
									if(pageSum < tmpRow){
										$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
										var newIdx = pageSum + 107;
										nowFocus = 'f_search_' + newIdx;
										$g(nowFocus).setAttribute('class', 'btn_focus_visible');
									}
								}
								answerFlag = false;
							} else{
								var tempF = getIdx(nowFocus, 'f_search_');
								if(tempF == 67 || tempF == 107 || tempF == 119 || tempF == 136){
									$g('search_107').style.visibility = 'hidden';
									$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
									nowFocus = 'f_search_107';
									$g(nowFocus).setAttribute('class', 'btn_focus_visible');
								} else $g('search_107').style.visibility = 'visible';
							}
							if(pageTotal > 1){
								$g('pageDivA').style.visibility = 'visible';
								$g('pageIndexA').innerText = pageIndex;
								$g('pageTotalA').innerText = pageTotal;
							} else{
								$g('pageDivA').style.visibility = 'hidden';
								$g('pageIndexA').innerText = '';
								$g('pageTotalA').innerText = '';
							}
							for(var i = 1; i <= 10; i++){
								var realIdx = i - 1;
								if(realIdx < artistList.length){
									$g('d_a_' + i).innerText = artistList[realIdx].cname.replace('(HD)', '');
									$g('d_p_' + i).src = 'images/commonly/artist/c_' + artistList[realIdx].pic;
								} else{
									$g('d_a_' + i).innerText = '';
									$g('d_p_' + i).src = 'images/application/pages/search/commonly/null.png';
								}
								if(i == 10) allowClick = true;
							}
							var tempS = getIdx(nowFocus, 'f_search_');
							if((tempS > 112 && tempS < 118) && pageTotal > pageIndex) $g('nextPA').style.visibility = 'visible';
							else $g('nextPA').style.visibility = 'hidden';
						} else{
							rightDiv = 4;
							$g('right_artist_y').style.display = 'none';
							$g('right_artist_n').style.display = 'block';
							$g('search_135').style.visibility = 'visible';
							$g('totalRowsSF').innerText = '(' + (totalRowsS > 1000 ?  (totalRowsS / 1000).toFixed(2) + 'k' : totalRowsS) + ')';
							$g('totalRowsAF').innerText = '(' + (totalRowsA > 1000 ?  (totalRowsA / 1000).toFixed(2) + 'k' : totalRowsA) + ')';
							if(!loadFlag[3]){
								for(var i = 1; i <= jsonRec.length; i++){
									var realIdx = i - 1;
									$g('f_r_' + i).src = 'images/commonly/song/' + jsonRec[realIdx].pic;
								}
								loadFlag[3] = true;
							}
							for(var i = 1; i <= 5; i++){
								var realIdx = i - 1;
								$g('f_a_' + i).innerText = artistList[realIdx].cname.replace('(HD)', '');
								$g('f_p_' + i).src = 'images/commonly/artist/c_' + artistList[realIdx].pic;
								if(i == 5) allowClick = true;
							}
							if(totalRowsS == 0){
								searchFlag = false;
								$g('inputWords').style.color = '#EC6878';
							}
							var tempF = getIdx(nowFocus, 'f_search_');
							if(tempF == 67 || tempF == 107 || tempF == 119){
								$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
								$g('search_135').style.visibility = 'visible';
								$g('search_136').style.visibility = 'hidden';
								nowFocus = 'f_search_136';
								var tempS = getIdx(nowFocus, 'f_search_');
								$g(nowFocus).setAttribute('class', 'btn_focus_visible');
							} else $g('search_136').style.visibility = 'visible';
						}
					}
				}
			}

			function getSongBack(){
				if(xmlhttp.readyState == 4){
					if(xmlhttp.status == 200){
						var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
						var contentJson = eval('(' + retText + ')');
						ifNull = contentJson.ifNull;
						totalRowsS = Number(contentJson.totalRowsS);
						totalRowsA = Number(contentJson.totalRowsA);
						pageTotal = Number(contentJson.pageTotal);
						pageSum = Number(contentJson.pageSum);
						songList = contentJson.songList;
						if(!ifNull){
							rightDiv = 1;
							$g('right_song_n').style.display = 'none';
							$g('right_song_y').style.display = 'block';
							$g('search_67').style.visibility = 'visible';
							$g('totalRowsS').innerText = '(' + (totalRowsS > 1000 ?  (totalRowsS / 1000).toFixed(2) + 'k' : totalRowsS) + ')';
							$g('totalRowsA').innerText = '(' + (totalRowsA > 1000 ?  (totalRowsA / 1000).toFixed(2) + 'k' : totalRowsA) + ')';
							if(answerFlag){
								var tempF = getIdx(nowFocus, 'f_search_');
								if(tempF > 67 && tempF < 92){
									var tmpRow = 0;
									if(tempF > 67 && tempF < 76) tmpRow = tempF - 67;
									else if(tempF > 75 && tempF < 84) tmpRow = tempF - 75;
									else if(tempF > 83 && tempF < 92) tmpRow = tempF - 83;
									if(pageSum < tmpRow){
										$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
										var newIdx = 0;
										if(tempF > 67 && tempF < 76) newIdx = pageSum + 67;
										else if(tempF > 75 && tempF < 84) newIdx = pageSum + 75;
										else if(tempF > 83 && tempF < 92) newIdx = pageSum + 83;
										nowFocus = 'f_search_' + newIdx;
										var tempS = getIdx(nowFocus, 'f_search_');
										$g(nowFocus).setAttribute('class', 'btn_focus_visible');
										displayBack(tempF, tempS);
									}
								}
								answerFlag = false;
							} else{
								var tempF = getIdx(nowFocus, 'f_search_');
								if(tempF == 66 || tempF == 106 || tempF == 118 || tempF == 135){
									$g('search_66').style.visibility = 'hidden';
									$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
									nowFocus = 'f_search_66';
									$g(nowFocus).setAttribute('class', 'btn_focus_visible');
								} else $g('search_66').style.visibility = 'visible';
							}
							if(pageTotal > 1){
								$g('pageDiv').style.visibility = 'visible';
								$g('pageIndex').innerText = pageIndex;
								$g('pageTotal').innerText = pageTotal;
							} else{
								$g('pageDiv').style.visibility = 'hidden';
								$g('pageIndex').innerText = '';
								$g('pageTotal').innerText = '';
							}
							for(var i = 1; i <= 8; i++){
								var realIdx = i - 1;
								if(realIdx < songList.length){
									$g('c_s_' + i).innerText = songList[realIdx].cname.replace('(HD)', '');
									var cfree = songList[realIdx].cfree;
									if(cfree == 0) $g('free_' + i).style.visibility = 'visible';
									else $g('free_' + i).style.visibility = 'hidden';
									$g('c_a_' + i).innerText = songList[realIdx].artist;
									var playIdx = i + 67;
									$g('search_' + playIdx).style.visibility = 'visible';
									var collectIdx = i + 75;
									var collectFlag = 'collect';
									if(collectStr.indexOf(songList[realIdx].sid) > -1) collectFlag = 'collect0';
									$g('search_' + collectIdx).src = 'images/application/pages/search/song/' + collectFlag + '.png';
									$g('f_search_' + collectIdx).src = 'images/application/pages/search/song/focus/f_' + collectFlag + '.png';
									$g('search_' + collectIdx).style.visibility = 'visible';
									var addIdx = i + 83;
									$g('search_' + addIdx).style.visibility = 'visible';
								} else{
									$g('c_s_' + i).innerText = '';
									$g('free_' + i).style.visibility = 'hidden';
									$g('c_a_' + i).innerText = '';
									var playIdx = i + 67;
									$g('search_' + playIdx).style.visibility = 'hidden';
									var collectIdx = i + 75;
									$g('search_' + collectIdx).src = 'images/application/pages/search/song/collect.png';
									$g('f_search_' + collectIdx).src = 'images/application/pages/search/song/focus/f_collect.png';
									$g('search_' + collectIdx).style.visibility = 'hidden';
									var addIdx = i + 83;
									$g('search_' + addIdx).style.visibility = 'hidden';
								}
								if(i == 8) allowClick = true;
							}
							var tempS = getIdx(nowFocus, 'f_search_');
							if((tempS == 75 || tempS == 83 || tempS == 91) && pageTotal > pageIndex) $g('nextPS').style.visibility = 'visible';
							else $g('nextPS').style.visibility = 'hidden';
						} else{
							rightDiv = 3;
							$g('right_song_y').style.display = 'none';
							$g('right_song_n').style.display = 'block';
							$g('search_119').style.visibility = 'visible';
							$g('totalRowsSE').innerText = '(' + (totalRowsS > 1000 ?  (totalRowsS / 1000).toFixed(2) + 'k' : totalRowsS) + ')';
							$g('totalRowsAE').innerText = '(' + (totalRowsA > 1000 ?  (totalRowsA / 1000).toFixed(2) + 'k' : totalRowsA) + ')';
							if(!loadFlag[2]){
								for(var i = 1; i <= jsonRec.length; i++){
									var realIdx = i - 1;
									$g('e_r_' + i).src = 'images/commonly/song/' + jsonRec[realIdx].pic;
								}
								loadFlag[2] = true;
							}
							for(var i = 1; i <= 4; i++){
								var realIdx = i - 1;
								$g('e_s_' + i).innerText = songList[realIdx].cname.replace('(HD)', '');
								var cfree = songList[realIdx].cfree;
								if(cfree == 0) $g('free_e_' + i).style.visibility = 'visible';
								else $g('free_e_' + i).style.visibility = 'hidden';
								$g('e_a_' + i).innerText = songList[realIdx].artist;
								var playIdx = i + 119;
								$g('search_' + playIdx).style.visibility = 'visible';
								var collectIdx = i + 123;
								var collectFlag = 'collect';
								if(collectStr.indexOf(songList[realIdx].sid) > -1) collectFlag = 'collect0';
								$g('search_' + collectIdx).src = 'images/application/pages/search/song/' + collectFlag + '.png';
								$g('f_search_' + collectIdx).src = 'images/application/pages/search/song/focus/f_' + collectFlag + '.png';
								$g('search_' + collectIdx).style.visibility = 'visible';
								var addIdx = i + 127;
								$g('search_' + addIdx).style.visibility = 'visible';
								if(i == 4) allowClick = true;							
							}
							if(totalRowsA == 0){
								searchFlag = false;
								$g('inputWords').style.color = '#EC6878';
							}
							var tempF = getIdx(nowFocus, 'f_search_');
							if(tempF == 66 || tempF == 106 || tempF == 135){
								$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
								$g('search_119').style.visibility = 'visible';
								$g('search_118').style.visibility = 'hidden';
								nowFocus = 'f_search_118';
								var tempS = getIdx(nowFocus, 'f_search_');
								$g(nowFocus).setAttribute('class', 'btn_focus_visible');
							} else $g('search_118').style.visibility = 'visible';
						}
					}
				}
			}

			function toPlayer(){
				var toPageId = 100;
				put('request', 'params', 'i=' + toPageId);
				var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&o=' + rightDiv + '&k=' + speedstr + '&p=' + pageIndex + '\'}]}';
				addToBack(nowInfo);
				var tempF = getIdx(nowFocus, 'f_search_');
				toOtrPage(tempF, toPageId, '');
			}

			function toOtrPage(idx, toPageId, key){
				allowClick = false;
				var delayT = 500;
				var viewUrl = 'h4', opr = 1;
				endViewPage(viewUrl, userid, idx, toPageId, key, viewId, opr, function(){
					setTimeout(function(){round(toPageId);}, delayT);
				});
			}