			function start(){
				if(ctlStart) return;
				ctlStart = true;
				if(stbType.indexOf('TEST') > -1) autoDivHeight();
				else handleDivHeight(0, 0);
				var tempF = getIdx(nowFocus, 'f_index_');
				if(backPos != 0) $g('pageindexbgReal').style.visibility = 'visible';
				allowClick = false;
				animateY('BigDiv', backPos, frequency, function(){
					allowClick = true;
				});
				if(tempF > 16 && tempF < 49){
					loadContent(6, 11, 3);
					loadContentArtist(2);
				} else if(tempF > 48 && tempF < 55){
					loadContent(12, 16, 4);
					loadContent(6, 11, 3);
					loadContentArtist(2);
				} else if(tempF > 54 && tempF < 60){
					loadContent(17, 22, 5);
					loadContent(12, 16, 4);
					loadContent(6, 11, 3);
					loadContentArtist(2);
				} else if(tempF > 59 && tempF < 66){
					loadContentMar(6);
					index_timer = setInterval('autoMarquee(\'pic_mar\')', index_delay);
					loadContent(17, 22, 5);
					loadContent(12, 16, 4);
					loadContent(6, 11, 3);
					loadContentArtist(2);
				} else if(tempF == 66){
					loadContent(23, 27, 7);
					loadContentMar(6);
					index_timer = setInterval('autoMarquee(\'pic_mar\')', index_delay);
					loadContent(17, 22, 5);
					loadContent(12, 16, 4);
					loadContent(6, 11, 3);
					loadContentArtist(2);
				} else if(tempF > 66 && tempF < 80){
					loadContent(28, 35, 8);
					loadContent(23, 27, 7);
					loadContentMar(6);
					index_timer = setInterval('autoMarquee(\'pic_mar\')', index_delay);
					loadContent(17, 22, 5);
					loadContent(12, 16, 4);
					loadContent(6, 11, 3);
					loadContentArtist(2);
				}
				$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				loadContent(1, 5, 0);
				loadContentSong(1);
				if(backPos == 0){
					$g('index_10').src = 'images/application/pages/index/commonly/null.png';
					playNext(stbPos[0], stbPos[1], stbPos[2], stbPos[3], 0);
				} else $g('index_10').src = 'images/application/pages/index/page1/window.png';
				followWords(1);
				var viewUrl = 'h4', opr = 0;
				startViewPage(viewUrl, userip, userid, cityN, pageId, '', '', opr, function(data){ viewId = data.viewId; });
			}

			function loadContent(start, end, idx){
				if(!loadFlag[idx]){
					allowClick = false;
					var preferGuide = getVal('globle', 'preferGuide');
					for(var i = start; i <= end; i++){
						var realIdx = i - 1;
						$g('pic_' + i).src = 'images/commonly/recommend/page1/' + jsonRec[realIdx].pic;
						var words = jsonRec[realIdx].pic_word;
						if(words){
							$g('words_' + i).innerHTML = words;
							var wordsColor = jsonRec[realIdx].pic_word_color;
							if(wordsColor) $g('words_' + i).style.color = wordsColor;
							if(preferGuide == 1) $g('words_' + i).style.visibility = 'visible';
						}
						if(i == end) allowClick = true;
					}
				}
				loadFlag[idx] = true;
			}

			function loadContentMar(idx){
				if(!loadFlag[idx]){
					allowClick = false;
					var preferGuide = getVal('globle', 'preferGuide');
					for(var i = jsonMarRec.length; i > 0; i--){
						var realIdx = jsonMarRec.length - i;
						$g('mar_' + i).src = 'images/commonly/recommend/page1/' + jsonMarRec[realIdx].pic;
						var words = jsonMarRec[realIdx].pic_word;
						if(words){
							$g('words_mar_' + i).innerHTML = words;
							var wordsColor = jsonMarRec[realIdx].pic_word_color;
							if(wordsColor) $g('words_mar_' + i).style.color = wordsColor;
							if(preferGuide == 1) $g('words_mar_' + i).style.visibility = 'visible';
						}
						if(i == 1) allowClick = true;
					}
					$g('mar_index_' + index_timeID).style.visibility = 'visible';
				}
				loadFlag[idx] = true;
			}

			function loadContentSong(idx){
				if(!loadFlag[idx]){
					allowClick = false;
					for(var i = 1; i <= jsonSong1.length; i++){
						var realIdx = i - 1;
						$g('s1_' + i).innerText = jsonSong1[realIdx].cname.replace('(HD)', '');
						$g('a1_' + i).innerText = jsonSong1[realIdx].artist;
						if(jsonSong1[realIdx].cfree == 0) $g('free_1_' + i).style.visibility = 'visible';
					}
					for(var i = 1; i <= jsonSong2.length; i++){
						var realIdx = i - 1;
						$g('s2_' + i).innerText = jsonSong2[realIdx].cname.replace('(HD)', '');
						$g('a2_' + i).innerText = jsonSong2[realIdx].artist;
						if(jsonSong2[realIdx].cfree == 0) $g('free_2_' + i).style.visibility = 'visible';
						if(i == jsonSong2.length) allowClick = true;
					}
				}
				loadFlag[idx] = true;
			}

			function loadContentArtist(idx){
				if(!loadFlag[idx]){
					allowClick = false;
					for(var i = 1; i <= jsonArtist.length; i++){
						var realIdx = i - 1;
						$g('ap_' + i).src = 'images/commonly/artist/c_' + jsonArtist[realIdx].pic;
						$g('at_' + i).innerText = jsonArtist[realIdx].cname;
						if(i == jsonArtist.length) allowClick = true;
					}
				}
				loadFlag[idx] = true;
			}

			function autoMarquee(id){
				$g('mar_index_' + index_timeID).style.visibility = 'hidden';
				if(index_timeID == jsonMarRec.length){
					index_timeID = 1;
				} else{
					index_timeID++;
				}
				var onePicW = $g(id).offsetWidth;
				var tempRs = 0 - (index_timeID - 1) * onePicW;
				animateX(id, tempRs, 10, function(){
					allowClick = true;
				});
				$g('mar_index_' + index_timeID).style.visibility = 'visible';
			}

			function getEleInfo(idx){
				var jsonStr = null;
				for(var i = 0; i < jsonRec.length; i++){
					if(idx == jsonRec[i].idx){
						jsonStr = jsonRec[i];
					}
				}
				return jsonStr;
			}

			function onkeyOK(){
				if(allowClick){
					destoryMP();
					var tempF = getIdx(nowFocus, 'f_index_');
					if(tempF == 0){
						// 天津河南有多余的按键
						var picName = $g('index_0').src;
						if(provinceN == '201'){
							if(picName.indexOf('order.png') > -1){ // 去订购
								var toUrl = 'pay.jsp?o=0&u=' + userid + '&i=' + userip + '&s=0&p=' + pageId + '&k=&c=' + cityN + '&a=' + provinceN + '&t=' + userToken + '&st=' + stbType + '&f=' + platform;
								var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '\'}]}';
								addToBack(nowInfo);
								setTimeout(function(){round(toUrl);}, 500);
							} else if(picName.indexOf('unsub.png') > -1){ // 去退订
								var toUrl = 'zone_unsub_201.jsp?o=0&u=' + userid + '&i=' + userip + '&s=0&p=' + pageId + '&k=&c=' + cityN + '&a=' + provinceN + '&f=' + platform;
								var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '\'}]}';
								addToBack(nowInfo);
								setTimeout(function(){round(toUrl);}, 500);
							}
						} else if(provinceN == '204'){ // 开启 | 关闭 童锁
							var lock = 0;
							if(picName.indexOf('lock0.png') > -1) lock = 1;
							var toUrl = 'zone_lock_204.jsp?o=0&u=' + userid + '&l=' + lock;
							var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '\'}]}';
							addToBack(nowInfo);
							setTimeout(function(){round(toUrl);}, 500);
						}
					} else if(tempF == 1){
						var toPageId = 6;
						put('request', 'params', 'i=' + toPageId);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF == 2){
						var toPageId = 14;
						put('request', 'params', 'i=' + toPageId);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF == 3){
						var toPageId = 13;
						put('request', 'params', 'i=' + toPageId);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF == 4){
						var toPageId = 16;
						put('request', 'params', 'i=' + toPageId);
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF > 4 && tempF < 10){
						var toPageId = tempF - 5;
						if(tempF == 5) toPageId = 5;
						if(toPageId != pageId){
							put('request', 'params', 'i=' + toPageId + '&n=' + nowFocus);
							toOtrIndex(tempF, toPageId);
						}
					} else if(tempF == 10){
						var dataUrl = 'h2';
						var sid = playList[nowRealPlay].sid;
						var songName = playList[nowRealPlay].cname;
						var artistName = playList[nowRealPlay].artist;
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
					} else if(tempF == 16){
						var toPageId = 9;
						put('request', 'params', 'i=' + toPageId);
						backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&b=' + backPos + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF == 33 || tempF == 35){
						var albumlistId = 10002;
						var aname = '一周热歌榜';
						if(tempF == 35){
							albumlistId = 10005;
							aname = '新歌速递榜';
						}
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
									toPlayer();
								}
							}
						});
					} else if(tempF > 20 && tempF < 33){
						var dataUrl = 'h2';
						var sidIdx = tempF < 27 ? tempF - 21 : tempF - 27;
						var sid = tempF < 27 ? jsonSong1[sidIdx].sid : jsonSong2[sidIdx].sid;
						var songName = tempF < 27 ? jsonSong1[sidIdx].cname : jsonSong2[sidIdx].cname;
						var artistName = tempF < 27 ? jsonSong1[sidIdx].artist : jsonSong2[sidIdx].artist;
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
					} else if((tempF > 16 && tempF < 21) || tempF == 34 || tempF == 36){
						var toPageId = 11;
						if(preferList == 1) toPageId = 12;
						var defList = weekList;
						if(tempF == 36) defList = newList;
						else if(tempF == 17) defList = movieList;
						else if(tempF == 18) defList = kidsList;
						else if(tempF == 19) defList = nostalgiaList;
						else if(tempF == 20) defList = popList;
						put('request', 'params', 'i=' + toPageId + '&k=' + defList);
						backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&b=' + backPos + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, defList);
					} else if(tempF > 36 && tempF < 49){
						var realIdx = tempF - 37;
						var toPageId = 7;
						if(preferList == 1) toPageId = 8;
						put('request', 'params', 'i=' + toPageId + '&k=' + jsonArtist[realIdx].aid);
						backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&b=' + backPos + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, jsonArtist[realIdx].aid);
					} else if(tempF == 66){
						var len = jsonMarRec.length;
						var nowIdx = len - index_timeID;
						var onclick_type = Number(jsonMarRec[nowIdx].onclick_type);
						var curl = jsonMarRec[nowIdx].curl;
						var params = jsonMarRec[nowIdx].params;
						if(onclick_type == 1){ // 专题_自由式
							var toPageId = curl;
							put('request', 'params', 'i=' + toPageId + '&' + params);
							backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
							var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&b=' + backPos + '&m=' + index_timeID + '\'}]}';
							addToBack(nowInfo);
							toOtrPage(tempF, toPageId, params.split('=')[1]);
						} else if(onclick_type == 2){ // 专题_列表式
							var toPageId = 11;
							if(preferList == 1) toPageId = 12;
							put('request', 'params', 'i=' + toPageId + '&' + params);
							backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
							var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&b=' + backPos + '&m=' + index_timeID + '\'}]}';
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
						var jsonStr = getEleInfo(tempF);
						var onclick_type = Number(jsonStr.onclick_type);
						var curl = jsonStr.curl;
						var params = jsonStr.params;
						if(onclick_type == 1){ // 专题_自由式
							var toPageId = curl;
							put('request', 'params', 'i=' + toPageId + '&' + params);
							backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
							var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&b=' + backPos + '\'}]}';
							addToBack(nowInfo);
							toOtrPage(tempF, toPageId, params.split('=')[1]);
						} else if(onclick_type == 2){ // 专题_列表式
							var toPageId = 11;
							if(preferList == 1) toPageId = 12;
							put('request', 'params', 'i=' + toPageId + '&' + params);
							backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
							var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&b=' + backPos + '\'}]}';
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
					}
				}
			}

			function onkeyBack(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_index_');
					if(tempF > 12){
						$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
						if(tempF < 10) $g('index_' + tempF).style.visibility = 'visible';
						setTimeout(function(){$g('pageindexbgReal').style.visibility = 'hidden';}, 500);
						allowClick = false;
						animateY('BigDiv', 0, frequency, function(){
							allowClick = true;
						});
						nowFocus = 'f_index_10';
						var tempS = getIdx(nowFocus, 'f_index_');
						if(tempS < 10) $g('index_' + tempS).style.visibility = 'hidden';
						$g(nowFocus).setAttribute('class', 'btn_focus_visible');
						displayBack();
					} else exitApp();
				}
			}

			function onkeyLeft(){
				if(allowClick){
					followWords(0);
					var tempF = getIdx(nowFocus, 'f_index_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF < 10) $g('index_' + tempF).style.visibility = 'visible';
					if(tempF > 20 && tempF < 24) nowFocus = 'f_index_17';
					else if((tempF > 23 && tempF < 27) || tempF == 33) nowFocus = 'f_index_18';
					else if(tempF > 26 && tempF < 30) nowFocus = 'f_index_19';
					else if((tempF > 29 && tempF < 33) || tempF == 35) nowFocus = 'f_index_20';
					else if(tempF == 19) nowFocus = 'f_index_21';
					else if(tempF == 20) nowFocus = 'f_index_24';
					else if((tempF > 1 && tempF < 5) || (tempF > 5 && tempF < 10) || (tempF > 10 && tempF < 13) || (tempF > 13 && tempF < 17) || tempF == 34 || tempF == 36
						|| (tempF > 37 && tempF < 43) || (tempF > 43 && tempF < 49) || (tempF > 49 && tempF < 52) || (tempF > 52 && tempF < 55) || (tempF > 55 && tempF < 60)
						|| (tempF > 60 && tempF < 63) || (tempF > 63 && tempF < 66) || (tempF > 67 && tempF < 72) || (tempF > 72 && tempF < 76) || (tempF > 76 && tempF < 80)){
						var newIdx = tempF - 1;
						nowFocus = 'f_index_' + newIdx;
					} else{
						// 天津河南有多余的按键
						var picName = $g('index_0').src;
						if((provinceN == '201' && picName.indexOf('ex201.png') < 0) || provinceN == '204'){
							if(tempF == 1) nowFocus = 'f_index_0';
						}
					}
					var tempS = getIdx(nowFocus, 'f_index_');
					if(tempS < 10) $g('index_' + tempS).style.visibility = 'hidden';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					displayBack();
					followWords(1);
				}
			}

			function onkeyRight(){
				if(allowClick){
					followWords(0);
					var tempF = getIdx(nowFocus, 'f_index_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF < 10) $g('index_' + tempF).style.visibility = 'visible';
					if(tempF > 20 && tempF < 24) nowFocus = 'f_index_19';
					else if((tempF > 23 && tempF < 27) || tempF == 34) nowFocus = 'f_index_20';
					else if(tempF == 17) nowFocus = 'f_index_21';
					else if(tempF == 18) nowFocus = 'f_index_24';
					else if(tempF == 19) nowFocus = 'f_index_27';
					else if(tempF == 20) nowFocus = 'f_index_30';
					else if((tempF > 0 && tempF < 4) || (tempF > 4 && tempF < 9) || (tempF > 9 && tempF < 12) || (tempF > 12 && tempF < 16) || tempF == 33 || tempF == 35
						|| (tempF > 36 && tempF < 42) || (tempF > 42 && tempF < 48) || (tempF > 48 && tempF < 51) || (tempF > 51 && tempF < 54) || (tempF > 54 && tempF < 59)
						|| (tempF > 59 && tempF < 62) || (tempF > 62 && tempF < 65) || (tempF > 66 && tempF < 71) || (tempF > 71 && tempF < 75) || (tempF > 75 && tempF < 79)){
						var newIdx = tempF + 1;
						nowFocus = 'f_index_' + newIdx;
					} else{
						// 天津河南有多余的按键
						var picName = $g('index_0').src;
						if((provinceN == '201' && picName.indexOf('ex201.png') < 0) || provinceN == '204'){
							if(tempF == 0) nowFocus = 'f_index_1';
						}
					}
					var tempS = getIdx(nowFocus, 'f_index_');
					if(tempS < 10) $g('index_' + tempS).style.visibility = 'hidden';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					displayBack();
					followWords(1);
				}
			}

			function onkeyUp(){
				if(allowClick){
					followWords(0);
					var tempF = getIdx(nowFocus, 'f_index_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF < 10) $g('index_' + tempF).style.visibility = 'visible';
					if(tempF == 5 || tempF == 6 || tempF == 7){
						// 天津河南有多余的按键
						var picName = $g('index_0').src;
						if((provinceN == '201' && picName.indexOf('ex201.png') < 0) || provinceN == '204') nowFocus = 'f_index_0';
						else nowFocus = 'f_index_1';
					} else if(tempF == 8) nowFocus = 'f_index_2';
					else if(tempF == 9) nowFocus = 'f_index_4';
					else if(tempF == 10 || tempF == 11 || tempF == 12) nowFocus = 'f_index_6';
					else if(tempF == 13 || tempF == 14) nowFocus = 'f_index_10';
					else if(tempF == 15) nowFocus = 'f_index_11';
					else if(tempF == 16) nowFocus = 'f_index_12';
					else if(tempF == 17) nowFocus = 'f_index_13';
					else if(tempF == 19) nowFocus = 'f_index_15';
					else if(tempF == 21) nowFocus = 'f_index_14';
					else if(tempF == 27) nowFocus = 'f_index_16';
					else if(tempF == 33 || tempF == 34) nowFocus = 'f_index_26';
					else if(tempF == 35 || tempF == 36) nowFocus = 'f_index_32';
					else if(tempF == 37) nowFocus = 'f_index_18';
					else if(tempF == 38) nowFocus = 'f_index_33';
					else if(tempF == 39) nowFocus = 'f_index_34';
					else if(tempF == 40) nowFocus = 'f_index_20';
					else if(tempF == 41) nowFocus = 'f_index_35';
					else if(tempF == 42) nowFocus = 'f_index_36';
					else if(tempF == 49) nowFocus = 'f_index_43';
					else if(tempF == 50) nowFocus = 'f_index_45';
					else if(tempF == 51) nowFocus = 'f_index_47';
					else if(tempF == 55 || tempF == 56) nowFocus = 'f_index_52';
					else if(tempF == 57) nowFocus = 'f_index_53';
					else if(tempF == 58 || tempF == 59) nowFocus = 'f_index_54';
					else if(tempF == 60) nowFocus = 'f_index_55';
					else if(tempF == 61) nowFocus = 'f_index_57';
					else if(tempF == 62) nowFocus = 'f_index_59';
					else if(tempF == 66) nowFocus = 'f_index_64';
					else if(tempF > 66 && tempF < 72) nowFocus = 'f_index_66';
					else if(tempF == 72) nowFocus = 'f_index_67';
					else if(tempF == 73) nowFocus = 'f_index_68';
					else if(tempF == 74) nowFocus = 'f_index_70';
					else if(tempF == 75) nowFocus = 'f_index_71';
					else if((tempF > 21 && tempF < 27) || tempF == 18 || tempF == 20 || (tempF > 27 && tempF < 33)){
						var newIdx = tempF - 1;
						nowFocus = 'f_index_' + newIdx;
					} else if((tempF > 51 && tempF < 55) || (tempF > 62 && tempF < 66)){
						var newIdx = tempF - 3;
						nowFocus = 'f_index_' + newIdx;
					} else if(tempF > 75 && tempF < 80){
						var newIdx = tempF - 4;
						nowFocus = 'f_index_' + newIdx;
					} else if(tempF > 42 && tempF < 49){
						var newIdx = tempF - 6;
						nowFocus = 'f_index_' + newIdx;
					}
					var tempS = getIdx(nowFocus, 'f_index_');
					movePos('up');
					if(tempS < 10) $g('index_' + tempS).style.visibility = 'hidden';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					displayBack();
					followWords(1);
				}
			}

			function onkeyDown(){
				if(allowClick){
					followWords(0);
					var tempF = getIdx(nowFocus, 'f_index_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF < 10) $g('index_' + tempF).style.visibility = 'visible';
					if(tempF > 0 && tempF < 5) nowFocus = 'f_index_6';
					else if(tempF == 5 || tempF == 6) nowFocus = 'f_index_10';
					else if(tempF == 7 || tempF == 8) nowFocus = 'f_index_11';
					else if(tempF == 9) nowFocus = 'f_index_12';
					else if(tempF == 10) nowFocus = 'f_index_13';
					else if(tempF == 11) nowFocus = 'f_index_15';
					else if(tempF == 12) nowFocus = 'f_index_16';
					else if(tempF == 13) nowFocus = 'f_index_17';
					else if(tempF == 14) nowFocus = 'f_index_21';
					else if(tempF == 15) nowFocus = 'f_index_19';
					else if(tempF == 16) nowFocus = 'f_index_27';
					else if(tempF == 26) nowFocus = 'f_index_33';
					else if(tempF == 32) nowFocus = 'f_index_35';
					else if(tempF == 18) nowFocus = 'f_index_37';
					else if(tempF == 33) nowFocus = 'f_index_38';
					else if(tempF == 34) nowFocus = 'f_index_39';
					else if(tempF == 20) nowFocus = 'f_index_40';
					else if(tempF == 35) nowFocus = 'f_index_41';
					else if(tempF == 36) nowFocus = 'f_index_42';
					else if(tempF == 43 || tempF == 44) nowFocus = 'f_index_49';
					else if(tempF == 45 || tempF == 46) nowFocus = 'f_index_50';
					else if(tempF == 47 || tempF == 48) nowFocus = 'f_index_51';
					else if(tempF == 52) nowFocus = 'f_index_55';
					else if(tempF == 53) nowFocus = 'f_index_57';
					else if(tempF == 54) nowFocus = 'f_index_59';
					else if(tempF == 55 || tempF == 56) nowFocus = 'f_index_60';
					else if(tempF == 57) nowFocus = 'f_index_61';
					else if(tempF == 58 || tempF == 59) nowFocus = 'f_index_62';
					else if(tempF > 62 && tempF < 66) nowFocus = 'f_index_66';
					else if(tempF == 66) nowFocus = 'f_index_69';
					else if(tempF == 67) nowFocus = 'f_index_72';
					else if(tempF == 68 || tempF == 69) nowFocus = 'f_index_73';
					else if(tempF == 70) nowFocus = 'f_index_74';
					else if(tempF == 71) nowFocus = 'f_index_75';
					else if((tempF > 20 && tempF < 26) || (tempF > 26 && tempF < 32) || tempF == 17 || tempF == 19){
						var newIdx = tempF + 1;
						nowFocus = 'f_index_' + newIdx;
					} else if((tempF > 48 && tempF < 52) || (tempF > 59 && tempF < 63)){
						var newIdx = tempF + 3;
						nowFocus = 'f_index_' + newIdx;
					} else if(tempF > 71 && tempF < 76){
						var newIdx = tempF + 4;
						nowFocus = 'f_index_' + newIdx;
					} else if(tempF > 36 && tempF < 43){
						var newIdx = tempF + 6;
						nowFocus = 'f_index_' + newIdx;
					} else{
						// 天津河南有多余的按键
						var picName = $g('index_0').src;
						if((provinceN == '201' && picName.indexOf('ex201.png') < 0) || provinceN == '204'){
							if(tempF == 0) nowFocus = 'f_index_6';
						}
					}
					var tempS = getIdx(nowFocus, 'f_index_');
					movePos('down');
					if(tempS < 10) $g('index_' + tempS).style.visibility = 'hidden';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					if(tempS > 16 && tempS < 37) loadContentArtist(2);
					else if(tempS > 42 && tempS < 49) loadContent(6, 11, 3);
					else if(tempS > 51 && tempS < 55) loadContent(12, 16, 4);
					else if(tempS > 54 && tempS < 60) loadContent(17, 22, 5);
					else if(tempS > 62 && tempS < 66){
						loadContentMar(6);
						index_timer = setInterval('autoMarquee(\'pic_mar\')', index_delay);
					} else if(tempS == 66) loadContent(23, 27, 7);
					else if(tempS > 66 && tempS < 72) loadContent(28, 35, 8);
					displayBack();
					followWords(1);
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
							changeSongN();
						} else if(key == 257 || key == 221 || key == 34){
							changeSongL();
						}
					}
				}
			}

			function displayBack(){
				var tempS = getIdx(nowFocus, 'f_index_');
				if(tempS < 13){
					if(!timesIn){
						$g('index_10').src = 'images/application/pages/index/commonly/null.png';
						playNext(stbPos[0], stbPos[1], stbPos[2], stbPos[3], 0);
					}
				} else{
					if(timesIn){
						try{
							$g('index_10').src = 'images/application/pages/index/page1/window.png';
							destoryMP();
						} catch(e){}
					}
				}
			}

			function movePos(dir){
				var tempS = getIdx(nowFocus, 'f_index_');
				if(dir == 'down'){
					if(tempS > 12){
						var eleH = $g('d_index_' + tempS).offsetHeight;
						var eleT = $g('d_index_' + tempS).offsetTop;
						if(tempS > 20 && tempS < 37){
							eleH = $g('d_index_17').offsetHeight;
							if(tempS > 20 && tempS < 24) eleT = $g('d_index_17').offsetTop;
							else if((tempS > 23 && tempS < 27) || (tempS > 32 && tempS < 35)) eleT = $g('d_index_18').offsetTop;
							else if(tempS > 26 && tempS < 30) eleT = $g('d_index_19').offsetTop;
							else if((tempS > 29 && tempS < 33) || (tempS > 34 && tempS < 37)) eleT = $g('d_index_20').offsetTop;
						}
						var posM = (720 - eleH) / 2 - eleT;
						if(posM <= -3515) posM = -3515;
						$g('pageindexbgReal').style.visibility = 'visible';
						allowClick = false;
						animateY('BigDiv', posM, frequency, function(){
							allowClick = true;
						});
					}
				} else if(dir == 'up'){
					if(tempS < 72){
						var eleH = $g('d_index_' + tempS).offsetHeight;
						var eleT = $g('d_index_' + tempS).offsetTop;
						if(tempS > 20 && tempS < 37){
							eleH = $g('d_index_17').offsetHeight;
							if(tempS > 20 && tempS < 24) eleT = $g('d_index_17').offsetTop;
							else if((tempS > 23 && tempS < 27) || (tempS > 32 && tempS < 35)) eleT = $g('d_index_18').offsetTop;
							else if(tempS > 26 && tempS < 30) eleT = $g('d_index_19').offsetTop;
							else if((tempS > 29 && tempS < 33) || (tempS > 34 && tempS < 37)) eleT = $g('d_index_20').offsetTop;
						}
						var posM = (720 - eleH) / 2 - eleT;
						if(posM >= 0) posM = 0;
						if(tempS < 13) $g('pageindexbgReal').style.visibility = 'hidden';
						allowClick = false;
						animateY('BigDiv', posM, frequency, function(){
							allowClick = true;
						});
					}
				}
			}

			function followWords(dis){
				var preferGuide = getVal('globle', 'preferGuide');
				if(preferGuide == 2){
					var tempF = getIdx(nowFocus, 'f_index_');
					if(tempF == 66){
						if(dis == 0){
							for(var i = jsonMarRec.length; i > 0; i--){
								$g('words_mar_' + i).style.visibility = 'hidden';
							}
						} else{
							for(var i = jsonMarRec.length; i > 0; i--){
								$g('words_mar_' + i).style.visibility = 'visible';
							}
						}
					} else{
						for(var i = 1; i <= jsonRec.length; i++){
							var realIdx = i - 1;
							if(jsonRec[realIdx].idx == tempF){
								var pos = jsonRec[realIdx].pos;
								if($gg('words_' + pos)){
									if(dis == 0) $g('words_' + pos).style.visibility = 'hidden';
									else $g('words_' + pos).style.visibility = 'visible';
								}
								break;
							}
						}
					}
				}
			}

			function toPlayer(){
				var toPageId = 100;
				put('request', 'params', 'i=' + toPageId);
				backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
				var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&b=' + backPos + '&m=' + index_timeID + '\'}]}';
				addToBack(nowInfo);
				var tempF = getIdx(nowFocus, 'f_index_');
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

			function toOtrIndex(idx, toPageId){
				allowClick = false;
				var delayT = 500;
				var viewUrl = 'h4', opr = 1;
				endViewPage(viewUrl, userid, idx, toPageId, '', viewId, opr, function(){
					setTimeout(function(){go(toPageId);}, delayT);
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