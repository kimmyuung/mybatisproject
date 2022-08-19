<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>boardWrite</title>
</head>
<script type="text/javascript">

	$j(document).ready(function(){
		
		$j("#submit").on("click",function(){
			var $frm = $j('.boardWrite :input');
			var param = $frm.serialize();
			console.log(param);
			if ($j('#typeBox option:selected').length == 0) { $j("#typeBox").val("a01") }
			$j.ajax({
			    url : "/board/boardWriteActionBylist.do",
			    dataType: "json",
			    // async : false : 동기 방식으로 동작
			    contentType: 'application/x-www-form-urlencoded; charset=UTF-8', 
			    type : "POST",
			    data : param,
			    success: function(data, textStatus, jqXHR)
			    {
					alert("작성완료");
					
					alert("메세지:"+data.success);
					
					location.href = "/board/boardList.do";
			    },
			    error: function (jqXHR, textStatus, errorThrown)
			    {
			    	//jqxHR :
			    		//jqXHR.status : http 오류 번호를 반환
			    		//jqXHR.statusText : "Internal Server Error" 오류 내용 텍스트 = errorThrown과 동일
						//jqXHR.responseText : url의 response full text를 반환
						//jqXHR.readyState : ajax readyState를 출력
			    	// textStatus : error 고정 출력
			    	// errorThrown : HTTP 오류 메시지 출력 
			    	alert("실패");
			    }
			});
		});
	});
	var i = 0; // 행 갯수 식별 위해 설정
	var jb = '';
	function plusboard() {
		 
		jb += '<tr><td width="120" align="center"> Type</td>' 
		jb += '<td width="400">' 			
		jb += '<select name="boardlist[' + (i+1) + '].boardType" id="typeBox">' 
		jb += '<c:forEach var="code" items="${codeName}" varStatus="status">' 
		jb += '<option value="${code.codeId}">${code.codeName}</option>' 
		jb +='</c:forEach></select></td></tr>' 
		jb +='<tr><td width="120" align="center">'
		jb +='Title' 
		jb +='</td>' 
		jb +='<td width="400">'  
		jb +='<input name="boardlist[' + (i+1) + '].boardTitle" type="text" size="50" value="${board.boardTitle}">' 
		jb +='</td></tr>' 
		jb +='<tr>' 
		jb +='<td height="300" align="center">'
		jb +='Comment</td>' 
		jb +='<td valign="top">' 
		jb +='<textarea name="boardlist[' + (i+1) + '].boardComment"  rows="20" cols="55">${board.boardComment}</textarea>' 
		jb +='</td></tr>' 
		jb +='<tr>' 
		jb +='<td align="center">' 
		jb +='Writer</td><td></td></tr>' 
		jb +='<tr><td align="center" colspan="2"><input type="checkbox" name="check">선택</button></td></tr>';
		
		 $j("#boardwriteTable > tbody:last").append(jb); // Table의 마지막 Row 다음에 Row 추가하기
		 $j('#minus').css('display', 'block'); // 마이너스 버튼 보이기
		 $j('#selectdel').css('display', 'block'); // 선택 삭제 버튼 보이기
		 i++;
	}
	function minusboard() { // 가장 밑의 부분 삭제
		var count = $j("#boardwriteTable tr").length; // 행의 길이를 저장하는 변수
		
		for(var i = 0; i < 5; i++) {
		$j('#boardwriteTable > tbody:last > tr:last').remove(); // 행이 3개이기 때문에 3번 마지막 행을 제거
		}
		
		if(count == 10) { // 총 행의 숫자가 10개면 행 삭제 버튼 제거 왜 5가 아니냐? th부분의 tr도 가져오기 때문
			$j('#minus').css('display', 'none');
			 $j('#selectdel').css('display', 'none'); // 선택 삭제 버튼 보이기
		}
		i--;
	}
	
	 function selectdelete(){
		 if(i == 0) {
			 alert("선택된 행이 없습니다.");
			 return;
		 }     
		  var count = $j("#boardwriteTable tr").length; // 행의 길이를 저장하는 변수
		 
		  var select = $j("input[name='check']:checked"); // 선택된 체크박스
		
		for(var i = select.length -1; i > -1; i--) { // 여러 행을 삭제해야 함.
			select.eq(i).closest('tr').remove();
			// form으로 묶여 있으니 가장 
		}
		  
		if(count == 10) { // 총 행의 숫자가 10개(=행 추가가 안 된 상태)면 행 삭제 버튼 제거
				$j('#minus').css('display', 'none');
				$j('#selectdel').css('display', 'none');
		}
	}
	 

</script>
<body style="width: 100%;">
	<table align="center" >
		<tr>
			<td align="right">
			<input id="submit" type="button" value="작성">
			</td>
			<td align="left">
			<input type="button" id="plus" value="행 추가" onclick="plusboard()">
			</td>
			<td align="left">
			<!-- 행 추가가 안되어 있을 때는 숨기기 css 설정 -->
			<input type="button" id="minus" value="맨 밑의 행 삭제" onclick="minusboard()" style="display: none;">
			</td>
			<td align="left">
			<!-- 행 추가가 안되어 있을 때는 숨기기 css 설정 -->
			<input type="button" id="selectdel" value="선택된 행 삭제" onclick="selectdelete()" style="display: none;">
			</td>
		</tr>
		<tr>
			<td>
				<form class="boardWrite">
				<table border ="1" id="boardwriteTable"> 
					<tr>
						<td width="120" align="center">
						Type
						</td>
						<td width="400">			
						<select name="boardlist[0].boardType" id="typeBox">
						<c:forEach var="code" items="${codeName}" varStatus="status">
							<option value="${code.codeId}">${code.codeName}</option>
						</c:forEach>				
						</select>
						</td>
					</tr>
					<tr>
						<td width="120" align="center">
						Title
						</td>
						<td width="400">
						
						<input name="boardlist[0].boardTitle" type="text" size="50" value="${board.boardTitle}"> 
						</td>
					</tr>
					<tr>
						<td height="300" align="center">
						Comment
						</td>
						<td valign="top">
						<textarea name="boardlist[0].boardComment"  rows="20" cols="55">${board.boardComment}</textarea>
						</td>
					</tr>
					<tr>
						<td align="center">
						Writer
						</td>
						<td>
						
						</td>
					</tr>
					<tr>
						<td align="center" colspan="2">
						<input type="checkbox" name="check">선택</button>
						</td>
					</tr>
				</table>
				</form>	
			</td>
		</tr>
		<tr>
			<td align="right">
				<a href="/board/boardList.do">List</a>
			</td>
		</tr>
	</table>	
</body>
</html>