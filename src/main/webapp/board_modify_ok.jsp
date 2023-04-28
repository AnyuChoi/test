<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model1.BoardTO"%>
<%@ page import="model1.BoardDAO"%>
<%@ page import="java.io.File"%>

<%
String uploadPath = "D:/dev_anyu/jsp_lesson/photo/src/main/webapp/upload"; //물리적 업로드 경로
int maxFileSize = 1024*1024*20;
String encType = "utf-8";
MultipartRequest multi 
= new MultipartRequest(request, uploadPath, maxFileSize, encType, new DefaultFileRenamePolicy());

String seq = multi.getParameter("seq");
String cpage = multi.getParameter("cpage");
String password = multi.getParameter("password");
String subject = multi.getParameter("subject");
String content = multi.getParameter("content");
String mail = "";

if(multi.getParameter("mail1") != null && multi.getParameter("mail2") != null){
	mail = multi.getParameter("mail1") + "@" + multi.getParameter("mail2"); 
}

String newFilename = multi.getFilesystemName("upload");
File newFile = multi.getFile("upload");

BoardTO to = new BoardTO();
BoardDAO dao = new BoardDAO();
to.setSeq(seq);
to.setPassword(password);
to.setSubject(subject);
to.setContent(content);
to.setMail(mail);
to.setFilename(newFilename);

int flag = dao.boardModifyOk(to);

out.println("<script>");
if(flag == 0){
	out.println("alert('글수정에 성공했습니다')");
	out.println("location.href='board_list.jsp?seq="+seq+"&cpage="+cpage+"'");
} else if(flag == 1){
	out.println("alert('비밀번호가 틀립니다')");
	out.println("history.back()");
} else {
	out.println("alert('글 수정에 실패했습니다')");
	out.println("history.back()");
}
out.println("</script>");
%>