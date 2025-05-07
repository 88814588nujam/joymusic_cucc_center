package com.joymusic.api;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.lang3.StringUtils;

import com.joymusic.common.Page;

public class InfoDataCore {
	// 页面详情
	public static Map<String, Object> getUiPageDetail(int entryid) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM ui_detail_page WHERE id=$entryid";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { Integer.valueOf(entryid) });
		li = DB.query(sql, true);
		if (li.size() > 0) {
			map = li.get(0);
		}
		return map;
	}

	// 首页版块的推荐位
	public static List<Map<String, Object>> getUiIndexRecommend(int... entryids) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM ui_index_recommend WHERE pid=$entryid AND pos<>0 ORDER BY pos";
		if (entryids.length > 1)
			sql = "SELECT * FROM ui_index_recommend_" + entryids[1]
					+ " WHERE pid=$entryid AND pos<>0 ORDER BY pos";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { Integer.valueOf(entryids[0]) });
		li = DB.query(sql, true);
		return li;
	}

	// 榜单查询歌手条目数
	public static int getArtistsCountByRecommend(int ctype, boolean flag) {
		int row = 0;
		String sql = "SELECT COUNT(0) FROM recommend_artist RA, entity_artist EA WHERE";
		sql += " RA.id_artist=EA.id AND RA.item_type=$ctype AND RA.csort<>0 AND EA.csort<>0 ORDER BY RA.csort DESC";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { Integer.valueOf(ctype) });
		row = DB.queryCount(sql, flag);
		return row;
	}

	// 榜单点歌查询歌手信息
	public static List<Map<String, Object>> getArtistsByRecommend(Page page,
			int ctype, boolean flag) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT EA.id,EA.cname,EA.sname,EA.pic,EA.ctype,EA.carea FROM recommend_artist RA, entity_artist EA WHERE";
		sql += " RA.id_artist=EA.id AND RA.item_type=$ctype AND RA.csort<>0 AND EA.csort<>0 ORDER BY RA.csort DESC LIMIT "
				+ page.getStartRow() + "," + page.getPageSize();
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { Integer.valueOf(ctype) });
		li = DB.query(sql, flag);
		return li;
	}

	// 榜单查询歌曲条目数
	public static int getSongsCountByRecommend(int ctype, boolean flag) {
		int row = 0;
		String sql = "SELECT COUNT(0) FROM recommend_song RS, entity_song ES WHERE";
		sql += " RS.id_song=ES.id AND RS.item_type=$ctype AND RS.csort<>0 AND ES.csort<>0 ORDER BY RS.csort DESC";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { Integer.valueOf(ctype) });
		row = DB.queryCount(sql, flag);
		return row;
	}

	// 榜单点歌查询歌曲信息
	public static List<Map<String, Object>> getSongsByRecommend(Page page,
			int ctype, boolean flag) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT ES.id,ES.cname,ES.artist,ES.artist_pic,ES.cfree,ES.duration FROM recommend_song RS, entity_song ES WHERE";
		sql += " RS.id_song=ES.id AND RS.item_type=$ctype AND RS.csort<>0 AND ES.csort<>0 ORDER BY RS.csort DESC LIMIT "
				+ page.getStartRow() + "," + page.getPageSize();
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { Integer.valueOf(ctype) });
		li = DB.query(sql, flag);
		return li;
	}

	// 用户信息
	public static Map<String, Object> getUserInfo(String uid, int platform) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM user_info WHERE uid=$uid AND platform=$platform";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { uid, Integer.valueOf(platform) });
		li = DB.query(sql, false);
		if (li.size() > 0) {
			map = li.get(0);
		}
		return map;
	}

	// 插入用户信息
	public static int addUserInfo(String ip, String uid, String preferTheme,
			String preferPlayer, int preferList, int preferKeyboard,
			int preferBubble, int preferGuide, int hour, int max,
			String provinceN, String provinceC, String cityN, String cityC,
			String stbType, String stbVersion, int platform) {
		Integer totalRows = 0;
		String sql = "INSERT INTO user_info(ip, uid, preferTheme, preferPlayer, preferList, preferKeyboard, preferBubble, preferGuide, hour, max, provinceN, provinceC, cityN, cityC, stbType, stbVersion, platform, createtime) VALUE($ip, $uid, $preferTheme, $preferPlayer, $preferList, $preferKeyboard, $preferBubble, $preferGuide, $hour, $max, $provinceN, $provinceC, $cityN, $cityC, $stbType, $stbVersion, $platform, NOW())";
		sql = DB.sqlWrapperByParams(
				sql,
				new Object[] { ip, uid, preferTheme, preferPlayer,
						Integer.valueOf(preferList),
						Integer.valueOf(preferKeyboard),
						Integer.valueOf(preferBubble),
						Integer.valueOf(preferGuide), Integer.valueOf(hour),
						Integer.valueOf(max), provinceN, provinceC, cityN,
						cityC, stbType, stbVersion, Integer.valueOf(platform) });
		totalRows = DB.update(sql);
		return totalRows;
	}

	// 用户设置
	public static int updateUserInfo(String uid, String key, String val) {
		int totalRows = 0;
		String sql = "UPDATE user_info SET " + key + "=$val WHERE uid=$uid";
		sql = DB.sqlWrapperByParams(sql, new Object[] { val, uid });
		totalRows = DB.update(sql);
		return totalRows;
	}

	// 歌曲缩写查询歌曲条目数
	public static int getSongsCountBySpell(String words) {
		int row = 0;
		String sql = "";
		if (StringUtils.isBlank(words)) {
			sql = "SELECT COUNT(0) FROM entity_song WHERE";
			sql = sql + " csort<>0";
			row = DB.queryCount(sql, true);
		} else {
			sql = "SELECT COUNT(0) FROM entity_song WHERE";
			sql = sql + " abbr Like '" + words + "%' AND csort<>0";
			row = DB.queryCount(sql, true);
		}
		return row;
	}

	// 歌曲缩写查询歌曲信息
	public static List<Map<String, Object>> getSongsBySpell(Page page,
			String words) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "";
		if (StringUtils.isBlank(words)) {
			sql = "SELECT * FROM entity_song WHERE";
			sql = sql + " csort<>0 ORDER BY csort DESC, id DESC LIMIT "
					+ page.getStartRow() + "," + page.getPageSize();
			li = DB.query(sql, true);
		} else {
			sql = "SELECT * FROM entity_song WHERE abbr Like '" + words
					+ "%' AND";
			sql = sql + " csort<>0 ORDER BY length(abbr) ASC, id DESC LIMIT "
					+ page.getStartRow() + "," + page.getPageSize();
			li = DB.query(sql, true);
		}
		return li;
	}

	// 歌手查询条目数
	public static int getArtistsCount(String words) {
		int row = 0;
		String sql = "";
		if (StringUtils.isBlank(words)) {
			sql = "SELECT COUNT(0) FROM entity_artist WHERE";
			sql = sql + " csort<>0";
			row = DB.queryCount(sql, true);
		} else {
			sql = "SELECT COUNT(0) FROM entity_artist WHERE";
			sql = sql + " abbr Like '" + words + "%' AND csort<>0";
			row = DB.queryCount(sql, true);
		}
		return row;
	}

	// 歌手查询
	public static List<Map<String, Object>> getArtists(Page page, String words) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "";
		if (StringUtils.isBlank(words)) {
			sql = "SELECT * FROM entity_artist WHERE";
			sql = sql + " csort<>0 ORDER BY csort DESC LIMIT "
					+ page.getStartRow() + "," + page.getPageSize();
			li = DB.query(sql, true);
		} else {
			sql = "SELECT * FROM entity_artist WHERE";
			sql = sql + " abbr Like '" + words
					+ "%' AND csort<>0 ORDER BY length(abbr) ASC LIMIT "
					+ page.getStartRow() + "," + page.getPageSize();
			li = DB.query(sql, true);
		}
		return li;
	}

	// 搜索页推荐歌曲
	public static List<Map<String, Object>> getUiSearchRecommend(
			String strlist, int num, int... entryids) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM ui_index_recommend WHERE pid=$entryid AND pos<>0 ORDER BY";
		if (entryids.length > 1)
			sql = "SELECT * FROM ui_index_recommend_" + entryids[1]
					+ " WHERE pid=$entryid AND pos<>0 ORDER BY";
		if (StringUtils.isNotBlank(strlist))
			sql = sql + " FIND_IN_SET(pos, '" + strlist + "')";
		else
			sql = sql + " RAND() LIMIT " + num;
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { Integer.valueOf(entryids[0]) });
		li = DB.query(sql, StringUtils.isNotBlank(strlist) ? true : false);
		return li;
	}

	// 歌手详情
	public static Map<String, Object> getEntityArtist(int entryid) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM entity_artist WHERE id=$cid";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { Integer.valueOf(entryid) });
		li = DB.query(sql, true);
		if (li.size() > 0) {
			map = li.get(0);
		}
		return map;
	}

	// 歌手点歌查询歌曲条目数
	public static int getSongsCountByArtist(String entryEle) {
		int row = 0;
		String sql = "SELECT COUNT(0) FROM entity_song WHERE";
		if (StringUtils.isNotBlank(entryEle)) {
			sql = sql + " artist Like '%" + entryEle + "%' AND";
		}
		sql = sql + " csort<>0";
		row = DB.queryCount(sql, true);
		return row;
	}

	// 歌手点歌查询歌曲信息
	public static List<Map<String, Object>> getSongsByArtist(Page page,
			String entryEle) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM entity_song WHERE";
		if (StringUtils.isNotBlank(entryEle)) {
			sql = sql + " artist Like '%" + entryEle + "%' AND";
		}
		sql = sql + " csort<>0 ORDER BY csort DESC, id DESC LIMIT "
				+ page.getStartRow() + "," + page.getPageSize();
		li = DB.query(sql, true);
		return li;
	}

	// 自由式专辑详情
	public static Map<String, Object> getEntityAlbum(String keyword) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM entity_album WHERE keyword='" + keyword
				+ "'";
		li = DB.query(sql, true);
		if (li.size() > 0) {
			map = li.get(0);
		}
		return map;
	}

	// 自由式专辑页面元素
	public static List<Map<String, Object>> getAlbumEles(int entryid) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM ui_album_freestyle WHERE pid=$pid ORDER BY pos";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { Integer.valueOf(entryid) });
		li = DB.query(sql, false);
		return li;
	}

	// 按照曲目id排序查询歌曲
	public static List<Map<String, Object>> getSongByIds(String idsArr) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String idsArrTmp = "'" + idsArr.replaceAll(",", "','") + "'";
		String sql = "SELECT * FROM entity_song WHERE id IN (" + idsArrTmp
				+ ") ORDER BY FIND_IN_SET(id,'" + idsArr + "')";
		li = DB.query(sql, false);
		return li;
	}

	// 歌曲缩写查询歌曲条目数
	public static int getFreeSongsCount() {
		int row = 0;
		String sql = "SELECT COUNT(0) FROM entity_song WHERE cfree=0 AND csort<>0";
		row = DB.queryCount(sql, true);
		return row;
	}

	// 歌曲缩写查询歌曲信息
	public static List<Map<String, Object>> getFreeSongs(Page page) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM entity_song WHERE cfree=0 AND";
		sql = sql + " csort<>0 ORDER BY csort DESC, id DESC LIMIT "
				+ page.getStartRow() + "," + page.getPageSize();
		li = DB.query(sql, true);
		return li;
	}

	// STB配置
	public static Map<String, Object> getStbConfig(String entryEle) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM config_stb WHERE stbType=$stbType";
		sql = DB.sqlWrapperByParams(sql, new Object[] { entryEle });
		li = DB.query(sql, true);
		if (li.size() > 0) {
			map = li.get(0);
		}
		return map;
	}

	// APP配置
	public static List<Map<String, Object>> getAppConfig(String entryEle) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM config_app WHERE zone=$zone";
		sql = DB.sqlWrapperByParams(sql, new Object[] { entryEle });
		li = DB.query(sql, false);
		return li;
	}

	// 专题列表条目数
	public static int getAlbumListCount() {
		int row = 0;
		String sql = "SELECT COUNT(0) FROM entity_album WHERE csort<>0";
		row = DB.queryCount(sql, true);
		return row;
	}

	// 专题列表信息
	public static List<Map<String, Object>> getAlbumList(Page page) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM entity_album WHERE";
		sql = sql + " csort<>0 ORDER BY csort DESC, id DESC LIMIT "
				+ page.getStartRow() + "," + page.getPageSize();
		li = DB.query(sql, true);
		return li;
	}

	// 获取一首单曲信息
	public static Map<String, Object> getSingleSong(String entryEle) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM entity_song WHERE id=$entryid AND csort<>0";
		sql = DB.sqlWrapperByParams(sql, new Object[] { entryEle });
		li = DB.query(sql, true);
		if (li.size() > 0) {
			map = li.get(0);
		}
		return map;
	}

	// 插入|置顶已选歌曲队列
	public static int addToChecked(String uid, String entryEle, int hour) {
		int row = 0;
		String sql = "SELECT IFNULL(MAX(csort), 0) FROM user_list WHERE uid=$uid AND createtime>=(NOW() - INTERVAL "
				+ hour + " HOUR)";
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid });
		int max = DB.queryCount(sql, false);
		String sql2 = "SELECT COUNT(0) FROM user_list WHERE uid=$uid AND createtime>=(NOW() - INTERVAL "
				+ hour + " HOUR) AND id_song=$entryid";
		sql2 = DB.sqlWrapperByParams(sql2, new Object[] { uid, entryEle });
		int rowC = DB.queryCount(sql2, false);
		if (rowC > 0) {
			String sql3 = "UPDATE user_list SET createtime=NOW(), csort="
					+ (max + 1)
					+ " WHERE uid=$uid AND id_song=$entryid AND createtime>=(NOW() - INTERVAL "
					+ hour + " HOUR) ORDER BY createtime DESC LIMIT 1";
			sql3 = DB.sqlWrapperByParams(sql3, new Object[] { uid, entryEle });
			int rt = DB.update(sql3);
			if (rt > 0)
				row = 1;
		} else {
			String sql4 = "INSERT INTO user_list(uid, id_song, csort, createtime) VALUES($uid, $entryid, "
					+ (max + 1) + ", NOW())";
			sql4 = DB.sqlWrapperByParams(sql4, new Object[] { uid, entryEle });
			int rt = DB.update(sql4);
			if (rt > 0)
				row = 2;
		}
		return row;
	}

	// 删除已选曲目
	public static int delToChecked(String uid, String entryEle, int hour) {
		int row = 0;
		String sql = "UPDATE user_list SET createtime=NOW(), csort=0 WHERE uid=$uid";
		if (StringUtils.isNotBlank(entryEle))
			sql += " AND id_song=$entryid";
		sql += " AND createtime>=(NOW() - INTERVAL " + hour + " HOUR)";
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid, entryEle });
		row = DB.update(sql);
		return row;
	}

	// 获取字符串型的已选歌曲ID(hour小时内点歌上限max首)
	public static String getCheckedStr(String uid, int hour, int max) {
		String str = "";
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT ES.id FROM user_list UL, entity_song ES WHERE";
		sql += " UL.uid=$uid AND UL.id_song=ES.id AND UL.csort<>0 AND ES.csort<>0";
		sql += " AND UL.createtime>=(NOW() - INTERVAL " + hour
				+ " HOUR) ORDER BY UL.csort DESC LIMIT " + max;
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid });
		li = DB.query(sql, false);
		if (li.size() > 0) {
			for (int i = 0; i < li.size(); i++) {
				if (i == li.size() - 1)
					str += li.get(i).get("id");
				else
					str += li.get(i).get("id") + ",";
			}
		}
		return str;
	}

	// 删除全部收藏歌曲|歌手
	public static int delToCollect(String uid, int ctype) {
		int row = 0;
		String sql = "UPDATE user_collect SET createtime=NOW(), csort=0 WHERE uid=$uid AND item_type=$ctype";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { uid, Integer.valueOf(ctype) });
		int rt = DB.update(sql);
		if (rt > 0)
			row = 1;
		return row;
	}

	// 插入|删除收藏歌曲|歌手队列
	public static int addToCollect(String uid, String entryEle, int ctype) {
		int row = 0;
		String sql = "SELECT IFNULL(MAX(csort), 0) FROM user_collect WHERE uid=$uid AND item_type=$ctype";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { uid, Integer.valueOf(ctype) });
		int max = DB.queryCount(sql, false);
		String sql2 = "SELECT COUNT(0) FROM user_collect WHERE uid=$uid AND item_type=$ctype AND id_item=$entryid";
		sql2 = DB.sqlWrapperByParams(sql2,
				new Object[] { uid, Integer.valueOf(ctype), entryEle });
		int rowC = DB.queryCount(sql2, false);
		if (rowC > 0) {
			String sqlTp = "SELECT csort FROM user_collect WHERE uid=$uid AND item_type=$ctype AND id_item=$entryid";
			sqlTp = DB.sqlWrapperByParams(sqlTp,
					new Object[] { uid, Integer.valueOf(ctype), entryEle });
			int csort = DB.queryCount(sqlTp, false);
			if (csort > 0) {
				String sql3a = "UPDATE user_collect SET createtime=NOW(), csort=0 WHERE uid=$uid AND item_type=$ctype AND id_item=$entryid";
				sql3a = DB.sqlWrapperByParams(sql3a, new Object[] { uid,
						Integer.valueOf(ctype), entryEle });
				int rt = Integer.valueOf(DB.update(sql3a));
				if (rt > 0)
					row = 1;
			} else {
				String sql3b = "UPDATE user_collect SET createtime=NOW(), csort="
						+ (max + 1)
						+ " WHERE uid=$uid AND item_type=$ctype AND id_item=$entryid";
				sql3b = DB.sqlWrapperByParams(sql3b, new Object[] { uid,
						Integer.valueOf(ctype), entryEle });
				int rt = Integer.valueOf(DB.update(sql3b));
				if (rt > 0)
					row = 2;
			}
		} else {
			String sql4 = "INSERT INTO user_collect(uid, item_type, id_item, csort, createtime) VALUES($uid, $ctype, $entryid, "
					+ (max + 1) + ", NOW())";
			sql4 = DB.sqlWrapperByParams(sql4,
					new Object[] { uid, Integer.valueOf(ctype), entryEle });
			int rt = Integer.valueOf(DB.update(sql4));
			if (rt > 0)
				row = 2;
		}
		return row;
	}

	// 获取字符串型的收藏歌曲|歌手ID(收藏上限150)
	public static String getCollectStr(String uid, int ctype) {
		String str = "";
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "";
		if (ctype == 0) {
			sql = "SELECT EA.id FROM user_collect UC, entity_artist EA WHERE UC.item_type=$ctype AND";
			sql += " UC.uid=$uid AND UC.id_item=EA.id AND UC.csort<>0 AND EA.csort<>0";
			sql += " ORDER BY UC.csort DESC LIMIT 150";
		} else if (ctype == 1) {
			sql = "SELECT ES.id FROM user_collect UC, entity_song ES WHERE UC.item_type=$ctype AND";
			sql += " UC.uid=$uid AND UC.id_item=ES.id AND UC.csort<>0 AND ES.csort<>0";
			sql += " ORDER BY UC.csort DESC LIMIT 150";
		}
		sql = DB.sqlWrapperByParams(sql, new Object[] { Integer.valueOf(ctype),
				uid });
		li = DB.query(sql, false);
		if (li.size() > 0) {
			for (int i = 0; i < li.size(); i++) {
				if (i == li.size() - 1)
					str += li.get(i).get("id");
				else
					str += li.get(i).get("id") + ",";
			}
		}
		return str;
	}

	// 判断用户是否收藏歌手|歌曲
	public static boolean checkCollect(String uid, String entryEle, int ctype) {
		boolean flg = false;
		String sql = "SELECT COUNT(0) FROM user_collect WHERE uid=$uid AND item_type=$ctype AND id_item=$entryid AND csort<>0";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { uid, Integer.valueOf(ctype), entryEle });
		int row = DB.queryCount(sql, false);
		if (row > 0)
			flg = true;
		return flg;
	}

	// 获取收藏歌曲|歌手总数
	public static int getCollectCount(String entryEle, int ctype) {
		String sql = "SELECT COUNT(0) FROM user_collect WHERE item_type=$ctype AND id_item=$entryid AND csort<>0";
		sql = DB.sqlWrapperByParams(sql, new Object[] { Integer.valueOf(ctype),
				entryEle });
		int row = DB.queryCount(sql, false);
		return row;
	}

	// 查询全部歌手信息
	public static List<Map<String, Object>> getAllArtists() {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM entity_artist WHERE csort<>0 ORDER BY csort DESC, id DESC";
		li = DB.query(sql, true);
		return li;
	}

	// 查询全部专题信息
	public static List<Map<String, Object>> getAllAlbum() {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM entity_album WHERE csort<>0 ORDER BY csort DESC, id DESC";
		li = DB.query(sql, true);
		return li;
	}

	// 歌手点歌查询全部歌曲信息
	public static List<Map<String, Object>> getAllSongsByArtist(String entryEle) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM entity_song WHERE";
		if (StringUtils.isNotBlank(entryEle)) {
			sql = sql + " artist Like '%" + entryEle + "%' AND";
		}
		sql = sql + " csort<>0 ORDER BY csort DESC, id DESC";
		li = DB.query(sql, true);
		return li;
	}

	// 歌曲列表详情
	public static Map<String, Object> getEntityAlbumlist(int entryid) {
		Map<String, Object> map = new HashMap<String, Object>();
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM entity_albumlist WHERE id=$cid";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { Integer.valueOf(entryid) });
		li = DB.query(sql, true);
		if (li.size() > 0) {
			map = li.get(0);
		}
		return map;
	}

	// 用户全部有效已点歌曲
	public static List<Map<String, Object>> getAllUserChecked(String uid,
			int hour, int max) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT ES.* FROM user_list UL, entity_song ES WHERE";
		sql += " UL.uid=$uid AND UL.id_song=ES.id AND UL.csort<>0 AND ES.csort<>0";
		sql += " AND UL.createtime>=(NOW() - INTERVAL " + hour
				+ " HOUR) ORDER BY UL.csort DESC LIMIT " + max;
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid });
		li = DB.query(sql, false);
		return li;
	}

	// 通过关键字模糊搜索所有歌曲
	public static List<Map<String, Object>> getSongsByKeyWords(String entryEle) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM ((SELECT * FROM entity_song WHERE cname LIKE '%"
				+ entryEle
				+ "%') UNION (SELECT * FROM entity_song WHERE artist LIKE '%"
				+ entryEle + "%')) A WHERE A.csort<>0 ORDER BY A.id ASC";
		li = DB.query(sql, true);
		return li;
	}

	// 用户有效已点歌曲总数
	public static int getSongsCountByChecked(String uid, int hour, int max) {
		int row = 0;
		String sql = "SELECT COUNT(0) FROM user_list UL, entity_song ES WHERE";
		sql += " UL.uid=$uid AND UL.id_song=ES.id AND UL.csort<>0 AND ES.csort<>0";
		sql += " AND UL.createtime>=(NOW() - INTERVAL " + hour
				+ " HOUR) ORDER BY UL.csort DESC";
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid });
		row = DB.queryCount(sql, false);
		if (row > max)
			row = max;
		return row;
	}

	// 用户有效已点歌曲
	public static List<Map<String, Object>> getSongsByChecked(Page page,
			String uid, int hour, int max) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT ES.id,ES.cname,ES.artist,ES.artist_pic,ES.cfree,ES.duration FROM user_list UL, entity_song ES WHERE";
		sql += " UL.uid=$uid AND UL.id_song=ES.id AND UL.csort<>0 AND ES.csort<>0";
		sql += " AND UL.createtime>=(NOW() - INTERVAL " + hour
				+ " HOUR) ORDER BY UL.csort DESC LIMIT " + page.getStartRow()
				+ "," + page.getPageSize();
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid });
		li = DB.query(sql, false);
		return li;
	}

	// 收藏歌曲|歌手条目数 收藏读取最后150条目
	public static int getSongsCountByCollect(String uid) {
		int row = 0;
		String sql = "SELECT COUNT(0) FROM user_collect UC, entity_song ES WHERE UC.uid=$uid AND UC.id_item=ES.id AND UC.item_type=1 AND UC.csort<>0 AND ES.csort<>0";
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid });
		row = DB.queryCount(sql, false);
		if (row > 150)
			row = 150;
		return row;
	}

	// 收藏歌曲 收藏读取最后150条目
	public static List<Map<String, Object>> getSongsByCollect(Page page,
			String uid) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM user_collect UC, entity_song ES WHERE UC.uid=$uid AND UC.id_item=ES.id AND UC.item_type=1 AND UC.csort<>0 AND ES.csort<>0";
		sql += " ORDER BY UC.csort DESC LIMIT " + page.getStartRow() + ","
				+ page.getPageSize();
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid });
		li = DB.query(sql, false);
		return li;
	}

	// 收藏歌手条目数
	public static int getSingersCountByCollect(String uid) {
		int row = 0;
		String sql = "SELECT COUNT(0) FROM user_collect UC, entity_artist EA WHERE UC.uid=$uid AND UC.id_item=EA.id AND UC.item_type=0 AND UC.csort<>0 AND EA.csort<>0";
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid });
		row = DB.queryCount(sql, false);
		if (row > 150) {
			row = 150;
		}
		return row;
	}

	// 收藏歌手
	public static List<Map<String, Object>> getSingersByCollect(Page page,
			String uid) {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM user_collect UC, entity_artist EA WHERE UC.uid=$uid AND UC.id_item=EA.id AND UC.item_type=0 AND UC.csort<>0 AND EA.csort<>0";
		sql += " ORDER BY UC.csort DESC LIMIT " + page.getStartRow() + ","
				+ page.getPageSize();
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid });
		li = DB.query(sql, false);
		return li;
	}

	// 全部歌手的歌曲插入到已选歌曲队列
	public static int checkAllSongByArtist(String uid, String entryEle, int hour) {
		int row = 0;
		String sql = "UPDATE user_list SET csort=0 WHERE uid=$uid AND createtime>=(NOW() - INTERVAL "
				+ hour
				+ " HOUR) AND id_song IN (SELECT id AS id_song FROM entity_song WHERE artist Like '%"
				+ entryEle + "%' AND csort<>0 ORDER BY csort DESC, id DESC)";
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid });
		DB.update(sql);
		String sql2 = "SELECT IFNULL(MAX(csort), 0) FROM user_list WHERE uid=$uid AND createtime>=(NOW() - INTERVAL "
				+ hour + " HOUR)";
		sql2 = DB.sqlWrapperByParams(sql2, new Object[] { uid });
		int max = DB.queryCount(sql2, false);
		String sql3 = "INSERT INTO user_list(uid, id_song, csort, createtime) "
				+ "(SELECT $uid AS uid, B.id AS id_song, (@j:=@j+1) AS csort, NOW() AS createtime FROM "
				+ "(SELECT (@i:=@i+1) seqNo, id, cname, artist FROM entity_song, (select @i:=0) A WHERE "
				+ "artist Like '%"
				+ entryEle
				+ "%' AND csort<>0 ORDER BY csort DESC, id DESC) B, (select @j:="
				+ max + ") C ORDER BY B.seqNo DESC)";
		sql3 = DB.sqlWrapperByParams(sql3, new Object[] { uid });
		row = DB.update(sql3);
		return row;
	}

	// 列表专题歌曲插入到已选歌曲队列
	public static int checkAllSongByList(String uid, int ctype, int hour) {
		int row = 0;
		String sql = "UPDATE user_list SET csort=0 WHERE uid=$uid AND createtime>=(NOW() - INTERVAL "
				+ hour
				+ " HOUR) AND id_song IN (SELECT ES.id AS id_song FROM recommend_song RS, entity_song ES "
				+ "WHERE RS.id_song=ES.id AND RS.item_type=$ctype AND RS.csort<>0 AND ES.csort<>0 ORDER BY RS.csort DESC)";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { uid, Integer.valueOf(ctype) });
		DB.update(sql);
		String sql2 = "SELECT IFNULL(MAX(csort), 0) FROM user_list WHERE uid=$uid AND createtime>=(NOW() - INTERVAL "
				+ hour + " HOUR)";
		sql2 = DB.sqlWrapperByParams(sql2, new Object[] { uid });
		int max = DB.queryCount(sql2, false);
		String sql3 = "INSERT INTO user_list(uid, id_song, csort, createtime) "
				+ "(SELECT $uid AS uid, C.id_song, (@j:=@j+1) AS csort, NOW() AS createtime FROM "
				+ "(SELECT B.id_song, (@i:=@i+1) seqNo FROM "
				+ "(SELECT ES.id AS id_song FROM recommend_song RS, entity_song ES WHERE "
				+ "RS.id_song=ES.id AND RS.item_type=$ctype AND RS.csort<>0 AND ES.csort<>0 ORDER BY RS.csort DESC) B, (select @i:=0) A) C, (select @j:="
				+ max + ") D ORDER BY C.seqNo DESC)";
		sql3 = DB.sqlWrapperByParams(sql3,
				new Object[] { uid, Integer.valueOf(ctype) });
		row = DB.update(sql3);
		return row;
	}

	// 收藏的歌曲插入到已选歌曲队列
	public static int checkAllSongByCollect(String uid, int hour) {
		int row = 0;
		String sql = "UPDATE user_list SET csort=0 WHERE uid=$uid AND createtime>=(NOW() - INTERVAL "
				+ hour
				+ " HOUR) AND id_song IN (SELECT ES.id AS id_song FROM user_collect UC, entity_song ES "
				+ "WHERE UC.item_type=1 AND UC.uid=$uid AND UC.id_item=ES.id AND UC.csort<>0 AND ES.csort<>0 ORDER BY UC.csort DESC)";
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid, uid });
		DB.update(sql);
		String sql2 = "SELECT IFNULL(MAX(csort), 0) FROM user_list WHERE uid=$uid AND createtime>=(NOW() - INTERVAL "
				+ hour + " HOUR)";
		sql2 = DB.sqlWrapperByParams(sql2, new Object[] { uid });
		int max = DB.queryCount(sql2, false);
		String sql3 = "INSERT INTO user_list(uid, id_song, csort, createtime) "
				+ "(SELECT $uid AS uid, C.id_song, (@j:=@j+1) AS csort, NOW() AS createtime FROM "
				+ "(SELECT B.id_song, (@i:=@i+1) seqNo FROM "
				+ "(SELECT ES.id AS id_song FROM user_collect UC, entity_song ES WHERE "
				+ "UC.item_type=1 AND UC.uid=$uid AND UC.id_item=ES.id AND UC.csort<>0 AND ES.csort<>0 ORDER BY UC.csort DESC LIMIT 150) B, (select @i:=0) A) C, (select @j:="
				+ max + ") D ORDER BY C.seqNo DESC)";
		sql3 = DB.sqlWrapperByParams(sql3, new Object[] { uid, uid });
		row = DB.update(sql3);
		return row;
	}

	// 皮肤
	public static List<Map<String, Object>> getSkins() {
		List<Map<String, Object>> li = new ArrayList<Map<String, Object>>();
		String sql = "SELECT * FROM entity_theme ORDER BY ctype ASC, csort DESC";
		li = DB.query(sql, true);
		return li;
	}

	// 插入点播数据
	public static int addUserPlay(String ip, String uid, String cityN,
			String entryEle, int durlen, String playId, String detail,
			String other) {
		Integer totalRows = 0;
		String sql = "INSERT INTO user_logs_play(ip, uid, cityN, id_song, curlen, durlen, playid, detail, other, cflag, curtime, createtime) VALUE($ip, $uid, $cityN, $entryEle, 10, $durlen, $playId, $detail, $other, 0, DATE_ADD(NOW(), INTERVAL 10 SECOND), NOW())";
		sql = DB.sqlWrapperByParams(sql, new Object[] { ip, uid, cityN,
				entryEle, Integer.valueOf(durlen), playId, detail, other });
		totalRows = DB.update(sql);
		return totalRows;
	}

	// 结束||心跳修改点播数据
	public static int modUserPlay(String uid, int curlen, String playId,
			int ctype) {
		int totalRows = 0;
		String sql = "UPDATE user_logs_play SET curlen=" + curlen
				+ ", cflag=0, curtime=NOW() WHERE uid=$uid AND playid=$playId";
		if (ctype == 1)
			sql = "UPDATE user_logs_play SET curlen="
					+ curlen
					+ ", cflag=1, curtime=NOW() WHERE uid=$uid AND playid=$playId";
		else if (ctype == 2)
			sql = "UPDATE user_logs_play SET curlen=UNIX_TIMESTAMP(curtime)-UNIX_TIMESTAMP(createtime), cflag=1, curtime=NOW() WHERE uid=$uid AND playid=$playId";
		sql = DB.sqlWrapperByParams(sql, new Object[] { uid, playId });
		totalRows = DB.update(sql);
		return totalRows;
	}

	// 插入访问页面数据
	public static int addUserView(String ip, String uid, String cityN,
			int entryId, String cname, String viewId, String other) {
		Integer totalRows = 0;
		String sql = "INSERT INTO user_logs_view(ip, uid, cityN, id_page, cname, staylen, viewid, fun_idx, to_id_page, to_cname, other, cflag, curtime, createtime)"
				+ " VALUE($ip, $uid, $cityN, $entryId, $cname, 0, $viewId, 0, 0, '', $other, 0, DATE_ADD(NOW(), INTERVAL 5 SECOND), NOW())";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { ip, uid, cityN, Integer.valueOf(entryId), cname,
						viewId, other });
		totalRows = DB.update(sql);
		return totalRows;
	}

	// 结束修改访问页面数据
	public static int modUserView(String uid, String viewId, int funIdx,
			int entryId, String cname) {
		int totalRows = 0;
		String sql = "UPDATE user_logs_view SET staylen=UNIX_TIMESTAMP(NOW())-UNIX_TIMESTAMP(createtime), fun_idx=$funIdx, to_id_page=$entryId, to_cname=$cname"
				+ " , cflag=1, curtime=NOW() WHERE uid=$uid AND viewid=$viewId";
		sql = DB.sqlWrapperByParams(sql, new Object[] {
				Integer.valueOf(funIdx), Integer.valueOf(entryId), cname, uid,
				viewId });
		totalRows = DB.update(sql);
		return totalRows;
	}

	// 插入入口访问
	public static int addUserFlow(String ip, String uid, String cityN,
			int entryId, String keyword, String cname, String other) {
		Integer totalRows = 0;
		String sql = "INSERT INTO user_logs_flow(ip, uid, cityN, to_id_page, to_key, to_cname, other, createtime) VALUE($ip, $uid, $cityN, $entryId, $keyword, $cname, $other, NOW())";
		sql = DB.sqlWrapperByParams(sql,
				new Object[] { ip, uid, cityN, Integer.valueOf(entryId),
						keyword, cname, other });
		totalRows = DB.update(sql);
		return totalRows;
	}
}