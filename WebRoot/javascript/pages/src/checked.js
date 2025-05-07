			function start(){
				if(ctlStart) return;
				ctlStart = true;
				if(stbType.indexOf('TEST') > -1) autoDivHeight();
				else handleDivHeight(0, 0);
				var viewUrl = 'h4', opr = 0;
				startViewPage(viewUrl, userip, userid, cityN, pageId, '', '', opr, function(data){
					viewId = data.viewId;
					loadSong();
				});
			}

			function loadSong(){
				allowClick = false;
				var hour = getVal('globle', 'hour');
				var max = getVal('globle', 'max');
				var tempF = getIdx(nowFocus, 'f_list_');
				if(!multipleLoad && tempF > 0 && tempF < pageLimit + 1) pageIndex = 1;
				var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=1&u=' + userid + '&h=' + hour + '&m=' + max + '&p=' + pageIndex + '\'}]';
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
							$g('l1').style.visibility = 'visible';
							$g('l2').style.visibility = 'visible';
							$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
							var tempS = getIdx(nowFocus, 'f_list_');
							if(tempS == 100004 || tempS == pageLimit + 1){
								for(var i = 1; i <= pageLimit; i++){
									$g('c_s_' + i).innerText = '';
									$g('free_' + i).style.visibility = 'hidden';
									$g('c_a_' + i).innerText = '';
									var playIdx = i;
									$g('list_' + playIdx).style.visibility = 'hidden';
									var deleteIdx = i + pageLimit;
									$g('list_' + deleteIdx).style.visibility = 'hidden';
									var topIdx = i + pageLimit * 2;
									var topFlag = 'top';
									if(pageIndex == 1 && i == 1) topFlag = 'first';
									$g('list_' + topIdx).src = 'images/application/pages/checked/' + topFlag + '.png';
									$g('f_list_' + topIdx).src = 'images/application/pages/checked/focus/f_' + topFlag + '.png';
									$g('list_' + topIdx).style.visibility = 'hidden';
									$g('back_' + i).style.visibility = 'hidden';
									$g('pageDiv').style.visibility = 'hidden';
									$g('pageIndex').innerText = '';
									$g('pageTotal').innerText = '';
								}
							}
							$g('recDiv').style.display = 'block';
							if(tempS < 100008 && tempS != 100001) nowFocus = 'f_list_100008';
							$g(nowFocus).setAttribute('class', 'btn_focus_visible');
							if(!loadFlag){
								for(var i = 1; i <= jsonRec.length; i++){
									var realIdx = i - 1;
									$g('f_r_' + i).src = 'images/commonly/song/' + jsonRec[realIdx].pic;
								}
								loadFlag = true;
							}
							animateX('rightDiv_mar', 0, frequency, function(){
								allowClick = true;
							});
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
								var deleteIdx = i + pageLimit;
								$g('list_' + deleteIdx).style.visibility = 'visible';
								var topIdx = i + pageLimit * 2;
								var topFlag = 'top';
								if(pageIndex == 1 && i == 1) topFlag = 'first';
								$g('list_' + topIdx).src = 'images/application/pages/checked/' + topFlag + '.png';
								$g('f_list_' + topIdx).src = 'images/application/pages/checked/focus/f_' + topFlag + '.png';
								$g('list_' + topIdx).style.visibility = 'visible';
							} else{
								$g('c_s_' + i).innerText = '';
								$g('free_' + i).style.visibility = 'hidden';
								$g('c_a_' + i).innerText = '';
								var playIdx = i;
								$g('list_' + playIdx).style.visibility = 'hidden';
								var deleteIdx = i + pageLimit;
								$g('list_' + deleteIdx).style.visibility = 'hidden';
								var topIdx = i + pageLimit * 2;
								var topFlag = 'top';
								if(pageIndex == 1 && i == 1) topFlag = 'first';
								$g('list_' + topIdx).src = 'images/application/pages/checked/' + topFlag + '.png';
								$g('f_list_' + topIdx).src = 'images/application/pages/checked/focus/f_' + topFlag + '.png';
								$g('list_' + topIdx).style.visibility = 'hidden';
							}
						}
						var tempS = getIdx(nowFocus, 'f_list_');
						if((tempS == pageLimit || tempS == pageLimit * 2 || tempS == pageLimit * 3) && pageTotal > pageIndex) $g('nextP').style.visibility = 'visible';
						else $g('nextP').style.visibility = 'hidden';
						songIds = songIds.substring(0, songIds.length - 1);
						if(!multipleLoad){ // 点了播放返回来的情况
							multipleLoad = true;
							var tempF = getIdx(nowFocus, 'f_list_');
							if(tempF == 100001 || tempF == 100003) $g(nowFocus).setAttribute('class', 'btn_focus_visible');
							else if(tempF > 0 && tempF < pageLimit + 1){
								nowFocus = 'f_list_1';
								$g(nowFocus).setAttribute('class', 'btn_focus_visible');
								$g('back_1').style.visibility = 'visible';
							}
							animateX('rightDiv_mar', 0, frequency, function(){
								allowClick = true;
							});
						}
						if(lstOpera != ''){
							if(tempS > pageLimit && tempS < pageLimit * 2 + 1){ // 点了删除重载按键选中
								$g('back_' + (tempS % 10 == 0 ? 10 : tempS % 10)).style.visibility = 'hidden';
								$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
								if(needreload){
									var newIdx = pageLimit + pageSum;
									nowFocus = 'f_list_' + newIdx;
									$g(nowFocus).setAttribute('class', 'btn_focus_visible');
									$g('back_' + pageSum).style.visibility = 'visible';
									needreload = false;
								} else{
									var newIdx = tempS < pageLimit + pageSum ? tempS : pageLimit + pageSum;
									nowFocus = 'f_list_' + newIdx;
									$g(nowFocus).setAttribute('class', 'btn_focus_visible');
									$g('back_' + (tempS < pageLimit + pageSum ? (tempS % 10 == 0 ? 10 : tempS % 10) : pageSum)).style.visibility = 'visible';
								}
							} else if(tempS > pageLimit * 2 && tempS < pageLimit * 3 + 1){ // 点了置顶重载按键选中
								$g('back_' + (tempS % 10 == 0 ? 10 : tempS % 10)).style.visibility = 'hidden';
								$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
								var newIdx = pageLimit * 2 + 1;
								nowFocus = 'f_list_' + newIdx;
								$g(nowFocus).setAttribute('class', 'btn_focus_visible');
								$g('back_1').style.visibility = 'visible';
							}
							lstOpera = '';
						}
						if(tempS > 100007 && tempS < 100014){
							nowFocus = 'f_list_100003';
							$g(nowFocus).setAttribute('class', 'btn_focus_visible');
						}
						allowClick = true;
					}
				}
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
					var tempF = getIdx(nowFocus, 'f_list_');
					if(tempF == 100001){
						var toPageId = 14;
						put('request', 'params', 'i=' + toPageId + '&' + params);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&p=' + pageIndex + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF == 100003){
						allowClick = false;
						msg.type = getVal('globle', 'preferBubble');
						msg.createMsgArea($g('realDis'));
						msg.sendMsg('即将播放全部历史点播曲目');
						toPlayer();
					} else if(tempF == 100004){
						var dataUrl = 'h2';
						var hour = getVal('globle', 'hour');
						var max = getVal('globle', 'max');
						var sid = '';
						var opr = 0;
						operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
							msg.type = getVal('globle', 'preferBubble');
							msg.createMsgArea($g('realDis'));
							msg.sendMsg('已经成功移除全部历史点播曲目！');
							var nowNumInt = Number(json.list_num);
							$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
							loadSong();
						});
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
					} else if(tempF > 100007 && tempF < 100014){
						tempF = tempF - 100008;
						var jsonStr = getEleInfo(tempF);
						var onclick_type = Number(jsonStr.onclick_type);
						var curl = jsonStr.curl;
						var params = jsonStr.params;
						if(onclick_type == 1){ // 专题_自由式
							var toPageId = curl;
							put('request', 'params', 'i=' + toPageId + '&' + params);
							var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '\'}]}';
							addToBack(nowInfo);
							toOtrPage(tempF, toPageId, params.split('=')[1]);
						} else if(onclick_type == 2){ // 专题_列表式
							var toPageId = 11;
							if(preferList == 1) toPageId = 12;
							put('request', 'params', 'i=' + toPageId + '&' + params);
							var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '\'}]}';
							addToBack(nowInfo);
							toOtrPage(tempF, toPageId, params.split('=')[1]);
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
							lstOpera = 'delete';
							var idx = tempF - (pageLimit + 1);
							var sRow = idx + 1;
							var sid = songList[idx].sid;
							var opr = 0;
							operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
								var songName = $g('c_s_' + sRow).innerText;
								var artistName = $g('c_a_' + sRow).innerText;
								msg.type = getVal('globle', 'preferBubble');
								msg.createMsgArea($g('realDis'));
								msg.sendMsg('已经将 [' + songName + ' - ' + artistName + '] 成功移除');
								var nowNumInt = Number(json.list_num);
								$g('idsCheckedNum').innerHTML = nowNumInt > 99 ? '99<span style=\'font-size:10px\'>+</span>' : nowNumInt;
								if(pageSum == 1){
									pageIndex--;
									needreload = true;
								}
								loadSong();
							});
						} else if(tempF > pageLimit * 2 && tempF < pageLimit * 3 + 1){
							lstOpera = 'top';
							if(pageIndex == 1 && tempF == pageLimit * 2 + 1) return;
							var idx = tempF - (pageLimit * 2 + 1);
							var sRow = idx + 1;
							var sid = songList[idx].sid;
							var opr = 1;
							operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
								var songName = $g('c_s_' + sRow).innerText;
								var artistName = $g('c_a_' + sRow).innerText;
								msg.type = getVal('globle', 'preferBubble');
								msg.createMsgArea($g('realDis'));
								msg.sendMsg('已经将 [' + songName + ' - ' + artistName + '] 成功置顶');
								pageIndex = 1;
								loadSong();
							});
						}
					}
				}
			}

			function onkeyBack(){
				if(allowClick){
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
					else if(tempF == 100001){
						if(totalRows > 0) nowFocus = 'f_list_100003';
					} else if(tempF == 100009) nowFocus = 'f_list_100008';
					else if(tempF == 100010) nowFocus = 'f_list_100009';
					else if(tempF == 100012) nowFocus = 'f_list_100011';
					else if(tempF == 100013) nowFocus = 'f_list_100012';
					else if(tempF > pageLimit && tempF < pageLimit * 3 + 1){
						var newIdx = tempF - pageLimit;
						nowFocus = 'f_list_' + newIdx;
					} else if(tempF > 0 && tempF < 8) nowFocus = 'f_list_100003';
					else if(tempF > 7 && tempF < 11) nowFocus = 'f_list_100004';
					else if(tempF == 100005){
						if(pageSum >= 4) nowFocus = 'f_list_24';
						else{
							var newIdx = pageSum + pageLimit * 2;
							nowFocus = 'f_list_' + newIdx;
						}
					} else if(tempF == 100006){
						if(pageSum >= 7) nowFocus = 'f_list_27';
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
					else if(tempF == 100008) nowFocus = 'f_list_100009';
					else if(tempF == 100009) nowFocus = 'f_list_100010';
					else if(tempF == 100011) nowFocus = 'f_list_100012';
					else if(tempF == 100012) nowFocus = 'f_list_100013';
					else if(tempF > pageLimit * 2 && tempF < pageLimit * 3 - 4){
						if(pageTotal > 1) nowFocus = 'f_list_100005';
					} else if(tempF > pageLimit * 3 - 5 && tempF < pageLimit * 3 + 1){
						if(pageTotal > 1) nowFocus = 'f_list_100006';
					} else if(tempF > 0 && tempF < pageLimit * 2 + 1){
						var newIdx = tempF + pageLimit;
						nowFocus = 'f_list_' + newIdx;
					} else if(tempF == 100003){
						if(pageSum >= 7) nowFocus = 'f_list_7';
						else nowFocus = 'f_list_' + pageSum;
					} else if(tempF == 100004){
						if(pageSum >= 8) nowFocus = 'f_list_8';
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
						if(pageSum >= 3) nowFocus = 'f_list_23';
						else{
							var newIdx = pageSum + pageLimit * 2;
							nowFocus = 'f_list_' + newIdx;
						}
					} else if(tempF == 100008 || tempF == 100009) nowFocus = 'f_list_100001';
					else if(tempF == 100010) nowFocus = 'f_list_100002';
					else if(tempF == 100011) nowFocus = 'f_list_100008';
					else if(tempF == 100012) nowFocus = 'f_list_100009';
					else if(tempF == 100013) nowFocus = 'f_list_100010';
					else if((tempF > 1 && tempF < pageLimit + 1) || (tempF > pageLimit + 1 && tempF < pageLimit * 2 + 1) || (tempF > pageLimit * 2 + 1 && tempF < pageLimit * 3 + 1)){
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
					if(tempF == 100001){
						if(totalRows > 0) nowFocus = 'f_list_1';
						else nowFocus = 'f_list_100010';
					} else if(tempF == 100002){
						if(totalRows > 0) nowFocus = 'f_list_21';
						else nowFocus = 'f_list_100010';
					} else if(tempF == 100003) nowFocus = 'f_list_100004';
					else if(tempF == 100005) nowFocus = 'f_list_100006';
					else if(tempF == 100006){
						if(pageSum == 7) nowFocus = 'f_list_27';
						else if(pageSum > 7) nowFocus = 'f_list_28';
					} else if(tempF == 100008) nowFocus = 'f_list_100011';
					else if(tempF == 100009) nowFocus = 'f_list_100012';
					else if(tempF == 100010) nowFocus = 'f_list_100013';
					else if((tempF > 0 && tempF < pageLimit) || (tempF > pageLimit && tempF < pageLimit * 2) || (tempF > pageLimit * 2 && tempF < pageLimit * 3)){
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
				if(allowClick){
					if(key == 258 || key == 219 || key == 33){
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
			}

			function toPlayer(){
				var toPageId = 100;
				put('request', 'params', 'i=' + toPageId);
				var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&p=' + pageIndex + '\'}]}';
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

			function animateX(id, target, speed, fun){
				if(animation == 0) nextDirectX(id, target, fun);
				else nextSlideX(id, target, speed, fun);
			}