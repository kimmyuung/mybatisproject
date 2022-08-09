<%@ page language="java" contentType="text/html; charset=EUC-KR"
    pageEncoding="EUC-KR"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>boardView</title>
</head>
<script type="text/javascript">

	function boarddelete(boardType,  boardNum){
		alert(boardType + " " + boardNum);
		$.ajax({
			 url : "/board/boardWriteAction.do",
			 type : "POST",
			 data : {"boardType" : boardType, "boardNum" : boardNum}
			  success: function()
			    {
					alert("삭제 완료");
					
					alert("메세지:");
					
					location.href = "/board/boardList.do?pageNo=1";
			    },
			   /*  error: function ()
			    {
			    	alert("실패");
			    } */
		});
	}
	
	</script>
<body>
<table align="center">
	<tr>
		<td>
			<table border ="1">
				<tr>
					<td width="120" align="center">
					Title
					</td>
					<td width="400">
					${board.boardTitle}
					</td>
				</tr>
				<tr>
					<td height="300" align="center">
					Comment
					</td>
					<td>
					${board.boardComment}
					</td>
				</tr>
				<tr>
					<td align="center">
					Writer
					</td>
					<td>
					</td>
				</tr>
			</table>
		</td>
	</tr>
	<tr>
			<td align="right">
			<a href="/board/boardList.do">List</a>
			</td>
			
			<td>
			<a href = "/board/${board.boardType}/${board.boardNum}/boardUpdate.do">Update</a>
			</td>
			
			<td align="right">
				<input id="boarddelete" type="button" value="Delete" onclick="boarddelete(${board.boardType}, ${board.boardNum})">
			</td>
	</tr>
</table>	
</body>
</html>