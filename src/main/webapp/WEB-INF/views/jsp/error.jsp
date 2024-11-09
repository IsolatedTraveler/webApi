<%@ page language="java" import="java.util.*" contentType="text/html;charset=UTF-8"%>
<%  
			 try {
				 String msg = (String) request.getAttribute("msg");
				 System.out.print(msg);
			 } catch (Exception e) {
				 e.printStackTrace();
			 }
%>