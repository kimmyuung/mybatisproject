<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@include file="/WEB-INF/views/common/common.jsp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=EUC-KR">
<title>list</title>
</head>
<script type="text/javascript">


$j(document).ready(function(){// 문서가 시작되면 실행되는 함수
	
		var arr = []; // codeId값들을 담을 배열 선언
		<c:forEach var="item" items="${codeName}">
		// codeName이라는 배열을 반복한다. item이라는 임시변수를 사용해서 => for(객체 임시변수 : 리스트)에서의 임시변수 역할
		arr.push("${item.codeId}");
		</c:forEach>
		// jstl로 가져온 codeName배열의 모든 codeId값을 배열에 넣음
		
		var codeNameLength = ${fn:length(codeName)};
		//  jstl로 가져온 codeName배열의 길이를 구하는 함수
		
		var selectdata = []; // 선택된 codeId값들을 저장하기 위해 사용
		//	체크박스 전체선택, 전체 해제
		
		$j("#checkAll").click(function(){ // 전체선택을 눌렀을 때 실행
			
			if($j("#checkAll").prop("checked")){  // 전체선택이 체크된 상태일 경우
				$j(".typeCk").prop("checked", true); // typeCk 클래스의 모든 체크박스 선택
				for(var i = 0; i < arr.length; i++) { 
					selectdata.push(arr[i]); // arr배열의 모든 데이터를 사용자가 선택된 배열에 넣음		
				}
			}else{
				$j(".typeCk").prop('checked',false); // typeCk 클래스의 모든 체크박스 선택해제
				selectdata = []; // 선택된 값들을 초기화
			}
		});
			
		// 체크박스 클릭시 발생하는 이벤트
		$j(".typeCk").change(function(){
			
			var select = $j("input[name='codeId']:checked").val(); // 선택된 값 변수 저장

			for(var i = 0; i < selectdata.length; i++) { // 유효성 검사(체크 검사)
				if($j("input[name='codeId']:checked").val() == selectdata[i]) { // 만약에 선택한 값이 내가 선택한 값을 저장하는 배열안에 있다면
					selectdata.splice(selectdata[i], 1);  // data배열에서 data[i]를 0으로 치환
				}
				if(typeof selectdata[i] == "undefined" ) {// 배열안에 undefined 타입이 있으면 삭제 하기 위해
					selectdata.splice(selectdata[i], 1);
				}
			}	
			selectdata.push(select);
			console.log(selectdata);
			if($j("input[name='codeId']:checked").length == codeNameLength){ // codeName배열의 길이와 codeId라는 이름을 가진 체크박스를 선택한 길이가 같아지면
				$j("#checkAll").prop("checked", true); // 모두 선택이 체크
			}else{
				$j("#checkAll").prop("checked", false); // 모두 선택 선택 취소		
			}
		});
			
		
		$j("#btnSearch").click(function(){ // 조회 버튼 클릭 시 발생하는 이벤트
			//$j('#selectType').submit(); // 조회 form을 submit
		
			jQuery.ajaxSettings.traditional = true; 
			// 배열을 파라미터로 보낼시 []도 같이 보내게 되는데 []를 안 보내기 위해 설정
			
				
			console.log(selectdata);
			$j.ajax({ // ajax 사용
				url : '/board/getboardList.do', // url 설정
				data : {'codeId' : selectdata} , // 보낼데이터 설정
				success : function(data, textStatus){
					console.log(data);	
					selectdata.splice(0, arr.length); // 배열 초기화를 위해 배열의 마지막길이까지 0으로 바꿈
					var html = '<tr><th width="80" align="center">' +
									'Type' +
									'</th>'+
									'<th width="40" align="center">' +
									'No'+
									'</th>' +
									'<th width="300" align="center">' +
									'Title' +
									'</th>' +
									'</tr>';
					for(let i = 0; i < data.length; i++) {
						
						html += '<tr>' +
						'<td align="center" >' + 
							data[i].codeName +
						'</td>' + 
						'<td>' +
							data[i].boardNum +
						'</td>' + 
						'<td>' + 
						'<a href = "/board/'+data[i].boardType+ '/' + data[i].boardNum + '/' + 'boardView.do">' +
						data[i].boardTitle +
						'</a>' +
						'</td>' +
						'</tr>';	
			
					}
				
					$j("#boardTable").html(html);
				}
			});
		});
	});

</script>
<body>
<table  align="center">
	<tr>
		<td align="left">
			<a href="/board/login.do">login</a>
		</td>
		<td align="left">
			<a href="/board/signup.do">signup</a>
		</td>
		<td align="right">
			total : ${totalCnt} <!-- 총 게시물의 숫자 -->
		</td>
	</tr>
	<tr>
		<td>
			<table id="boardTable" border = "1">
				<tr>
					<th width="80" align="center">
						Type
					</th>
					<th width="40" align="center">
						No
					</th>
					<th width="300" align="center">
						Title
					</th>
				</tr>
				<c:forEach items="${boardList}" var="list"> <!-- boardlist라는 배열가져옴 list라는 반복문용 변수에 설정 -->
					<tr>
						<td align="center" >
							${list.codeName} <!-- 게시글의 종류 -->
						</td>
						<td >
							${list.boardNum} <!-- 게시글의 번호 -->
						</td>
						<td>
							<a href = "/board/${list.boardType}/${list.boardNum}/boardView.do?pageNo=${pageNo}">${list.boardTitle}</a>
							<!-- 게시글 상세보기로 페이지 전환 식별을 위해 boardType과 boardNum을 파라미터로 넘겨줌 -->
						</td>
					</tr>	
				</c:forEach>
			</table>
		</td>
	</tr>
	<tr>
		<td align="left">
		<form id="selectType" class="selectType" method="get" action="/board/boardList.do">
		<input type="checkbox" id="checkAll" value="all">전체선택
		<c:forEach var="code" items="${codeName}" varStatus="status">
		<!-- code라는 이름의 변수(반복문에서 사용)에 codeName이라는 배열을 가지고 옴 status라는 상태용변수 설정-->
		<input type="checkbox" class="typeCk" name="codeId" value="${code.codeId}">${code.codeName}</>
		</c:forEach>
		<button type="button" id="btnSearch">조회</button>
		</form>
		</td>
		<td align="right">
			<a href ="/board/boardWrite.do">글쓰기</a>
		</td>
	</tr>
</table>	
</body>
</html>