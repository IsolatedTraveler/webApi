<%@ page pageEncoding="UTF-8"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
  <head>

    <title>手动刷新sql语句</title>
    
	<meta http-equiv="pragma" content="no-cache">
	<meta http-equiv="cache-control" content="no-cache">
	<meta http-equiv="expires" content="0">    
	<meta http-equiv="keywords" content="keyword1,keyword2,keyword3">
	<meta http-equiv="description" content="This is my page">
	<!--
	<link rel="stylesheet" type="text/css" href="styles.css">
	-->
	<script type="text/javascript">
		function getMkh() {
			const mkbhObj = document.getElementById("mkbh");
			return mkbhObj.value || 'all'
		}
		function  refresh(ywlx, mkbh) {
			let url = new URL('rest/' + ywlx + '/' + mkbh, location.href)
			window.location = url.href
		}
		function refreshSql(){
			document.getElementById("refresh").disabled = true;
			refresh('refreshSql', getMkh())
		}
		function refreshYwxtSql(){
			document.getElementById("refreshYwxt").disabled = true;
			refresh('refreshYwxtSql', getMkh())
		}
	</script>

  </head>
  
  <body>
  	<br/>
    <br/>
	<label for="mkbh">模块编号：</label><input id = "mkbh" name="mkbh" value = ""/>
    	   <input id="refresh" name="refresh" type="button" value = "刷新sql" onclick = "refreshSql();"/>
    	   <input id="refreshYwxt" name="refreshYwxt" type="button" value = "刷新业务协sql" onclick = "refreshYwxtSql();"/>
    <br/>
    <br/>
    <span>说明：如果录入模块编号，则刷新相应模块，如果不录入，则刷新所有模块。</span>
  </body>
</html>
