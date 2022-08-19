package com.spring.board.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.spring.board.HomeController;
import com.spring.board.service.boardService;
import com.spring.board.vo.BoardByListVo;
import com.spring.board.vo.BoardVo;
import com.spring.board.vo.ComCodeVo;
import com.spring.board.vo.PageVo;
import com.spring.common.CommonUtil;

@Controller
public class BoardController {
	
	@Autowired 
	boardService boardService;
	
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	// 이클립스에 로그를 남기기 위해 사용  log4j를 사용하면 로그내용을 파일로 알아서 작성
	
	@RequestMapping(value = "/board/boardList.do", method = RequestMethod.GET)
	public String boardList(HttpServletRequest request ,Locale locale, Model model
			,PageVo pageVo
			// Locale 지역의 언어, 국가 등의 정보를 가지고 있는 객체
			) throws Exception{
		
		 String[] codeId = request.getParameterValues("codeId"); 
		// codeId를 배열로 받아옴	
		if (codeId != null) { // codeId가 null이 아니라면
			for (int i=0; i<codeId.length; i++) {
				System.out.println("String[] codeId : "+codeId[i].toString());
			}
		}
		List<BoardVo> boardList = new ArrayList<BoardVo>();
		List<ComCodeVo> comCodeVos = new ArrayList<>();
		
		int page = 1;
		int totalCnt = 0;
		
		if(pageVo.getPageNo() == 0){
			pageVo.setPageNo(page);
		}
		pageVo.setCodeId(codeId);
		
		boardList = boardService.SelectBoardList(pageVo);
		
		comCodeVos = boardService.codeNameList();
		totalCnt = boardService.selectBoardCnt();
		
		model.addAttribute("boardList", boardList);
		model.addAttribute("totalCnt", totalCnt);
		model.addAttribute("pageNo", page);
		model.addAttribute("codeName", comCodeVos);
		
		return "board/boardList";
	}
	@RequestMapping(value = "/board/login.do", method = RequestMethod.GET)
	public String login() { return "board/login";}
	
	@RequestMapping(value = "/board/signup.do", method = RequestMethod.GET)
	public String signup() { return "board/signup";}
	
	@RequestMapping(value = "/board/getboardList.do", method = RequestMethod.GET)
	@ResponseBody
	public List<BoardVo> getboardlist(HttpServletRequest request ,Locale locale, Model model
			,PageVo pageVo) throws Exception{
		 String[] codeId = request.getParameterValues("codeId"); 
			// codeId를 배열로 받아옴	
			if (codeId != null) { // codeId가 null이 아니라면
				for (int i=0; i<codeId.length; i++) {
					System.out.println("String[] codeId : "+codeId[i].toString());
				}
			}
			List<BoardVo> boardList = new ArrayList<BoardVo>();
			List<ComCodeVo> comCodeVos = new ArrayList<>();
			
			int page = 1;
			int totalCnt = 0;
			
			if(pageVo.getPageNo() == 0){
				pageVo.setPageNo(page);
			}
			pageVo.setCodeId(codeId);
			
			boardList = boardService.SelectBoardList(pageVo);
			comCodeVos = boardService.codeNameList();
			totalCnt = boardService.selectBoardCnt();
			
			return boardList;
	}
	
	
	@RequestMapping(value = "/board/{boardType}/{boardNum}/boardView.do", method = RequestMethod.GET)
	public String boardView(Locale locale, Model model
			,@PathVariable("boardType")String boardType // 사용자가 입력한 값에 따라 달라짐(어떤 타입의 게시물을 클릭했는지 + 어떤 게시물 번호를 클릭했는지)
			,@PathVariable("boardNum")int boardNum) throws Exception{
		
		BoardVo boardVo = new BoardVo();
		boardVo = boardService.selectBoard(boardType,boardNum);
		
		model.addAttribute("boardType", boardType);
		model.addAttribute("boardNum", boardNum);
		model.addAttribute("board", boardVo);
		
		return "board/boardView";
	}
	
	@RequestMapping(value = "/board/boardWrite.do", method = RequestMethod.GET)
	public String boardWrite(Locale locale, Model model) throws Exception{
		List<ComCodeVo> comCodeVos = new ArrayList<>();
		comCodeVos = boardService.codeNameList();
		model.addAttribute("codeName", comCodeVos);
		return "board/boardWrite";
	}
	
