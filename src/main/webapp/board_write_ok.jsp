<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="model1.BoardTO" %>
<%@ page import="model1.BoardDAO" %>
<%@ page import="java.io.File" %>
<%
String cpage = request.getParameter("cpage");//cpage값을 요청하고

String uploadPath = "D:\\dev_anyu\\jsp_lesson\\photo\\src\\main\\webapp\\upload";//(물리적경로)업로드 되는 경로를 얘기함
int maxFileSize = 1024 * 1024 * 20; //용량제한 20메가까지
String encType = "utf-8"; //인코딩 값 utf-8로 
//객체생성
MultipartRequest multi = new MultipartRequest(request, uploadPath, maxFileSize, encType, new DefaultFileRenamePolicy());
//DefaultFileRenamePolicy() 동일한 파일이름이 존재한다면 test1.jpg, test2.jpg, test3.jpg 파일명 디폴트에 1, 2, 3을 붙게 해주는 클래스
String subject = multi.getParameter("subject");
String writer = multi.getParameter("writer");

//필수 입력항목이 아닌 경우 아래와 같이 값을 검사하고 저장
String mail = "";
if(!multi.getParameter("mail1").equals("") && !multi.getParameter("mail2").equals("")){
	mail = multi.getParameter("mail1") + "@" + multi.getParameter("mail2");
}
String password = multi.getParameter("password");
String content = multi.getParameter("content");
String wip = request.getRemoteAddr();//자바에서 클라이언트의 ip주소를 얻기 위해 사용하는 코드

String filename = multi.getFilesystemName("upload");
File file = multi.getFile("upload");

long filesize = 0; //파일 사이즈를 체크하기 위함
if(file != null){
	filesize = file.length();
}

BoardTO to = new BoardTO();
BoardDAO dao = new BoardDAO();

to.setSubject(subject);
to.setWriter(writer);
to.setMail(mail);
to.setPassword(password);
to.setContent(content);
to.setFilename(filename);
to.setFilesize(filesize);
to.setWip(wip);

int flag = dao.boardWriteOk(to);

out.println("<script>");
if(flag == 0){
	out.println("alert('글쓰기 성공');");
	out.println("location.href='board_list.jsp'");
} else {
	out.println("alert('글쓰기 실패');");
	out.println("history.back()");
}
out.println("</script>");
%>

<!-- 
enctype 속성값 목록
multipart/form-data : 파일 업로드시 사용(인코딩 하지 않음)
applicationx-www-formurlencoded : 디폴트값으로 모든 문자를 인코딩
text/plain: 공백은 + 기호로 변환함 특수문자는 인코딩하지 않음

maxFileSize: 파일당 최대파일크기 제한없음
maxRequestSize: 파일 한 개의 용량이 아니라 multipart/form-data요청당 최대 파일크기이다
(여러파일 업로드 시 총 크기로 보면 된다)
fileSizeThreshold: 업로드하는 파일이 임시로 저장되지 않고 메모리에서 바로 스트림으로 전달되는 크기의 한계를 나타냄
 -->
