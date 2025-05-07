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
				var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=1&k=' + albumlistId + '&p=' + pageIndex + '&l=' + pageLimit + '\'}]';
				if(!multipleLoad && pageIndex > 1){
					params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=1&k=' + albumlistId + '&p=1&l=' + pageLimit * pageIndex + '\'}]';
				}
				var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
				ajaxRequest('POST', reqUrl, getSongBack);
			}

			function getSongBack(){
				if(xmlhttp.readyState == 4){
					if(xmlhttp.status == 200){
						var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
						var contentJson = eval('(' + retText + ')');
						totalRows = Number(contentJson.totalRows);
						pageTotal = Number(contentJson.pagesReal);
						pageSum = Number(contentJson.pageSumReal);
						songList = contentJson.songList;
						addToArr(songListAll, songList);
						$g('totalRows').innerText = totalRows;
						if(totalRows == 0){
							allowClick = true;
							onkeyBack();
							return;
						}
						var songS = $g('songS');
						for(var i = 1; i <= songList.length; i++){
							var realIdx = i - 1;
							var docIdx = !multipleLoad && pageIndex > 1 ? i : (pageIndex - 1) * pageLimit + i;
							var topT = 400;
							var sortDiv = document.createElement('div');
							sortDiv.style.cssText = 'position:absolute;width:50px;height:24px;left:150px;top:' + Number((docIdx - 1) * 52 + topT) + 'px;color:#B2AFAA;font-size:18px;z-index:1;text-align:center';
							sortDiv.innerText = docIdx;
							songS.appendChild(sortDiv);
							var cnameDiv = document.createElement('div');
							cnameDiv.id = 'songs_' + docIdx;
							cnameDiv.style.cssText = 'position:absolute;width:455px;height:26px;left:190px;top:' + Number((docIdx - 1) * 52 + topT - 5) + 'px;color:#FFFFFF;font-size:20px;overflow:hidden;z-index:1';
							cnameDiv.innerText = songList[realIdx].cname.replace('(HD)', '');
							songS.appendChild(cnameDiv);
							var artistDiv = document.createElement('div');
							artistDiv.id = 'artists_' + docIdx;
							artistDiv.style.cssText = 'display:none';
							artistDiv.innerText = songList[realIdx].artist;
							songS.appendChild(artistDiv);
							var cfree = songList[realIdx].cfree;
							if(cfree == 0){
								var cfreeDiv = document.createElement('img');
								cfreeDiv.src = 'images/application/pages/index/commonly/free.png';
								cfreeDiv.style.cssText = 'position:absolute;width:32px;height:15px;left:630px;top:' + Number((docIdx - 1) * 52 + topT + 7) + 'px;z-index:1';
								songS.appendChild(cfreeDiv);
							}
							var coDiv = document.createElement('div');
							coDiv.style.cssText = 'position:absolute;width:165px;height:24px;left:680px;top:' + Number((docIdx - 1) * 52 + topT + 2) + 'px;color:#B2AFAA;font-size:18px;overflow:hidden;z-index:1';
							coDiv.innerText = songList[realIdx].artist;
							songS.appendChild(coDiv);
							var duration = Number(songList[realIdx].duration);
							var durDiv = document.createElement('div');
							durDiv.style.cssText = 'position:absolute;width:165px;height:24px;left:850px;top:' + Number((docIdx - 1) * 52 + topT + 2) + 'px;color:#B2AFAA;font-size:18px;z-index:1';
							durDiv.innerText = formatSeconds(duration);
							songS.appendChild(durDiv);
							var playDiv = document.createElement('img');
							playDiv.src = 'images/application/pages/search/song/play.png';
							playDiv.style.cssText = 'position:absolute;width:58px;height:58px;left:924px;top:' + Number((docIdx - 1) * 52 + topT - 17) + 'px;z-index:3';
							songS.appendChild(playDiv);
							var collectFlag = 'collect';
							if(collectStr.indexOf(songList[realIdx].sid) > -1) collectFlag = 'collect0';
							var collectDiv = document.createElement('img');
							collectDiv.id = 'collect_' + docIdx;
							collectDiv.src = 'images/application/pages/search/song/' + collectFlag + '.png';
							collectDiv.style.cssText = 'position:absolute;width:58px;height:58px;left:991px;top:' + Number((docIdx - 1) * 52 + topT - 17) + 'px;z-index:3';
							songS.appendChild(collectDiv);
							var addDiv = document.createElement('img');
							addDiv.src = 'images/application/pages/search/song/add.png';
							addDiv.style.cssText = 'position:absolute;width:58px;height:58px;left:1056px;top:' + Number((docIdx - 1) * 52 + topT - 17) + 'px;z-index:3';
							songS.appendChild(addDiv);
							var backDiv = document.createElement('img');
							backDiv.id = 'back_' + docIdx;
							backDiv.src = 'images/application/pages/search/song/back.png';
							backDiv.style.cssText = 'position:absolute;width:960px;height:50px;left:160px;top:' + Number((docIdx - 1) * 52 + topT - 13) + 'px;z-index:2;visibility:hidden';
							songS.appendChild(backDiv);
							var playFDiv = document.createElement('img');
							playFDiv.id = 'f_play_' + docIdx;
							playFDiv.setAttribute('class', 'btn_focus_hidden');
							playFDiv.src = 'images/application/pages/search/song/focus/f_play.png';
							playFDiv.style.cssText = 'position:absolute;width:58px;height:58px;left:924px;top:' + Number((docIdx - 1) * 52 + topT - 17) + 'px;z-index:3';
							songS.appendChild(playFDiv);
							var collectFDiv = document.createElement('img');
							collectFDiv.id = 'f_collect_' + docIdx;
							collectFDiv.setAttribute('class', 'btn_focus_hidden');
							collectFDiv.src = 'images/application/pages/search/song/focus/f_' + collectFlag + '.png';
							collectFDiv.style.cssText = 'position:absolute;width:58px;height:58px;left:991px;top:' + Number((docIdx - 1) * 52 + topT - 17) + 'px;z-index:3';
							songS.appendChild(collectFDiv);
							var addFDiv = document.createElement('img');
							addFDiv.id = 'f_add_' + docIdx;
							addFDiv.setAttribute('class', 'btn_focus_hidden');
							addFDiv.src = 'images/application/pages/search/song/focus/f_add.png';
							addFDiv.style.cssText = 'position:absolute;width:58px;height:58px;left:1056px;top:' + Number((docIdx - 1) * 52 + topT - 17) + 'px;z-index:3';
							songS.appendChild(addFDiv);
							if(i == songList.length) allowClick = true;
						}
						if(!multipleLoad){
							multipleLoad = true;
							if(nowFocus.indexOf('f_list_') < 0){
								allowClick = false;
								animateY('BigDiv', backPos, frequency, function(){
									allowClick = true;
									if(rightStat > 0) animateX('right', 1205, frequency, function(){});
									if(tipsStat == 1) $g('moreData').style.visibility = 'visible';
									else if(tipsStat == 2) $g('maxData').style.visibility = 'visible';
								});
							}
							$g(nowFocus).setAttribute('class', 'btn_focus_visible');
							var tempIdx = getNowIdx(nowFocus);
							if(tempIdx > 0) $g('back_' + tempIdx).style.visibility = 'visible';
						}
					}
				}
			}

			function onkeyOK(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_list_');
					if(tempF == 100001){
						var toPageId = 14;
						put('request', 'params', 'i=' + toPageId);
						backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&k=' + albumlistId + '&b=' + backPos + '&t=' + tipsStat + '&r=' + rightStat + '&p=' + pageIndex + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF == 100002){
						var toPageId = 13;
						put('request', 'params', 'i=' + toPageId);
						backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&k=' + albumlistId + '&b=' + backPos + '&t=' + tipsStat + '&r=' + rightStat + '&p=' + pageIndex + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF == 100003 || tempF == 100005){
						if(tempF == 100005) backPos = 0;
						nowFocus = 'f_list_100003';
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
					} else if(tempF == 100004 || tempF == 100006){
						nowFocus = 'f_list_100004';
						preferList = 1;
						put('globle', 'preferList', preferList + '');
						var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=2&k=' + preferList + '&u=' + userid + '\'}]';
						var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
						ajaxRequest('POST', reqUrl, doNext);
					} else if(tempF == 100007){
						$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
						nowFocus = lastFocus;
						var tempS = getNowIdx(nowFocus);
						$g('back_' + tempS).style.visibility = 'visible';
						$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					} else if(tempF == 100008){
						returnTop();
					} else{
						tempF = getNowIdx(nowFocus);
						var idx = tempF - 1;
						var dataUrl = 'h2';
						var sid = songListAll[idx].sid;
						var hour = getVal('globle', 'hour');
						var max = getVal('globle', 'max');
						if(nowFocus.indexOf('f_play_') > -1){
							var opr = 1;
							operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
								allowClick = false;
								var songName = $g('songs_' + tempF).innerText;
								var artistName = $g('artists_' + tempF).innerText;
								msg.type = getVal('globle', 'preferBubble');
								msg.createMsgArea($g('realDis'));
								msg.sendMsg('即将播放 - [' + songName + ' - ' + artistName + ']');
								var nowNumInt = Number(json.list_num);
								$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
								toPlayer();
							});
						} else if(nowFocus.indexOf('f_collect_') > -1){
							var opr = 2;
							var tpy = 1;
							operaCollect(dataUrl, sid, userid, tpy, opr, function(json){
								collectStr = json.list_ids_str;
								var operaType = json.opera_type;
								var songName = $g('songs_' + tempF).innerText;
								var artistName = $g('artists_' + tempF).innerText;
								msg.type = getVal('globle', 'preferBubble');
								msg.createMsgArea($g('realDis'));
								var msgStr = '';
								if(operaType == 1){
									$g('collect_' + tempF).src = 'images/application/pages/search/song/collect.png';
									$g('f_collect_' + tempF).src = 'images/application/pages/search/song/focus/f_collect.png';
									msgStr = '成功删除收藏曲目 [' + songName + ' - ' + artistName + ']';
								} else{
									$g('collect_' + tempF).src = 'images/application/pages/search/song/collect0.png';
									$g('f_collect_' + tempF).src = 'images/application/pages/search/song/focus/f_collect0.png';
									msgStr = '成功收藏曲目 [' + songName + ' - ' + artistName + ']';
								}
								msg.sendMsg(msgStr);
							});
						} else if(nowFocus.indexOf('f_add_') > -1){
							var opr = 1;
							operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
								var songName = $g('songs_' + tempF).innerText;
								var artistName = $g('artists_' + tempF).innerText;
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
					var eleT = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
					if(eleT <= rightLine - 52){
						if(nowFocus.indexOf('f_artist_') > -1){
							$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
							nowFocus = lastFocus;
							var tempS = getNowIdx(nowFocus);
							$g('back_' + tempS).style.visibility = 'visible';
							$g(nowFocus).setAttribute('class', 'btn_focus_visible');
						} else returnTop();
					} else{
						if(eleT < 0) returnTop();
						else{
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
			}

			function onkeyLeft(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_list_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF == 100002) nowFocus = 'f_list_100001';
					else if(tempF == 100004) nowFocus = 'f_list_100003';
					else if(tempF > 100004 && tempF < 100011){
						nowFocus = lastFocus;
						var tempS = getNowIdx(nowFocus);
						$g('back_' + tempS).style.visibility = 'visible';
					} else{
						tempF = getNowIdx(nowFocus);
						if(nowFocus.indexOf('f_add_') > -1) nowFocus = 'f_collect_' + tempF;
						else if(nowFocus.indexOf('f_collect_') > -1) nowFocus = 'f_play_' + tempF;
					}
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onkeyRight(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_list_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF == 100001) nowFocus = 'f_list_100002';
					else if(tempF == 100003) nowFocus = 'f_list_100004';
					else{
						tempF = getNowIdx(nowFocus);
						if(nowFocus.indexOf('f_play_') > -1) nowFocus = 'f_collect_' + tempF;
						else if(nowFocus.indexOf('f_collect_') > -1) nowFocus = 'f_add_' + tempF;
						else if(nowFocus.indexOf('f_add_') > -1){
							if(rightStat == 1){
								$g('back_' + tempF).style.visibility = 'hidden';
								lastFocus = nowFocus;
								nowFocus = 'f_list_100005';
							}
						}
					}
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onkeyUp(){
				if(allowClick){
					var lastFocusTmp = nowFocus;
					var tempF = getIdx(nowFocus, 'f_list_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF == 100003 || tempF == 100004) nowFocus = 'f_list_100001';
					else if(tempF > 100005 && tempF < 100011){
						var newIdx = tempF - 1;
						nowFocus = 'f_list_' + newIdx;
					} else{
						tempF = getNowIdx(nowFocus);
						if(nowFocus.indexOf('f_play_') > -1){
							if(tempF == 1){
								nowFocus = 'f_list_100003';
								$g('back_1').style.visibility = 'hidden';
							} else {
								var newIdx = tempF - 1;
								nowFocus = 'f_play_' + newIdx;
							}
						} else if(nowFocus.indexOf('f_collect_') > -1){
							if(tempF == 1){
								nowFocus = 'f_list_100004';
								$g('back_1').style.visibility = 'hidden';
							} else {
								var newIdx = tempF - 1;
								nowFocus = 'f_collect_' + newIdx;
							}
						} else if(nowFocus.indexOf('f_add_') > -1){
							if(tempF == 1){
								nowFocus = 'f_list_100004';
								$g('back_1').style.visibility = 'hidden';
							} else {
								var newIdx = tempF - 1;
								nowFocus = 'f_add_' + newIdx;
							}
						}
					}
					movePos('up');
					if(nowFocus.indexOf('f_list_') < 0) displayBack(lastFocusTmp, nowFocus);
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onkeyDown(){
				if(allowClick){
					var lastFocusTmp = nowFocus;
					var tempF = getIdx(nowFocus, 'f_list_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF == 100001 || tempF == 100002) nowFocus = 'f_list_100004';
					else if(tempF == 100003){
						if(totalRows > 0) nowFocus = 'f_play_1';
					} else if(tempF == 100004){
						if(totalRows > 0) nowFocus = 'f_add_1';
					} else if(tempF > 100004 && tempF < 100008){
						var newIdx = tempF + 1;
						nowFocus = 'f_list_' + newIdx;
					} else{
						tempF = getNowIdx(nowFocus);
						if(nowFocus.indexOf('f_play_') > -1){
							if((pageIndex - 1) * pageLimit + pageSum > tempF){
								var newIdx = tempF + 1;
								nowFocus = 'f_play_' + newIdx;
							} else{
								if(pageIndex < pageTotal){
									tipsStat = 0;
									$g('moreData').style.visibility = 'hidden';
									pageIndex++;
									loadSong();
								}
							}
						} else if(nowFocus.indexOf('f_collect_') > -1){
							if((pageIndex - 1) * pageLimit + pageSum > tempF){
								var newIdx = tempF + 1;
								nowFocus = 'f_collect_' + newIdx;
							} else{
								if(pageIndex < pageTotal){
									tipsStat = 0;
									$g('moreData').style.visibility = 'hidden';
									pageIndex++;
									loadSong();
								}
							}
						} else if(nowFocus.indexOf('f_add_') > -1){
							if((pageIndex - 1) * pageLimit + pageSum > tempF){
								var newIdx = tempF + 1;
								nowFocus = 'f_add_' + newIdx;
							} else{
								if(pageIndex < pageTotal){
									tipsStat = 0;
									$g('moreData').style.visibility = 'hidden';
									pageIndex++;
									loadSong();
								}
							}
						}
						movePos('down');
					}
					if(nowFocus.indexOf('f_list_') < 0) displayBack(lastFocusTmp, nowFocus);
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function displayBack(lF, nF){
				if(lF.indexOf('f_list_') > -1){
					var tempS = getNowIdx(nF);
					$g('back_' + tempS).style.visibility = 'visible';
				} else{
					var tempF = getNowIdx(lF);
					var tempS = getNowIdx(nF);
					if(tempF != tempS){
						$g('back_' + tempF).style.visibility = 'hidden';
						$g('back_' + tempS).style.visibility = 'visible';
					}
				}
			}

			function getNowIdx(nF){
				if(nF.indexOf('f_play_') > -1){
					return getIdx(nF, 'f_play_');
				} else if(nF.indexOf('f_collect_') > -1){
					return getIdx(nF, 'f_collect_');
				} else if(nF.indexOf('f_add_') > -1){
					return getIdx(nF, 'f_add_');
				} else return 0;
			}

			function movePos(dir){
				var stbType = getVal('globle', 'stbType');
				if(dir == 'down'){
					var tempS = getNowIdx(nowFocus);
					if(tempS > 5){
						if(stbType.indexOf('EC6108V9') > -1){
							var eleH = $g('back_' + tempS).offsetHeight;
							var eleT = $g('back_' + tempS).offsetTop;
							var scorllPos = $g("BigDivFather").scrollTop;
							var posM = 720 - (eleH + eleT + 75);
							allowClick = false;
							animateY('BigDiv', posM, frequency, function(){
								allowClick = true;
								if(scorllPos >= 260){
									rightStat = 1;
									animateX('right', 1205, frequency, function(){});
								}
							});
						} else{
							var eleT = $g('BigDiv').offsetTop;
							var eleT0 = $g('back_' + tempS).offsetTop;
							if(eleT + eleT0 >= 647){
								var posM = eleT - 52;
								// if(posM <= -2358) posM = -2358;
								allowClick = false;
								animateY('BigDiv', posM, frequency, function(){
									allowClick = true;
									eleT = $g('BigDiv').offsetTop;
									if(eleT <= rightLine){
										if(pageIndex == 1 && pageSum == 11 && pageSum == totalRows) return;
										rightStat = 1;
										animateX('right', 1205, frequency, function(){});
									}
								});
							}
						}
					}
					if(tempS == (pageIndex - 1) * pageLimit + pageSum){
						setTimeout(function(){
							if(pageSum == pageLimit){
								if(pageTotal == 1){
									tipsStat = 2;
									$g('maxData').style.visibility = 'visible';
								} else{
									tipsStat = 1;
									$g('moreData').style.visibility = 'visible';
								}
							} else{
								if(pageIndex == 1 && pageSum <= 11 && pageSum == totalRows) return;
								else{
									tipsStat = 2;
									$g('maxData').style.visibility = 'visible';
								}
							}
						}, 100);
					}
				} else if(dir == 'up'){
					if(nowFocus.indexOf('f_list_') < 0){
						var tempS = getNowIdx(nowFocus);
						if(tempS < 45){
							if(stbType.indexOf('EC6108V9') > -1){
								var eleH = $g('back_' + tempS).offsetHeight;
								var eleT = $g('back_' + tempS).offsetTop;
								var scorllPos = $g("BigDivFather").scrollTop;
								if(scorllPos >= 104){
									var posM = 0 - (scorllPos - 52);
									allowClick = false;
									tipsStat = 0;
									$g('moreData').style.visibility = 'hidden';
									$g('maxData').style.visibility = 'hidden';
									animateY('BigDiv', posM, frequency, function(){
										allowClick = true;
										if(scorllPos <= 364){
											rightStat = 0;
											animateX('right', 1280, frequency, function(){});
										}
									});
								}
							} else{
								var eleT = $g('BigDiv').offsetTop;
								var eleT0 = $g('back_' + tempS).offsetTop;
								if(eleT + eleT0 <= 75){
									var posM = eleT + 52;
									allowClick = false;
									tipsStat = 0;
									$g('moreData').style.visibility = 'hidden';
									$g('maxData').style.visibility = 'hidden';
									animateY('BigDiv', posM, frequency, function(){
										allowClick = true;
										eleT = $g('BigDiv').offsetTop;
										if(eleT >= rightLine){
											rightStat = 0;
											animateX('right', 1280, frequency, function(){});
										}
									});
								}
							}
						}
					} else{
						var tempF = getIdx(nowFocus, 'f_list_');
						if(tempF < 100005){
							allowClick = false;
							animateY('BigDiv', 0, frequency, function(){
								allowClick = true;
							});
						}
					}
				}
			}

			function returnTop(){
				allowClick = false;
				animateY('BigDiv', 0, frequency, function(){
					allowClick = true;
				});
				tipsStat = 0;
				$g('moreData').style.visibility = 'hidden';
				$g('maxData').style.visibility = 'hidden';
				$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
				var tempS = getNowIdx(nowFocus);
				if(tempS > 0) $g('back_' + tempS).style.visibility = 'hidden';
				nowFocus = 'f_list_100003';
				$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				if(rightStat == 1){
					rightStat = 0;
					animateX('right', 1280, frequency, function(){});
				}
			}

			function doNext(){
				if(xmlhttp.readyState == 4){
					if(xmlhttp.status == 200){
						var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
						var contentJson = eval('(' + retText + ')');
						allowClick = false;
						var delayT = 500;
						var toPageId = 12;
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
				backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
				var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&k=' + albumlistId + '&b=' + backPos + '&t=' + tipsStat + '&r=' + rightStat + '&p=' + pageIndex + '\'}]}';
				addToBack(nowInfo);
				var tempF = nowFocus.indexOf('f_play_') > -1 ? 1000 + Number(getIdx(nowFocus, 'f_play_')) : getIdx(nowFocus, 'f_list_');
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

			function animateY(id, target, speed, fun){
				if(animation == 0) nextDirectY(id, target, fun);
				else nextSlideY(id, target, speed, fun);
			}

			function animateX(id, target, speed, fun){
				if(animation == 0) nextDirectX(id, target, fun);
				else nextSlideX(id, target, speed, fun);
			}