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
				 String jlid = String.valueOf(paramJson.getString("jlid"));
				 String sql = "DELETE From EMR_FWNR  WHERE jlid=?";
				 st= connection.prepareStatement(sql);
				 st.setObject(1, jlid);
				 st.execute();
				 JSONArray jgdatas = new JSONArray();
				 String jgdatastr = paramJson.getString("jgdata");
				 System.out.println("jgdatastr...."+jgdatastr);
				 if(StringUtils.isNotBlank(jgdatastr)){
					 jgdatastr = jgdatastr.replaceAll(" ", "+");
					 jgdatastr = new String(Base64.decodeBase64(jgdatastr.getBytes("UTF-8")),"UTF-8");
					 jgdatas = JSONArray.fromObject(jgdatastr);
				 }
				 for(int i = 0 ; i < jgdatas.size();i++){
					JSONArray jgdata = (JSONArray) jgdatas.get(i);
					String v_id= String.valueOf(jgdata.getString(0));
					String jgSql = "";
					if(StringUtils.isBlank(v_id)){
						jgSql = "INSERT INTO EMR_FWNR (ID,jlid,DXXH,FDXXH,YSID,DXID,DXMC,DXNR,SFHH) VALUES (getseq('EMR_FWNR'),?,?,?,?,?,?,?,?)";
						st= connection.prepareStatement(jgSql);
						st.setObject(1, String.valueOf(jgdata.get(1)));
						st.setObject(2, Integer.valueOf((String) jgdata.get(2)));
						st.setObject(3, jgdata.get(3));
						st.setObject(4, String.valueOf(jgdata.get(4)));
						st.setObject(5, String.valueOf(jgdata.get(5)));
						st.setObject(6, String.valueOf(jgdata.get(6)));
						st.setObject(7, String.valueOf(jgdata.get(7)));
						st.setObject(8, Integer.valueOf((String) jgdata.get(8)));
						st.execute();
					}else{
						jgSql = "INSERT INTO EMR_FWNR (ID,jlid,DXXH,FDXXH,YSID,DXID,DXMC,DXNR,SFHH) VALUES (?,?,?,?,?,?,?,?,?)";
						st= connection.prepareStatement(jgSql);
						st.setObject(1, String.valueOf(jgdata.get(0)) );
						st.setObject(2, String.valueOf(jgdata.get(1)) );
						st.setObject(3, Integer.valueOf((String) jgdata.get(2)) );
						st.setObject(4, jgdata.get(3));
						st.setObject(5, String.valueOf(jgdata.get(4)) );
						st.setObject(6, String.valueOf(jgdata.get(5)) );
						st.setObject(7, String.valueOf(jgdata.get(6)) );
						st.setObject(8, String.valueOf(jgdata.get(7)) );
						st.setObject(9, Integer.valueOf((String) jgdata.get(8)) );
						st.execute();
					}
				}
				String blnr = String.valueOf(paramJson.getString("nrdata"));
				String blsql = "update EMR_FWGS set bbid=sys_guid(),nr=? where jlid=?";
				st= connection.prepareStatement(blsql);
				st.setObject(1, blnr);
				st.setObject(2, jlid);
				int updateRows = st.executeUpdate();
				if(updateRows == 0){
					String gssql = "insert into EMR_FWGS(bbid,nr,jlid) VALUES (sys_guid(),?,?)";
					st= connection.prepareStatement(gssql);
					st.setObject(1, blnr);
					st.setObject(2, jlid);
					st.execute();
				 }
				 connection.commit();
				 connection.setAutoCommit(true);//还原
				 JSONObject resultJson = new JSONObject();
				 resultJson.put("code","1");
				 resultJson.put("msg","保存成功");
				 System.out.print(resultJson.toString());
			 } catch (Exception e) {
				 e.printStackTrace();
				 JSONObject resultJson = new JSONObject();
				 resultJson.put("code","0");
				 resultJson.put("msg",e.getMessage());
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