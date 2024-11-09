<%@ page language="java" import="java.util.*" contentType="text/html;charset=UTF-8"%><%@ page import="org.springframework.jdbc.core.JdbcTemplate" %><%@ page import="org.springframework.jdbc.core.namedparam.MapSqlParameterSource" %><%@ page import="org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate" %><%@ page import="net.sf.json.JSONArray" %><%@ page import="net.sf.json.JSONObject" %><%@ page import="java.text.SimpleDateFormat" %><%@ page import="org.apache.commons.lang3.StringUtils" %><%@ page import="org.apache.commons.codec.binary.Base64" %><%@ page import="com.jtwx.jtphis.model.ResultJson" %><%@ page import="java.net.URLEncoder" %><%@ page import="java.net.URLDecoder" %><%@ page import="java.math.BigDecimal" %><%@ page import="com.jtwx.jtphis.utils.NamedParameterJdbcTemplateQuery" %><%@ page import="java.sql.*" %>
<%  
			 Connection connection = null;
			 PreparedStatement st = null;
			 try {
				 JdbcTemplate jdbcTemplate = (JdbcTemplate) request.getAttribute("jdbcTemplate");
				 String data = (String) request.getAttribute("data");
				 ResultJson result = new ResultJson();
				 JSONObject paramJson = JSONObject.fromObject(data);
				 connection = jdbcTemplate.getDataSource().getConnection();//设置不自动提交
				 connection.setAutoCommit(false);
				 String id = String.valueOf(paramJson.getString("id"));
				 String jcid = String.valueOf(paramJson.getString("jcid"));
				 String wjnr = String.valueOf(paramJson.getString("wjnr"));
				 if(StringUtils.isNotBlank(wjnr)){
					 wjnr = wjnr.replaceAll(" ", "+");
				 }

				 if(StringUtils.isNotBlank(id)){
					 String updateSql = "update PACS_BGWJ set jcid = ?,wjnr = ? where id=?";
					 st= connection.prepareStatement(updateSql);
					 st.setObject(1, jcid);
					 st.setObject(2, wjnr);
					 st.setObject(3, id);
					 st.execute();
				 }else{
					 String insertSql = "INSERT INTO PACS_BGWJ (ID,JCID,WJNR) VALUES (lower(sys_guid()),?,?)";
					 st= connection.prepareStatement(insertSql);
					 st.setObject(1, jcid);
					 st.setObject(2, wjnr);
					 st.execute();
				 }
				 connection.commit();
				 connection.setAutoCommit(true);//还原
				 JSONObject resultJson = new JSONObject();
				 resultJson.put("code","1");
				 resultJson.put("msg","");
				 resultJson.put("data", "");
				 System.out.print(resultJson.toString());
			 } catch (Exception e) {
				 e.printStackTrace();
				 JSONObject resultJson = new JSONObject();
				 resultJson.put("code","0");
				 resultJson.put("msg",e.getMessage());
				 resultJson.put("data", "");
				 System.out.print(resultJson.toString());
			     try {//事务回滚
			    	 st.close();
			    	 st = null;
			    	 connection.rollback();
			    	 connection.setAutoCommit(true);
			    	 connection.close();
			     } catch (SQLException e1) {
			         e1.printStackTrace();
			     }
			 }finally{
				st.close();
		    	st = null;
				connection.setAutoCommit(true);
				connection.close();
			 }
%>