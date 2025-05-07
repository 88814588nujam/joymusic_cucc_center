<%@page language="java" import="java.util.*" pageEncoding="UTF-8"%>
<%
	String grul = request.getRequestURL().toString();
	String prefixPath = "http://192.168.100.101:8082" + request.getContextPath() + "/";
	// 局域网终端测试地址
	// if(grul.contains("192.168.")) prefixPath = grul.replace("m0", "");
	// else if(grul.contains("127.0.0.1")) prefixPath = "http://127.0.0.1:8082" + request.getContextPath() + "/";
	// else if(grul.contains("localhost")) prefixPath = "http://localhost:8082" + request.getContextPath() + "/";
	prefixPath = prefixPath + "?isOnline=n";
%>
<!DOCTYPE html>
<html>
<head>
	<title>欢乐歌房【手机测试】</title>
	<meta name='viewport' content='width=device-width,initial-scale=0.32,user-scalable=no'>
	<meta name='msapplication-tap-highlight' content='no'>
	<link rel='shortcut icon' href='<%=request.getContextPath() %>/images/application/utils/icon/joymusic.ico' type='image/x-icon'>
</head>
<body>
	<div style='float:left'>
		<span style='display:inline-block'>
			<iframe id='joymusic' src='<%=prefixPath %>' style='width:1280px;height:720px' frameborder=no border=0 marginwidth=0 marginheight=0 scrolling=no></iframe>
		</span>
	</div>
	<div style='float:left;margin-top:400px;margin-left:35px'>
		<table>
			<tr>
				<td></td>
				<td><input type='button' onclick='sendMsg(38)' value='⬆️' style='width:170px;height:170px;font-size:50px;font-family:黑体'/></td>
				<td></td>
			</tr>
			<tr>
				<td>
					<input type='button' onclick='sendMsg(37)' value='⬅️' style='width:170px;height:170px;font-size:50px;font-family:黑体'/>
				</td>
				<td></td>
				<td>
					<input type='button' onclick='sendMsg(39)' value='➡️' style='width:170px;height:170px;font-size:50px;font-family:黑体'/>
				</td>
			</tr>
			<tr>
				<td></td>
				<td>
					<input type='button' onclick='sendMsg(40)' value='⬇️' style='width:170px;height:170px;font-size:50px;font-family:黑体'/>
				</td>
					<td></td>
			</tr>
			<tr style='height:150px;'></tr>
			<tr>
				<td></td>
				<td></td>
				<td>
					<input type='button' onclick='sendMsg(33)' value='️⏮' style='width:170px;height:100px;font-size:40px;font-family:黑体'/>
				</td>
			</tr>
		</table>
	</div>
	<div style='float:right;margin-top:400px;margin-right:35px'>
		<table>
			<tr>
				<td></td>
				<td><input type='button' onclick='closePage()' value='🔴' style='width:170px;height:170px;font-size:50px;font-family:黑体'/></td>
				<td></td>
			</tr>
			<tr>
				<td>
					<input type='button' onclick='refreshPage()' value='🟣' style='width:170px;height:170px;font-size:50px;font-family:黑体'/>
				</td>
				<td></td>
				<td>
					<input type='button' onclick='sendMsg(13);' value='🟢' style='width:170px;height:170px;font-size:50px;font-family:黑体'/>
				</td>
			</tr>
			<tr>
				<td></td>
				<td><input type='button' onclick='sendMsg(8);' value='🔵' style='width:170px;height:170px;font-size:50px;font-family:黑体'/></td>
				<td></td>
			</tr>
			<tr style='height:150px;'></tr>
			<tr>
				<td>
					<input type='button' onclick='sendMsg(34)' value='⏭' style='width:170px;height:100px;font-size:40px;font-family:黑体'/>
				</td>
				<td></td>
				<td></td>
			</tr>
		</table>
	</div>
	<div style='float:right;margin-top:200px;margin-right:35px'>
		<table>
			<tr>
				<td>
					<div style='float:left;text-align:center;line-height:50px;color:#FFFFFF;font-size:26px;background-image:url(images/application/pages/index/commonly/grey.png)'>🟢确定</div>
				</td>
				<td>
					<div style='float:left;text-align:center;line-height:50px;color:#FFFFFF;font-size:26px;background-image:url(images/application/pages/index/commonly/grey.png)'>🔵返回</div>
				</td>
				<td>
					<div style='float:left;text-align:center;line-height:50px;color:#FFFFFF;font-size:26px;background-image:url(images/application/pages/index/commonly/grey.png)'>🟣重启</div>
				</td>
				<td>
					<div style='float:left;text-align:center;line-height:50px;color:#FFFFFF;font-size:26px;background-image:url(images/application/pages/index/commonly/grey.png)'>🔴关闭</div>
				<td>
			</tr>
		</table>
	</div>
	<script type='text/javascript'>
		function sendMsg(key){
			var joymusic = document.getElementById('joymusic');
			joymusic.contentWindow.keyAction(key);
		}

		function refreshPage(){
			var joymusic = document.getElementById('joymusic');
			joymusic.src = '<%=prefixPath %>';
		}

		function closePage(){
			try{
				WeixinJSBridge.call('closeWindow');
			} catch(e){
				window.close();
			}
		}

		// 禁用双指放大
		document.documentElement.addEventListener('touchstart', function(event){
		    if(event.touches.length > 1){
		        event.preventDefault();
		    }
		}, {
		    passive: false
		});

		// 禁用双击放大
		var lastTouchEnd = 0;
		document.documentElement.addEventListener('touchend', function(event){
		    var now = Date.now();
		    if(now - lastTouchEnd <= 300){
		        event.preventDefault();
		    }
		    lastTouchEnd = now;
		}, {
		    passive: false
		});

		function orient(){
            if(window.orientation == 90 || window.orientation == -90){
                // alert('横屏');
                return false;
            } else if(window.orientation == 0 || window.orientation == 180){
				// alert('竖屏');
                return false;
            }
        }
	</script>
</body>