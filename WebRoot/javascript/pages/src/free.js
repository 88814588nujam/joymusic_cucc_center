			function start(){
				if(ctlStart) return;
				ctlStart = true;
				if(stbType.indexOf('TEST') > -1) autoDivHeight();
				else handleDivHeight(0, 0);
				$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				var tempF = getIdx(nowFocus, 'f_free_');
				displayStat(0, tempF);
				var viewUrl = 'h4', opr = 0;
				startViewPage(viewUrl, userip, userid, cityN, pageId, '', '', opr, function(data){
					viewId = data.viewId;
					loadSong();
				});
			}

			function loadSong(){
				allowClick = false;
				var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=1&p=' + pageIndex + '\'}]';
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
						$g('pageInfo').innerText = '─── 【' +  pageIndex + ' / ' + pageTotal + '】 ───';
						var pLen = picPaths.length;
						var nowPic = pageIndex % pLen;
						for(var i = 1; i <= 12; i++){
							$g('p_f_free_' + i).src = 'images/commonly/free/' + picPaths[nowPic];
						}
						if(answerFlag){
							var tempF = getIdx(nowFocus, 'f_free_');
							if(tempF > 0 && tempF < 13){
								if(pageSum < tempF){
									displayStat(1, tempF);
									$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
									nowFocus = 'f_free_' + pageSum;
									var tempS = getIdx(nowFocus, 'f_free_');
									if(tempS > 12){
										$g('nowPlay').style.visibility = 'hidden';
										$g('nowTips').style.visibility = 'hidden';
									} else{
										$g('nowPlay').style.visibility = 'visible';
										$g('nowTips').style.visibility = 'visible';
									}
									displayStat(0, tempS);
									$g(nowFocus).setAttribute('class', 'btn_focus_visible');
									displayBack();
								}
							}
							answerFlag = false;
						}
						if(pageIndex == 1 && pageTotal > 1){
							$g('il').style.visibility = 'hidden';
							$g('ir').style.visibility = 'visible';
						} else if(pageTotal == pageIndex){
							$g('il').style.visibility = 'visible';
							$g('ir').style.visibility = 'hidden';
						} else if(pageTotal > pageIndex){
							$g('il').style.visibility = 'visible';
							$g('ir').style.visibility = 'visible';
						} else{
							$g('il').style.visibility = 'hidden';
							$g('ir').style.visibility = 'hidden';
						}
						songIds = '';
						for(var i = 1; i <= 12; i++){
							var realIdx = i - 1;
							if(realIdx < songList.length){
								songIds += songList[realIdx].sid + ',';
								$g('s_f_free_' + i).innerText = '[ ' + songList[realIdx].cname.replace('(HD)', '') + ' ]';
								$g('a_f_free_' + i).innerText = '- ' + songList[realIdx].artist + ' -';
								$g('d_f_free_' + i).innerText = formatSeconds(Number(songList[realIdx].duration));
							} else{
								$g('s_f_free_' + i).innerText = '';
								$g('a_f_free_' + i).innerText = '';
								$g('d_f_free_' + i).innerText = '';
							}
						}
						songIds = songIds.substring(0, songIds.length - 1);
						loadSongRes();
					}
				}
			}

			function loadSongRes(){
				allowClick = false;
				var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=2&k=' + songIds + '\'}]';
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
						displayBack();
						allowClick = true;
					}
				}
			}

			function onkeyOK(){
				if(allowClick){
					destoryMP();
					var tempF = getIdx(nowFocus, 'f_free_');
					if(tempF == 13){
						var toPageId = 14;
						put('request', 'params', 'i=' + toPageId);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&p=' + pageIndex + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF == 14){
						var toPageId = 13;
						put('request', 'params', 'i=' + toPageId);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&p=' + pageIndex + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF > 0 && tempF < 13){
						var realIdx = tempF - 1;
						var dataUrl = 'h2';
						var sid = songList[realIdx].sid;
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
					var tempF = getIdx(nowFocus, 'f_free_');
					displayStat(1, tempF);
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if((tempF > 1 && tempF < 5) || (tempF > 5 && tempF < 9) || (tempF > 9 && tempF < 13)){
						var newIdx = tempF - 1;
						nowFocus = 'f_free_' + newIdx;
					} else if(tempF == 1 || tempF == 5 || tempF == 9){
						if(pageIndex > 1){
							answerFlag = true;
							pageIndex--;
							loadSong();
						}
					} else if(tempF == 14) nowFocus = 'f_free_13';
					var tempS = getIdx(nowFocus, 'f_free_');
					if(tempS > 12){
						$g('nowPlay').style.visibility = 'hidden';
						$g('nowTips').style.visibility = 'hidden';
					} else{
						$g('nowPlay').style.visibility = 'visible';
						$g('nowTips').style.visibility = 'visible';
					}
					displayStat(0, tempS);
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					if(tempF != tempS){
						destoryMP();
						displayBack();
					}
				}
			}

			function onkeyRight(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_free_');
					displayStat(1, tempF);
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if((tempF > 0 && tempF < 4) || (tempF > 4 && tempF < 8) || (tempF > 8 && tempF < 12)){
						var newIdx = tempF + 1;
						if(newIdx <= pageSum) nowFocus = 'f_free_' + newIdx;
						else{
							if(tempF > 4) nowFocus = 'f_free_' + (newIdx - 4);
							else nowFocus = 'f_free_13';
						}
					} else if(tempF == 4 || tempF == 8 || tempF == 12){
						if(pageIndex < pageTotal){
							answerFlag = true;
							pageIndex++;
							loadSong();
						}
					} else if(tempF == 13) nowFocus = 'f_free_14';
					var tempS = getIdx(nowFocus, 'f_free_');
					if(tempS > 12){
						$g('nowPlay').style.visibility = 'hidden';
						$g('nowTips').style.visibility = 'hidden';
					} else{
						$g('nowPlay').style.visibility = 'visible';
						$g('nowTips').style.visibility = 'visible';
					}
					displayStat(0, tempS);
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					if(tempF != tempS){
						destoryMP();
						displayBack();
					}
				}
			}

			function onkeyUp(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_free_');
					displayStat(1, tempF);
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF > 4 && tempF < 13){
						var newIdx = tempF - 4;
						nowFocus = 'f_free_' + newIdx;
					} else if(tempF < 4) nowFocus = 'f_free_13';
					else if(tempF == 4) nowFocus = 'f_free_14';
					var tempS = getIdx(nowFocus, 'f_free_');
					if(tempS > 12){
						$g('nowPlay').style.visibility = 'hidden';
						$g('nowTips').style.visibility = 'hidden';
					} else{
						$g('nowPlay').style.visibility = 'visible';
						$g('nowTips').style.visibility = 'visible';
					}
					displayStat(0, tempS);
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					if(tempF != tempS){
						destoryMP();
						displayBack();
					}
				}
			}

			function onkeyDown(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_free_');
					displayStat(1, tempF);
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF > 0 && tempF < 9){
						var newIdx = tempF + 4;
						if(newIdx <= pageSum) nowFocus = 'f_free_' + newIdx;
						else{
							var row1 = Math.ceil(tempF / 4);
							var row2 = Math.ceil(pageSum / 4);
							if(row2 > row1) nowFocus = 'f_free_' + pageSum;
						}
					} else if(tempF == 13 || tempF == 14){
						if(pageSum > 4) nowFocus = 'f_free_4';
						else nowFocus = 'f_free_' + pageSum;
					}
					var tempS = getIdx(nowFocus, 'f_free_');
					if(tempS > 12){
						$g('nowPlay').style.visibility = 'hidden';
						$g('nowTips').style.visibility = 'hidden';
					} else{
						$g('nowPlay').style.visibility = 'visible';
						$g('nowTips').style.visibility = 'visible';
					}
					displayStat(0, tempS);
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					if(tempF != tempS){
						destoryMP();
						displayBack();
					}
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

			function displayStat(n, i){
				if(i > 0 && i < 13){
					var stat = 'hidden';
					if(n == 1) stat = 'visible';
					$g('c_f_free_' + i).style.visibility = stat;
					$g('s_f_free_' + i).style.visibility = stat;
					$g('a_f_free_' + i).style.visibility = stat;
					$g('d_f_free_' + i).style.visibility = stat;
				}
			}

			function displayBack(){
				var tempF = getIdx(nowFocus, 'f_free_');
				if(tempF > 0 && tempF < 13){
					var x = $g('free_' + tempF).offsetLeft;
					var y = $g('free_' + tempF).offsetTop;
					var realIdx = tempF - 1;
					$g('nowPlay').innerText = '正在预览：' + songList[realIdx].cname + ' - ' + songList[realIdx].artist;
					$g('nowPlay').style.visibility = 'visible';
					$g('nowTips').style.visibility = 'visible';
					playList[0] = songList[realIdx];
					changeWin(x, y);
				} else{
					var x = $g('free_1').offsetLeft;
					var y = $g('free_1').offsetTop;
					$g('pageindexbgl').style.width = x + 'px';
					$g('pageindexbgu').style.height = y + 'px';
					$g('imgindexbgr').style.left = Number(0 - x - playWinW) + 'px';
					$g('pageindexbgr').style.left = Number(x + playWinW) + 'px';
					$g('pageindexbgr').style.width = Number(pageW - x - playWinW) + 'px';
					$g('imgindexbgd').style.top = Number(0 - y - playWinH) + 'px';
					$g('pageindexbgd').style.top = Number(y + playWinH) + 'px';
					$g('pageindexbgd').style.height = Number(pageH - y - playWinH) + 'px';
					var stbType = getVal('globle', 'stbType');
					if(stbType.indexOf('EC6108V9') > -1) $g('pageindexbgd').scrollTop = Number(y + playWinH);
				}
			}

			function changeWin(x, y){
				$g('pageindexbgl').style.width = x + 'px';
				$g('pageindexbgu').style.height = y + 'px';
				$g('imgindexbgr').style.left = Number(0 - x - playWinW) + 'px';
				$g('pageindexbgr').style.left = Number(x + playWinW) + 'px';
				$g('pageindexbgr').style.width = Number(pageW - x - playWinW) + 'px';
				$g('imgindexbgd').style.top = Number(0 - y - playWinH) + 'px';
				$g('pageindexbgd').style.top = Number(y + playWinH) + 'px';
				$g('pageindexbgd').style.height = Number(pageH - y - playWinH) + 'px';
				var stbType = getVal('globle', 'stbType');
				if(stbType.indexOf('EC6108V9') > -1) $g('pageindexbgd').scrollTop = Number(y + playWinH);
				toPlay();
			}

			function toPlay(){
				var tempF = getIdx(nowFocus, 'f_free_');
				var x = $g('free_' + tempF).offsetLeft;
				var y = $g('free_' + tempF).offsetTop;
				var w = $g('free_' + tempF).offsetWidth;
				var h = $g('free_' + tempF).offsetHeight;
				$g('backDis').style.left = x + 'px';
				$g('backDis').style.top = y + 'px';
				$g('backDis').style.visibility = 'visible';
				if(layTimes > -1){
					clearTimeout(layTimes); 
					layTimes = -1;
				}
				layTimes = setTimeout(function(){
					$g('backDis').style.visibility = 'hidden';
					playNext(x, y, w, h, 0);
				}, 1500);
			}
			
			function toPlayer(){
				var toPageId = 100;
				put('request', 'params', 'i=' + toPageId);
				var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&p=' + pageIndex + '\'}]}';
				addToBack(nowInfo);
				var tempF = getIdx(nowFocus, 'f_free_');
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