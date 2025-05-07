			function start(){
				if(ctlStart) return;
				ctlStart = true;
				if(stbType.indexOf('TEST') > -1) autoDivHeight();
				else handleDivHeight(0, 0);
				var tempF = getIdx(nowFocus, 'f_index_');
				allowClick = false;
				animateY('BigDiv', backPos, frequency, function(){
					allowClick = true;
				});
				if(tempF > 18 && tempF < 31){
					loadContentSong(2);
				} else if(tempF > 30 && tempF < 43){
					loadContent(6, 11, 3);
					loadContentSong(2);
				} else if(tempF > 42 && tempF < 49){
					loadContent(12, 17, 4);
					loadContent(6, 11, 3);
					loadContentSong(2);
				} else if(tempF > 48 && tempF < 55){
					loadContent(18, 25, 5);
					loadContent(12, 17, 4);
					loadContent(6, 11, 3);
					loadContentSong(2);
				} else if(tempF > 54 && tempF < 69){
					loadContent(26, 31, 6);
					loadContent(18, 25, 5);
					loadContent(12, 17, 4);
					loadContent(6, 11, 3);
					loadContentSong(2);
				}
				$g(nowFocus).setAttribute('class', 'btn_focus_visible');
				loadContent(1, 6, 0);
				loadContentArtist(1);
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
						$g('pic_' + i).src = 'images/commonly/recommend/page5/' + jsonRec[realIdx].pic;
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

			function loadContentSong(idx){
				if(!loadFlag[idx]){
					allowClick = false;
					for(var i = 1; i <= jsonSong1.length; i++){
						var realIdx = i - 1;
						$g('s1_' + i).innerText = jsonSong1[realIdx].cname.replace('(HD)', '');
						$g('a1_' + i).innerText = jsonSong1[realIdx].artist;
						var artistPic = jsonSong1[realIdx].artistPic;
						if(artistPic == 'null') artistPic = 'default.png';
						$g('as1_' + i).src = 'images/commonly/artist/c_' + artistPic;
						if(jsonSong1[realIdx].cfree == 0) $g('free_1_' + i).style.visibility = 'visible';
					}
					for(var i = 1; i <= jsonSong2.length; i++){
						var realIdx = i - 1;
						$g('s2_' + i).innerText = jsonSong2[realIdx].cname.replace('(HD)', '');
						$g('a2_' + i).innerText = jsonSong2[realIdx].artist;
						var artistPic = jsonSong2[realIdx].artistPic;
						if(artistPic == 'null') artistPic = 'default.png';
						$g('as2_' + i).src = 'images/commonly/artist/c_' + artistPic;
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
					} else if(tempF == 10){
						var toPageId = 6;
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
					} else if(tempF == 3 || tempF == 12){
						var toPageId = 13;
						put('request', 'params', 'i=' + toPageId);
						backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&b=' + backPos + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF > 4 && tempF < 10){
						var toPageId = tempF - 5;
						if(tempF == 5) toPageId = 5;
						if(toPageId != pageId){
							put('request', 'params', 'i=' + toPageId + '&n=' + nowFocus);
							toOtrIndex(tempF, toPageId);
						}
					} else if(tempF == 11){
						var toPageId = 14;
						put('request', 'params', 'i=' + toPageId);
						backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&b=' + backPos + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF == 18){
						var toPageId = 10;
						put('request', 'params', 'i=' + toPageId);
						backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&b=' + backPos + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, '');
					} else if(tempF > 18 && tempF < 31){
						var realIdx = tempF - 19;
						var toPageId = 7;
						if(preferList == 1) toPageId = 8;
						put('request', 'params', 'i=' + toPageId + '&k=' + jsonArtist[realIdx].aid);
						backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
						var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&b=' + backPos + '\'}]}';
						addToBack(nowInfo);
						toOtrPage(tempF, toPageId, jsonArtist[realIdx].aid);
					} else if(tempF > 30 && tempF < 43){
						var dataUrl = 'h2';
						var sidIdx = tempF < 37 ? tempF - 31 : tempF - 37;
						var sid = tempF < 37 ? jsonSong1[sidIdx].sid : jsonSong2[sidIdx].sid;
						var songName = tempF < 37 ? jsonSong1[sidIdx].cname : jsonSong2[sidIdx].cname;
						var artistName = tempF < 37 ? jsonSong1[sidIdx].artist : jsonSong2[sidIdx].artist;
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
					if(tempF > 18 || (tempF > 11 && tempF < 13) || (tempF > 13 && tempF < 16) || (tempF > 16 && tempF < 19)){
						$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
						if(tempF < 10) $g('index_' + tempF).style.visibility = 'visible';
						allowClick = false;
						animateY('BigDiv', 0, frequency, function(){
							allowClick = true;
						});
						nowFocus = 'f_index_10';
						var tempS = getIdx(nowFocus, 'f_index_');
						if(tempS < 10) $g('index_' + tempS).style.visibility = 'hidden';
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
					followWords(0);
					var tempF = getIdx(nowFocus, 'f_index_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF < 10) $g('index_' + tempF).style.visibility = 'visible';
					if(tempF == 13) nowFocus = 'f_index_10';
					else if(tempF == 14) nowFocus = 'f_index_12';
					else if(tempF == 16) nowFocus = 'f_index_13';
					else if(tempF == 17) nowFocus = 'f_index_15';
					else if((tempF > 1 && tempF < 5) || (tempF > 5 && tempF < 10) || tempF == 15 || tempF == 18 || (tempF > 19 && tempF < 25) || (tempF > 25 && tempF < 31)
						|| (tempF > 43 && tempF < 46) || (tempF > 46 && tempF < 49) || (tempF > 49 && tempF < 52) || (tempF > 52 && tempF < 55) || (tempF > 55 && tempF < 59)
						|| (tempF > 59 && tempF < 63) || (tempF > 63 && tempF < 66) || (tempF > 66 && tempF < 69)){
						var newIdx = tempF - 1;
						nowFocus = 'f_index_' + newIdx;
					} else if(tempF > 36 && tempF < 43){
						var newIdx = tempF - 6;
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
					followWords(1);
				}
			}

			function onkeyRight(){
				if(allowClick){
					followWords(0);
					var tempF = getIdx(nowFocus, 'f_index_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF < 10) $g('index_' + tempF).style.visibility = 'visible';
					if(tempF == 10 || tempF == 11) nowFocus = 'f_index_13';
					else if(tempF == 12) nowFocus = 'f_index_14';
					else if(tempF == 13) nowFocus = 'f_index_16';
					else if(tempF == 15) nowFocus = 'f_index_17';
					else if((tempF > 0 && tempF < 4) || (tempF > 4 && tempF < 9) || tempF == 14 || tempF == 17 || (tempF > 18 && tempF < 24) || (tempF > 24 && tempF < 30)
						|| (tempF > 42 && tempF < 45) || (tempF > 45 && tempF < 48) || (tempF > 48 && tempF < 51) || (tempF > 51 && tempF < 54) || (tempF > 54 && tempF < 58)
						|| (tempF > 58 && tempF < 62) || (tempF > 62 && tempF < 65) || (tempF > 65 && tempF < 68)){
						var newIdx = tempF + 1;
						nowFocus = 'f_index_' + newIdx;
					} else if(tempF > 30 && tempF < 37){
						var newIdx = tempF + 6;
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
					else if(tempF == 10 || tempF == 13 || tempF == 16) nowFocus = 'f_index_5';
					else if(tempF == 11) nowFocus = 'f_index_10';
					else if(tempF == 12) nowFocus = 'f_index_11';
					else if(tempF == 15) nowFocus = 'f_index_13';
					else if(tempF == 18) nowFocus = 'f_index_16';
					else if(tempF == 19) nowFocus = 'f_index_12';
					else if(tempF == 20) nowFocus = 'f_index_14';
					else if(tempF == 21 || tempF == 22) nowFocus = 'f_index_15';
					else if(tempF == 23) nowFocus = 'f_index_17';
					else if(tempF == 24) nowFocus = 'f_index_18';
					else if(tempF == 31) nowFocus = 'f_index_26';
					else if(tempF == 37) nowFocus = 'f_index_29';
					else if(tempF == 43 || tempF == 44) nowFocus = 'f_index_36';
					else if(tempF == 45) nowFocus = 'f_index_42';
					else if(tempF == 55) nowFocus = 'f_index_52';
					else if(tempF == 56 || tempF == 57) nowFocus = 'f_index_53';
					else if(tempF == 58) nowFocus = 'f_index_54';
					else if(tempF == 63) nowFocus = 'f_index_59';
					else if(tempF == 64) nowFocus = 'f_index_60';
					else if(tempF == 65) nowFocus = 'f_index_62';
					else if((tempF > 10 && tempF < 12) || tempF == 14 || tempF == 17 || (tempF > 31 && tempF < 37) || (tempF > 37 && tempF < 43)){
						var newIdx = tempF - 1;
						nowFocus = 'f_index_' + newIdx;
					} else if((tempF > 45 && tempF < 55) || (tempF > 65 && tempF < 69)){
						var newIdx = tempF - 3;
						nowFocus = 'f_index_' + newIdx;
					} else if(tempF > 58 && tempF < 63){
						var newIdx = tempF - 4;
						nowFocus = 'f_index_' + newIdx;
					} else if(tempF > 24 && tempF < 31){
						var newIdx = tempF - 6;
						nowFocus = 'f_index_' + newIdx;
					}
					movePos('up');
					var tempS = getIdx(nowFocus, 'f_index_');
					if(tempS < 10) $g('index_' + tempS).style.visibility = 'hidden';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					followWords(1);
				}
			}

			function onkeyDown(){
				if(allowClick){
					followWords(0);
					var tempF = getIdx(nowFocus, 'f_index_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF < 10) $g('index_' + tempF).style.visibility = 'visible';
					if(tempF > 0 && tempF < 5) nowFocus = 'f_index_5';
					else if(tempF == 5) nowFocus = 'f_index_10';
					else if(tempF == 6 || tempF == 7) nowFocus = 'f_index_13';
					else if(tempF == 8 || tempF == 9) nowFocus = 'f_index_16';
					else if(tempF == 10) nowFocus = 'f_index_11';
					else if(tempF == 11) nowFocus = 'f_index_12';
					else if(tempF == 12) nowFocus = 'f_index_19';
					else if(tempF == 13) nowFocus = 'f_index_14';
					else if(tempF == 14) nowFocus = 'f_index_20';
					else if(tempF == 15) nowFocus = 'f_index_21';
					else if(tempF == 16) nowFocus = 'f_index_17';
					else if(tempF == 17) nowFocus = 'f_index_23';
					else if(tempF == 18) nowFocus = 'f_index_24';
					else if(tempF > 24 && tempF < 28) nowFocus = 'f_index_31';
					else if(tempF > 27 && tempF < 31) nowFocus = 'f_index_37';
					else if(tempF == 36) nowFocus = 'f_index_43';
					else if(tempF == 42) nowFocus = 'f_index_45';
					else if(tempF == 52) nowFocus = 'f_index_55';
					else if(tempF == 53) nowFocus = 'f_index_56';
					else if(tempF == 54) nowFocus = 'f_index_58';
					else if(tempF == 59) nowFocus = 'f_index_63';
					else if(tempF == 60 || tempF == 61) nowFocus = 'f_index_64';
					else if(tempF == 62) nowFocus = 'f_index_65';
					else if((tempF > 30 && tempF < 36) || (tempF > 36 && tempF < 42)){
						var newIdx = tempF + 1;
						nowFocus = 'f_index_' + newIdx;
					} else if((tempF > 42 && tempF < 52) || (tempF > 62 && tempF < 66)){
						var newIdx = tempF + 3;
						nowFocus = 'f_index_' + newIdx;
					} else if(tempF > 54 && tempF < 59){
						var newIdx = tempF + 4;
						nowFocus = 'f_index_' + newIdx;
					} else if(tempF > 18 && tempF < 25){
						var newIdx = tempF + 6;
						nowFocus = 'f_index_' + newIdx;
					} else{
						// 天津河南有多余的按键
						var picName = $g('index_0').src;
						if((provinceN == '201' && picName.indexOf('ex201.png') < 0) || provinceN == '204'){
							if(tempF == 0) nowFocus = 'f_index_5';
						}
					}
					movePos('down');
					var tempS = getIdx(nowFocus, 'f_index_');
					if(tempS < 10) $g('index_' + tempS).style.visibility = 'hidden';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					if(tempS > 24 && tempS < 31) loadContentSong(2);
					else if(tempS == 33 || tempS == 39) loadContent(6, 11, 3);
					else if(tempS > 45 && tempS < 49) loadContent(12, 17, 4);
					else if(tempS > 51 && tempS < 55) loadContent(18, 25, 5);
					else if(tempS > 58 && tempS < 63) loadContent(26, 31, 6);
					followWords(1);
				}
			}

			function movePos(dir){
				var tempS = getIdx(nowFocus, 'f_index_');
				if(dir == 'down'){
					if((tempS > 11 && tempS < 13) || (tempS > 13 && tempS < 16) || tempS > 16){
						var eleH = $g('d_index_' + tempS).offsetHeight;
						var eleT = $g('d_index_' + tempS).offsetTop;
						var posM = (720 - eleH) / 2 - eleT;
						if(posM <= -3040) posM = -3040;
						allowClick = false;
						animateY('BigDiv', posM, frequency, function(){
							allowClick = true;
						});
					}
				} else if(dir == 'up'){
					if(tempS < 69){
						var eleH = $g('d_index_' + tempS).offsetHeight;
						var eleT = $g('d_index_' + tempS).offsetTop;
						var posM = (720 - eleH) / 2 - eleT;
						if(posM >= 0) posM = 0;
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

			function toPlayer(){
				var toPageId = 100;
				put('request', 'params', 'i=' + toPageId);
				backPos = $g('BigDiv').offsetTop == 0 ? 0 - $g("BigDivFather").scrollTop : $g('BigDiv').offsetTop;
				var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&b=' + backPos + '\'}]}';
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