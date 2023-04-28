package model1;

import java.io.File;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.sql.DataSource;

public class BoardDAO {
	//db연동
	private DataSource dataSource;
	
	//JNDI (Java Naming and Directory Interface)
	//디렉터리 서비스에서 제공하는 데이터 및 객체를 발견하고 참고하기 위한 자바 API
	//외부에 있는 객체를 가져오기 위한 기술이다
	//tomcat과 같은 was를 보면 특정 폴더에 데이터 소스 라이브러리가 있는데
	//그것을 사용하기 위해 JNDI를 이용해서 가져온다
	//DBCP(Database Connection Pool)
	/*
	 데이터베이스와 연결된 커넥션을 미리 만들어서 저장해두고 있다가 
	 필요할 때 저장된 공간(pool)에서 가져다 쓰고 반환하는 기법
	 */
	public BoardDAO() {
		try {
			Context initCtx = new InitialContext();
			Context envCtx = (Context)initCtx.lookup("java:comp/env");
			this.dataSource = (DataSource)envCtx.lookup("jdbc/mysql");
			//initCtx lookup메소드를 이용해서 "java:comp/env"에 해당하는 객체를 찾아서 envCtx에 삽입
			/*
			 java:comp/env는 웹어플의 구성된 엔트리와 리소스들이 배치되어 있는 부분
			 그래서 이것에 접근하여 web.xml의 <resorce-env-ref>에 설정한 jdbc/mysql과 매핑되는 리소스를 가져옴
			 envCtx에 lookup메소드를 이용해서 jdbc/mysql해당하는 객체를 찾아서 dataSource에 삽입 
			 */
		} catch (NamingException e) {
			System.out.println("[error]: " + e.getMessage());//에러가 생길경우 출력
		}
	}
	
	//write
	public void boardWrite() {
		
	}
	