	@RequestMapping(value = "/board/boardWriteAction.do", method = RequestMethod.POST)
	@ResponseBody // boardVo를 이용하여 데이터 insert
	public String boardWriteAction(HttpServletRequest request,Locale locale,BoardVo boardVo) throws Exception{
		
		HashMap<String, String> result = new HashMap<String, String>();
		
		CommonUtil commonUtil = new CommonUtil();
		
		String[] boardType = request.getParameterValues("boardType");
		String[] boardTitle = request.getParameterValues("boardTitle");
		String[] boardComment = request.getParameterValues("boardComment");
		
		int resultCnt = 0;
		if (boardType != null) { // boardType가 null이 아니라면
			// 리스트를 이용하여 구현해볼
			for (int i=0; i<boardType.length; i++) {
				System.out.println("String[] boardType : "+boardType[i].toString());
				System.out.println("String[] boardTitle : "+boardTitle[i].toString());
				System.out.println("String[] boardComment : "+boardComment[i].toString());	
				System.out.println("insert into ~" + boardVo.toString());
				boardVo.setBoardTitle(boardTitle[i]);
				boardVo.setBoardComment(boardType[i]);
				boardVo.setBoardType(boardType[i]);
				resultCnt = boardService.boardInsert(boardVo);
			}
		}	
		result.put("success", (resultCnt > 0)?"Y":"N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
		
		System.out.println("callbackMsg::"+callbackMsg);
		
		return callbackMsg;
	}
	//List 이용하여 데이터 insert
	@RequestMapping(value = "/board/boardWriteActionBylist.do", method = RequestMethod.POST)
	@ResponseBody
	public String boardWriteActionBylist(HttpServletRequest request,Locale locale, 
			@ModelAttribute BoardByListVo myboard) throws Exception{
		request.setCharacterEncoding("UTF-8");
		
		HashMap<String, String> result = new HashMap<String, String>(); // 처리 결과가 담기는 맵
		CommonUtil commonUtil = new CommonUtil(); 
		int resultCnt = 0;
		
// 1. request.getParameterValues를 이용한 방법	
// List<BoardVo> list = new ArrayList<>(); // 실제 데이터가 담긴 리스트
//		String[] boardType = request.getParameterValues("boardType");
//		String[] boardTitle = request.getParameterValues("boardTitle");
//		String[] boardComment = request.getParameterValues("boardComment");
		
//		if(boardType != null) {
//		for(int i = 0; i < boardType.length; i++) {
//			BoardVo boardVo = new BoardVo();
//			boardVo.setBoardType(boardType[i]);
//			boardVo.setBoardTitle(boardTitle[i]);
//			boardVo.setBoardComment(boardComment[i]);
//			list.add(boardVo);
//			System.out.println(list.get(i).toString());
//		}
//	} 
		System.out.println("result : " + myboard.toString());
		System.out.println("Title  : " + myboard.getBoardlist().size());
		
		
		// 리스트를 넣는 것이 아닌 리스트를 보내서 받는 방법
		// 삭제 기능 구현(선택 삭제)
		resultCnt = boardService.boardInsertbyList(myboard);
		System.out.println("result db처리 " + resultCnt);
		result.put("success", (resultCnt > 0)?"Y":"N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
		return callbackMsg;
	}
	
	
	
	@RequestMapping(value="/board/{boardType}/{boardNum}/boardUpdate.do", method=RequestMethod.GET)
	public String boardUpdate(Locale locale, Model model
			,@PathVariable("boardType")String boardType
			,@PathVariable("boardNum")int boardNum) throws Exception{
		
		
		BoardVo boardVo = new BoardVo();
		
		
		boardVo = boardService.selectBoard(boardType,boardNum);
		
		model.addAttribute("boardType", boardType);
		model.addAttribute("boardNum", boardNum);
		model.addAttribute("board", boardVo);
		
		return "board/boardUpdate";
	}
	
	@RequestMapping(value = "/board/boardUpdateAction.do", method = RequestMethod.POST )
	@ResponseBody
	public String boardUpdateAction(Locale locale, BoardVo boardVo, Model model) throws Exception{
		
		
		HashMap<String, String> result = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		
		int resultCnt = boardService.boardUpdate(boardVo);
		
		result.put("success", (resultCnt > 0)?"Y":"N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
		
		System.out.println("callbackMsg::"+callbackMsg);
		
		return callbackMsg;
	}
	
	@RequestMapping(value="/board/boardDeleteAction.do",method = RequestMethod.POST)
	@ResponseBody
	public String boardDelete(Locale locale, @RequestParam("boardType") String boardType, @RequestParam("boardNum") int boardNum) throws Exception{
		
		HashMap<String, String> result = new HashMap<String, String>();
		CommonUtil commonUtil = new CommonUtil();
		BoardVo boardVo = new BoardVo();
		boardVo.setBoardNum(boardNum);
		boardVo.setBoardType(boardType);
		int resultCnt = boardService.boardDelete(boardVo);
		
		result.put("success", (resultCnt > 0)?"Y":"N");
		String callbackMsg = commonUtil.getJsonCallBackString(" ",result);
		
		System.out.println("callbackMsg::"+callbackMsg);
		
		return callbackMsg;
	}
	
}