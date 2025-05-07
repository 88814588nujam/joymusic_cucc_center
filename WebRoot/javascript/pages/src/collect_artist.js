			function start(){
				if(ctlStart) return;
				ctlStart = true;
				if(stbType.indexOf('TEST') > -1) autoDivHeight();
				else handleDivHeight(0, 0);
				var viewUrl = 'h4', opr = 0;
				startViewPage(viewUrl, userip, userid, cityN, pageId, '', '', opr, function(data){
					viewId = data.viewId;
					loadArtist();
				});
			}

			function loadArtist(){
				allowClick = false;
				var tempF = getIdx(nowFocus, 'f_list_');
				var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=1&u=' + userid + '&p=' + pageIndex + '\'}]';
				var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
				ajaxRequest('POST', reqUrl, getArtistBack);
			}

			function getArtistBack(){
				if(xmlhttp.readyState == 4){
					if(xmlhttp.status == 200){
						var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
						var contentJson = eval('(' + retText + ')');
						totalRows = Number(contentJson.totalRows);
						var totalRowsS = Number(contentJson.totalRowsS);
						var totalRowsA = totalRows;
						pageTotal = Number(contentJson.pageTotal);
						pageSum = Number(contentJson.pageSum);
						artistList = contentJson.artistList;
						$g('totalRows').innerText = totalRows;
						$g('totalRowsS').innerText = '(' + (totalRowsS > 1000 ?  (totalRowsS / 1000).toFixed(2) + 'k' : totalRowsS) + ')';
						$g('totalRowsA').innerText = '(' + (totalRowsA > 1000 ?  (totalRowsA / 1000).toFixed(2) + 'k' : totalRowsA) + ')';
						if(totalRows == 0){
							$g('l1').style.visibility = 'visible';
							$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
							var tempS = getIdx(nowFocus, 'f_list_');
							for(var i = 1; i <= pageLimit; i++){
								$g('d_a_' + i).innerText = '';
								$g('d_b_' + i).src = 'images/application/pages/search/commonly/null.png';
								$g('d_p_' + i).src = 'images/application/pages/search/commonly/null.png';
							}
							$g('pageDiv').style.visibility = 'hidden';
							$g('pageIndex').innerText = '';
							$g('pageTotal').innerText = '';
							$g('recDiv').style.display = 'block';
							if(tempS < 100006 && tempS != 100002) nowFocus = 'f_list_100006';
							else if(tempS == 100013) $g('list_100013').style.visibility = 'hidden';
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
							if(tempF > 0 && tempF < pageLimit + 1){
								if(pageSum < tempF){
									$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
									nowFocus = 'f_list_' + pageSum;
									$g(nowFocus).setAttribute('class', 'btn_focus_visible');
								}
							}
							answerFlag = false;
						}
						pageIndex = pageIndex > pageTotal ? pageTotal : pageIndex;
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
							if(realIdx < artistList.length){
								$g('d_a_' + i).innerText = artistList[realIdx].cname.replace('(HD)', '');
								$g('d_p_' + i).src = 'images/commonly/artist/c_' + artistList[realIdx].pic;
							} else{
								$g('d_a_' + i).innerText = '';
								$g('d_p_' + i).src = 'images/application/pages/search/commonly/null.png';
							}
						}
						var tempS = getIdx(nowFocus, 'f_list_');
						if((tempS > pageLimit / 2 && tempS < pageLimit + 1) && pageTotal > pageIndex) $g('nextP').style.visibility = 'visible';
						else $g('nextP').style.visibility = 'hidden';
						if(tempS > 0 && tempS < pageLimit + 1){
							if(pageSum < tempS){
								$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
								nowFocus = 'f_list_' + pageSum;
								$g(nowFocus).setAttribute('class', 'btn_focus_visible');
							} else $g(nowFocus).setAttribute('class', 'btn_focus_visible');
						} else $g(nowFocus).setAttribute('class', 'btn_focus_visible');
						if(!multipleLoad){
							multipleLoad = true;
							var tempF = getIdx(nowFocus, 'f_list_');
							if(tempF == 100001 || tempF == 100002) $g(nowFocus).setAttribute('class', 'btn_focus_visible');
							else if(tempF == 100013){
								$g('list_100013').style.visibility = 'hidden';
								$g(nowFocus).setAttribute('class', 'btn_focus_visible');
							}
							animateX('rightDiv_mar', 0, frequency, function(){
								allowClick = true;
							});
						} else allowClick = true;
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
					if(tempF == 100002){
						var toPageId = 13;
						put('request', 'params', 'i=' + toPageId + '&' + params);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&p=' + pageIndex + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF == 100003){
						var dataUrl = 'h2';
						var hour = getVal('globle', 'hour');
						var max = getVal('globle', 'max');
						var sid = '';
						var opr = 2;
						var tpy = 0;
						operaCollect(dataUrl, sid, userid, tpy, opr, function(json){
							collectStr = json.list_ids_str;
							var operaType = json.opera_type;
							msg.type = getVal('globle', 'preferBubble');
							msg.createMsgArea($g('realDis'));
							msg.sendMsg('已经成功移除全部收藏歌手！');
							loadArtist();
						});
					} else if(tempF == 100004){
						if(pageIndex > 1){
							answerFlag = false;
							pageIndex--;
							loadArtist();
						}
					} else if(tempF == 100005){
						if(pageIndex < pageTotal){
							answerFlag = false;
							pageIndex++;
							loadArtist();
						}
					} else if(tempF > 100005 && tempF < 100012){
						tempF = tempF - 100006;
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
					} else if(tempF == 100012){
						allowClick = false;
						var delayT = 500;
						var toPageId = 14;
						put('request', 'params', 'i=' + toPageId + '&n=f_list_100013');
						var viewUrl = 'h4', opr = 1;
						endViewPage(viewUrl, userid, tempF, toPageId, '', viewId, opr, function(){
							setTimeout(function(){go(toPageId);}, delayT);
						});
					} else{
						if(tempF > 0 && tempF < pageLimit + 1){
							var realIdx = tempF - 1;
							var toPageId = 7;
							if(preferList == 1) toPageId = 8;
							put('request', 'params', 'i=' + toPageId + '&k=' + artistList[realIdx].aid);
							var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&p=' + pageIndex + '\'}]}';
							addToBack(nowInfo);
							toOtrPage(tempF, toPageId, artistList[realIdx].aid);
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
					if(tempF == 100001){
						nowFocus = 'f_list_100013';
						$g('list_100013').style.visibility = 'hidden';
					} else if(tempF == 100002) nowFocus = 'f_list_100001';
					else if(tempF == 100007) nowFocus = 'f_list_100006';
					else if(tempF == 100008) nowFocus = 'f_list_100007';
					else if(tempF == 100010) nowFocus = 'f_list_100009';
					else if(tempF == 100011) nowFocus = 'f_list_100010';
					else if(tempF == 100012){
						if(totalRows > 0){
							$g('list_100012').style.visibility = 'visible';
							nowFocus = 'f_list_100003';
						}
					} else if(tempF == 100013){
						$g('list_100013').style.visibility = 'visible';
						nowFocus = 'f_list_100012';
						$g('list_100012').style.visibility = 'hidden';
					} else if((tempF > 1 && tempF < pageLimit / 2 + 1) || (tempF > pageLimit / 2 + 1 && tempF < pageLimit + 1)){
						var newIdx = tempF - 1;
						nowFocus = 'f_list_' + newIdx;
					} else if(tempF == 1 || tempF == pageLimit / 2 + 1) nowFocus = 'f_list_100003';
					else if(tempF == 100004){
						if(pageSum >= 5) nowFocus = 'f_list_5';
						else nowFocus = 'f_list_' + pageSum;
					} else if(tempF == 100005) nowFocus = 'f_list_' + pageSum;
					var tempS = getIdx(nowFocus, 'f_list_');
					if((tempS > pageLimit / 2 && tempS < pageLimit + 1) && pageTotal > pageIndex) $g('nextP').style.visibility = 'visible';
					else $g('nextP').style.visibility = 'hidden';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onkeyRight(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_list_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF == 100001) nowFocus = 'f_list_100002';
					else if(tempF == 100003){
						if(pageSum >= 6) nowFocus = 'f_list_6';
						else nowFocus = 'f_list_1';
					} else if(tempF == 100006) nowFocus = 'f_list_100007';
					else if(tempF == 100007) nowFocus = 'f_list_100008';
					else if(tempF == 100009) nowFocus = 'f_list_100010';
					else if(tempF == 100010) nowFocus = 'f_list_100011';
					else if(tempF == 100012){
						$g('list_100012').style.visibility = 'visible';
						nowFocus = 'f_list_100013';
						$g('list_100013').style.visibility = 'hidden';
					} else if(tempF == 100013){
						$g('list_100013').style.visibility = 'visible';
						nowFocus = 'f_list_100001';
					} else if((tempF > 0 && tempF < pageLimit / 2) || (tempF > pageLimit / 2 && tempF < pageLimit)){
						if(pageSum > tempF){
							var newIdx = tempF + 1;
							nowFocus = 'f_list_' + newIdx;
						} else{
							if(tempF > 0 && tempF < pageLimit / 2){
								if(pageTotal > 1) nowFocus = 'f_list_100004';
							} else if(tempF > pageLimit / 2 && tempF < pageLimit){
								if(pageTotal > 1) nowFocus = 'f_list_100005';
								else{
									var newIdx = tempF - 4;
									nowFocus = 'f_list_' + newIdx;
								}
							}
						}
					} else if(tempF == pageLimit / 2){
						if(pageTotal > 1) nowFocus = 'f_list_100004';
					} else if(tempF == pageLimit){
						if(pageTotal > 1) nowFocus = 'f_list_100005';
					}
					var tempS = getIdx(nowFocus, 'f_list_');
					if((tempS > pageLimit / 2 && tempS < pageLimit + 1) && pageTotal > pageIndex) $g('nextP').style.visibility = 'visible';
					else $g('nextP').style.visibility = 'hidden';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onkeyUp(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_list_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF == 100003){
						nowFocus = 'f_list_100012';
						$g('list_100012').style.visibility = 'hidden';
					} else if(tempF == 100004){
						if(pageSum >= 5) nowFocus = 'f_list_5';
						else nowFocus = 'f_list_' + pageSum;
					} else if(tempF == 100005) nowFocus = 'f_list_100004';
					else if(tempF == 100006 || tempF == 100007 || tempF == 100008){
						nowFocus = 'f_list_100013';
						$g('list_100013').style.visibility = 'hidden';
					} else if(tempF == 100009) nowFocus = 'f_list_100006';
					else if(tempF == 100010) nowFocus = 'f_list_100007';
					else if(tempF == 100011) nowFocus = 'f_list_100008';
					else if(tempF == 100012){
						$g('list_100012').style.visibility = 'visible';
						nowFocus = 'f_list_100001';
					} else if(tempF == 100013){
						$g('list_100013').style.visibility = 'visible';
						nowFocus = 'f_list_100001';
					} else if(tempF > pageLimit / 2 && tempF < pageLimit + 1){
						var newIdx = tempF - 5;
						nowFocus = 'f_list_' + newIdx;
					} else if(tempF == 1){
						nowFocus = 'f_list_100012';
						$g('list_100012').style.visibility = 'hidden';
					} else if(tempF > 1 && tempF < pageLimit / 2 + 1){
						nowFocus = 'f_list_100013';
						$g('list_100013').style.visibility = 'hidden';
					}
					var tempS = getIdx(nowFocus, 'f_list_');
					if((tempS > pageLimit / 2 && tempS < pageLimit + 1) && pageTotal > pageIndex) $g('nextP').style.visibility = 'visible';
					else $g('nextP').style.visibility = 'hidden';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onkeyDown(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_list_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF == 100001 || tempF == 100002){
						nowFocus = 'f_list_100013';
						$g('list_100013').style.visibility = 'hidden';
					} else if(tempF == 100004) nowFocus = 'f_list_100005';
					else if(tempF == 100005){
						if(pageSum > 5) nowFocus = 'f_list_' + pageSum;
					} else if(tempF == 100006) nowFocus = 'f_list_100009';
					else if(tempF == 100007) nowFocus = 'f_list_100010';
					else if(tempF == 100008) nowFocus = 'f_list_100011';
					else if(tempF == 100012){
						$g('list_100012').style.visibility = 'visible';
						if(pageSum > 0) nowFocus = 'f_list_1';
						else nowFocus = 'f_list_100006';
					} else if(tempF == 100013){
						$g('list_100013').style.visibility = 'visible';
						if(pageSum >= 2) nowFocus = 'f_list_2';
						else if(pageSum == 1) nowFocus = 'f_list_1';
						else nowFocus = 'f_list_100006';
					} else if(tempF > 0 && tempF < pageLimit / 2 + 1){
						var newIdx = tempF + 5;
						if(newIdx <= pageSum) nowFocus = 'f_list_' + newIdx;
						else{
							if(pageSum > pageLimit / 2) nowFocus = 'f_list_' + pageSum;
						}
					} else if(tempF > pageLimit / 2 && tempF < pageLimit + 1){
						if(pageIndex < pageTotal){
							answerFlag = true;
							pageIndex++;
							loadArtist();
						}
					}
					var tempS = getIdx(nowFocus, 'f_list_');
					if((tempS > pageLimit / 2 && tempS < pageLimit + 1) && pageTotal > pageIndex) $g('nextP').style.visibility = 'visible';
					else $g('nextP').style.visibility = 'hidden';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onKeyOther(key){
				if(allowClick){
					if(key == 258 || key == 219 || key == 33){
						if(pageIndex > 1){
							answerFlag = true;
							pageIndex--;
							loadArtist();
						}
					} else if(key == 257 || key == 221 || key == 34){
						if(pageIndex < pageTotal){
							answerFlag = true;
							pageIndex++;
							loadArtist();
						}
					}
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