<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="javax.sql.DataSource" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.SQLException" %>
<%@page import="javax.naming.NamingException"%>
<%@page import="javax.naming.InitialContext"%>
<%@page import="javax.naming.Context"%>
<%
request.setCharacterEncoding("utf-8");

Connection conn = null;//커넥션 콘 = 값을 가지지 않음
PreparedStatement pstmt = null;

try{
	//커넥션 풀로 DB에 연결하기
	Context initCtx = new InitialContext();
	Context envCtx = (Context)initCtx.lookup("java:comp/env");
	DataSource dataSource = (DataSource)envCtx.lookup("jdbc/mysql");
	conn = dataSource.getConnection();

	
	String sql = "INSERT INTO al_board1 VALUES(0,?,?,?,?,?,?,0,0,?,now())";
	pstmt = conn.prepareStatement(sql);

	for(int i=1; i <= 10; i++){
		pstmt.setString(1, "제목" + i);
		pstmt.setString(2, "글쓴이" + i);
		pstmt.setString(3, "test@test.com");
		pstmt.setString(4, "1234");
		pstmt.setString(5, "내용" + i);
		pstmt.setString(6, "jjap.jpg");
		pstmt.setString(7, "192.168.000.000");
		pstmt.executeUpdate();
	} 
} catch(NamingException e) {
	System.out.println("error: " + e.getMessage());
} catch(SQLException e) {
	System.out.println("error: " + e.getMessage());
} finally {
	if(pstmt != null)pstmt.close();
	if(conn != null)conn.close();
}
out.println("<script>");
out.println("alert('글쓰기에 성공했습니다')");
out.println("location.href = 'board_list.jsp'");
out.println("</script>");
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
		
		</div>
	</div>
</div>

</body>
</html>