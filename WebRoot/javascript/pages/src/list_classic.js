			function start(){
				if(ctlStart) return;
				ctlStart = true;
				document.title = aname;
				if(stbType.indexOf('TEST') > -1) autoDivHeight();
				else handleDivHeight(0, 0);
				var viewUrl = 'h4', opr = 0;
				startViewPage(viewUrl, userip, userid, cityN, pageId, albumlistId, '', opr, function(data){
					viewId = data.viewId;
					loadSong();
				});
			}

			function loadSong(){
				allowClick = false;
				var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=1&k=' + albumlistId + '&p=' + pageIndex + '\'}]';
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
						$g('totalRows').innerText = totalRows;
						if(totalRows == 0){
							allowClick = true;
							onkeyBack();
							return;
						}
						if(answerFlag){
							var tempF = getIdx(nowFocus, 'f_list_');
							if(tempF > 0 && tempF < pageLimit * 3 + 1){
								var tmpRow = 0;
								if(tempF > 0 && tempF < pageLimit + 1) tmpRow = tempF;
								else if(tempF > pageLimit && tempF < pageLimit * 2 + 1) tmpRow = tempF - pageLimit;
								else if(tempF > pageLimit * 2 && tempF < pageLimit * 3 + 1) tmpRow = tempF - pageLimit * 2;
								if(pageSum < tmpRow){
									$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
									var newIdx = 0;
									if(tempF > 0 && tempF < pageLimit + 1) newIdx = pageSum;
									else if(tempF > pageLimit && tempF < pageLimit * 2 + 1) newIdx = pageSum + pageLimit;
									else if(tempF > pageLimit * 2 && tempF < pageLimit * 3 + 1) newIdx = pageSum + pageLimit * 2;
									nowFocus = 'f_list_' + newIdx;
									var tempS = getIdx(nowFocus, 'f_list_');
									$g(nowFocus).setAttribute('class', 'btn_focus_visible');
									displayBack(tempF, tempS);
								}
							}
							answerFlag = false;
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
						songIds = '';
						for(var i = 1; i <= pageLimit; i++){
							var realIdx = i - 1;
							if(realIdx < songList.length){
								songIds += songList[realIdx].sid + ',';
								$g('c_s_' + i).innerText = songList[realIdx].cname.replace('(HD)', '');
								var cfree = songList[realIdx].cfree;
								if(cfree == 0) $g('free_' + i).style.visibility = 'visible';
								else $g('free_' + i).style.visibility = 'hidden';
								$g('c_a_' + i).innerText = songList[realIdx].artist;
								var playIdx = i;
								$g('list_' + playIdx).style.visibility = 'visible';
								var collectIdx = i + pageLimit;
								var collectFlag = 'collect';
								if(collectStr.indexOf(songList[realIdx].sid) > -1) collectFlag = 'collect0';
								$g('list_' + collectIdx).src = 'images/application/pages/search/song/' + collectFlag + '.png';
								$g('f_list_' + collectIdx).src = 'images/application/pages/search/song/focus/f_' + collectFlag + '.png';
								$g('list_' + collectIdx).style.visibility = 'visible';
								var addIdx = i + pageLimit * 2;
								$g('list_' + addIdx).style.visibility = 'visible';
							} else{
								$g('c_s_' + i).innerText = '';
								$g('free_' + i).style.visibility = 'hidden';
								$g('c_a_' + i).innerText = '';
								var playIdx = i;
								$g('list_' + playIdx).style.visibility = 'hidden';
								var collectIdx = i + pageLimit;
								$g('list_' + collectIdx).src = 'images/application/pages/search/song/collect.png';
								$g('f_list_' + collectIdx).src = 'images/application/pages/search/song/focus/f_collect.png';
								$g('list_' + collectIdx).style.visibility = 'hidden';
								var addIdx = i + pageLimit * 2;
								$g('list_' + addIdx).style.visibility = 'hidden';
							}
						}
						var tempS = getIdx(nowFocus, 'f_list_');
						if((tempS == pageLimit || tempS == pageLimit * 2 || tempS == pageLimit * 3) && pageTotal > pageIndex) $g('nextP').style.visibility = 'visible';
						else $g('nextP').style.visibility = 'hidden';
						songIds = songIds.substring(0, songIds.length - 1);
						if(!multipleLoad){
							multipleLoad = true;
							$g(nowFocus).setAttribute('class', 'btn_focus_visible');				
							var tempF = getIdx(nowFocus, 'f_list_');
							if(tempF < 100000){
								var realIdx = tempF % pageLimit == 0 ? pageLimit : tempF % pageLimit;
								$g('back_' + realIdx).style.visibility = 'visible';
							}
							animateX('rightDiv_mar', 0, frequency, function(){
								calculateSmallVod();
								$g('pageindexbgReal').style.visibility = 'hidden';
								loadSongRes();
							});
						} else loadSongRes();
					}
				}
			}

			function loadSongRes(){
				allowClick = false;
				var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=3&k=' + songIds + '\'}]';
				var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
				ajaxRequest('POST', reqUrl, loadSongResBack);
			}

			function loadSongResBack(){
				if(xmlhttp.readyState == 4){
					if(xmlhttp.status == 200){
						var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
						var contentJson = eval('(' + retText + ')');
						for(var i = 0; i < songList.length; i++){
							songList[i].cres = contentJson[i].cres;
						}
						toPlay();
						allowClick = true;
					}
				}
			}

			function onkeyOK(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_list_');
					if(tempF == 100001){
						destoryMP();
						var toPageId = 14;
						put('request', 'params', 'i=' + toPageId);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&k=' + albumlistId + '&p=' + pageIndex + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF == 100002){
						destoryMP();
						var toPageId = 13;
						put('request', 'params', 'i=' + toPageId);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&k=' + albumlistId + '&p=' + pageIndex + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF == 100003){
						var opr = 3;
						var dataUrl = 'h2';
						var hour = getVal('globle', 'hour');
						var max = getVal('globle', 'max');
						var docUrl = dataUrl + '?u=' + userid + '&t=' + hour + '&m=' + max + '&p=' + pageId + '&c=' + albumlistId + '&o=' + opr;
						ajaxRequest('POST', docUrl, function(){
							if(xmlhttp.readyState == 4){
								if(xmlhttp.status == 200){
									allowClick = false;
									var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
									var contentJson = eval('(' + retText + ')');
									msg.type = getVal('globle', 'preferBubble');
									msg.createMsgArea($g('realDis'));
									msg.sendMsg('即将播放 [' + aname + '] 列表里的全部曲目');
									var nowNumInt = Number(contentJson.list_num);
									$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
									toPlayer();
								}
							}
						});
					} else if(tempF == 100004){
						destoryMP();
						preferList = 0;
						put('globle', 'preferList', preferList + '');
						var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=2&k=' + preferList + '&u=' + userid + '\'}]';
						var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
						ajaxRequest('POST', reqUrl, doNext);
					} else if(tempF == 100005){
						if(pageIndex > 1){
							answerFlag = false;
							pageIndex--;
							loadSong();
						}
					} else if(tempF == 100006){
						if(pageIndex < pageTotal){
							answerFlag = false;
							pageIndex++;
							loadSong();
						}
					} else{
						var dataUrl = 'h2';
						var hour = getVal('globle', 'hour');
						var max = getVal('globle', 'max');
						if(tempF > 0 && tempF < pageLimit + 1){
							var idx = tempF - 1;
							var sRow = idx + 1;
							var sid = songList[idx].sid;
							var opr = 1;
							operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
								allowClick = false;
								var songName = $g('c_s_' + sRow).innerText;
								var artistName = $g('c_a_' + sRow).innerText;
								msg.type = getVal('globle', 'preferBubble');
								msg.createMsgArea($g('realDis'));
								msg.sendMsg('即将播放 - [' + songName + ' - ' + artistName + ']');
								var nowNumInt = Number(json.list_num);
								$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
								toPlayer();
							});
						} else if(tempF > pageLimit && tempF < pageLimit * 2 + 1){
							var idx = tempF - (pageLimit + 1);
							var sRow = idx + 1;
							var sid = songList[idx].sid;
							var opr = 2;
							var tpy = 1;
							operaCollect(dataUrl, sid, userid, tpy, opr, function(json){
								collectStr = json.list_ids_str;
								var operaType = json.opera_type;
								var songName = $g('c_s_' + sRow).innerText;
								var artistName = $g('c_a_' + sRow).innerText;
								msg.type = getVal('globle', 'preferBubble');
								msg.createMsgArea($g('realDis'));
								var msgStr = '';
								if(operaType == 1){
									$g('list_' + tempF).src = 'images/application/pages/search/song/collect.png';
									$g('f_list_' + tempF).src = 'images/application/pages/search/song/focus/f_collect.png';
									msgStr = '成功删除收藏曲目 [' + songName + ' - ' + artistName + ']';
								} else{
									$g('list_' + tempF).src = 'images/application/pages/search/song/collect0.png';
									$g('f_list_' + tempF).src = 'images/application/pages/search/song/focus/f_collect0.png';
									msgStr = '成功收藏曲目 [' + songName + ' - ' + artistName + ']';
								}
								msg.sendMsg(msgStr);
							});
						} else if(tempF > pageLimit * 2 && tempF < pageLimit * 3 + 1){
							var idx = tempF - (pageLimit * 2 + 1);
							var sRow = idx + 1;
							var sid = songList[idx].sid;
							var opr = 1;
							operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
								var songName = $g('c_s_' + sRow).innerText;
								var artistName = $g('c_a_' + sRow).innerText;
								msg.type = getVal('globle', 'preferBubble');
								msg.createMsgArea($g('realDis'));
								msg.sendMsg('成功添加曲目 [' + songName + ' - ' + artistName + ']');
								var nowNumInt = Number(json.list_num);
								$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
							});
						}
					}
				}
			}

			function onkeyBack(){
				if(allowClick){
					destoryMP();
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

			function onkeyLeft(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_list_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF == 100002) nowFocus = 'f_list_100001';
					else if(tempF == 100001) nowFocus = 'f_list_100003';
					else if(tempF > pageLimit && tempF < pageLimit * 3 + 1){
						var newIdx = tempF - pageLimit;
						nowFocus = 'f_list_' + newIdx;
					} else if(tempF > 0 && tempF < 6) nowFocus = 'f_list_100003';
					else if(tempF > 5 && tempF < 9) nowFocus = 'f_list_100004';
					else if(tempF == 100005){
						if(pageSum >= 3) nowFocus = 'f_list_19';
						else{
							var newIdx = pageSum + pageLimit * 2;
							nowFocus = 'f_list_' + newIdx;
						}
					} else if(tempF == 100006){
						if(pageSum >= 6) nowFocus = 'f_list_22';
						else{
							var newIdx = pageSum + pageLimit * 2;
							nowFocus = 'f_list_' + newIdx;
						}
					}
					var tempS = getIdx(nowFocus, 'f_list_');
					if((tempS == pageLimit || tempS == pageLimit * 2 || tempS == pageLimit * 3) && pageTotal > pageIndex) $g('nextP').style.visibility = 'visible';
					else $g('nextP').style.visibility = 'hidden';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					displayBack(tempF, tempS);
				}
			}

			function onkeyRight(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_list_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF == 100001) nowFocus = 'f_list_100002';
					else if(tempF > pageLimit * 2 && tempF < pageLimit * 3 - 3){
						if(pageTotal > 1) nowFocus = 'f_list_100005';
					} else if(tempF > pageLimit * 3 - 4 && tempF < pageLimit * 3 + 1){
						if(pageTotal > 1) nowFocus = 'f_list_100006';
					} else if(tempF > 0 && tempF < pageLimit * 2 + 1){
						var newIdx = tempF + pageLimit;
						nowFocus = 'f_list_' + newIdx;
					} else if(tempF == 100003){
						if(pageSum >= 5) nowFocus = 'f_list_5';
						else nowFocus = 'f_list_' + pageSum;
					} else if(tempF == 100004){
						if(pageSum >= 6) nowFocus = 'f_list_6';
						else nowFocus = 'f_list_' + pageSum;
					}
					var tempS = getIdx(nowFocus, 'f_list_');
					if((tempS == pageLimit || tempS == pageLimit * 2 || tempS == pageLimit * 3) && pageTotal > pageIndex) $g('nextP').style.visibility = 'visible';
					else $g('nextP').style.visibility = 'hidden';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					displayBack(tempF, tempS);
				}
			}

			function onkeyUp(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_list_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF == 100001) nowFocus = 'f_list_100001';
					else if(tempF == 100003) nowFocus = 'f_list_100001';
					else if(tempF == 100004) nowFocus = 'f_list_100003';
					else if(tempF == 100006) nowFocus = 'f_list_100005';
					else if(tempF == 100005){
						if(pageSum >= 2) nowFocus = 'f_list_18';
						else{
							var newIdx = pageSum + pageLimit * 2;
							nowFocus = 'f_list_' + newIdx;
						}
					} else if((tempF > 1 && tempF < pageLimit + 1) || (tempF > pageLimit + 1 && tempF < pageLimit * 2 + 1) || (tempF > pageLimit * 2 + 1 && tempF < pageLimit * 3 + 1)){
						var newIdx = tempF - 1;
						nowFocus = 'f_list_' + newIdx;
					} else if(tempF == 1 || tempF == pageLimit + 1) nowFocus = 'f_list_100001';
					else if(tempF == pageLimit * 2 + 1) nowFocus = 'f_list_100002';
					var tempS = getIdx(nowFocus, 'f_list_');
					if((tempS == pageLimit || tempS == pageLimit * 2 || tempS == pageLimit * 3) && pageTotal > pageIndex) $g('nextP').style.visibility = 'visible';
					else $g('nextP').style.visibility = 'hidden';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					displayBack(tempF, tempS);
				}
			}

			function onkeyDown(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_list_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF == 100001) nowFocus = 'f_list_1';
					else if(tempF == 100002) nowFocus = 'f_list_17';
					else if(tempF == 100003) nowFocus = 'f_list_100004';
					else if(tempF == 100005) nowFocus = 'f_list_100006';
					else if(tempF == 100006){
						if(pageSum == 6) nowFocus = 'f_list_22';
						else if(pageSum > 6) nowFocus = 'f_list_23';
					} else if((tempF > 0 && tempF < pageLimit) || (tempF > pageLimit && tempF < pageLimit * 2) || (tempF > pageLimit * 2 && tempF < pageLimit * 3)){
						var tmpRow = 0;
						if(tempF > 0 && tempF < pageLimit) tmpRow = tempF;
						else if(tempF > pageLimit && tempF < pageLimit * 2) tmpRow = tempF - pageLimit;
						else if(tempF > pageLimit * 2 && tempF < pageLimit * 3) tmpRow = tempF - pageLimit * 2;
						if(tmpRow < pageSum){
							var newIdx = tempF + 1;
							nowFocus = 'f_list_' + newIdx;
						}
					} else if(tempF == pageLimit || tempF == pageLimit * 2 || tempF == pageLimit * 3){
						if(pageIndex < pageTotal){
							answerFlag = true;
							pageIndex++;
							loadSong();
						}
					}
					var tempS = getIdx(nowFocus, 'f_list_');
					if((tempS == pageLimit || tempS == pageLimit * 2 || tempS == pageLimit * 3) && pageTotal > pageIndex) $g('nextP').style.visibility = 'visible';
					else $g('nextP').style.visibility = 'hidden';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					displayBack(tempF, tempS);
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
						} else if(key == 258 || key == 219 || key == 33){
							if(pageIndex > 1){
								answerFlag = true;
								pageIndex--;
								loadSong();
							}
						} else if(key == 257 || key == 221 || key == 34){
							if(pageIndex < pageTotal){
								answerFlag = true;
								pageIndex++;
								loadSong();
							}
						}
					}
				}
			}

			function displayBack(tempF, tempS){
				var tmpRow1 = 0;
				if(tempF > 0 && tempF < pageLimit + 1) tmpRow1 = tempF;
				else if(tempF > pageLimit && tempF < pageLimit * 2 + 1) tmpRow1 = tempF - pageLimit;
				else if(tempF > pageLimit * 2 && tempF < pageLimit * 3 + 1) tmpRow1 = tempF - pageLimit * 2;
				var tmpRow2 = 0;
				if(tempS > 0 && tempS < pageLimit + 1) tmpRow2 = tempS;
				else if(tempS > pageLimit && tempS < pageLimit * 2 + 1) tmpRow2 = tempS - pageLimit;
				else if(tempS > pageLimit * 2 && tempS < pageLimit * 3 + 1) tmpRow2 = tempS - pageLimit * 2;
				if(tmpRow1 != tmpRow2){
					if(tmpRow1 > 0) $g('back_' + tmpRow1).style.visibility = 'hidden';
					if(tmpRow2 > 0) $g('back_' + tmpRow2).style.visibility = 'visible';
				}
				toPlay();
			}

			function doNext(){
				if(xmlhttp.readyState == 4){
					if(xmlhttp.status == 200){
						var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
						var contentJson = eval('(' + retText + ')');
						allowClick = false;
						var delayT = 500;
						var toPageId = 11;
						put('request', 'params', 'i=' + toPageId + '&n=' + nowFocus + '&k=' + albumlistId);
						var viewUrl = 'h4', opr = 1;
						endViewPage(viewUrl, userid, 100004, toPageId, albumlistId, viewId, opr, function(){
							setTimeout(function(){go(toPageId);}, delayT);
						});
					}
				}
			}

			function toPlayer(){
				var toPageId = 100;
				put('request', 'params', 'i=' + toPageId);
				var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&k=' + albumlistId + '&p=' + pageIndex + '\'}]}';
				addToBack(nowInfo);
				var tempF = getIdx(nowFocus, 'f_list_');
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

			function toPlay(){
				var tempF = getIdx(nowFocus, 'f_list_');
				if(tempF < pageLimit * 3 + 1){
					if(layTimes > -1){
						clearTimeout(layTimes); 
						layTimes = -1;
					}
					layTimes = setTimeout(function(){
						var tmpRow = 0;
						if(tempF > 0 && tempF < pageLimit + 1) tmpRow = tempF;
						else if(tempF > pageLimit && tempF < pageLimit * 2 + 1) tmpRow = tempF - pageLimit;
						else if(tempF > pageLimit * 2 && tempF < pageLimit * 3 + 1) tmpRow = tempF - pageLimit * 2;
						var realIdx = tmpRow - 1;
						if(lastId != songList[realIdx].sid){
							if(playList.length > 0) lastId = songList[realIdx].sid;
							playList[0] = songList[realIdx];
							playNext(stbPos[0], stbPos[1], stbPos[2], stbPos[3], 0);
						}
					}, 1500);
				} else{
					if(layTimes > -1){
						clearTimeout(layTimes); 
						layTimes = -1;
					}
					if(!timesIn){
						if(lastId == ''){
							var realIdx = 0;
							lastId = songList[realIdx].sid;
							playList[0] = songList[realIdx];
							playNext(stbPos[0], stbPos[1], stbPos[2], stbPos[3], 0);
						}
					}
				}
			}

			function animateX(id, target, speed, fun){
				if(animation == 0) nextDirectX(id, target, fun);
				else nextSlideX(id, target, speed, fun);
			}