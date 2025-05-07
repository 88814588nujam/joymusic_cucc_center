package com.joymusic.common;

public class Page {

	public final static int DEFAULT_PAGE_SIZE = 10;

	public int pageIndex;//当前页页码

	public int pageSize;//每页记录数

	public int startRow;//起始条目

	public int endRow;//截至条目

	public int pageTotal;//总页数

	public int itemTotal;//总记录数

	public Page() {
	}

	public Page(int itemTotal, int pageSize) {
		this.itemTotal = itemTotal;
		this.pageSize = pageSize;
		repaginate();
	}

	/**
	 * 重新计算得到page对象所有分页信息
	 */
	private void repaginate() {
		if (pageSize < 1) {
			pageSize = DEFAULT_PAGE_SIZE;
		}
		if (pageIndex < 1) {
			pageIndex = 1;
		}
		startRow = (pageIndex - 1) * pageSize;
		endRow = pageIndex * pageSize;
		if (itemTotal > 0) {
			pageTotal = itemTotal / pageSize + (itemTotal % pageSize > 0 ? 1 : 0);
			if (pageIndex > pageTotal) {
				pageIndex = pageTotal;
			}
			if (endRow > itemTotal){
				endRow = itemTotal;
			}
			if (startRow == endRow){
				startRow = startRow - pageSize;	
			}
		}
	}

	public int getPageIndex() {
		return pageIndex;
	}

	public void setPageIndex(int pageIndex) {
		this.pageIndex = pageIndex;
		repaginate();
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(int pageSize) {
		this.pageSize = pageSize;
		repaginate();
	}

	public int getPageTotal() {
		return pageTotal;
	}

	public void setPageTotal(int pageTotal) {
		this.pageTotal = pageTotal;
	}

	public int getItemTotal() {
		return itemTotal;
	}

	public void setItemTotal(int itemTotal) {
		this.itemTotal = itemTotal;
		repaginate();
	}
	
	public int getStartRow() {
		return startRow;
	}
	
	public int getEndRow() {
		return endRow;
	}
	
	//下一页页码
	public int next() {
		return pageIndex == pageTotal ? pageTotal : (pageIndex + 1);
	}
	
	//上一页页码
	public int previous() {
		return pageIndex == 1 ? 1 : (pageIndex - 1);
	}
}