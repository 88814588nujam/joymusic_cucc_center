			function start(){
				if(ctlStart) return;
				ctlStart = true;
				if(stbType.indexOf('TEST') > -1) autoDivHeight();
				else handleDivHeight(0, 0);
				$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				if(nowFocus.indexOf('f_a_album_') > -1 || nowFocus.indexOf('f_b_album_') > -1){
					var tempF = getEleIdx();
					if(pageIndex % 2 == 1) $g('a_album_' + tempF).style.zIndex = 5;
					else $g('b_album_' + tempF).style.zIndex = 5;
				}
				var viewUrl = 'h4', opr = 0;
				startViewPage(viewUrl, userip, userid, cityN, pageId, '', '', opr, function(data){
					viewId = data.viewId;
					loadAlbum();
				});
			}

			function loadAlbum(){
				allowClick = false;
				var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=1&p=' + pageIndex + '\'}]';
				var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
				ajaxRequest('POST', reqUrl, getAlbumBack);
			}

			function getAlbumBack(){
				if(xmlhttp.readyState == 4){
					if(xmlhttp.status == 200){
						var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
						var contentJson = eval('(' + retText + ')');
						totalRows = Number(contentJson.totalRows);
						pageTotal = Number(contentJson.pageTotal);
						pageSum = Number(contentJson.pageSum);
						albumList = contentJson.albumList;
						$g('pageInfo').innerText = '─── 【' +  pageIndex + ' / ' + pageTotal + '】 ───';
						if(pageIndex == 1){
							$g('album_100002').style.visibility = 'hidden';
							$g('album_100003').style.visibility = 'visible';
						} else if(pageIndex == pageTotal){
							$g('album_100002').style.visibility = 'visible';
							$g('album_100003').style.visibility = 'hidden';
						} else{
							$g('album_100002').style.visibility = 'visible';
							$g('album_100003').style.visibility = 'visible';
						}
						if(pageIndex % 2 == 1){
							for(var i = 1; i <= 21; i++){
								var realIdx = i - 1;
								if(realIdx < albumList.length){
									$g('a_album_' + i).src = 'images/commonly/album_list/' + albumList[realIdx].pic;
								} else{
									$g('a_album_' + i).src = 'images/application/pages/index/commonly/null.png';
								}
							}
							$g('a_album').style.display = 'block';
							$g('b_album').style.display = 'none';
						} else{
							$g('b_album_' + albumList.length).src = 'images/application/pages/index/commonly/null.png';
							for(var i = 1; i <= 21; i++){
								var realIdx = i - 1;
								if(realIdx < albumList.length){
									if(albumList.length > 14){
										if(i < albumList.length) $g('b_album_' + i).src = 'images/commonly/album_list/' + albumList[realIdx].pic;
										else $g('b_album_21').src = 'images/commonly/album_list/' + albumList[albumList.length - 1].pic;
									} else $g('b_album_' + i).src = 'images/commonly/album_list/' + albumList[realIdx].pic;
								} else{
									if(albumList.length > 14){
										if(i >= albumList.length && i < 21){
											$g('b_album_' + i).src = 'images/application/pages/index/commonly/null.png';
										}
									} else $g('b_album_' + i).src = 'images/application/pages/index/commonly/null.png';
								}
							}
							$g('a_album').style.display = 'none';
							$g('b_album').style.display = 'block';
						}
						if(!firstLoad){
							var tempF = getEleIdx();
							if(tempF > 0){
								$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
								var backF = nowFocus.replace('f_', '');
								$g(backF).style.zIndex = 1;
								if(pageIndex % 2 == 1){
									var newIdx = tempF;
									if(newIdx == 8){
										newIdx = newIdx - 1;
										if(pageSum < newIdx) newIdx = pageSum;
									} else if(newIdx == 21){
										if(pageSum > 13){
											if(pageSum == 21 || pageSum == 20) newIdx = pageSum;
											else newIdx = 13;
										} else newIdx = pageSum;
									} else if(newIdx == 1 || newIdx == 2 || newIdx == 9 || newIdx == 10) newIdx = 1;
									else if((newIdx > 2 && newIdx < 8) || (newIdx > 14 && newIdx < 21)){
										newIdx = newIdx - 1;
										if(pageSum < newIdx) newIdx = pageSum;
									} else if(newIdx > 10 && newIdx < 15){
										newIdx = newIdx - 3;
										if(pageSum < newIdx) newIdx = pageSum;
									}
									nowFocus = 'f_a_album_' + newIdx;
								} else{
									var newIdx = tempF;
									if((tempF > 1 && tempF < 8) || (tempF > 13 && tempF < 20)){
										newIdx = tempF + 1;
										if(pageSum < newIdx) newIdx = pageSum;
									} else if(tempF > 7 && tempF < 12){
										newIdx = tempF + 3;
										if(pageSum < newIdx) newIdx = pageSum;
									} else if(tempF == 12 || tempF == 13 || tempF == 20 || tempF == 21){
										if(pageSum > 14) newIdx = 21;
										else newIdx = pageSum;
									}
									nowFocus = 'f_b_album_' + newIdx;
								}
								$g(nowFocus).setAttribute('class', 'btn_focus_visible');
								var backS = nowFocus.replace('f_', '');
								$g(backS).style.zIndex = 5;
							} else{
								$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
								tempF = getIdx(nowFocus, 'f_album_');
								if(tempF == 100002){
									if(pageIndex == 1) nowFocus = 'f_album_100003';
								} else if(tempF == 100003){
									if(pageIndex == pageTotal) nowFocus = 'f_album_100002';
								}
								$g(nowFocus).setAttribute('class', 'btn_focus_visible');
							}
						}
						firstLoad = false;
						allowClick = true;
					}
				}
			}

			function onkeyOK(){
				if(allowClick){
					var tempF = getEleIdx();
					if(tempF > 0){
						var realIdx = tempF - 1;
						if(pageIndex % 2 == 0 && tempF == 21) realIdx = albumList.length - 1;
						var toPageId = 99;
						var jsonStr = albumList[realIdx];
						var params = 'k=' + jsonStr.keyword;
						put('request', 'params', 'i=' + toPageId + '&' + params);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&p=' + pageIndex + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, jsonStr.keyword);
					} else{
						tempF = getIdx(nowFocus, 'f_album_');
						if(tempF == 100000){
							var toPageId = 14;
							put('request', 'params', 'i=' + toPageId);
							var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&p=' + pageIndex + '\'}]}';
							addToBack(nowInfo);
							toOtrPage(tempF, toPageId, '');
						} else if(tempF == 100001){
							var toPageId = 13;
							put('request', 'params', 'i=' + toPageId);
							var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&p=' + pageIndex + '\'}]}';
							addToBack(nowInfo);
							toOtrPage(tempF, toPageId, '');
						} else if(tempF == 100002){
							if(pageIndex > 1){
								pageIndex--;
								loadAlbum();
							}
						} else if(tempF == 100003){
							if(pageIndex < pageTotal){
								pageIndex++;
								loadAlbum();
							}
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
					var tempF = getEleIdx();
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(pageIndex % 2 == 1){
						if(tempF > 0){
							$g('a_album_' + tempF).style.zIndex = 1;
							if((tempF > 1 && tempF < 8) || (tempF > 8 && tempF < 14) || (tempF > 14 && tempF < 22)){
								var newIdx = tempF - 1;
								nowFocus = 'f_a_album_' + newIdx;
							} else if(tempF == 8) nowFocus = 'f_a_album_1';
							else if(tempF == 1 || tempF == 14){
								if(pageIndex > 1){
									pageIndex--;
									loadAlbum();
								}
							}
							var tempS = getEleIdx();
							if(tempS > 0) $g('a_album_' + tempS).style.zIndex = 5;
						} else{
							if(nowFocus == 'f_album_100001') nowFocus = 'f_album_100000';
							else if(nowFocus == 'f_album_100000'){
								nowFocus = 'f_a_album_6';
								var tempS = getEleIdx();
								if(tempS > 0) $g('a_album_' + tempS).style.zIndex = 5;
							} else if(nowFocus == 'f_album_100003'){
								if(pageIndex > 1) nowFocus = 'f_album_100002';
								else{
									nowFocus = 'f_a_album_21';
									var tempS = getEleIdx();
									if(tempS > 0) $g('a_album_' + tempS).style.zIndex = 5;
								}
							} else if(nowFocus == 'f_album_100002'){
								if(pageSum == 20 || pageSum == 21) nowFocus = 'f_a_album_20';
								else if(pageSum == 12 || pageSum == 13) nowFocus = 'f_a_album_12';
								else if(pageSum == 6 || pageSum == 7) nowFocus = 'f_a_album_6';
								else nowFocus = 'f_a_album_' + pageSum;
								var tempS = getEleIdx();
								if(tempS > 0) $g('a_album_' + tempS).style.zIndex = 5;
							}
						}
					} else{
						if(tempF > 0){
							$g('b_album_' + tempF).style.zIndex = 1;
							if((tempF > 1 && tempF < 9) || (tempF > 9 && tempF < 15) || (tempF > 15 && tempF < 21)){
								var newIdx = tempF - 1;
								nowFocus = 'f_b_album_' + newIdx;
							} else if(tempF == 8) nowFocus = 'f_b_album_1';
							else if(tempF == 1 || tempF == 9 || tempF == 15){
								if(pageIndex > 1){
									pageIndex--;
									loadAlbum();
								}
							} else if(tempF == 21){
								if(pageSum == 21) nowFocus = 'f_b_album_20';
								else nowFocus = 'f_b_album_14';
							}
							var tempS = getEleIdx();
							if(tempS > 0) $g('b_album_' + tempS).style.zIndex = 5;
						} else{
							if(nowFocus == 'f_album_100001') nowFocus = 'f_album_100000';
							else if(nowFocus == 'f_album_100000'){
								if(pageSum > 6) nowFocus = 'f_b_album_7';
								else nowFocus = 'f_b_album_' + pageSum;
								var tempS = getEleIdx();
								if(tempS > 0) $g('b_album_' + tempS).style.zIndex = 5;
							} else if(nowFocus == 'f_album_100003'){
								if(pageIndex > 1) nowFocus = 'f_album_100002';
								else{
									if(pageSum > 14) nowFocus = 'f_b_album_21';
									else nowFocus = 'f_b_album_' + pageSum;
									var tempS = getEleIdx();
									if(tempS > 0) $g('b_album_' + tempS).style.zIndex = 5;
								}
							} else if(nowFocus == 'f_album_100002'){
								if(pageSum > 14) nowFocus = 'f_b_album_21';
								else if(pageSum == 8) nowFocus = 'f_b_album_7';
								else nowFocus = 'f_b_album_' + pageSum;
								var tempS = getEleIdx();
								if(tempS > 0) $g('b_album_' + tempS).style.zIndex = 5;
							}
						}
					}
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onkeyRight(){
				if(allowClick){
					var tempF = getEleIdx();
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(pageIndex % 2 == 1){
						if(tempF > 0){
							$g('a_album_' + tempF).style.zIndex = 1;
							if((tempF > 0 && tempF < 7) || (tempF > 7 && tempF < 13) || (tempF > 13 && tempF < 21)){
								var newIdx = tempF + 1;
								if(newIdx <= pageSum) nowFocus = 'f_a_album_' + newIdx;
								else{
									if(tempF < 7) nowFocus = 'f_album_100000';
									else if(tempF > 7 && tempF < 13){
										var newIdx = tempF - 5;
										nowFocus = 'f_a_album_' + newIdx;
									} else if(tempF > 14 && tempF < 21){
										var newIdx = tempF - 7;
										nowFocus = 'f_a_album_' + newIdx;
									}
								}
							} else if(tempF == 7 || tempF == 13 || tempF == 21){
								if(pageIndex < pageTotal){
									pageIndex++;
									loadAlbum();
								}
							}
							var tempS = getEleIdx();
							if(tempS > 0) $g('a_album_' + tempS).style.zIndex = 5;
						} else{
							if(nowFocus == 'f_album_100000') nowFocus = 'f_album_100001';
							else if(nowFocus == 'f_album_100002'){
								if(pageIndex < pageTotal) nowFocus = 'f_album_100003';
								else{
									if(pageSum > 19){
										nowFocus = 'f_a_album_' + pageSum;
										var tempS = getEleIdx();
										if(tempS > 0) $g('a_album_' + tempS).style.zIndex = 5;
									}
								}
							}
						}
					} else{
						if(tempF > 0){
							$g('b_album_' + tempF).style.zIndex = 1;
							if((tempF > 0 && tempF < 8) || (tempF > 8 && tempF < 14) || (tempF > 14 && tempF < 20)){
								var newIdx = tempF + 1;
								var pageSumT = pageSum > 14 ? pageSum - 1 : pageSum;
								if(newIdx <= pageSumT) nowFocus = 'f_b_album_' + newIdx;
								else{
									if(tempF < 8) nowFocus = 'f_album_100000';
									else if(tempF > 8 && tempF < 14){
										var newIdx = tempF - 7;
										nowFocus = 'f_b_album_' + newIdx;
									} else if(tempF > 14 && tempF < 20){
										var newIdx = tempF - 5;
										nowFocus = 'f_b_album_' + newIdx;
									}
								}
							} else if(tempF == 14){
								if(pageSum > 14) nowFocus = 'f_b_album_21';
								else nowFocus = 'f_b_album_7';
							} else if(tempF == 20) nowFocus = 'f_b_album_21';
							else if(tempF == 8 || tempF == 21){
								if(pageIndex < pageTotal){
									pageIndex++;
									loadAlbum();
								}
							}
							var tempS = getEleIdx();
							if(tempS > 0) $g('b_album_' + tempS).style.zIndex = 5;
						} else{
							if(nowFocus == 'f_album_100000') nowFocus = 'f_album_100001';
							else if(nowFocus == 'f_album_100002'){
								if(pageIndex < pageTotal) nowFocus = 'f_album_100003';
								else{
									if(pageSum > 14){
										nowFocus = 'f_b_album_21';
										var tempS = getEleIdx();
										if(tempS > 0) $g('b_album_' + tempS).style.zIndex = 5;
									}
								}
							}
						}
					}
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onkeyUp(){
				if(allowClick){
					var tempF = getEleIdx();
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(pageIndex % 2 == 1){
						if(tempF > 0){
							$g('a_album_' + tempF).style.zIndex = 1;
							if(tempF > 7 && tempF < 14){
								var newIdx = tempF - 6;
								nowFocus = 'f_a_album_' + newIdx;
							} else if(tempF > 15 && tempF < 22){
								var newIdx = tempF - 8;
								nowFocus = 'f_a_album_' + newIdx;
							} else if(tempF == 14 || tempF == 15) nowFocus = 'f_a_album_1';
							else if(tempF < 7) nowFocus = 'f_album_100000';
							else if(tempF == 7) nowFocus = 'f_album_100001';
							var tempS = getEleIdx();
							if(tempS > 0) $g('a_album_' + tempS).style.zIndex = 5;
						} else{
							if(nowFocus == 'f_album_100002'){
								if(pageSum > 20) nowFocus = 'f_a_album_20';
								else nowFocus = 'f_a_album_' + pageSum;
							} else if(nowFocus == 'f_album_100003'){
								if(pageSum > 21) nowFocus = 'f_a_album_21';
								else nowFocus = 'f_a_album_' + pageSum;
							}
							var tempS = getEleIdx();
							if(tempS > 0) $g('a_album_' + tempS).style.zIndex = 5;
						}
					} else{
						if(tempF > 0){
							$g('b_album_' + tempF).style.zIndex = 1;
							if(tempF > 8 && tempF < 15){
								var newIdx = tempF - 8;
								nowFocus = 'f_b_album_' + newIdx;
							} else if(tempF > 14 && tempF < 21){
								var newIdx = tempF - 6;
								nowFocus = 'f_b_album_' + newIdx;
							} else if(tempF == 21) nowFocus = 'f_b_album_8';
							else if(tempF < 8) nowFocus = 'f_album_100000';
							else if(tempF == 8) nowFocus = 'f_album_100001';
							var tempS = getEleIdx();
							if(tempS > 0) $g('b_album_' + tempS).style.zIndex = 5;
						} else{
							if(nowFocus == 'f_album_100002'){
								if(pageSum > 14) nowFocus = 'f_b_album_21';
								else if(pageSum == 8) nowFocus = 'f_b_album_7';
								else nowFocus = 'f_b_album_' + pageSum;
							} else if(nowFocus == 'f_album_100003') nowFocus = 'f_b_album_21';
							var tempS = getEleIdx();
							if(tempS > 0) $g('b_album_' + tempS).style.zIndex = 5;
						}
					}
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onkeyDown(){
				if(allowClick){
					var tempF = getEleIdx();
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(pageIndex % 2 == 1){
						if(tempF > 0){
							$g('a_album_' + tempF).style.zIndex = 1;
							if(tempF > 1 && tempF < 8){
								if(pageSum < 8) nowFocus = 'f_album_100002';
								else{
									var newIdx = tempF + 6;
									if(newIdx < pageSum) nowFocus = 'f_a_album_' + newIdx;
									else nowFocus = 'f_a_album_' + pageSum;
								}
							} else if(tempF > 7 && tempF < 14){
								if(pageSum < 14) nowFocus = 'f_album_100002';
								else{
									var newIdx = tempF + 8;
									if(newIdx < pageSum) nowFocus = 'f_a_album_' + newIdx;
									else nowFocus = 'f_a_album_' + pageSum;
								}
							} else if(tempF > 13 && tempF < 21){
								if(pageIndex > 1) nowFocus = 'f_album_100002';
								else nowFocus = 'f_album_100003';
							} else if(tempF == 21){
								if(pageIndex < pageTotal) nowFocus = 'f_album_100003';
								else nowFocus = 'f_album_100002';
							} else if(tempF == 1){
								if(pageSum < 14) nowFocus = 'f_album_100002';
								else nowFocus = 'f_a_album_14';
							}
							var tempS = getEleIdx();
							if(tempS > 0) $g('a_album_' + tempS).style.zIndex = 5;
						} else{
							if(nowFocus == 'f_album_100000') nowFocus = 'f_a_album_6';
							else if(nowFocus == 'f_album_100001') nowFocus = 'f_a_album_7';
							var tempS = getEleIdx();
							if(tempS > 0) $g('a_album_' + tempS).style.zIndex = 5;
						}
					} else{
						if(tempF > 0){
							$g('b_album_' + tempF).style.zIndex = 1;
							if(tempF > 0 && tempF < 7){
								if(pageSum < 9) nowFocus = 'f_album_100002';
								else{
									var newIdx = tempF + 8;
									if(newIdx < pageSum) nowFocus = 'f_b_album_' + newIdx;
									else nowFocus = 'f_b_album_' + pageSum;
								}
							} else if(tempF > 8 && tempF < 15){
								if(pageSum < 15) nowFocus = 'f_album_100002';
								else{
									var newIdx = tempF + 6;
									var pageSumT = pageSum > 14 ? pageSum - 1 : pageSum;
									if(newIdx < pageSum) nowFocus = 'f_b_album_' + newIdx;
									else{
										if(pageSum > 15) nowFocus = 'f_b_album_' + pageSumT;
										else nowFocus = 'f_album_100002';
									}
								}
							} else if(tempF > 14 && tempF < 21) nowFocus = 'f_album_100002';
							else if(tempF == 7 || tempF == 8){
								if(pageSum > 14) nowFocus = 'f_b_album_21';
								else if(pageSum > 8 && pageSum < 15) nowFocus = 'f_b_album_' + pageSum;
								else if(pageSum < 9) nowFocus = 'f_album_100002';
							} else if(tempF == 21){
								if(pageIndex < pageTotal) nowFocus = 'f_album_100003';
								else nowFocus = 'f_album_100002';
							}
							var tempS = getEleIdx();
							if(tempS > 0) $g('b_album_' + tempS).style.zIndex = 5;
						} else{
							if(nowFocus == 'f_album_100000'){
								if(pageSum > 6) nowFocus = 'f_b_album_7';
								else nowFocus = 'f_b_album_' + pageSum;
							} else if(nowFocus == 'f_album_100001'){
								if(pageSum > 7) nowFocus = 'f_b_album_8';
								else nowFocus = 'f_b_album_' + pageSum;
							}
							var tempS = getEleIdx();
							if(tempS > 0) $g('b_album_' + tempS).style.zIndex = 5;
						}
					}
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onKeyOther(key){
				if(allowClick){
					if(key == 258 || key == 219 || key == 33){
						if(pageIndex > 1){
							pageIndex--;
							loadAlbum();
						}
					} else if(key == 257 || key == 221 || key == 34){
						if(pageIndex < pageTotal){
							pageIndex++;
							loadAlbum();
						}
					}
				}
			}

			function getEleIdx(){
				var tempF = 0;
				if(nowFocus.indexOf('f_album_') == -1){
					if(pageIndex % 2 == 1) tempF = getIdx(nowFocus, 'f_a_album_');
					else tempF = getIdx(nowFocus, 'f_b_album_');
				}
				return tempF;
			}

			function toPlayer(){
				var toPageId = 100;
				put('request', 'params', 'i=' + toPageId);
				var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&p=' + pageIndex + '\'}]}';
				addToBack(nowInfo);
				var tempF = getIdx(nowFocus, 'f_setting_');
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