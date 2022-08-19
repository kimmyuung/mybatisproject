package com.spring.board.vo;

public class PageVo {
	
	private int pageNo = 0;
	private String[] codeId;
	
	public int getPageNo() {
		return pageNo;
	}

	public void setPageNo(int pageNo) {
		this.pageNo = pageNo;
	}

	public String[] getCodeId() {
		return codeId;
	}

	public void setCodeId(String[] codeId) {
		this.codeId = codeId;
	}
	
}
