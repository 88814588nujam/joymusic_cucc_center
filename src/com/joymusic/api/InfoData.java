package com.joymusic.api;

import java.util.List;
import java.util.Map;

import com.joymusic.common.Page;

public class InfoData {
	public static Map<String, Object> getUiPageDetail(int entryid) {
		Map<String, Object> map = InfoDataCore.getUiPageDetail(entryid);
		return map;
	}

	public static List<Map<String, Object>> getUiIndexRecommend(int... entryids) {
		List<Map<String, Object>> li = InfoDataCore
				.getUiIndexRecommend(entryids);
		return li;
	}

	public static int getArtistsCountByRecommend(int ctype, boolean flag) {
		int row = InfoDataCore.getArtistsCountByRecommend(ctype, flag);
		return row;
	}

	public static List<Map<String, Object>> getArtistsByRecommend(Page page,
			int ctype, boolean flag) {
		List<Map<String, Object>> li = InfoDataCore.getArtistsByRecommend(page,
				ctype, flag);
		return li;
	}

	public static int getSongsCountByRecommend(int ctype, boolean flag) {
		int row = InfoDataCore.getSongsCountByRecommend(ctype, flag);
		return row;
	}

	public static List<Map<String, Object>> getSongsByRecommend(Page page,
			int ctype, boolean flag) {
		List<Map<String, Object>> li = InfoDataCore.getSongsByRecommend(page,
				ctype, flag);
		return li;
	}

	public static Map<String, Object> getUserInfo(String uid, int platform) {
		Map<String, Object> map = InfoDataCore.getUserInfo(uid, platform);
		return map;
	}

	public static int addUserInfo(String ip, String uid, String preferTheme,
			String preferPlayer, int preferArtist, int preferKeyboard,
			int preferBubble, int preferGuide, int hour, int max,
			String provinceN, String provinceC, String cityN, String cityC,
			String stbType, String stbVersion, int platform) {
		int row = InfoDataCore.addUserInfo(ip, uid, preferTheme, preferPlayer,
				preferArtist, preferKeyboard, preferBubble, preferGuide, hour,
				max, provinceN, provinceC, cityN, cityC, stbType, stbVersion,
				platform);
		return row;
	}

	public static int updateUserInfo(String uid, String key, String val) {
		int totalRows = InfoDataCore.updateUserInfo(uid, key, val);
		return totalRows;
	}

	public static int getSongsCountBySpell(String words) {
		int row = InfoDataCore.getSongsCountBySpell(words);
		return row;
	}

	public static List<Map<String, Object>> getSongsBySpell(Page page,
			String words) {
		List<Map<String, Object>> li = InfoDataCore
				.getSongsBySpell(page, words);
		return li;
	}

	public static int getArtistsCount(String words) {
		int row = InfoDataCore.getArtistsCount(words);
		return row;
	}

	public static List<Map<String, Object>> getArtists(Page page, String words) {
		List<Map<String, Object>> li = InfoDataCore.getArtists(page, words);
		return li;
	}

	public static List<Map<String, Object>> getUiSearchRecommend(
			String strlist, int num, int... entryids) {
		List<Map<String, Object>> li = InfoDataCore.getUiSearchRecommend(
				strlist, num, entryids);
		return li;
	}

	public static Map<String, Object> getEntityArtist(int entryid) {
		Map<String, Object> map = InfoDataCore.getEntityArtist(entryid);
		return map;
	}

	public static int getSongsCountByArtist(String entryEle) {
		int row = InfoDataCore.getSongsCountByArtist(entryEle);
		return row;
	}

	public static List<Map<String, Object>> getSongsByArtist(Page page,
			String entryEle) {
		List<Map<String, Object>> li = InfoDataCore.getSongsByArtist(page,
				entryEle);
		return li;
	}

	public static Map<String, Object> getEntityAlbum(String keyword) {
		Map<String, Object> map = InfoDataCore.getEntityAlbum(keyword);
		return map;
	}

	public static List<Map<String, Object>> getAlbumEles(int entryid) {
		List<Map<String, Object>> li = InfoDataCore.getAlbumEles(entryid);
		return li;
	}

	public static List<Map<String, Object>> getSongByIds(String idsArr) {
		List<Map<String, Object>> li = InfoDataCore.getSongByIds(idsArr);
		return li;
	}

	public static int getFreeSongsCount() {
		int row = InfoDataCore.getFreeSongsCount();
		return row;
	}

	public static List<Map<String, Object>> getFreeSongs(Page page) {
		List<Map<String, Object>> li = InfoDataCore.getFreeSongs(page);
		return li;
	}

	public static Map<String, Object> getStbConfig(String entryEle) {
		Map<String, Object> map = InfoDataCore.getStbConfig(entryEle);
		return map;
	}

	public static List<Map<String, Object>> getAppConfig(String entryEle) {
		List<Map<String, Object>> li = InfoDataCore.getAppConfig(entryEle);
		return li;
	}

	public static int getAlbumListCount() {
		int row = InfoDataCore.getAlbumListCount();
		return row;
	}

	public static List<Map<String, Object>> getAlbumList(Page page) {
		List<Map<String, Object>> li = InfoDataCore.getAlbumList(page);
		return li;
	}

	public static Map<String, Object> getSingleSong(String entryEle) {
		Map<String, Object> map = InfoDataCore.getSingleSong(entryEle);
		return map;
	}

