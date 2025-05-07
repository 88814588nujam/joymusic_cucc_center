			function start(){
				if(ctlStart) return;
				ctlStart = true;
				if(stbType.indexOf('TEST') > -1) autoDivHeight();
				else handleDivHeight(0, 0);
				// 初始化个人信息标签卡
				var cityC = getVal('globle', 'cityC');
				$g('cityC').innerText = cityC;
				// 特殊地区得处理一下
				var tmpUid = userid;
				var isHidden = false;
				var provinceC = getVal('globle', 'provinceC');
				// 四川省用户ID多了一半，并且获取不到机顶盒型号,所以默认化
				if(provinceC == '四川省'){
					tmpUid = userid.indexOf('_') > -1 ? userid.split('_')[0] : userid;
					stbType = 'TV机顶盒';
					stbVersion = '';
				} else if(provinceC == '互联网'){
					stbType = 'TV类终端';
					stbVersion = '';
				}
				$g('uid').innerText = tmpUid;
				$g('stbType').innerText = stbType;
				$g('stbVersion').innerText = stbVersion && stbVersion != 'undefined' ? 'ver : ' + stbVersion : '';
				$g('rightDiv_' + rightDiv).style.display = 'block';
				allowClick = false;
				var topT = $g('f_setting_' + rightDiv).offsetTop;
				var backPos = topT + 3;
				animateY('sta', backPos, frequency, function(){
					allowClick = true;
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					animateX('rightDiv_' + rightDiv + '_mar', 0, frequency, function(){});
				});
				// 初始化历史标签卡
				checkBox();
				// 初始化偏好设置
				checkSwitch();
				// 初始化时间标签卡
				updateDayOfWeek();
				startColck();
				var viewUrl = 'h4', opr = 0;
				startViewPage(viewUrl, userip, userid, cityN, pageId, '', '', opr, function(data){
					viewId = data.viewId;
					// 初始化皮肤
					loadSkin();
				});
				var tempF = getIdx(nowFocus, 'f_setting_');
				if(tempF > 404 && tempF < 408){
					$g('gd_alt_0').style.visibility = 'visible';
					$g('gd_alt_1').style.visibility = 'visible';
					checkSwitchMore(0);
				} else if(tempF > 701 && tempF < 704) $g('rsDiv').style.visibility = 'visible';
			}

			function loadSkin(){
				allowClick = false;
				var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=3\'}]';
				var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
				ajaxRequest('POST', reqUrl, getSkinBack);
			}

			function getSkinBack(){
				if(xmlhttp.readyState == 4){
					if(xmlhttp.status == 200){
						var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
						var contentJson = eval('(' + retText + ')');
						themeList = contentJson.themeList;
						cnameList = contentJson.cnameList;
						var preferTheme = getVal('globle', 'preferTheme');
						var eleSelf = [242, 137, 264, 149, 314, 199];
						// 默认皮肤
						var t_0_ele = contentJson.t_0;
						var t_0_blk = $g('t_0_blk');
						if(t_0_ele.length > 0){
							var realIdx = 0;
							var t_0_ele_l = 89;
							var eleDiv = document.createElement('img');
							eleDiv.src = 'images/commonly/skins/preview/' + t_0_ele[realIdx].theme + '.png';
							eleDiv.style.cssText = 'position:absolute;width:' + eleSelf[0] + 'px;height:' + eleSelf[1] + 'px;left:' + t_0_ele_l + 'px;top:22px;z-index:1';
							eleDiv.id = 'setting_301';
							var disFlag = 'hidden';
							if(preferTheme == t_0_ele[realIdx].theme) disFlag = 'visible';
							var eleDivN = document.createElement('img');
							eleDivN.src = 'images/application/pages/setting/now.png';
							eleDivN.style.cssText = 'position:absolute;width:21px;height:21px;left:' + Number(t_0_ele_l + 216) + 'px;top:27px;z-index:2;visibility:' + disFlag;
							eleDivN.id = 'n_' + t_0_ele[realIdx].theme;
							var eleDivB = document.createElement('img');
							eleDivB.src = 'images/application/pages/setting/border.png';
							eleDivB.style.cssText = 'position:absolute;width:' + eleSelf[0] + 'px;height:' + eleSelf[1] + 'px;left:' + t_0_ele_l + 'px;top:22px;z-index:3';
							var eleDivD = document.createElement('img');
							eleDivD.src = 'images/commonly/skins/preview/' + t_0_ele[realIdx].theme + '.png';
							eleDivD.style.cssText = 'position:absolute;width:' + eleSelf[2] + 'px;height:' + eleSelf[3] + 'px;left:' + Number(t_0_ele_l - 11) + 'px;top:16px;z-index:4';
							eleDivD.id = 'd_f_setting_301';
							eleDivD.setAttribute('class', 'btn_focus_hidden');
							var eleDivF = document.createElement('img');
							eleDivF.src = 'images/application/pages/setting/focus/f_skin.png';
							eleDivF.style.cssText = 'position:absolute;width:' + eleSelf[4] + 'px;height:' + eleSelf[5] + 'px;left:' + Number(t_0_ele_l - 36) + 'px;top:0px;z-index:5';
							eleDivF.id = 'f_setting_301';
							eleDivF.setAttribute('class', 'btn_focus_hidden');
							t_0_blk.appendChild(eleDiv);
							t_0_blk.appendChild(eleDivN);
							t_0_blk.appendChild(eleDivB);
							t_0_blk.appendChild(eleDivD);
							t_0_blk.appendChild(eleDivF);
						}
						// 个性皮肤
						t_1_ele = contentJson.t_1;
						var t_1_blk = $g('t_1_blk');
						for(var i = 1; i <= t_1_ele.length + 3; i++){
							var realIdx = i - 1;
							var t_1_ele_l = realIdx * 255 + 89;
							if(i <= t_1_ele.length){
								var eleDiv = document.createElement('img');
								eleDiv.src = 'images/commonly/skins/preview/' + t_1_ele[realIdx].theme + '.png';
								eleDiv.style.cssText = 'position:absolute;width:' + eleSelf[0] + 'px;height:' + eleSelf[1] + 'px;left:' + t_1_ele_l + 'px;top:22px;z-index:1';
								eleDiv.id = 'setting_' + Number(300 + i + 1);
								var disFlag = 'hidden';
								if(preferTheme == t_1_ele[realIdx].theme) disFlag = 'visible';
								var eleDivN = document.createElement('img');
								eleDivN.src = 'images/application/pages/setting/now.png';
								eleDivN.style.cssText = 'position:absolute;width:21px;height:21px;left:' + Number(t_1_ele_l + 216) + 'px;top:27px;z-index:2;visibility:' + disFlag;
								eleDivN.id = 'n_' + t_1_ele[realIdx].theme;
								var eleDivB = document.createElement('img');
								eleDivB.src = 'images/application/pages/setting/border.png';
								eleDivB.style.cssText = 'position:absolute;width:' + eleSelf[0] + 'px;height:' + eleSelf[1] + 'px;left:' + t_1_ele_l + 'px;top:22px;z-index:3';
								var eleDivD = document.createElement('img');
								eleDivD.src = 'images/commonly/skins/preview/' + t_1_ele[realIdx].theme + '.png';
								eleDivD.style.cssText = 'position:absolute;width:' + eleSelf[2] + 'px;height:' + eleSelf[3] + 'px;left:' + Number(t_1_ele_l - 11) + 'px;top:16px;z-index:4';
								eleDivD.id = 'd_f_setting_' + Number(300 + i + 1);
								eleDivD.setAttribute('class', 'btn_focus_hidden');
								var eleDivF = document.createElement('img');
								eleDivF.src = 'images/application/pages/setting/focus/f_skin.png';
								eleDivF.style.cssText = 'position:absolute;width:' + eleSelf[4] + 'px;height:' + eleSelf[5] + 'px;left:' + Number(t_1_ele_l - 36) + 'px;top:0px;z-index:5';
								eleDivF.id = 'f_setting_' + Number(300 + i + 1);
								eleDivF.setAttribute('class', 'btn_focus_hidden');
								t_1_blk.appendChild(eleDiv);
								t_1_blk.appendChild(eleDivN);
								t_1_blk.appendChild(eleDivB);
								t_1_blk.appendChild(eleDivD);
								t_1_blk.appendChild(eleDivF);
							} else{
								var eleDiv = document.createElement('img');
								if(i == t_1_ele.length + 1) eleDiv.src = 'images/application/pages/setting/soon.png';
								else eleDiv.src = 'images/application/utils/common/null.png';
								eleDiv.style.cssText = 'position:absolute;width:' + eleSelf[0] + 'px;height:' + eleSelf[1] + 'px;left:' + t_1_ele_l + 'px;top:22px;z-index:1';
								t_1_blk.appendChild(eleDiv);
							}
						}
						t1Focus = 'f_setting_302';
						// 节日皮肤
						t_2_ele = contentJson.t_2;
						var t_2_blk = $g('t_2_blk');
						for(var i = 1; i <= t_2_ele.length + 3; i++){
							var realIdx = i - 1;
							var t_2_ele_l = realIdx * 255 + 89;
							if(i <= t_2_ele.length){
								var eleDiv = document.createElement('img');
								eleDiv.src = 'images/commonly/skins/preview/' + t_2_ele[realIdx].theme + '.png';
								eleDiv.style.cssText = 'position:absolute;width:' + eleSelf[0] + 'px;height:' + eleSelf[1] + 'px;left:' + t_2_ele_l + 'px;top:22px;z-index:1';
								eleDiv.id = 'setting_' + Number(300 + i + 1 + t_1_ele.length);
								var disFlag = 'hidden';
								if(preferTheme == t_2_ele[realIdx].theme) disFlag = 'visible';
								var eleDivN = document.createElement('img');
								eleDivN.src = 'images/application/pages/setting/now.png';
								eleDivN.style.cssText = 'position:absolute;width:21px;height:21px;left:' + Number(t_2_ele_l + 216) + 'px;top:27px;z-index:2;visibility:' + disFlag;
								eleDivN.id = 'n_' + t_2_ele[realIdx].theme;
								var eleDivB = document.createElement('img');
								eleDivB.src = 'images/application/pages/setting/border.png';
								eleDivB.style.cssText = 'position:absolute;width:' + eleSelf[0] + 'px;height:' + eleSelf[1] + 'px;left:' + t_2_ele_l + 'px;top:22px;z-index:3';
								var eleDivD = document.createElement('img');
								eleDivD.src = 'images/commonly/skins/preview/' + t_2_ele[realIdx].theme + '.png';
								eleDivD.style.cssText = 'position:absolute;width:' + eleSelf[2] + 'px;height:' + eleSelf[3] + 'px;left:' + Number(t_2_ele_l - 11) + 'px;top:16px;z-index:4';
								eleDivD.id = 'd_f_setting_' + Number(300 + i + 1 + t_1_ele.length);
								eleDivD.setAttribute('class', 'btn_focus_hidden');
								var eleDivF = document.createElement('img');
								eleDivF.src = 'images/application/pages/setting/focus/f_skin.png';
								eleDivF.style.cssText = 'position:absolute;width:' + eleSelf[4] + 'px;height:' + eleSelf[5] + 'px;left:' + Number(t_2_ele_l - 36) + 'px;top:0px;z-index:5';
								eleDivF.id = 'f_setting_' + Number(300 + i + 1 + t_1_ele.length);
								eleDivF.setAttribute('class', 'btn_focus_hidden');
								t_2_blk.appendChild(eleDiv);
								t_2_blk.appendChild(eleDivN);
								t_2_blk.appendChild(eleDivB);
								t_2_blk.appendChild(eleDivD);
								t_2_blk.appendChild(eleDivF);
							} else{
								var eleDiv = document.createElement('img');
								if(i == t_2_ele.length + 1) eleDiv.src = 'images/application/pages/setting/soon.png';
								else eleDiv.src = 'images/application/utils/common/null.png';
								eleDiv.style.cssText = 'position:absolute;width:' + eleSelf[0] + 'px;height:' + eleSelf[1] + 'px;left:' + t_2_ele_l + 'px;top:22px;z-index:1';
								t_2_blk.appendChild(eleDiv);
							}
						}
						t2Focus = 'f_setting_' + Number(302 + t_1_ele.length);
						var tempF = getIdx(nowFocus, 'f_setting_');
						if(tempF == 301){
							$g(nowFocus).setAttribute('class', 'btn_focus_visible');
							var tempS = getIdx(nowFocus, 'f_setting_');
							$g('d_' + nowFocus).setAttribute('class', 'btn_focus_visible');
						} else if(tempF > 301 && tempF <= 301 + t_1_ele.length){
							var newLeftIdx = tempF - 301;
							var t1Pos = 0 - ((newLeftIdx - 1) * 255);
							$g('t_1_blk').style.left = t1Pos + 'px';
							t1Focus = nowFocus;
							t2Focus = 'f_setting_' + Number(302 + t_1_ele.length);
							$g(nowFocus).setAttribute('class', 'btn_focus_visible');
							var tempS = getIdx(nowFocus, 'f_setting_');
							$g('d_' + nowFocus).setAttribute('class', 'btn_focus_visible');
						} else if(tempF > 301 + t_1_ele.length && tempF <= 301 + t_1_ele.length + t_2_ele.length){
							var newLeftIdx = tempF - (301 + t_1_ele.length);
							var t2Pos = 0 - ((newLeftIdx - 1) * 255);
							$g('t_2_blk').style.left = t2Pos + 'px';
							t2Focus = nowFocus;
							t1Focus = 'f_setting_302';
							$g(nowFocus).setAttribute('class', 'btn_focus_visible');
							var tempS = getIdx(nowFocus, 'f_setting_');
							if(tempS > 300 && tempS < 400) $g('d_' + nowFocus).setAttribute('class', 'btn_focus_visible');
						}
						allowClick = true;
					}
				}
			}

			function onkeyOK(){
				if(allowClick){
					var delayT = 500;
					var tempF = getIdx(nowFocus, 'f_setting_');
					if(tempF > 0 && tempF < 9){
						if(tempF != rightDiv){
							allowClick = false;
							var lstRightDiv = rightDiv;
							rightDiv = tempF;
							var topT = $g('f_setting_' + rightDiv).offsetTop;
							var backPos = topT + 3;
							animateY('sta', backPos, frequency, function(){
								$g('rightDiv_' + lstRightDiv).style.display = 'none';
								$g('rightDiv_' + lstRightDiv + '_mar').style.left = '25px';
								$g('rightDiv_' + rightDiv).style.display = 'block';
								animateX('rightDiv_' + rightDiv + '_mar', 0, frequency, function(){
									allowClick = true;
								});
							});
						}
					} else if(tempF == 101){
						exitApp();
					} else if(tempF == 102){
						openQrcode();
					} else if(tempF > 200 && tempF < 204){
						var hour = getVal('globle', 'hour');
						var max = getVal('globle', 'max');
						var modHour = 0;
						if(tempF == 201) modHour = 6;
						else if(tempF == 202) modHour = 12;
						else if(tempF == 203) modHour = 24;
						if(hour != modHour){
							$g('c_setting_h_' + hour).setAttribute('class', 'btn_focus_hidden');
							var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=1&u=' + userid + '&h=' + modHour + '&m=' + max + '\'}]';
							var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
							ajaxRequest('POST', reqUrl, function(){
								if(xmlhttp.readyState == 4){
									if(xmlhttp.status == 200){
										put('globle', 'hour', modHour + '');
										$g('c_setting_h_' + modHour).setAttribute('class', 'btn_focus_visible');
										var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
										var contentJson = eval('(' + retText + ')');
										var idsCheckedNum = contentJson.idsCheckedNum;
										$g('idsCheckedNum').innerText = idsCheckedNum;
										msg.type = getVal('globle', 'preferBubble');
										msg.createMsgArea($g('realDis'));
										msg.sendMsg('由于历史点播条件变更，满足的曲目条目数目前为：' + idsCheckedNum + '条');
									}
								}
							});
						}
					} else if(tempF > 203 && tempF < 207){
						var hour = getVal('globle', 'hour');
						var max = getVal('globle', 'max');
						var modMax = 0;
						if(tempF == 204) modMax = 50;
						else if(tempF == 205) modMax = 100;
						else if(tempF == 206) modMax = 150;
						if(max != modMax){
							$g('c_setting_m_' + max).setAttribute('class', 'btn_focus_hidden');
							var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=2&u=' + userid + '&h=' + hour + '&m=' + modMax + '\'}]';
							var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
							ajaxRequest('POST', reqUrl, function(){
								if(xmlhttp.readyState == 4){
									if(xmlhttp.status == 200){
										put('globle', 'max', modMax + '');
										$g('c_setting_m_' + modMax).setAttribute('class', 'btn_focus_visible');
										var retText = xmlhttp.responseText.replace(/(\s*$)/g, '');
										var contentJson = eval('(' + retText + ')');
										var idsCheckedNum = contentJson.idsCheckedNum;
										$g('idsCheckedNum').innerText = idsCheckedNum;
										msg.type = getVal('globle', 'preferBubble');
										msg.createMsgArea($g('realDis'));
										msg.sendMsg('由于历史点播条件变更，满足的曲目条目数目前为：' + idsCheckedNum + '条');
									}
								}
							});
						}
					} else if(tempF == 207){
						var idsCheckedNum = $g('idsCheckedNum').innerText;
						if(idsCheckedNum > 0){
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
								$g('idsCheckedNum').innerText = nowNumInt;
							});
						} else{
							msg.type = getVal('globle', 'preferBubble');
							msg.createMsgArea($g('realDis'));
							msg.sendMsg('暂无满足条件的历史点播曲目，无需清空！');
						}
					} else if(tempF > 300 && tempF < 302 + t_1_ele.length + t_2_ele.length){
						var realIdx = tempF - 301;
						var nowTheme = themeList[realIdx];
						var nowCname = cnameList[realIdx];
						var preferTheme = getVal('globle', 'preferTheme');
						if(preferTheme != nowTheme){
							var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=4&u=' + userid + '&k=' + nowTheme + '\'}]';
							var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
							ajaxRequest('POST', reqUrl, function(){
								if(xmlhttp.readyState == 4){
									if(xmlhttp.status == 200){
										put('globle', 'preferTheme', nowTheme + '');
										$g('n_' + preferTheme).style.visibility = 'hidden';
										$g('n_' + nowTheme).style.visibility = 'visible';
										$g('pageindexbgReal').style.backgroundImage = 'url(images/commonly/skins/' + nowTheme + '.png)';
										msg.type = getVal('globle', 'preferBubble');
										msg.createMsgArea($g('realDis'));
										msg.sendMsg('成功切换到新的主题 - [' + nowCname + ']');
									}
								}
							});
						} else{
							msg.type = getVal('globle', 'preferBubble');
							msg.createMsgArea($g('realDis'));
							msg.sendMsg('当前已经是主题 - [' + nowCname + ']，无需切换');
						}
					} else if(tempF > 400 && tempF < 404){
						var prefer = 'preferList';
						if(tempF == 402) prefer = 'preferKeyboard';
						else if(tempF == 403) prefer = 'preferBubble';
						var preferStaff = getVal('globle', prefer);
						var keyword = 0;
						if(preferStaff == 0) keyword = 1;
						var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=5&u=' + userid + '&p=' + prefer + '&k=' + keyword + '\'}]';
						var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
						ajaxRequest('POST', reqUrl, function(){
							if(xmlhttp.readyState == 4){
								if(xmlhttp.status == 200){
									put('globle', prefer, keyword + '');
									checkSwitch();
								}
							}
						});
					} else if(tempF == 404){
						$g('gd_alt_0').style.visibility = 'visible';
						$g('gd_alt_1').style.visibility = 'visible';
						$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
						nowFocus = 'f_setting_405';
						$g(nowFocus).setAttribute('class', 'btn_focus_visible');
						checkSwitchMore(0);
					} else if(tempF > 404 && tempF < 408){
						var keyword = 1;
						if(tempF == 406) keyword = 0;
						else if(tempF == 407) keyword = 2;
						var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=6&u=' + userid + '&k=' + keyword + '\'}]';
						var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
						ajaxRequest('POST', reqUrl, function(){
							if(xmlhttp.readyState == 4){
								if(xmlhttp.status == 200){
									put('globle', 'preferGuide', keyword + '');
									checkSwitchMore(0);
									msg.type = getVal('globle', 'preferBubble');
									msg.createMsgArea($g('realDis'));
									var tips = '开启显示导读模式';
									if(tempF == 406) tips = '关闭显示导读模式';
									else if(tempF == 407) tips = '随动显示导读模式';
									msg.sendMsg(tips);
								}
							}
						});
					} else if(tempF == 701){
						$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
						$g('rsDiv').style.visibility = 'visible';
						nowFocus = 'f_setting_703';
						$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					} else if(tempF == 702){
						var params0 = '[{\'zone\':\'request\',\'key\':\'params\',\'val\':\'d=7&u=' + userid + '\'}]';
						var reqUrl = pageId + '?jsdata=' + encodeURIComponent(params0);
						ajaxRequest('POST', reqUrl, function(){
							if(xmlhttp.readyState == 4){
								if(xmlhttp.status == 200){
									put('globle', 'preferList', '0');
									put('globle', 'preferKeyboard', '0');
									put('globle', 'preferBubble', '0');
									put('globle', 'preferGuide', '1');
									msg.type = getVal('globle', 'preferBubble');
									msg.createMsgArea($g('realDis'));
									msg.sendMsg('成功初始化设置');
									$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
									$g('rsDiv').style.visibility = 'hidden';
									nowFocus = 'f_setting_701';
									$g(nowFocus).setAttribute('class', 'btn_focus_visible');
									checkSwitch();
								}
							}
						});
					} else if(tempF == 703){
						$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
						$g('rsDiv').style.visibility = 'hidden';
						nowFocus = 'f_setting_701';
						$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					}
				}
			}

			function onkeyBack(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_setting_');
					if(tempF > 100 && tempF < 103){
						$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
						nowFocus = 'f_setting_1';
						$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					} else if(tempF > 200 && tempF < 208){
						$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
						nowFocus = 'f_setting_2';
						$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					} else if(tempF > 300 && tempF <= 301 + t_1_ele.length + t_2_ele.length){
						$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
						if(tempF > 300 && tempF < 400) $g('d_' + nowFocus).setAttribute('class', 'btn_focus_hidden');
						var t1Pos = $g('t_1_blk').offsetLeft;
						var t2Pos = $g('t_2_blk').offsetLeft;
						if(t1Pos < 0){
							allowClick = false;
							animateX('t_1_blk', 0, frequency, function(){ allowClick = true; });
						}
						if(t2Pos < 0){
							allowClick = false;
							animateX('t_2_blk', 0, frequency, function(){ allowClick = true; });
						}
						t1Focus = 'f_setting_302';
						t2Focus = 'f_setting_' + Number(302 + t_1_ele.length);
						nowFocus = 'f_setting_3';
						$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					} else if(tempF > 400 && tempF < 405){
						$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
						nowFocus = 'f_setting_4';
						$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					} else if(tempF > 404 && tempF < 408){
						checkSwitchMore(1);
						$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
						nowFocus = 'f_setting_404';
						$g(nowFocus).setAttribute('class', 'btn_focus_visible');
						$g('gd_alt_0').style.visibility = 'hidden';
						$g('gd_alt_1').style.visibility = 'hidden';
					} else if(tempF == 701){
						$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
						nowFocus = 'f_setting_7';
						$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					} else if(tempF == 702 || tempF == 703){
						$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
						$g('rsDiv').style.visibility = 'hidden';
						nowFocus = 'f_setting_701';
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
					var tempF = getIdx(nowFocus, 'f_setting_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF > 300 && tempF < 400) $g('d_' + nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF == 101 || tempF == 102) nowFocus = 'f_setting_1';
					else if(tempF == 203) nowFocus = 'f_setting_202';
					else if(tempF == 202) nowFocus = 'f_setting_201';
					else if(tempF == 201 || tempF == 204) nowFocus = 'f_setting_2';
					else if(tempF == 206 || tempF == 207) nowFocus = 'f_setting_205';
					else if(tempF == 205) nowFocus = 'f_setting_204';
					else if(tempF == 301 || tempF == 302 || tempF == 302 + t_1_ele.length) nowFocus = 'f_setting_3';
					else if(tempF > 302 && tempF < 302 + t_1_ele.length){
						var newIdx = tempF - 1;
						nowFocus = 'f_setting_' + newIdx;
						var lf = $g(nowFocus).offsetLeft;
						if(lf >= 53){
							var t1Pos = $g('t_1_blk').offsetLeft;
							t1Pos = t1Pos + 255;
							allowClick = false;
							animateX('t_1_blk', t1Pos, frequency, function(){
								t1Focus = nowFocus;
								$g(nowFocus).setAttribute('class', 'btn_focus_visible');
								var tempS = getIdx(nowFocus, 'f_setting_');
								if(tempS > 300 && tempS < 400) $g('d_' + nowFocus).setAttribute('class', 'btn_focus_visible');
								allowClick = true;
							});
						}
						return;
					} else if(tempF > 302 + t_1_ele.length && tempF < 302 + t_1_ele.length + t_2_ele.length){
						var newIdx = tempF - 1;
						nowFocus = 'f_setting_' + newIdx;
						var lf = $g(nowFocus).offsetLeft;
						if(lf >= 53){
							var t2Pos = $g('t_2_blk').offsetLeft;
							t2Pos = t2Pos + 255;
							allowClick = false;
							animateX('t_2_blk', t2Pos, frequency, function(){
								t2Focus = nowFocus;
								$g(nowFocus).setAttribute('class', 'btn_focus_visible');
								var tempS = getIdx(nowFocus, 'f_setting_');
								if(tempS > 300 && tempS < 400) $g('d_' + nowFocus).setAttribute('class', 'btn_focus_visible');
								allowClick = true;
							});
						}
						return;
					} else if(tempF > 400 && tempF < 405) nowFocus = 'f_setting_4';
					else if(tempF > 404 && tempF < 408){
						checkSwitchMore(1);
						nowFocus = 'f_setting_404';
						$g(nowFocus).setAttribute('class', 'btn_focus_visible');
						$g('gd_alt_0').style.visibility = 'hidden';
						$g('gd_alt_1').style.visibility = 'hidden';
						return;
					} else if(tempF == 701) nowFocus = 'f_setting_7';
					else if(tempF == 703) nowFocus = 'f_setting_702';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					var tempS = getIdx(nowFocus, 'f_setting_');
					if(tempS > 300 && tempS < 400) $g('d_' + nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onkeyRight(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_setting_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF > 300 && tempF < 400) $g('d_' + nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF > 0 && tempF < 9){
						if(rightDiv == 1) nowFocus = 'f_setting_101';
						else if(rightDiv == 2) nowFocus = 'f_setting_201';
						else if(rightDiv == 3) nowFocus = 'f_setting_301';
						else if(rightDiv == 4) nowFocus = 'f_setting_401';
						else if(rightDiv == 7) nowFocus = 'f_setting_701';
					} else if(tempF == 201) nowFocus = 'f_setting_202';
					else if(tempF == 202) nowFocus = 'f_setting_203';
					else if(tempF == 204) nowFocus = 'f_setting_205';
					else if(tempF == 205) nowFocus = 'f_setting_206';
					else if(tempF > 301 && tempF < 301 + t_1_ele.length){
						var newIdx = tempF + 1;
						nowFocus = 'f_setting_' + newIdx;
						var lf = $g(nowFocus).offsetLeft;
						if(lf >= 308){
							var t1Pos = $g('t_1_blk').offsetLeft;
							t1Pos = t1Pos - 255;
							allowClick = false;
							animateX('t_1_blk', t1Pos, frequency, function(){
								t1Focus = nowFocus;
								$g(nowFocus).setAttribute('class', 'btn_focus_visible');
								var tempS = getIdx(nowFocus, 'f_setting_');
								if(tempS > 300 && tempS < 400) $g('d_' + nowFocus).setAttribute('class', 'btn_focus_visible');
								allowClick = true;
							});
						}
						return;
					} else if(tempF > 301 + t_1_ele.length && tempF < 301 + t_1_ele.length + t_2_ele.length){
						var newIdx = tempF + 1;
						nowFocus = 'f_setting_' + newIdx;
						var lf = $g(nowFocus).offsetLeft;
						if(lf >= 308){
							var t2Pos = $g('t_2_blk').offsetLeft;
							t2Pos = t2Pos - 255;
							allowClick = false;
							animateX('t_2_blk', t2Pos, frequency, function(){
								t2Focus = nowFocus;
								$g(nowFocus).setAttribute('class', 'btn_focus_visible');
								var tempS = getIdx(nowFocus, 'f_setting_');
								if(tempS > 300 && tempS < 400) $g('d_' + nowFocus).setAttribute('class', 'btn_focus_visible');
								allowClick = true;
							});
						}
						return;
					} else if(tempF == 404){
						$g('gd_alt_0').style.visibility = 'visible';
						$g('gd_alt_1').style.visibility = 'visible';
						$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
						nowFocus = 'f_setting_405';
						$g(nowFocus).setAttribute('class', 'btn_focus_visible');
						checkSwitchMore(0);
						return;
					} else if(tempF == 702) nowFocus = 'f_setting_703';
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					var tempS = getIdx(nowFocus, 'f_setting_');
					if(tempS > 300 && tempS < 400) $g('d_' + nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onkeyUp(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_setting_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF > 300 && tempF < 400) $g('d_' + nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF > 1 && tempF < 9){
						var newIdx = tempF - 1;
						nowFocus = 'f_setting_' + newIdx;
					} else if(tempF == 102) nowFocus = 'f_setting_101';
					else if(tempF == 204) nowFocus = 'f_setting_201';
					else if(tempF == 205) nowFocus = 'f_setting_202';
					else if(tempF == 206) nowFocus = 'f_setting_203';
					else if(tempF == 207) nowFocus = 'f_setting_206';
					else if(tempF > 301 && tempF < 302 + t_1_ele.length) nowFocus = 'f_setting_301';
					else if(tempF > 301 + t_1_ele.length && tempF < 302 + t_1_ele.length + t_2_ele.length) nowFocus = t1Focus;
					else if((tempF > 401 && tempF < 405) || (tempF > 405 && tempF < 408)){
						var newIdx = tempF - 1;
						nowFocus = 'f_setting_' + newIdx;
					}
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					var tempS = getIdx(nowFocus, 'f_setting_');
					if(tempS > 300 && tempS < 400) $g('d_' + nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function onkeyDown(){
				if(allowClick){
					var tempF = getIdx(nowFocus, 'f_setting_');
					$g(nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF > 300 && tempF < 400) $g('d_' + nowFocus).setAttribute('class', 'btn_focus_hidden');
					if(tempF > 0 && tempF < 8){
						var newIdx = tempF + 1;
						nowFocus = 'f_setting_' + newIdx;
					} else if(tempF == 101){
						if($gg('f_setting_102')) nowFocus = 'f_setting_102';
					} else if(tempF == 201) nowFocus = 'f_setting_204';
					else if(tempF == 202) nowFocus = 'f_setting_205';
					else if(tempF == 203) nowFocus = 'f_setting_206';
					else if(tempF == 204 || tempF == 205 || tempF == 206) nowFocus = 'f_setting_207';
					else if(tempF == 301) nowFocus = t1Focus;
					else if(tempF > 301 && tempF < 302 + t_1_ele.length) nowFocus = t2Focus;
					else if((tempF > 400 && tempF < 404) || (tempF > 404 && tempF < 407)){
						var newIdx = tempF + 1;
						nowFocus = 'f_setting_' + newIdx;
					}
					$g(nowFocus).setAttribute('class', 'btn_focus_visible');
					var tempS = getIdx(nowFocus, 'f_setting_');
					if(tempS > 300 && tempS < 400) $g('d_' + nowFocus).setAttribute('class', 'btn_focus_visible');
				}
			}

			function checkBox(){
				var hour = getVal('globle', 'hour');
				var max = getVal('globle', 'max');
				$g('c_setting_h_' + hour).setAttribute('class', 'btn_focus_visible');
				$g('c_setting_m_' + max).setAttribute('class', 'btn_focus_visible');
			}

			function checkSwitch(){
				var preferList = getVal('globle', 'preferList');
				var preferKeyboard = getVal('globle', 'preferKeyboard');
				var preferBubble = getVal('globle', 'preferBubble');
				if(preferList == 0){
					$g('setting_401').src = 'images/application/pages/setting/close.png';
					$g('f_setting_401').src = 'images/application/pages/setting/focus/f_close.png';
				} else{
					$g('setting_401').src = 'images/application/pages/setting/open.png';
					$g('f_setting_401').src = 'images/application/pages/setting/focus/f_open.png';
				}
				if(preferKeyboard == 1){
					$g('setting_402').src = 'images/application/pages/setting/close.png';
					$g('f_setting_402').src = 'images/application/pages/setting/focus/f_close.png';
				} else{
					$g('setting_402').src = 'images/application/pages/setting/open.png';
					$g('f_setting_402').src = 'images/application/pages/setting/focus/f_open.png';
				}
				if(preferBubble == 0){
					$g('setting_403').src = 'images/application/pages/setting/close.png';
					$g('f_setting_403').src = 'images/application/pages/setting/focus/f_close.png';
				} else{
					$g('setting_403').src = 'images/application/pages/setting/open.png';
					$g('f_setting_403').src = 'images/application/pages/setting/focus/f_open.png';
				}
			}

			function checkSwitchMore(tp){
				if(tp == 0){
					var preferGuide = getVal('globle', 'preferGuide');
					if(preferGuide == 0){
						$g('gd_now_1').style.visibility = 'hidden';
						$g('gd_now_2').style.visibility = 'hidden';
					} else if(preferGuide == 1){
						$g('gd_now_0').style.visibility = 'hidden';
						$g('gd_now_2').style.visibility = 'hidden';
					} else if(preferGuide == 2){
						$g('gd_now_0').style.visibility = 'hidden';
						$g('gd_now_1').style.visibility = 'hidden';
					}
					$g('gd_now_' + preferGuide).style.visibility = 'visible';
				} else{
					$g('gd_now_0').style.visibility = 'hidden';
					$g('gd_now_1').style.visibility = 'hidden';
					$g('gd_now_2').style.visibility = 'hidden';
				}
			}

			function animateY(id, target, speed, fun){
				if(animation == 0) nextDirectY(id, target, fun);
				else nextSlideY(id, target, speed, fun);
			}

			function animateX(id, target, speed, fun){
				if(animation == 0) nextDirectX(id, target, fun);
				else nextSlideX(id, target, speed, fun);
			}

			function startColck(){
				clockTask = setInterval('roundNumber()', 1000);
			}

			function roundNumber(){
				var nowTime = new Date();
				var nowHour = nowTime.getHours();
				var nowMinute = nowTime.getMinutes();
				var nowSecond = nowTime.getSeconds();
				for(var i = 1; i <= 60; i++){
					$g('s' + i).style.visibility = 'hidden';
					$g('m' + i).style.visibility = 'hidden';
					$g('h' + i).style.visibility = 'hidden';
				}
				if(nowHour > 11) nowHour = nowHour - 12;
				var disH = (nowHour * 5 + 1) + Math.floor(nowMinute / 12);
				$g('s' + Number(nowSecond + 1)).style.visibility = 'visible';
				$g('m' + Number(nowMinute + 1)).style.visibility = 'visible';
				$g('h' + disH).style.visibility = 'visible';
				var nowYear = nowTime.getFullYear();
				var nowMonth = nowTime.getMonth() + 1;
				var nowDay = nowTime.getDate();
				var nowDate = nowYear + '-';
				var tmpNowHour = nowTime.getHours();
				nowDate += nowMonth < 10 ? '0' + nowMonth + '-' : nowMonth + '-';
				nowDate += nowDay < 10 ? '0' + nowDay + ' ' : nowDay;
				var nowDate2 = tmpNowHour < 10 ? '0' + tmpNowHour + ':' : tmpNowHour + ':';
				nowDate2 += nowMinute < 10 ? '0' + nowMinute + ':' : nowMinute + ':';
				nowDate2 += nowSecond < 10 ? '0' + nowSecond : nowSecond;
				$g('timeC1').innerText = nowDate;
				$g('timeC2').innerText = nowDate2;
				if(nowHour == 0) updateDayOfWeek();
			}

			function updateDayOfWeek(){
				for(var i = 1; i <= 7; i++){
					$g('wkd' + i).style.color = '#FFFFFF';
					$g('b_wkd' + i).style.visibility = 'hidden';
				}
				var nowTime = new Date();
				var nowWkd = nowTime.getDay();
				var tmpIdx = nowWkd + 1;
				$g('wkd' + tmpIdx).style.color = '#00CDFF';
				$g('b_wkd' + tmpIdx).style.visibility = 'visible';
				var nowDay = nowTime.getDate();
				$g('d_wkd' + tmpIdx).innerText = nowDay;
				var idx = 0;
				for(var i = 1; i < tmpIdx; i++){
					idx = tmpIdx - i;
					var tmpNow = nowDay - idx;
					if(tmpNow < 1){
						var nowdays = new Date();
						var year = nowdays.getFullYear();
						var month = nowdays.getMonth();
						if(month == 0){
							month = 12;
							year = year - 1;
						}
						var myDate = new Date(year, month, 0);
						var lstDay = myDate.getDate();
						tmpNow = tmpNow + lstDay;
					}
					$g('d_wkd' + i).innerText = tmpNow;
				}
				idx = 0;
				for(var i = tmpIdx + 1; i <= 7; i++){
					idx++;
					var tmpNow = nowDay + idx;
					$g('d_wkd' + i).innerText = tmpNow;
				}
			}

			function toPlayer(){
				var toPageId = 100;
				put('request', 'params', 'i=' + toPageId);
				var nowInfo = '{\'back\':[{\'target\':\'' + pageId + '\'},{\'params\':\'i=' + pageId + '&n=' + nowFocus + '&h=' + rightDiv + '\'}]}';
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