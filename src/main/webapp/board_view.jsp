<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model1.BoardTO" %>
<%@ page import="model1.BoardDAO" %>
<%
request.setCharacterEncoding("utf-8");

String cpage = request.getParameter("cpage");
String seq = request.getParameter("seq");

BoardTO to = new BoardTO();
to.setSeq(seq);

BoardDAO dao = new BoardDAO();
to = dao.boardModify(to);

seq = to.getSeq();
String subject = to.getSubject();
String writer = to.getWriter();
String mail = to.getMail();
String wip = to.getWip();
String wdate = to.getWdate();
String hit = to.getHit();
String content = to.getContent();
String filename = to.getFilename();

//이전 글 얻어오기
BoardTO to_before = new BoardTO();
to_before.setSeq(seq);

BoardDAO dao_before = new BoardDAO();
to_before = dao_before.boardView_before(to);

String subject_before = to_before.getSubject();
String seq_before = to_before.getSeq();

//다음 글 얻어오기
BoardTO to_next = new BoardTO();
to_next.setSeq(seq);

BoardDAO dao_next = new BoardDAO();
to_next = dao_next.boardView_next(to_next);

String subject_next = to_next.getSubject();
String seq_next = to_next.getSeq();

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
<title></title>
</head>
<body>
<div class="container">
	<div class="row">
		<div class="col-12">
		
			<ul class="breadcrumb my-3">
				<li class="breadcrumb-item"><img alt="home" src="img/home.svg"/></li>
				<li class="breadcrumb-item">BOARD &gt;</li>
				<li class="breadcrumb-item active">VIEW</li>
			</ul>
		

			<form method="get">
				<table class="table">
					<tr>
						<th class="w-25">번호</th>
						<td class="w-75"><%=seq %></td>
					</tr>
					<tr>
						<th>제목</th>
						<td><%=subject %></td>
					</tr>
					<tr>
						<th>글쓴이</th>
						<td><%=writer %></td>
					</tr>
					<tr>
						<th>조회</th>
						<td><%=hit %></td>
					</tr>
					<tr>
						<td colspan="2">
							<div class="d-flex jstify-content-center mt-3 mb-3">
								<img alt="" src="upload/<%=filename%>" class="mw-100"/><br>
							</div>
							<div class="d-flex jstify-content-center mt-3 mb-3">
							<%=content %>
							</div>
						</td>
					</tr>
				</table>
				
				<div class="d-flex justify-content-end">
					<div class="btn-group">
						<input type="button" value="목록" class="btn btn-primary" 
						onclick="location.href='board_list.jsp?cpage=<%=cpage %>'"/>
						<input type="button" value="수정" class="btn btn-warning" 
						onclick="location.href='board_modify.jsp?cpage=<%=cpage %>&seq=<%=seq %>'"/>
						<input type="button" value="삭제" class="btn btn-danger" 
						onclick="location.href='board_delete.jsp?cpage=<%=cpage %>&seq=<%=seq %>'"/>
						<input type="button" value="쓰기" class="btn btn-success" 
						onclick="location.href='board_write.jsp?cpage=<%=cpage %>'"/>
					</div>
				</div>
			</form>
			
			<div>
				<span class="badge bg-secondary p-2">다음글 =></span>
				<%
				if(subject_next.equals("다음글이 없습니다")){
					out.println("다음 글이 없습니다");
				} else {
					out.println("<a href='board_view.jsp?cpage="+cpage+"&seq="+seq_next+"'>"+subject_next+"</a>");
				}
				%>
			</div>
			
			<div class="mt-3">
				<span class="badge bg-secondary p-2">&lt;= 이전글</span>
				<%
				if(subject_before.equals("이전글이 없습니다")){
					out.println("이전 글이 없습니다");
				} else {
					out.println("<a href='board_view.jsp?cpage="+cpage+"&seq="+seq_before+"'>"+subject_before+"</a>");
				}
				%>
			</div>
		</div>
	</div>
</div>

</body>
</html>