	public static int addToChecked(String uid, String entryEle, int hour) {
		int row = InfoDataCore.addToChecked(uid, entryEle, hour);
		return row;
	}

	public static int delToChecked(String uid, String entryEle, int hour) {
		int row = InfoDataCore.delToChecked(uid, entryEle, hour);
		return row;
	}

	public static String getCheckedStr(String uid, int hour, int max) {
		String str = InfoDataCore.getCheckedStr(uid, hour, max);
		return str;
	}

	public static int delToCollect(String uid, int ctype) {
		int row = InfoDataCore.delToCollect(uid, ctype);
		return row;
	}

	public static int addToCollect(String uid, String entryEle, int ctype) {
		int row = InfoDataCore.addToCollect(uid, entryEle, ctype);
		return row;
	}

	public static String getCollectStr(String uid, int ctype) {
		String str = InfoDataCore.getCollectStr(uid, ctype);
		return str;
	}

	public static boolean checkCollect(String uid, String entryEle, int ctype) {
		boolean flg = InfoDataCore.checkCollect(uid, entryEle, ctype);
		return flg;
	}

	public static int getCollectCount(String entryEle, int ctype) {
		int row = InfoDataCore.getCollectCount(entryEle, ctype);
		return row;
	}

	public static List<Map<String, Object>> getAllArtists() {
		List<Map<String, Object>> li = InfoDataCore.getAllArtists();
		return li;
	}

	public static List<Map<String, Object>> getAllAlbum() {
		List<Map<String, Object>> li = InfoDataCore.getAllAlbum();
		return li;
	}

	public static List<Map<String, Object>> getAllSongsByArtist(String entryEle) {
		List<Map<String, Object>> li = InfoDataCore
				.getAllSongsByArtist(entryEle);
		return li;
	}

	public static Map<String, Object> getEntityAlbumlist(int entryid) {
		Map<String, Object> map = InfoDataCore.getEntityAlbumlist(entryid);
		return map;
	}

	public static List<Map<String, Object>> getAllUserChecked(String uid,
			int hour, int max) {
		List<Map<String, Object>> li = InfoDataCore.getAllUserChecked(uid,
				hour, max);
		return li;
	}

	public static List<Map<String, Object>> getSongsByKeyWords(String entryEle) {
		List<Map<String, Object>> li = InfoDataCore
				.getSongsByKeyWords(entryEle);
		return li;
	}

	public static int getSongsCountByChecked(String uid, int hour, int max) {
		int row = InfoDataCore.getSongsCountByChecked(uid, hour, max);
		return row;
	}

	public static List<Map<String, Object>> getSongsByChecked(Page page,
			String uid, int hour, int max) {
		List<Map<String, Object>> li = InfoDataCore.getSongsByChecked(page,
				uid, hour, max);
		return li;
	}

	public static int getSongsCountByCollect(String uid) {
		int row = InfoDataCore.getSongsCountByCollect(uid);
		return row;
	}

	public static List<Map<String, Object>> getSongsByCollect(Page page,
			String uid) {
		List<Map<String, Object>> li = InfoDataCore
				.getSongsByCollect(page, uid);
		return li;
	}

	public static int getSingersCountByCollect(String uid) {
		int row = InfoDataCore.getSingersCountByCollect(uid);
		return row;
	}

	public static List<Map<String, Object>> getSingersByCollect(Page page,
			String uid) {
		List<Map<String, Object>> li = InfoDataCore.getSingersByCollect(page,
				uid);
		return li;
	}

	public static int checkAllSongByArtist(String uid, String entryEle, int hour) {
		int row = InfoDataCore.checkAllSongByArtist(uid, entryEle, hour);
		return row;
	}

	public static int checkAllSongByList(String uid, int ctype, int hour) {
		int row = InfoDataCore.checkAllSongByList(uid, ctype, hour);
		return row;
	}

	public static int checkAllSongByCollect(String uid, int hour) {
		int row = InfoDataCore.checkAllSongByCollect(uid, hour);
		return row;
	}

	public static List<Map<String, Object>> getSkins() {
		List<Map<String, Object>> li = InfoDataCore.getSkins();
		return li;
	}

	public static int addUserPlay(String ip, String uid, String cityN,
			String entryEle, int durlen, String playId, String detail,
			String other) {
		int row = InfoDataCore.addUserPlay(ip, uid, cityN, entryEle, durlen,
				playId, detail, other);
		return row;
	}

	public static int modUserPlay(String uid, int curlen, String playId,
			int ctype) {
		int row = InfoDataCore.modUserPlay(uid, curlen, playId, ctype);
		return row;
	}

	public static int addUserView(String ip, String uid, String cityN,
			int entryId, String cname, String viewId, String other) {
		int row = InfoDataCore.addUserView(ip, uid, cityN, entryId, cname,
				viewId, other);
		return row;
	}

	public static int modUserView(String uid, String viewId, int funIdx,
			int entryId, String cname) {
		int row = InfoDataCore.modUserView(uid, viewId, funIdx, entryId, cname);
		return row;
	}

	public static int addUserFlow(String ip, String uid, String cityN,
			int entryId, String keyword, String cname, String other) {
		int row = InfoDataCore.addUserFlow(ip, uid, cityN, entryId, keyword,
				cname, other);
		return row;
	}
}