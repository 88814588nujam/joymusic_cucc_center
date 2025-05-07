<%@page language="java" import="com.joymusic.api.*,java.util.*,org.apache.commons.lang3.StringUtils" pageEncoding="UTF-8"%>
<%
	int opera = Integer.parseInt(StringUtils.isBlank(request.getParameter("o")) ? "1" : request.getParameter("o").toString()); // 操作类型
	
	if(opera == 0){ // 从已选队列中移除歌曲
		int row = 0;
		int ckd = 0;
		String checkedStr = "";
		String userid = request.getParameter("u");
		if(StringUtils.isNotBlank(userid)){
			int hour = Integer.parseInt(StringUtils.isBlank(request.getParameter("t")) ? "24" : request.getParameter("t").toString()); // hour小时内有效已选歌曲
			int max = Integer.parseInt(StringUtils.isBlank(request.getParameter("m")) ? "100" : request.getParameter("m").toString()); // 有效已选歌曲上限max	
			String songIds = request.getParameter("s");
			if(StringUtils.isNotBlank(songIds)){ // 移除一组|一个已选歌曲
				String[] ids0 = songIds.split(",");
				for(int i = ids0.length - 1; i >= 0; i--){
					// 首先判断歌曲是否下线
					String tmpSongId = ids0[i].trim();
					Map<String, Object> map = InfoData.getSingleSong(tmpSongId);
					if(map.size() > 0){
						int row0 = InfoData.delToChecked(userid, tmpSongId, hour);
						if(row0 > 0) row++;
					}
				}
			} else{ // 移除全部已选歌曲
				int row0 = InfoData.delToChecked(userid, "", hour);
				if(row0 > 0) row++;
			}
			checkedStr = InfoData.getCheckedStr(userid, hour, max);
			String[] idsCheckedStr = checkedStr.split(",");
			ckd = checkedStr.contains(",") ? idsCheckedStr.length : (StringUtils.isBlank(checkedStr) ? 0 : 1);
		}
		out.print("{\"opera\":\"" + opera + "\", \"opera_num\":\"" + row + "\", \"list_num\":\"" + ckd + "\", \"list_ids_str\":\"" + checkedStr + "\"}");
	} else if(opera == 1){ // 加入已选队列
		int row = 0;
		int ckd = 0;
		String checkedStr = "";
		String userid = request.getParameter("u");
		if(StringUtils.isNotBlank(userid)){
			int hour = Integer.parseInt(StringUtils.isBlank(request.getParameter("t")) ? "24" : request.getParameter("t").toString()); // hour小时内有效已选歌曲
			int max = Integer.parseInt(StringUtils.isBlank(request.getParameter("m")) ? "100" : request.getParameter("m").toString()); // 有效已选歌曲上限max
			String songIds = request.getParameter("s");
			if(StringUtils.isNotBlank(songIds)){
				String[] ids0 = songIds.split(",");
				for(int i = ids0.length - 1; i >= 0; i--){
					// 首先判断歌曲是否下线
					String tmpSongId = ids0[i].trim();
					Map<String, Object> map = InfoData.getSingleSong(tmpSongId);
					if(map.size() > 0){
						int row0 = InfoData.addToChecked(userid, tmpSongId, hour);
						if(row0 > 0) row++;
					}
				}
			}
			checkedStr = InfoData.getCheckedStr(userid, hour, max);
			String[] idsCheckedStr = checkedStr.split(",");
			ckd = checkedStr.contains(",") ? idsCheckedStr.length : (StringUtils.isBlank(checkedStr) ? 0 : 1);
		}
		out.print("{\"opera\":\"" + opera + "\", \"opera_num\":\"" + row + "\", \"list_num\":\"" + ckd + "\", \"list_ids_str\":\"" + checkedStr + "\"}");
	} else if(opera == 2){ // 加入|移除收藏队列
		int row = 0;
		int ckd = 0;
		String collectStr = "";
		String userid = request.getParameter("u");
		if(StringUtils.isNotBlank(userid)){
			int ctype = Integer.parseInt(StringUtils.isBlank(request.getParameter("c")) ? "1" : request.getParameter("c").toString()); // 0:歌手 1:歌曲
			String contId = StringUtils.isBlank(request.getParameter("s")) ? "" : request.getParameter("s").toString();
			if(StringUtils.isNotBlank(contId)) row = InfoData.addToCollect(userid, contId, ctype);
			else{ // 删除全部收藏队列
				int rt = InfoData.delToCollect(userid, ctype);
				if(rt > 0) row = -1;
			}
			collectStr = InfoData.getCollectStr(userid, ctype);
			String[] idsCollectStr = collectStr.split(",");
			ckd = collectStr.contains(",") ? idsCollectStr.length : (StringUtils.isBlank(collectStr) ? 0 : 1);
		}
		out.print("{\"opera\":\"" + opera + "\", \"opera_type\":\"" + row + "\", \"list_num\":\"" + ckd + "\", \"list_ids_str\":\"" + collectStr + "\"}");
	} else if(opera == 3){ // 大篇幅列表曲目的全部播放按钮
		int row = 0;
		int ckd = 0;
		String checkedStr = "";
		String userid = request.getParameter("u");
		if(StringUtils.isNotBlank(userid)){
			int hour = Integer.parseInt(StringUtils.isBlank(request.getParameter("t")) ? "24" : request.getParameter("t").toString()); // hour小时内有效已选歌曲
			int max = Integer.parseInt(StringUtils.isBlank(request.getParameter("m")) ? "100" : request.getParameter("m").toString()); // 有效已选歌曲上限max
			int pageId = Integer.parseInt(StringUtils.isBlank(request.getParameter("p")) ? "0" : request.getParameter("p").toString()); // 按钮来源页面
			if(pageId == 7 || pageId == 8){ // 明星点歌的全部播放
				int singerId = Integer.parseInt(StringUtils.isBlank(request.getParameter("c")) ? "0" : request.getParameter("c").toString()); // 艺人ID
				// 获取艺人信息
				Map<String, Object> gabr = InfoData.getEntityArtist(singerId);
				String cname = gabr.get("cname").toString();
				row = InfoData.checkAllSongByArtist(userid, cname, hour);
			} else if(pageId == 1 || pageId == 11 || pageId == 12){ // 列表专题的全部播放
				int albumlistId = Integer.parseInt(StringUtils.isBlank(request.getParameter("c")) ? "0" : request.getParameter("c").toString()); // 列表ID
				row = InfoData.checkAllSongByList(userid, albumlistId, hour);
			} else if(pageId == 14){ // 收藏列表的全部播放
				row = InfoData.checkAllSongByCollect(userid, hour);
			}
			checkedStr = InfoData.getCheckedStr(userid, hour, max);
			String[] idsCheckedStr = checkedStr.split(",");
			ckd = checkedStr.contains(",") ? idsCheckedStr.length : (StringUtils.isBlank(checkedStr) ? 0 : 1);
		}
		out.print("{\"opera\":\"" + opera + "\", \"opera_num\":\"" + row + "\", \"list_num\":\"" + ckd + "\", \"list_ids_str\":\"" + checkedStr + "\"}");
	} else if(opera == 4){ // 获取单曲详细信息
		String songId = StringUtils.isBlank(request.getParameter("s")) ? "" : request.getParameter("s").toString();
		Map<String, Object> map = InfoData.getSingleSong(songId);
		String jsonStr = "{'sid':'', 'cname':'', 'artist':'', 'cres':''}";
		if(!map.isEmpty()){
			jsonStr = "{'sid':'" + map.get("id") + "', 'cname':'" + map.get("cname").toString().replaceAll("'", "\\\\'") + "', 'artist':'" + map.get("artist").toString().replaceAll("'", "\\\\'") + "', 'cres':'" + map.get("cres") + "'}";
		}
		out.print(jsonStr);
	} else if(opera == 5){ // 获取艺人详细信息
		String singerId = StringUtils.isBlank(request.getParameter("s")) ? "" : request.getParameter("s").toString();
		int aid = Integer.parseInt(singerId);
		Map<String, Object> map = InfoData.getEntityArtist(aid);
		String jsonStr = "{'sid':'', 'cname':'', 'artist':'', 'cres':''}";
		if(!map.isEmpty()){
			jsonStr = "{'sid':'" + map.get("id") + "', 'cname':'" + map.get("cname").toString().replaceAll("'", "\\\\'") + "'}";
		}
		out.print(jsonStr);
	}
%>