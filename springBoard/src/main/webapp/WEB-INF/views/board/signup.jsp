<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<script type="text/javascript">
var pass = [false, false]; // 비밀번호 체크와 아이디 체크 유효성 검사를 위한 변수
function idcheck() {
	alert("ㅇㅇ");
}
</script>
<body>
	<table align="center">
	<form>
		<tr>
			<td align="right"><a href="/board/boardList.do">List</a></td>
		</tr>
		<tr>
			<td align="center">Id</td>
			<td align="center"><input type="text" placeholder="아이디" name="userId"></td>
			<td align="center"><input type="button" value="중복확인" onclick="idcheck()"></td>
		</tr>
		<tr>
			<td align="center">PassWord</td>
			<td align="center"><input type="password" placeholder="비밀번호" name="userPw"></td>
		</tr>
		<tr>
			<td align="center">PassWord Check</td>
			<td align="center"><input type="password" placeholder="비밀번호체크"></td>
		</tr>
		<tr>
			<td align="center">Name</td>
			<td align="center"><input type="text" placeholder="이름" name="userName"></td>
		</tr>
		<tr>
			<td align="center">Phone</td>
			<td align="center"><input type="text" placeholder="휴대전화 번호" name="userPhone"></td>
		</tr>
		<tr>
			<td align="center">PostNo</td>
			<td align="center"><input type="text" placeholder="우편번호" name="userAddr"></td>
		</tr>
		<tr>
			<td align="center">Address</td>
			<td align="center"><input type="text" placeholder="주소"></td>
		</tr>
		<tr>
			<td align="center">Company</td>
			<td align="center"><input type="text" placeholder="회사"></td>
		</tr>
	</form>	
		<tr>
			<td align="right"><input type="button" value="join"
				onclick="signup()"></td>
		</tr>
	</table>


</body>
</html>