package com.spring.board.vo;

import java.util.List;

public class BoardByListVo {

	
	private List<BoardVo> boardlist;

	public List<BoardVo> getBoardlist() {
		return boardlist;
	}

	public void setBoardlist(List<BoardVo> boardlist) {
		this.boardlist = boardlist;
	}

	@Override
	public String toString() {
		return "BoardByListVo [boardlist=" + boardlist + "]";
	}
	
	
	
	
}
