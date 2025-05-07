			function start(){
				if(ctlStart) return;
				ctlStart = true;
				document.title = cname;
				if(stbType.indexOf('TEST') > -1) autoDivHeight();
				else handleDivHeight(0, 0);
				var viewUrl = 'h4', opr = 0;
				startViewPage(viewUrl, userip, userid, cityN, pageId, key, '', opr, function(data){
					viewId = data.viewId;
					loadEle();
				});
			}

			function loadEle(){
				allowClick = false;
				var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=1&k=' + aid + '\'}]';
				var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
				ajaxRequest('POST', reqUrl, getEleBack);
			}

			function getEleBack(){
				if(xmlhttp.readyState == 4){
					if(xmlhttp.status == 200){
						var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
						var contentJson = eval('(' + retText + ')');
						idxArr = contentJson.idxArr;
						focusArr = contentJson.focusArr;
						songEle = contentJson.songEle;
						var pageEle = contentJson.pageEle;
						var BigDiv = $g('BigDiv');
						var j = 0;
						var vodPos = {'x':0, 'y':0, 'w':0, 'h':0};
						for(var i = 1; i <= pageEle.length; i++){
							var realIdx = i - 1;
							var onclick_type = Number(pageEle[realIdx].onclick_type);
							if(onclick_type == -1){
								playList = contentJson.freeEle;
								vodPos.x = Number(pageEle[realIdx].x);
								vodPos.y = Number(pageEle[realIdx].y);
								vodPos.w = Number(pageEle[realIdx].w);
								vodPos.h = Number(pageEle[realIdx].h);
								needVod = true;
								continue;
							} else if(onclick_type == 4){
								var txtDiv = document.createElement('div');
								txtDiv.style.cssText = 'position:absolute;width:' + pageEle[realIdx].w + 'px;height:' + pageEle[realIdx].h + 'px;left:' + pageEle[realIdx].x + 'px;top:' + pageEle[realIdx].y + 'px;z-index:' + pageEle[realIdx].zindex + ';' + pageEle[realIdx].pic_word_css;
								txtDiv.innerText = pageEle[realIdx].pic_word;
								BigDiv.appendChild(txtDiv);
								continue;
							} else if(onclick_type > 0) clkEle.push(pageEle[realIdx]);
							var eleDiv = document.createElement('img');
							eleDiv.src = 'images/commonly/album_freestyle/' + picPath + '/' + pageEle[realIdx].pic;
							eleDiv.style.cssText = 'position:absolute;width:' + pageEle[realIdx].w + 'px;height:' + pageEle[realIdx].h + 'px;left:' + pageEle[realIdx].x + 'px;top:' + pageEle[realIdx].y + 'px;z-index:' + pageEle[realIdx].zindex;
							var pos = Number(pageEle[realIdx].pos);
							if(pos > 0) eleDiv.id = 'album_' + pos;
							BigDiv.appendChild(eleDiv);
							var cfocus = Number(pageEle[realIdx].cfocus);
							if(cfocus > 0){
								var feleDiv = document.createElement('img');
								feleDiv.src = 'images/commonly/album_freestyle/' + picPath + '/f_' + pageEle[realIdx].pic;
								feleDiv.style.cssText = 'position:absolute;width:' + pageEle[realIdx].w2 + 'px;height:' + pageEle[realIdx].h2 + 'px;left:' + pageEle[realIdx].x2 + 'px;top:' + pageEle[realIdx].y2 + 'px;z-index:' + (Number(pageEle[realIdx].zindex) + 1) + ';visibility:hidden';
								feleDiv.id = 'f_album_' + pos;
								BigDiv.appendChild(feleDiv);
								if(onclick_type == 1){
									var xsDiv = document.createElement('div');
									xsDiv.style.cssText = 'position:absolute;width:0px;height:0px;left:0px;top:0px;visibility:hidden';
									xsDiv.innerText = Number(j + 1) + '. ' + (Number(songEle[j].cfree) == 0 ? '免费' : '付费') + ' : (' + songEle[j].sid + ') ' + songEle[j].cname + '-' + songEle[j].artist;
									BigDiv.appendChild(xsDiv);
									j++;
								}
								direct.push(pageEle[realIdx].direct);
							}
							if(nowFocus == ''){
								var defaultfocus = Number(pageEle[realIdx].defaultfocus);
								if(defaultfocus == 1) nowFocus = 'f_album_' + pos;
							}
							if(i == pageEle.length){
								var tempF = getIdx(nowFocus, 'f_album_');
								var tempCfocus = Number(focusArr[tempF - 1]);
								if(tempCfocus == 1) $g('album_' + tempF).style.visibility = 'hidden';
								$g(nowFocus).style.visibility = 'visible';
								allowClick = true;
								if(needVod){
									setTimeout(function(){
										playNext(vodPos.x, vodPos.y, vodPos.w, vodPos.h, 0);
									}, 1500);
								}
							}
						}
					}
				}
			}

			function onkeyOK(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_album_');
					var realIdx = tempF - 1;
					var onclick_type = clkEle[realIdx].onclick_type;
					if(onclick_type == 1){
						var isline = songEle[realIdx].isline;
						var songName = songEle[realIdx].cname;
						var artistName = songEle[realIdx].artist;
						if(isline == 'y'){
							var dataUrl = 'h2';
							var sidIdx = realIdx;
							var sid = getSongSids(songEle, sidIdx);
							var hour = getVal('globle', 'hour');
							var max = getVal('globle', 'max');
							var opr = 1;
							operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
								allowClick = false;
								msg.type = getVal('globle', 'preferBubble');
								msg.createMsgArea($g('realDis'));
								msg.sendMsg('即将播放 - [' + songName + ' - ' + artistName + ']');
								toPlayer();
							});
						} else{
							msg.type = getVal('globle', 'preferBubble');
							msg.createMsgArea($g('realDis'));
							msg.sendMsg('[' + songName + ' - ' + artistName + '] 已下线');
						}
					} else if(onclick_type == 2){
						var dataUrl = 'h2';
						var sid = getSongSids(songEle, 0);
						var hour = getVal('globle', 'hour');
						var max = getVal('globle', 'max');
						var opr = 1;
						operaChecked(dataUrl, sid, userid, hour, max, opr, function(json){
							allowClick = false;
							msg.type = getVal('globle', 'preferBubble');
							msg.createMsgArea($g('realDis'));
							msg.sendMsg('即将播放 [专题：' + cname + '] 中的全部歌曲');
							toPlayer();
						});
					} else if(onclick_type == 3){
						exitSpecila();
					}
				}
			}

			function onkeyBack(){
				if(allowClick){
					exitSpecila();
				}
			}

			function exitSpecila(){
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

			function onkeyLeft(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_album_');
					var realIdx = tempF - 1;
					var nowD = direct[realIdx].split(',')[0];
					if(nowD > 0){
						$g(nowFocus).style.visibility = 'hidden';
						var focusN = focusArr[realIdx];
						if(focusN == 1) $g('album_' + tempF).style.visibility = 'visible';
						nowFocus = 'f_album_' + nowD;
						$g(nowFocus).style.visibility = 'visible';
						if(focusN == 1) $g('album_' + nowD).style.visibility = 'hidden';
					}
				}
			}

			function onkeyRight(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_album_');
					var realIdx = tempF - 1;
					var nowD = direct[realIdx].split(',')[2];
					if(nowD > 0){
						$g(nowFocus).style.visibility = 'hidden';
						var focusN = focusArr[realIdx];
						if(focusN == 1) $g('album_' + tempF).style.visibility = 'visible';
						nowFocus = 'f_album_' + nowD;
						$g(nowFocus).style.visibility = 'visible';
						if(focusN == 1) $g('album_' + nowD).style.visibility = 'hidden';
					}
				}
			}

			function onkeyUp(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_album_');
					var realIdx = tempF - 1;
					var nowD = direct[realIdx].split(',')[1];
					if(nowD > 0){
						$g(nowFocus).style.visibility = 'hidden';
						var focusN = focusArr[realIdx];
						if(focusN == 1) $g('album_' + tempF).style.visibility = 'visible';
						nowFocus = 'f_album_' + nowD;
						$g(nowFocus).style.visibility = 'visible';
						if(focusN == 1) $g('album_' + nowD).style.visibility = 'hidden';
					}
				}
			}

			function onkeyDown(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_album_');
					var realIdx = tempF - 1;
					var nowD = direct[realIdx].split(',')[3];
					if(nowD > 0){
						$g(nowFocus).style.visibility = 'hidden';
						var focusN = focusArr[realIdx];
						if(focusN == 1) $g('album_' + tempF).style.visibility = 'visible';
						nowFocus = 'f_album_' + nowD;
						$g(nowFocus).style.visibility = 'visible';
						if(focusN == 1) $g('album_' + nowD).style.visibility = 'hidden';
					}
				}
			}

			function onKeyOther(key){
				if(needVod){
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
			}

			function toPlayer(){
				var toPageId = 100;
				put('request', 'params', 'i=' + toPageId);
				var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&k=' + key + '\'}]}';
				addToBack(nowInfo);
				var tempF = getIdx(nowFocus, 'f_album_');
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

			function outDestroy(){
				if(needVod) destoryMP();
			}