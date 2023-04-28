<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% 
request.setCharacterEncoding("UTF-8");
String cpage = request.getParameter("cpage");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
<script src="js/list.js"></script>
<title></title>
</head>
<body>
<div class="container">
	<div class="row">
		<div class="col-12">
		
			<ul class="breadcrumb my-3">
				<li class="breadcrumb-item">HOME &gt;</li>
				<li class="breadcrumb-item">BOARD &gt;</li>
				<li class="breadcrumb-item active">WRITE</li>
			</ul>
			
			<form action="board_write_ok.jsp" method="post" name="wfrm" enctype="multipart/form-data">
				<input type="hidden" name="cpage" value="<%=cpage%>"/>
				<table class="table">
				<tr>
					<th>글쓴이</th>
					<td><input type="text" name="writer" class="form-control" maxlength="5" placeholder="이름을 적어주세요"></td>
				</tr>
				<tr>
					<th>제목</th>
					<td><input type="text" name="subject" class="form-control" maxlength="100" placeholder="제목을 적어주세요"></td>
				</tr>
				<tr>
					<th>비밀번호</th>
					<td><input type="password" name="password" class="form-control" maxlength="16" placeholder="비밀번호를 적어주세요"></td>
				</tr>
				<tr>
					<th>내용</th>
					<td><textarea name="content" class="form-control" maxlength="2048" placeholder="내용을 적어주세요" rows="6"></textarea></td>
				</tr>
				<tr>
					<th>이메일</th>
					<td>
						<div class="input-group">
							<input type="text" name="mail1" class="form-control" maxlength="16"/>
							&nbsp;@&nbsp;
							<input type="text" name="mail2" class="form-control"/>
						</div>
					</td>
				</tr>
				<tr>
					<th>첨부파일</th>
					<td>
						<input type="file" name="upload" class="form-control" maxlength="16" value="파일첨부">
					</td>
				</tr>
				</table>
				
				<table class="table">
					<tr>
						<td>
							<h3>개인정보 수집 및 이용에 관한 안내</h3>
<pre class="py-3">
1. 개인정보 수집 항목: 
2. 개인정보 수집 및 이용목적: 
3. 개인정보의 이용기간:
4. 그 밖의 사항은 개인정보 취급방침을 준수합니다
</pre>
<div class="py-3">
<input type="checkbox" name="info" value="1">&nbsp;개인정보 수집 및 이용에 대해 동의합니다
</div>
						</td>
					</tr>
				</table>
				
				<div class="d-flex justify-content-end">
					<div class="btn-group">
						<input 
						type="button" 
						class="btn btn-primary" 
						value="목록" 
						onclick="location.href='board_list.jsp?cpage=<%=cpage %>'"
						/>
						
						<input 
						type="button" 
						class="btn btn-success" 
						value="쓰기" 
						id="submit1"
						/>
					</div>
				</div>
			</form>
		</div>
	</div>
</div>

</body>
</html>