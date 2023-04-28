/*
 비워져 있는 부분이나 첨부파일 형식 체크 
 */

window.onload = function(){
	document.getElementById('submit1').onclick = function(){
		//도큐먼트에서 id submit1을 찾아서 클릭할 때
		if(document.wfrm.info.checked == false){
			//도큐먼트 동의부분에서 체크박스를 체크하지 않았을 때
			alert('동의를 해주세요'); //경고창 실행
			return false; //a태그가 click이벤트를 받았을 때 false값을 반환시켜서 동작을 중지시키는것
		}
		if(document.wfrm.writer.value.trim() == ''){
			//글쓴이가 비워져있을 때
			alert('글쓴이를 입력해주세요');
			return false;
		}
		if(document.wfrm.subject.value.trim() == ''){
			alert('제목을 입력해주세요');
			return false;
		}
		if(document.wfrm.password.value.trim() == ''){
			alert('비밀번호를 입력해주세요');
			return false;
		}
		if(document.wfrm.upload.value.trim() == ''){
			alert('사진파일을 첨부해주세요');
			return false;
		}
		var fileValue = document.wfrm.upload.value.trim().split('\\');//첨부파일
		var filename = fileValue[fileValue.length-1];//파일명
		var fileEname = filename.substring(filename.length-4, filename.length);//확장자
		if(fileEname == '.jpg' || fileEname == '.png' || fileEname == '.gif'){
			//사진 파일만 첨부
		} else {
			alert('이미지 파일만 첨부하세요.(.jpg, .png, .gif 확장자만 가능합니다)');
			document.wfrm.upload.value = '';
			return false;
		}
		document.wfrm.submit();
	}
}