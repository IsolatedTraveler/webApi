<%@ page language="java" import="java.util.*" contentType="text/html;charset=UTF-8"%><%@ page import="org.springframework.jdbc.core.JdbcTemplate" %><%@ page import="org.springframework.jdbc.core.namedparam.MapSqlParameterSource" %><%@ page import="org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate" %><%@ page import="net.sf.json.JSONArray" %><%@ page import="net.sf.json.JSONObject" %><%@ page import="java.text.SimpleDateFormat" %><%@ page import="org.apache.commons.lang3.StringUtils" %><%@ page import="com.jtwx.jtphis.model.ResultJson" %><%@ page import="java.net.URLEncoder" %><%@ page import="java.net.URLDecoder" %><%@ page import="java.math.BigDecimal" %><%@ page import="com.jtwx.jtphis.utils.NamedParameterJdbcTemplateQuery" %>
<%  
        try{
             MapSqlParameterSource namedParameters = new MapSqlParameterSource();
			 NamedParameterJdbcTemplate namedParameterJdbcTemplate = (NamedParameterJdbcTemplate) request.getAttribute("namedParameterJdbcTemplate");
			 SimpleDateFormat sdYear = new SimpleDateFormat("yyyy-MM-dd");
			 SimpleDateFormat sdFull = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			 String data = (String) request.getAttribute("data");
			 String ywdm = (String) request.getAttribute("ywdm");
			 
			 List list = new ArrayList();
			 ResultJson result = new ResultJson();
			 JSONObject paramJson = JSONObject.fromObject(data);
			 
			 {sqlBody}

			 //Map map = namedParameterJdbcTemplate.queryForMap(countsql, namedParameters);
			 
			 int pageNumber = 1;
			 int pageSize = 10;
			 if(paramJson.containsKey("pageNumber")){//要 分页
				 String pNumber = String.valueOf(paramJson.get("pageNumber"));
				 String pSize = String.valueOf(paramJson.get("pageSize"));
				 String sumColumn = String.valueOf(paramJson.get("sum_column")==null?"":paramJson.get("sum_column"));
				 if(StringUtils.isNotBlank(pNumber)){
					 pageNumber = Integer.valueOf(pNumber);
				 }
				 if(StringUtils.isNotBlank(pSize)){
					 pageSize = Integer.valueOf(pSize);
				 }
				 
				 String countSql = " select count(1) as \"count\" from ("+sql+")";
				 if(StringUtils.isNotBlank(sumColumn)){
					 countSql = " select count(1) as \"count\",sum("+sumColumn+") as \"sum_number\"  from ("+sql+")";
				 }
				 Map countMap = namedParameterJdbcTemplate.queryForMap(countSql, namedParameters);
				 int count = Integer.valueOf(String.valueOf(countMap.get("count")));
				 String sum_number = String.valueOf(countMap.get("sum_number"));
				 //System.out.println("countsql==="+countSql);
				 if(count > 0){
					 String pageSql = " Select tt.* From ( Select a.*,rownum rn From ( ";
				 	 pageSql+= sql;
				 	 pageSql+= ")a) tt Where tt.rn<= "+pageNumber*pageSize+" And tt.rn> "+(pageNumber - 1) * pageSize+"";
				 	 //list = namedParameterJdbcTemplate.queryForList(pageSql, namedParameters);
				 	 list = NamedParameterJdbcTemplateQuery.query(namedParameterJdbcTemplate, pageSql, namedParameters);
				 	 System.out.println("pagesql==="+pageSql);
				 	
				 }
			 	 JSONObject resultJson = new JSONObject();
			 	 JSONObject pageData = new JSONObject();
				 pageData.put("rows", JSONArray.fromObject(list).toString());
			 	 pageData.put("total", count);
			 	 pageData.put("sum_number", sum_number);
			 	 resultJson.put("code","1");
				 resultJson.put("msg","");
				 resultJson.put("data", pageData.toString());
				 System.out.print(resultJson.toString());
			 }else{
				 //list = namedParameterJdbcTemplate.queryForList(sql, namedParameters);
				 NamedParameterJdbcTemplateQuery.queryStream(namedParameterJdbcTemplate, sql, namedParameters,out);
				 //System.out.println(list.size()+"==="+sql);
				 //JSONObject resultJson = new JSONObject();
				 //resultJson.put("data", JSONArray.fromObject(list).toString());
				 //resultJson.put("code","1");
				 //resultJson.put("msg","");
				 System.out.println("ywdm="+ywdm+"  sql===  "+sql);
				 //System.out.println("data==="+resultJson.toString());
				 System.out.println("param==="+data);
				 //out.print(resultJson.toString());
			 }
        }catch(Exception e){
        	e.printStackTrace();
        	JSONObject resultJson = new JSONObject();
        	resultJson.put("code","0");
        	resultJson.put("data","");
        	resultJson.put("msg",e.getMessage());
			out.print(resultJson.toString());
        }
%>