<%@page import="org.apache.poi.util.SystemOutLogger"%>
<%@ page language="java" import="java.util.*" contentType="text/html;charset=UTF-8"%>
<%@ page import="org.springframework.jdbc.core.JdbcTemplate" %>
<%@ page import="org.springframework.jdbc.core.namedparam.MapSqlParameterSource" %>
<%@ page import="org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate" %>
<%@ page import="net.sf.json.JSONArray" %><%@ page import="net.sf.json.JSONObject" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="org.apache.commons.lang3.StringUtils" %>
<%@ page import="com.jtwx.jtphis.model.ResultJson" %>
<%@ page import="java.net.URLEncoder" %>
<%@ page import="java.net.URLDecoder" %>
<%@ page import="java.math.BigDecimal" %>
<%@ page import="com.jtwx.jtphis.utils.NamedParameterJdbcTemplateQuery" %>
<%@ page import="javax.servlet.http.HttpServletResponse" %>
<%@ page import="javax.servlet.ServletOutputStream" %>
<%@ page import="org.apache.poi.hssf.usermodel.HSSFWorkbook" %>
<%@ page import="org.apache.poi.ss.util.WorkbookUtil" %>
<%@ page language="java" import="org.apache.poi.ss.usermodel.*" contentType="text/html;charset=UTF-8"%>
<%  
        try{
             MapSqlParameterSource namedParameters = new MapSqlParameterSource();
			 NamedParameterJdbcTemplate namedParameterJdbcTemplate = (NamedParameterJdbcTemplate) request.getAttribute("namedParameterJdbcTemplate");
			 SimpleDateFormat sdYear = new SimpleDateFormat("yyyy-MM-dd");
			 SimpleDateFormat sdFull = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss");
			 String data = (String) request.getAttribute("data");
			 String title = (String) request.getAttribute("title");
			 String filename = (String) request.getAttribute("filename");
			 String ywdm = (String) request.getAttribute("ywdm");
			 ServletOutputStream outSTr = null;
			 
			 List list = new ArrayList();
			 Map map = new HashMap();
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
					 String pageSql = "select aa.* from ( Select tt.* From ( Select a.*,rownum rn From ( ";
				 	 pageSql+= sql;
				 	 pageSql+= ")a) tt Where tt.rn<= "+pageNumber*pageSize+") aa ";
				 	 pageSql+= " where aa.rn >= "  +((pageNumber - 1) * pageSize + 1) + "";
				 	 //list = namedParameterJdbcTemplate.queryForList(pageSql, namedParameters);
				 	 list = NamedParameterJdbcTemplateQuery.query(namedParameterJdbcTemplate, pageSql, namedParameters);
				 	 //System.out.println("pagesql==="+pageSql);
					 JSONObject resultJson = new JSONObject();
					 Workbook wb = new HSSFWorkbook();
					 String excel = WorkbookUtil.createSafeSheetName(filename);
					 Sheet excelSheet = wb.createSheet(excel);
					 CellStyle style=wb.createCellStyle();
			         Font font=wb.createFont();
			         font.setBold(true);
			         style.setFont(font);
			         Row excelRow = excelSheet.createRow(0);
			         JSONObject titleJson = JSONObject.fromObject(title);
			         
			 		Iterator iterator = titleJson.keys();
			 		String keyStr = "";
			 		String valStr = "";
			 		while(iterator.hasNext()){
			            String key = (String) iterator.next();
			            keyStr += key+",";
			            String value = titleJson.getString(key);
			            valStr += value+","; 
			 		}
			 		String [] keyArray = keyStr.split(",");
			 		String [] valArray = valStr.split(",");
			 		for(int i = 0 ; i < valArray.length ; i++){//表头行
						if(StringUtils.isNotBlank(valArray[i])){
							excelRow.createCell(i).setCellValue(valArray[i]);
						}
					}
			 		
			 		JSONArray resultArray = JSONArray.fromObject(list);
					for(int a = 0 ; a < resultArray.size() ; a++){
						JSONObject jsonObj = resultArray.getJSONObject(a);
						Row dataRow = excelSheet.createRow(a+1);
						for(int b = 0 ; b < keyArray.length ; b++){
							dataRow.createCell(b).setCellValue(jsonObj.getString(keyArray[b]));
						}
						
					}
			 		
					response.addHeader("Content-Disposition", "attachment;filename=" + new String((filename+".xls").getBytes("GB2312"), "ISO8859-1"));
					outSTr = response.getOutputStream();
					wb.write(outSTr);
					outSTr.close();
				 }
			 }else{
				 //System.out.println("--11---"+sql);
				 list = NamedParameterJdbcTemplateQuery.query(namedParameterJdbcTemplate, sql, namedParameters);
				 //System.out.println("--LIST SIZE---"+list.size());
				 JSONObject resultJson = new JSONObject();
				 Workbook wb = new HSSFWorkbook();
				 String excel = WorkbookUtil.createSafeSheetName(filename);
				 Sheet excelSheet = wb.createSheet(excel);
				 CellStyle style=wb.createCellStyle();
		         Font font=wb.createFont();
		         font.setBold(true);
		         style.setFont(font);
		         Row excelRow = excelSheet.createRow(0);
		         JSONObject titleJson = JSONObject.fromObject(title);
		         
		 		Iterator iterator = titleJson.keys();
		 		String keyStr = "";
		 		String valStr = "";
		 		while(iterator.hasNext()){
		            String key = (String) iterator.next();
		            keyStr += key+",";
		            String value = titleJson.getString(key);
		            valStr += value+","; 
		 		}
		 		String [] keyArray = keyStr.split(",");
		 		String [] valArray = valStr.split(",");
		 		for(int i = 0 ; i < valArray.length ; i++){//表头行
					if(StringUtils.isNotBlank(valArray[i])){
						//System.out.println("--LIST title---"+valArray[i]);
						excelRow.createCell(i).setCellValue(valArray[i]);
					}
				}
		 		
		 		JSONArray resultArray = JSONArray.fromObject(list);
				for(int a = 0 ; a < resultArray.size() ; a++){
					JSONObject jsonObj = resultArray.getJSONObject(a);
					Row dataRow = excelSheet.createRow(a+1);
					for(int b = 0 ; b < keyArray.length ; b++){
						String tempValue = jsonObj.getString(keyArray[b]);
						if(StringUtils.isNotBlank(tempValue) && !"null".equals(tempValue)){
							dataRow.createCell(b).setCellValue(tempValue);
						}else{
							dataRow.createCell(b).setCellValue("");
						}
					}
					
				}
		 		
				response.setHeader("Content-Disposition", "attachment;filename=" + new String((filename+".xls").getBytes("GB2312"), "ISO8859-1"));
		        response.setContentType("application/msexcel");// 定义输出类型   
		        response.setCharacterEncoding("GBK");
				outSTr = response.getOutputStream();
				wb.write(outSTr);
				outSTr.close();
			 }
        }catch(Exception e){
        	e.printStackTrace();
        }
%>