<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model1.BoardTO" %>
<%@ page import="model1.BoardDAO" %>
<%@ page import="model1.BoardListTO" %>
<%@ page import="java.util.ArrayList" %>
<!-- 
컴포넌트 : 재사용 가능한 웹의 구성요소란 뜻으로 웹 응용 프로그램에서 재사용 가능한 구성요소를 만들 수 있게 해주는
일련의 표준기반 웹 플랫폼 API세트 react, vue
 -->
<%
int cpage = 1;
if(request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")){
 cpage = Integer.parseInt(request.getParameter("cpage"));
}//내용이 있다고 하면 cpage구성
BoardListTO listTO = new BoardListTO();
listTO.setCpage(cpage);

BoardDAO dao = new BoardDAO();
listTO = dao.boardList(listTO);

//페이징 설정
int recordPerPage = listTO.getRecordPerPage();
int totalRecord = listTO.getTotalRecord();
int totalPage = listTO.getTotalPage();
int blockPerPage = listTO.getBlockPerPage();
int blockRecord = listTO.getBlockRecord();
int startBlock = listTO.getStartBlock();
int endBlock = listTO.getEndBlock();

/*
StirngBuffer => 문자열을 추가하거나 변경할 때 주로 사용하는 자료형
StringBuffer sb = new StringButter(); 객체 sb생성
sb.append("hello");
sb.append("world");
string result = sb.toString();
*/

//컴포넌트 작성
StringBuffer sbHtml = new StringBuffer();
for(BoardTO to: listTO.getBoardLists()){
	blockRecord++;
	sbHtml.append("<td width='20%'>");
	sbHtml.append("<div>");
	sbHtml.append("<table width='100%'>");
	sbHtml.append("<tr>");
	sbHtml.append("<td >");
	sbHtml.append("<div class='card'>");
	sbHtml.append("<a href='board_view.jsp?cpage=" + cpage +"&seq=" + to.getSeq()+"'><img src='upload/"+ to.getFilename()+ "' class='card-img-top'></a>");
	sbHtml.append("<div class='card-body'>");
	sbHtml.append("<div class='card-title'>");
	sbHtml.append("<div class='boardItem mt-3 mb-3 sub'>"); //텍스트 오버플로우 선언하는곳
	
	//아래가 제목
	sbHtml.append("<span class='badge bg-danger me-2'>new</span><strong>" + to.getSubject() + "</strong>");
	//제목이 너무 짧을 경우에는 얘를 사용
	if(to.getWgap() == 0){
		sbHtml.append("...");
	}
	
	sbHtml.append("</div>"); //card-title end
	//글쓴이
	sbHtml.append("<div class='card-text'>");
	sbHtml.append("<span class='mt-3 mb-3'>" + to.getWriter() + "</span>");
	//hit
	sbHtml.append("<br>");
	sbHtml.append("<div class='d-flex justify-content-end fs10'>" + to.getWdate() + "&nbsp;|&nbsp;Hit " + to.getHit() + "</div>");
	sbHtml.append("</div>"); //card-text end
	
	sbHtml.append("<div class='d-flex justify-content-end'>"); //오른쪽
	
	sbHtml.append("<a href='board_view.jsp?cpage=" + cpage +"&seq=" + to.getSeq()+"' class='btn btn-primary'>");
	sbHtml.append("more");
	sbHtml.append("</a>");
	sbHtml.append("</div>");
	sbHtml.append("</div>");//card-body end
	
	sbHtml.append("</div>");//오른쪽 엔드
	
	sbHtml.append("</td>");
	sbHtml.append("</tr>");
	sbHtml.append("</div>");
	sbHtml.append("</table>");
	sbHtml.append("</div>");
	sbHtml.append("</td>");
}

%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.3/dist/css/bootstrap.min.css">
<link rel="stylesheet" href="css/custom.scss">
<title></title>
</head>
<body>
<div class="container">
	<div class="row">
		<div class="col-12">
			<div class="d-flex mt-3 mb-3">
				<p class="mx-3">
					<img alt="홈아이콘" src="img/home.svg">
				</p>
				<p>
				총<span class="text-danger">
				<%= blockRecord %>
				</span>건
				</p>
			</div>
			
			<div><!-- sbhtml들어가는 곳 -->
				<table class="table">
					<tr>
					<%=sbHtml%>
					</tr>
				</table>
			</div>
			
			<!-- 페이징 -->
			<div class="d-flex justify-content-between mt-3 align-items-center">
				<ul class="pagination">
					<%
					if(startBlock == 1){
						out.println("<li class='off page-item'><a class='page-link'>&lt;&lt;</a></li>");
					} else {
						out.println("<li class='off page-item'><a class='page-link' href='board_list.jsp?cpage=" + (startBlock - blockPerPage) + "'>&lt;&lt;</a></li>");
					}//왼쪽 prev
					
					if(cpage == 1){
						out.println("<li class='off page-item'><a class='page-link'>&lt;</a></li>");
					} else {
						out.println("<li class='off page-item'><a class='page-link' href='board_list.jsp?cpage=" + (cpage-1) + "'>&lt;</a></li>");
					}
					
					for(int i = startBlock; i <= endBlock; i++){
						if(cpage == i){
							out.println("<li class='off page-item'><a class='page-link'>[" + i + "]</a></li>");
						} else {
							out.println("<li class='off page-item'><a class='page-link' href='board_list.jsp?cpage=" + i + "'>" + i + "</a></li>");
						}
					}
					
					//오른쪽 next
					if(cpage == totalPage){
						out.println("<li class='off page-item'><a class='page-link'>&gt;</a></li>");
					} else {
						out.println("<li class='off page-item'><a class='page-link' href='board_list.jsp?cpage=" + (cpage+1) + "'>&gt;</a></li>");
					}
					
					if(endBlock == totalPage){
						out.println("<li class='off page-item'><a class='page-link'>&gt;&gt;</a></li>");
					} else {
						out.println("<li class='off page-item'><a class='page-link' href='board_list.jsp?cpage=" + (startBlock + blockPerPage) + "'>&gt;&gt;</a></li>");
					}
					%>
				</ul>
				
				<input type="button" value="write" class="btn btn-primary" onclick="location.href='board_write.jsp?cpage=<%=cpage%>'">
			</div>
		</div>
	</div>
</div>

</body>
</html>