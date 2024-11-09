<%@ page import="java.util.*" pageEncoding="UTF-8"%>
<%@ page import="org.springframework.jdbc.core.namedparam.MapSqlParameterSource" %>
<%@ page import="org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate" %>  
<%@ page import="net.sf.json.JSONArray" %>
<%
        try{
             MapSqlParameterSource namedParameters = new MapSqlParameterSource();
			 NamedParameterJdbcTemplate namedParameterJdbcTemplate = (NamedParameterJdbcTemplate) request.getAttribute("namedParameterJdbcTemplate");

		     String sql="select 1 as test from dual";


			 List list = namedParameterJdbcTemplate.queryForList(sql, namedParameters);
			 System.out.println(sql);
			 JSONArray jArray = JSONArray.fromObject(list);
			 System.out.print(jArray.toString());
        }catch(Exception e){
        	 e.printStackTrace();
			 System.out.print(e.getMessage());
        }
%>