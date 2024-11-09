<%@ page language="java" import="java.util.*" contentType="text/html;charset=UTF-8"%><%@ page import="org.springframework.jdbc.core.JdbcTemplate" %><%@ page import="org.springframework.jdbc.core.namedparam.MapSqlParameterSource" %><%@ page import="org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate" %><%@ page import="net.sf.json.JSONArray" %><%@ page import="net.sf.json.JSONObject" %><%@ page import="java.text.SimpleDateFormat" %><%@ page import="org.apache.commons.lang3.StringUtils" %><%@ page import="com.jtwx.jtphis.model.ResultJson" %><%@ page import="java.net.URLEncoder" %><%@ page import="java.net.URLDecoder" %><%@ page import="java.math.BigDecimal" %><%@ page import="com.jtwx.jtphis.utils.NamedParameterJdbcTemplateQuery" %><%@ page import="java.sql.*" %><%@ page import="org.apache.commons.codec.binary.Base64" %>
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
				 String jlid = String.valueOf(paramJson.getString("jlid"));
				 String bb = String.valueOf(paramJson.getString("bb"));
				 String ryid = String.valueOf(paramJson.getString("ryid"));
				 String xm = String.valueOf(paramJson.getString("xm"));
				 
				 String sql = "DELETE From EMR_ZYJLNR  WHERE jlid=? and bb >=?";
				 st= connection.prepareStatement(sql);
				 st.setObject(1, jlid);
				 st.setObject(2, bb);
				 st.execute();
				 JSONArray jgdatas = new JSONArray();
				 String jgdatastr = paramJson.getString("jgdata");
				 if(StringUtils.isNotBlank(jgdatastr)){
					 jgdatastr = jgdatastr.replaceAll(" ", "+");
					 jgdatastr = new String(Base64.decodeBase64(jgdatastr.getBytes("UTF-8")),"UTF-8");
					 jgdatas = JSONArray.fromObject(jgdatastr);
				 }
				 //String nrdata = String.valueOf(paramJson.getJSONObject("nrdata"));
				 for(int i = 0 ; i < jgdatas.size();i++){
					JSONArray jgdata = (JSONArray) jgdatas.get(i);
					String v_id= String.valueOf(jgdata.getString(0));
					String jgSql = "";
					if(StringUtils.isBlank(v_id)){
						jgSql = "INSERT INTO EMR_ZYJLNR (ID,jlid,BB,DXXH,FDXXH,YSID,DXID,DXMC,DXNR,SFHH) VALUES (sys_guid(),?,?,?,?,?,?,?,?,?)";
						st= connection.prepareStatement(jgSql);
						st.setObject(1, String.valueOf(jgdata.get(1)));
						st.setObject(2, Integer.valueOf((String) jgdata.get(2)));
						st.setObject(3, bb);
						st.setObject(4, Integer.valueOf((String) jgdata.get(3)));
						st.setObject(5, String.valueOf(jgdata.get(4)));
						st.setObject(6, String.valueOf(jgdata.get(5)));
						st.setObject(7, String.valueOf(jgdata.get(6)));
						st.setObject(8, String.valueOf(jgdata.get(7)));
						st.setObject(9, Integer.valueOf((String) jgdata.get(8)));
						st.execute();
					}else{
						jgSql = "INSERT INTO EMR_ZYJLNR (ID,jlid,BB,DXXH,FDXXH,YSID,DXID,DXMC,DXNR,SFHH) VALUES (?,?,?,?,?,?,?,?,?,?)";
						st= connection.prepareStatement(jgSql);
						st.setObject(1, String.valueOf(jgdata.get(0)) );
						st.setObject(2, String.valueOf(jgdata.get(1)) );
						st.setObject(3, bb);
						st.setObject(4, Integer.valueOf((String) jgdata.get(2)) );
						st.setObject(5, Integer.valueOf((String) jgdata.get(3)) );
						st.setObject(6, String.valueOf(jgdata.get(4)) );
						st.setObject(7, String.valueOf(jgdata.get(5)) );
						st.setObject(8, String.valueOf(jgdata.get(6)) );
						st.setObject(9, String.valueOf(jgdata.get(7)) );
						st.setObject(10, Integer.valueOf((String) jgdata.get(8)) );
						st.execute();
					}
				}
				String blnr = String.valueOf(paramJson.getString("nrdata"));
				String blsql = "update Emr_ZyjlGS set bb=?,nr=?,xgrid=?,xgrxm=?,xgsj=sysdate where jlid=?";
				st= connection.prepareStatement(blsql);
				st.setObject(1, bb);
				st.setObject(2, blnr);
				st.setObject(3, ryid);
				st.setObject(4, xm);
				st.setObject(5, jlid);
				int updateRows = st.executeUpdate();
				if(updateRows == 0){
					String gssql = "insert into Emr_ZyjlGS(bb,nr,cjrid,cjrxm,jlid,cjsj) VALUES (?,?,?,?,?,sysdate)";
					st= connection.prepareStatement(gssql);
					st.setObject(1, bb);
					st.setObject(2, blnr);
					st.setObject(3, ryid);
					st.setObject(4, xm);
					st.setObject(5, jlid);
					st.execute();
				 }
				 String gssql = "update EMR_ZYJL set bb=? where id=? and bb<>?";
				 st= connection.prepareStatement(gssql);
				 st.setObject(1, bb);
				 st.setObject(2, jlid);
				 st.setObject(3, bb);
				 st.execute();
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