	//write ok
	public int boardWriteOk(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		
		//정상처리 또는 비정상 처리변수
		int flag = 1;
		/*
		 *정상처리 또는 비정상 처리변수 
		 *0이면 설정되지 않음을 의미하고 1이면 설정됨을 의미
		 *산술계산을 수행했는데 결과가 0이면 flag=1
		 *다른 숫자는 0이 된다 
		 */
		
		try {
			conn = dataSource.getConnection();
			//데이터베이스에 데이터집어넣기
			String sql = "INSERT INTO al_board1 VALUES (0,?,?,?,?,?,?,?,0,?,now())";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSubject());//제목
			pstmt.setString(2, to.getWriter());//글쓴이
			pstmt.setString(3, to.getMail());//메일
			pstmt.setString(4, to.getPassword());//패스워드
			pstmt.setString(5, to.getContent());//내용
			pstmt.setString(6, to.getFilename());//파일명
			pstmt.setLong(7, to.getFilesize());//파일사이즈
			pstmt.setString(8, to.getWip());//ip
			
			int result = pstmt.executeUpdate();
			if(result == 1) {
				flag = 0;
			}
			
		} catch (SQLException e) {
			System.out.println("error: " + e.getMessage());
		} finally {
			if(pstmt != null ) try {pstmt.close();} catch(SQLException e) {}
			if(conn != null ) try {conn.close();} catch(SQLException e) {}
		}
		return flag;
	}
	
	//list
	public ArrayList<BoardTO> boardList(){
		Connection conn = null; //연결해주는 객체를 생성 Connection연결
		PreparedStatement pstmt = null; //값을 나중에 입력한다
		//PreparedStatement = 설정 및 실행
		ResultSet rs = null; //ResultSet결과값
		
		ArrayList<BoardTO> lists = new ArrayList<BoardTO>();
		/*
		 1. 원소를 추가 삭제 할 수 있나?
		 new ArrayList<>() 원소를 추가 삭제 가능
		 2. null을 가질 수 있는가? 가질 수 있음
		 
		 배열의 사이즈가 변하면 안되거나 변할 필요가 없을때는 list.of를 사용
		 리스트에서는 위에 선언한걸 사용
		 */
		try {
			conn = dataSource.getConnection();
			
			String sql = "SELECT seq, subject, filename, writer, date_format(wdate, '%Y-%m-%d') wdate, hit, datediff(now(), wdate)wgap FROM al_board1 ORDER BY seq DESC";
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			/*
			  ResultSet.TYPE_SCROLL_INSENSITIVE
			  result set에서 rs.next를 사용하면 다음 결과 row를 가져오고 다음에는 이전 값을 사용 못하게 된다. 
			  그런데 이 옵션으로 ResultSet을 만들면 한번 커서가 지나간 다음에 다시 되돌릴 수 있다.
			  
			  ResultSet.CONCUR_READ_ONLY
			  resultSet으로 가져온 row의 값을 다시 Insert나 update로 사용하지 않겠다는 의미
			 */
			rs = pstmt.executeQuery(); //세팅이 끝난 쿼리문을 실행시키고 나온 결과값을 rs에 저장
			
			//데이터베이스에서 글 목록을 가져와서 리스트 나타내기
			while(rs.next()) { //커서의 위치를 순방향으로 이동
				BoardTO to  = new BoardTO();
				String seq = rs.getString("seq");
				String subject = rs.getString("subject");
				String writer = rs.getString("writer");
				String filename = rs.getString("filename");
				String wdate = rs.getString("wdate");
				String hit = rs.getString("hit");
				int wgap = rs.getInt("wgap");
				
				to.setSeq(seq);
				to.setSubject(subject);
				to.setWriter(writer);
				to.setFilename(filename);
				to.setWdate(wdate);
				to.setHit(hit);
				to.setWgap(wgap);
				lists.add(to);
			}
		} catch (SQLException e) {
			System.out.println("error: " + e.getMessage());
		} finally {
			if(pstmt != null ) try {pstmt.close();} catch(SQLException e) {}
			if(conn != null ) try {conn.close();} catch(SQLException e) {}
		}
		return lists;
	}
	
	//paging list
	public BoardListTO boardList (BoardListTO listTO) {
		Connection conn = null; //연결해주는 객체를 생성 Connection연결
		PreparedStatement pstmt = null; //값을 나중에 입력한다
		//PreparedStatement = 설정 및 실행
		ResultSet rs = null; //ResultSet결과값
		
		//페이지를 위한 기본요소
		int cpage = listTO.getCpage();
		int recordPerPage = listTO.getRecordPerPage();//한 페이지에 보이는 글의 개수 5개
		int BlockPerPage = listTO.getBlockPerPage(); //한 화면에 보일 페이지의 수 3개
		
		try {
			conn = dataSource.getConnection();
			
			String sql = "SELECT seq, subject, filename, writer, date_format(wdate, '%Y-%m-%d') wdate, hit, datediff(now(), wdate)wgap FROM al_board1 ORDER BY seq DESC";
			pstmt = conn.prepareStatement(sql, ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_READ_ONLY);
			rs = pstmt.executeQuery();
			
			//총 글의 개수 얻기 
			rs.last(); //커서의 위치를 조회 결과 값의 마지막으로 이동
			listTO.setTotalRecord(rs.getRow()); //토탈레코드(현재row)
			rs.beforeFirst(); 
			/*
			 *rs.first(): 커서를 처음으로
			 *rs.last(): 커서를 제일 뒤로
			 *rs.next(): 커서를 다음으로
			 *rs.previous(): 커서의 이전으로
			 *rs.getRow(): 현재 커서가 가르키고 있는 row번호
			 *rs.isFirst(): 커서가 처음인지
			 *rs.isLast(): 커서가 마지막인지
			 *rs.beforeFirst(): 커서를 제일 위로(빈공간)
			 *rs.afterLast(): 커서를 제일 아래로(빈공간)
			 */
			
			//총 페이지 수 얻기
			listTO.setTotalPage(((listTO.getTotalRecord()-1)/recordPerPage) + 1);
			int skip = (cpage * recordPerPage) - recordPerPage;
			if(skip != 0)rs.absolute(skip);
			/*
			 * 페이징 처리 방법
			 * 1. 한 화면(한 장)에 몇개의 글을 보여줄건지 정함 5개
			 * 2. 몇개의 페이지를 보여줄건지 3개
			 * 예를 들어 42개의 글이 있다고 하면
			 * (42-1)/3 + 1 = 
			 * 1  2  3  4  5
			 * << < 123 > >>
			 */
			
			ArrayList<BoardTO> lists = new ArrayList<BoardTO>();
		
			for (int i = 0; i < recordPerPage && rs.next(); i++) {
				BoardTO to = new BoardTO();
				String seq = rs.getString("seq");
				String subject = rs.getString("subject");
				String writer = rs.getString("writer");
				String filename = rs.getString("filename");
				String wdate = rs.getString("wdate");
				String hit = rs.getString("hit");
				int wgap = rs.getInt("wgap");
				
				to.setSeq(seq);
				to.setSubject(subject);
				to.setWriter(writer);
				to.setFilename(filename);
				to.setWdate(wdate);
				to.setHit(hit);
				to.setWgap(wgap);
				lists.add(to);
			}
			listTO.setBoardLists(lists);
			//시작블록과 엔드블록 설정
			listTO.setStartBlock(((cpage-1)/BlockPerPage) * BlockPerPage + 1 );
			listTO.setEndBlock(((cpage-1)/BlockPerPage) * BlockPerPage + BlockPerPage);
			if(listTO.getEndBlock() >= listTO.getTotalPage()) {//엔드블록이 토탈페이지와 같거나 클때는
				listTO.setEndBlock(listTO.getTotalPage()); //페이징리스트 엔드블록은 토탈페이지와 같게
			}
		} catch (SQLException e) {
			System.out.println("error: " + e.getMessage());
		} finally {
			if(pstmt != null ) try {pstmt.close();} catch(SQLException e) {}
			if(conn != null ) try {conn.close();} catch(SQLException e) {}
		}
		return listTO;
	}
	
	//view 디테일페이지 또는 상세페이지라 함
	public BoardTO boardView(BoardTO to) {
		Connection conn = null; //연결해주는 객체를 생성 Connection연결
		PreparedStatement pstmt = null; //값을 나중에 입력한다
		//PreparedStatement = 설정 및 실행
		ResultSet rs = null; //ResultSet결과값
		
		try {
			/*
			 * 조회수 증가시키고 데이터베이스에서 해당글 내용 가져오고
			 * sql실행문에서 각 컬럼을 가져와서 변수에 저장
			 */
			
			conn = dataSource.getConnection();
			
			//조회수 증가시키기
			String sql = "UPDATE al_board1 SET hit = hit+1 WHERE seq = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			rs = pstmt.executeQuery();
			
			//데이터베이스 해당 글 내용가져오기
			sql = "SELECT subject, writer, mail, content, filename, hit, wip, wdate FROM al_board WHERE weq = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			rs = pstmt.executeQuery();
			
			//데이터베이스에서 sql실행문의 각 컬럼을 가져와서 변수에 저장
			if(rs.next()) {
				String subject = rs.getString("subject");
				String writer = rs.getString("writer");
				String mail = rs.getString("mail");
				String content = rs.getString("content");
				String filename = rs.getString("filename");
				String hit = rs.getString("hit");
				String wip = rs.getString("wip");
				String wdate = rs.getString("wdate");
				
				to.setSubject(subject);
				to.setWriter(writer);
				to.setMail(mail);
				to.setContent(content);
				to.setFilename(filename);
				to.setHit(hit);
				to.setWip(wip);
				to.setWdate(wdate);
			}
		} catch (SQLException e) {
			System.out.println("error: " + e.getMessage());
		} finally {
			if(pstmt != null ) try {pstmt.close();} catch(SQLException e) {}
			if(conn != null ) try {conn.close();} catch(SQLException e) {}
		}
		return to;
	}
	
	//view 이전글
	public BoardTO boardView_before(BoardTO to_before) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = dataSource.getConnection();
			//데이터베이스에서 해당 글 내용 가져오기
			String sql = "SELECT seq, subject FROM al_board1 WHERE seq = (SELECT max(seq) FROM al_board1 WHERE seq < ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to_before.getSeq());
			rs = pstmt.executeQuery();
			
			//이전 글이 있으면 가져오고 아니면 메세지 실행
			if(rs.next()) {
				String subject = rs.getString("subject");
				String seq = rs.getString("seq");
				to_before.setSubject(subject);
				to_before.setSeq(seq);
			} else {
				to_before.setSubject("이전글이 없습니다");
			}
		} catch (SQLException e) {
			System.out.println("error: " + e.getMessage());
		} finally {
			if(pstmt != null ) try {pstmt.close();} catch(SQLException e) {}
			if(conn != null ) try {conn.close();} catch(SQLException e) {}
		}
		return to_before;
	}
	
	//view 다음글
	public BoardTO boardView_next(BoardTO to_next) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = dataSource.getConnection();
			//데이터베이스에서 해당 글 내용 가져오기
			String sql = "SELECT seq, subject FROM al_board1 WHERE seq = (SELECT min(seq) FROM al_board1 WHERE seq > ?)";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to_next.getSeq());
			rs = pstmt.executeQuery();
			
			//다음 글이 있으면 가져오고 아니면 메세지 실행
			if(rs.next()) {
				String subject = rs.getString("subject");
				String seq = rs.getString("seq");
				to_next.setSubject(subject);
				to_next.setSeq(seq);
			} else {
				to_next.setSubject("이전글이 없습니다");
			}
			
		} catch (SQLException e) {
			System.out.println("error: " + e.getMessage());
		} finally {
			if(pstmt != null ) try {pstmt.close();} catch(SQLException e) {}
			if(conn != null ) try {conn.close();} catch(SQLException e) {}
		}
		return to_next;
	}
	
	//delete 삭제할 내용을 담는 부분
	public BoardTO boardDelete(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = dataSource.getConnection();
			//데이터베이스에서 해당 글 내용 가져오기
			String sql = "SELECT subject, writer FROM al_board1 WHERE seq = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			rs = pstmt.executeQuery();
			
			//데이터베이스에서 sql실행문의 각 컬럼을 가져와서 변수에 저장
			if(rs.next()) {
				String subject = rs.getString("subject");
				String writer = rs.getString("writer");
				
				to.setSubject(subject);
				to.setWriter(writer);
			}
		} catch (SQLException e) {
			System.out.println("error: " + e.getMessage());
		} finally {
			if(pstmt != null ) try {pstmt.close();} catch(SQLException e) {}
			if(conn != null ) try {conn.close();} catch(SQLException e) {}
		}
		return to;
	}
	
	//delete ok 삭제하는 영역 첨부파일 사진이 들어가 있어서 파일명을 가져오고 해당글 내용을 가져온다
	//패스워드가 초기 등록했던 것과 맞아야 삭제가 됨
	public int BoardDeleteOk(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int flag = 2;
		
		try {
			conn = dataSource.getConnection();
			String sql = "SELECT filename FROM al_board1 WHERE seq = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			
			rs = pstmt.executeQuery();
			String filename = null;
			if(rs.next()) {
				filename = rs.getString("filename");
			}
			//데이터베이스에서 해당 글 내용 가져오기
			sql = "DELETE FROM al_board1 WHERE seq = ? AND password =?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			pstmt.setString(2, to.getPassword());
			
			int result = pstmt.executeUpdate();
			if(result == 0) {
				flag = 1;
			} else if(result == 1) {
				flag = 0;
				if(filename != null) {
					File file = new File("D:/dev_anyu/jsp_lesson/bbs/src/main/webapp/upload/" + filename);
					file.delete();
				}
			}
		} catch (SQLException e) {
			System.out.println("error: " + e.getMessage());
		} finally {
			if(pstmt != null ) try {pstmt.close();} catch(SQLException e) {}
			if(conn != null ) try {conn.close();} catch(SQLException e) {}
		}
		return flag;
		
	}
	
	//modify 수정 update 글과 올려놓은 사진을 바꿔치기
	public BoardTO boardModify(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		try {
			conn = dataSource.getConnection();
			String sql = "SELECT writer, subject, content, mail, filename FROM al_board1 WHERE seq = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			rs = pstmt.executeQuery();
			//데이터베이스에서 sql실행문의 각 컬럼을 가져와서 변수에 저장
			
			if(rs.next()) {
				String subject = rs.getString("subject");
				String writer = rs.getString("writer");
				String content = rs.getString("content");
				String mail = rs.getString("mail");
				String filename = rs.getString("filename");
				
				to.setSubject(subject);
				to.setWriter(writer);
				to.setContent(content);
				to.setFilename(filename);
				to.setMail(mail);
			}
			
		} catch (SQLException e) {
			System.out.println("error: " + e.getMessage());
		} finally {
			if(pstmt != null ) try {pstmt.close();} catch(SQLException e) {}
			if(conn != null ) try {conn.close();} catch(SQLException e) {}
		}
		return to;
	}
	
	//modify ok 첨부파일이 있을 때와 없을 때
	public int boardModifyOk(BoardTO to) {
		Connection conn = null;
		PreparedStatement pstmt = null;
		ResultSet rs = null;
		
		int flag = 2;
		
		try {
			conn = dataSource.getConnection();
			
			String sql = "SELECT filename FROM al_board1 WHERE seq = ?";
			pstmt = conn.prepareStatement(sql);
			pstmt.setString(1, to.getSeq());
			rs = pstmt.executeQuery();
			String oldFilename = null;
			if(rs.next()) {
				oldFilename = rs.getString("filename");
			}
			
			//수정에서 첨부파일이 있을 때..
			if(to.getFilename() != null) {
				sql = "UPDATE al_board1 SET subject = ?, content = ?, mail = ?, filename = ? WHERE seq = ? AND password = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, to.getSubject());
				pstmt.setString(2, to.getContent());
				pstmt.setString(3, to.getMail());
				pstmt.setString(4, to.getFilename());
				pstmt.setString(5, to.getSeq());
				pstmt.setString(6, to.getPassword());
			} else {//첨부파일이 없을 때
				sql = "UPDATE al_board1 SET subject = ?, content = ?, mail = ? WHERE seq = ? AND password = ?";
				pstmt = conn.prepareStatement(sql);
				pstmt.setString(1, to.getSubject());
				pstmt.setString(2, to.getContent());
				pstmt.setString(3, to.getMail());
				pstmt.setString(4, to.getSeq());
				pstmt.setString(5, to.getPassword());
			} 
			int result = pstmt.executeUpdate();
			if(result == 0) {
				flag = 1;
			} else if (result == 1) {
				flag = 0;
				//기존의 첨부파일이 있고 추가된 첨부파일이 있을 경우 기존 파일은 삭제
				if(to.getFilename() != null && oldFilename != null) {
					File file = new File("D:/dev_anyu/jsp_lesson/bbs/src/main/webapp/upload/" + oldFilename);
					file.delete();
				}
			}
			
		} catch (SQLException e) {
			System.out.println("error: " + e.getMessage());
		} finally {
			if(pstmt != null ) try {pstmt.close();} catch(SQLException e) {}
			if(conn != null ) try {conn.close();} catch(SQLException e) {}
		}
		return flag;
	}
	
	
}
