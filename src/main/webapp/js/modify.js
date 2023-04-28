/*
 수정용 스크립트 
 */

window.onload = function(){
	document.getElementById('submit1').onclick = function(){
		if(document.mfrm.subject.value.trim() == ''){
			alert("제목을 입력해주세요");
			return false;
		}
		if(document.mfrm.password.value.trim() == ''){
			alert("비밀번호를 입력해주세요");
			return false;
		}
		if(document.mfrm.content.value.trim() == ''){
			alert("내용을 입력해주세요");
			return false;
		}
		document.mfrm.submit();
	}
}