<%@ page import="java.util.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate" %>
<%@ page import="org.springframework.jdbc.core.namedparam.MapSqlParameterSource" %>
<%@ page import="org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate" %>
<%@ page import="net.sf.json.JSONArray" %>
<%@ page import="net.sf.json.JSONObject" %>
<%@ page import="com.jtwx.jtphis.utils.NamedParameterJdbcTemplateQuery" %>
<%  
			 try {
				 JSONObject resultJson = new JSONObject();
				 NamedParameterJdbcTemplate namedParameterJdbcTemplate = (NamedParameterJdbcTemplate) request.getAttribute("namedParameterJdbcTemplate");
				 JdbcTemplate jdbcTemplate = (JdbcTemplate) request.getAttribute("jdbcTemplate");
				 String data = (String) request.getAttribute("data");
				 JSONObject paramJson = JSONObject.fromObject(data);
				 String sfzh = String.valueOf(paramJson.getString("sfzh"));
				 String dasql = " Select a.Daid, a.Sfzh, a.Xm, To_Char(a.Csrq, 'yyyy-mm-dd') As Csrq, a.Xbbm, a.Dazt, a.Yljgdm, b.Yymc, a.Lxdh, a.Xzz, a.Mzbm,";
				       dasql += " To_Char(Jdrq, 'yyyy-mm-dd') As Jdrq,a.gridid";
					   dasql += " From Subject_Jkda.Tb_Chss_Grjbxx a,";
				       dasql += " Subject_Jkda.Tb_Dic_Gy_Yljgdm b";
					   dasql += " Where a.Yljgdm = b.Yyzcid";
					   dasql += " And a.Sfzh =:sfzh";
					   MapSqlParameterSource namedParameters = new MapSqlParameterSource();
					   namedParameters.addValue("sfzh", sfzh);
					   List list = NamedParameterJdbcTemplateQuery.query(namedParameterJdbcTemplate, dasql, namedParameters);
					   if(list.isEmpty() || list.size() < 1){
						   resultJson.put("code","2");
						   resultJson.put("msg","没有查询 到档案信息");
					   }
					  JSONArray array = new JSONArray();
					  for(int i = 0 ; i < list.size() ; i++){
						  Map damap = (Map) list.get(i);
				    	 String daid = String.valueOf(damap.get("daid"));
				    	 String gxysql = "Select To_Char(Max(b.Sfrq), 'yyyy-mm-dd') As Sfrq,";
				    	 		gxysql+=" To_Char(Max(b.Xcsfrq), 'yyyy-mm-dd') As Xcsfrq, a.Glkid";
				    	 		gxysql+=" From Subject_Jkda.Tb_Jbgl_Gxysqbg a, Subject_Jkda.Tb_Jbgl_Gxysqsfgl b";
				    	 		gxysql+=" Where a.Glkid = b.Glkid(+)";
				    	 		gxysql+=" And a.Daid =:daid";
				    	 		gxysql+=" group by a.glkid";
				    	 		
				    	 MapSqlParameterSource namedParametersgxy = new MapSqlParameterSource();
				    	 namedParametersgxy.addValue("daid", daid);
						 List gxyList = NamedParameterJdbcTemplateQuery.query(namedParameterJdbcTemplate, gxysql, namedParametersgxy);
						 Map gxyMap = new HashMap();
						 if(!gxyList.isEmpty() && gxyList.size() > 0){
							 gxyMap = (Map) gxyList.get(0);
						 }
						 damap.put("gxy", gxyMap);
						 String tnbsql = "Select To_Char(Max(b.Sfrq), 'yyyy-mm-dd') As Sfrq,";
								 tnbsql+=" To_Char(Max(b.Xcsfrq), 'yyyy-mm-dd') As Xcsfrq, a.Glkid";
								 tnbsql+=" From Subject_Jkda.Tb_Jbgl_Tnbsqbg a, Subject_Jkda.Tb_Jbgl_Tnbsqsfgl b";
								 tnbsql+=" Where a.Glkid = b.Glkid(+)";
								 tnbsql+=" And a.Daid =:daid";
								 tnbsql+=" group by a.glkid";
			    	 		
				    	 MapSqlParameterSource namedParameterstnb = new MapSqlParameterSource();
				    	 namedParameterstnb.addValue("daid", daid);
						 List tnbList = NamedParameterJdbcTemplateQuery.query(namedParameterJdbcTemplate, tnbsql, namedParameterstnb);
						 Map tnbMap = new HashMap();
						 if(!tnbList.isEmpty() && tnbList.size() > 0){
							 tnbMap = (Map) tnbList.get(0);
						 }
						 damap.put("tnb", tnbMap);
					 
					 String jsbsql = "Select To_Char(Max(b.Sfrq), 'yyyy-mm-dd') As Sfrq,";
					 jsbsql+="  To_Char(Max(b.Xcsfrq), 'yyyy-mm-dd') As Xcsfrq, a.jsjbglkid as glkid ";
					 jsbsql+=" From Subject_Jkda.Tb_Jbgl_Jsbkfdj a, Subject_Jkda.Tb_Jbgl_Jsbkfjl b";
					 jsbsql+=" Where a.jsjbglkid = b.jsjbglkid(+)";
					 jsbsql+=" And a.Daid =:daid";
					 jsbsql+=" group by a.jsjbglkid";
		 		
			    	 MapSqlParameterSource namedParametersjsb = new MapSqlParameterSource();
			    	 namedParametersjsb.addValue("daid", daid);
					 List jsbList = NamedParameterJdbcTemplateQuery.query(namedParameterJdbcTemplate, jsbsql, namedParametersjsb);
					 Map jsbMap = new HashMap();
					 if(!jsbList.isEmpty() && jsbList.size() > 0){
						 jsbMap = (Map) jsbList.get(0);
					 }
					 damap.put("jsb", jsbMap);
					 
					 
					 String fjhsql = " Select  max(a.glkid) glkid";
					 fjhsql+="  From Subject_Jkda.Tb_Jbgl_Fjhglk a";
					 fjhsql+=" Where a.Daid =:daid";
					 fjhsql+=" group by glkid";
		 		
			    	 MapSqlParameterSource namedParametersfjh = new MapSqlParameterSource();
			    	 namedParametersfjh.addValue("daid", daid);
					 List fjhList = NamedParameterJdbcTemplateQuery.query(namedParameterJdbcTemplate, fjhsql, namedParametersfjh);
					 Map fjhMap = new HashMap();
					 if(!fjhList.isEmpty() && fjhList.size() > 0){
						 fjhMap = (Map) fjhList.get(0);
					 }
					 damap.put("fjh", fjhMap);
					 JSONObject object = JSONObject.fromObject(damap);
					 array.add(i,object);
			     }
				 resultJson.put("code","1");
				 resultJson.put("msg","");
				 resultJson.put("data", array.toString());
				 System.out.print(resultJson.toString());
			 } catch (Exception e) {
				 e.printStackTrace();
				 JSONObject resultJson = new JSONObject();
				 resultJson.put("code","0");
				 resultJson.put("msg",e.getMessage());
				 resultJson.put("data", "");
				 System.out.print(resultJson.toString());
			 }
%>