package com.hb.api.utils;

import cn.hutool.core.codec.Base64;
import cn.hutool.core.date.DateUtil;
import cn.hutool.crypto.digest.DigestUtil;
import cn.hutool.crypto.symmetric.DES;
import cn.hutool.http.HttpResponse;
import cn.hutool.http.HttpUtil;

import java.math.BigInteger;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
public class cs {
    private static String url = "http://10.92.0.72:9090/dmp/ws/CommonWebServiceTransferCqjkzx?wsdl";
    private static String token = "597fca97-8bb2-42ff-b5ae-c54c7a8e5e53";
    private static String userName = "51300119731230083X";
    private static String passWord = "88888888";
    private static String getXml() {
        return  "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
                + "<DataExchange>"
                + "<eventHead>"
                + "<eventId>d7b257d8-354a-4746-9084-fa823b06a05a</eventId>"
                + "<entityName>IDR</entityName>"
                + "<operateType>Add</operateType>"
                + "</eventHead>"
                + "<eventBody>"
                + "<BaseInfo>"
                + "<BirthDate>1987-01-01</BirthDate>"
                + "<BirthDateString>1987-01-01</BirthDateString>"
                + "<CardFillingTime>2021-06-30</CardFillingTime>"
                + "<CardFillingTimeString>2021-06-30</CardFillingTimeString>"
                + "<CardID></CardID>"
                + "<CardNotes><![CDATA[]]></CardNotes>"
                + "<CODRIS_OccupationCode></CODRIS_OccupationCode>"
                + "<Country>中国大陆</Country>"
                + "<CreatingTime>2021-06-30 21:38:11</CreatingTime>"
                + "<CreatingTimeString>2021-06-30</CreatingTimeString>"
                + "<DeathDate>2021-06-30</DeathDate>"
                + "<DeathDateString>2021-06-30</DeathDateString>"
                + "<DeathPlaceCode></DeathPlaceCode>"
                + "<DiagnosisDate>2021-06-30 21:08:11</DiagnosisDate>"
                + "<DiagnosisDateString>2021-06-30</DiagnosisDateString>"
                + "<DiagnosisTypeCode>3</DiagnosisTypeCode>"
                + "<DiagnosisTypeName>疑似病例</DiagnosisTypeName>"
                + "<DiseaseCause></DiseaseCause>"
                + "<DiseaseCode>A16.1</DiseaseCode>"
                + "<DiseaseName>无病原学结果</DiseaseName>"
                + "<DomicileAddressAttributionCode>01</DomicileAddressAttributionCode>"
                + "<DomicileAddressAttributionName>本县区</DomicileAddressAttributionName>"
                + "<DomicileAddressCode>52038206</DomicileAddressCode>"
                + "<DomicileAddressName>贵州省遵义市仁怀市五马镇</DomicileAddressName>"
                + "<DomicileAdrressDetails>贵州省遵义市仁怀市五马镇鱼孔村</DomicileAdrressDetails>"
                + "<EducationLevelCode></EducationLevelCode>"
                + "<EducationLevelName></EducationLevelName>"
                + "<EmployerOrgName></EmployerOrgName>"
                + "<FillingDoctorName>蒲冰霜</FillingDoctorName>"
                + "<GenderCode>1</GenderCode>"
                + "<GenderName>男</GenderName>"
                + "<GuardianName>雷明</GuardianName>"
                + "<Hospitalnum>12010284</Hospitalnum>"
                + "<IDCardCode>522130198701014291</IDCardCode>"
                + "<IDCardType>01</IDCardType>"
                + "<IDR_OccupationCode>18</IDR_OccupationCode>"
                + "<LifeTimeAddr></LifeTimeAddr>"
                + "<LifeTimeAddrTypeCode></LifeTimeAddrTypeCode>"
                + "<LifeTimeVillageCode></LifeTimeVillageCode>"
                + "<LifeTimeZoneCode></LifeTimeZoneCode>"
                + "<LivingAddressAttributionCode>01</LivingAddressAttributionCode>"
                + "<LivingAddressAttributionName>本县区</LivingAddressAttributionName>"
                + "<LivingAddressCode>52038206</LivingAddressCode>"
                + "<LivingAddressDetails>贵州省遵义市仁怀市五马镇鱼孔村</LivingAddressDetails>"
                + "<LivingAddressName>贵州省遵义市仁怀市五马镇</LivingAddressName>"
                + "<MaritalStatusCode></MaritalStatusCode>"
                + "<MaritalStatusName></MaritalStatusName>"
                + "<NationCode></NationCode>"
                + "<NationName></NationName>"
                + "<NCD_OccupationCode></NCD_OccupationCode>"
                + "<OccupationName>家务及待业</OccupationName>"
                + "<OrgCode>520382002</OrgCode>"
                + "<OrgCountyCode>52038200</OrgCountyCode>"
                + "<OrgCountyName>贵州省遵义市仁怀市</OrgCountyName>"
                + "<OrgName>仁怀市人民医院</OrgName>"
                + "<OtherOccupationName></OtherOccupationName>"
                + "<PatientName>杨龙江</PatientName>"
                + "<RegisterVillageCode></RegisterVillageCode>"
                + "<TeleCom>18985228516</TeleCom>"
                + "</BaseInfo>"
                + "<ForColor>Black</ForColor>"
                + "<GjMsg></GjMsg>"
                + "<IDRCard>"
                + "<CaseClassificationCode>3</CaseClassificationCode>"
                + "<CaseClassificationName>2021-06-30</CaseClassificationName>"
                + "<CloseContactsSymptomCode>0</CloseContactsSymptomCode>"
                + "<CloseContactsSymptomName>无</CloseContactsSymptomName>"
                + "<Customer>522130197607240027</Customer>"
                + "<NewPneumSeverityCode></NewPneumSeverityCode>"
                + "<NewPneumSeverityName></NewPneumSeverityName>"
                + "<OnsetDate>2021-06-30</OnsetDate>"
                + "<OtherDiseaseName></OtherDiseaseName>"
                + "</IDRCard>"
                + "<Order>4</Order>"
                + "<OrgCountyCode>52038200</OrgCountyCode>"
                + "<OrgCountyName>贵州省遵义市仁怀市</OrgCountyName>"
                + "</eventBody>"
                + "</DataExchange>";
    }
    private static String buildRequestXml( String signature, String timestamp, String nonce, String data) {
        // MD5 加密数据
        String dataMD5 = DigestUtil.md5Hex(data);
        // DES 加密数据
        DES des = new DES((token + timestamp).getBytes(StandardCharsets.UTF_8));
        byte[] encodedData = des.encrypt(data.getBytes(StandardCharsets.UTF_8));
        String encodedDataBase64 = Base64.encode(encodedData);
        return "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ser=\"http://service.webService.sinosoft.com.cn/\">" +
                "<soap:Header/>" +
                "<soap:Body>" +
                "<ser:transferDataToDmp>" +
                "<userName>" + userName + "</userName>" +
                "<passWord>" + passWord + "</passWord>" +
                "<signature>" + signature + "</signature>" +
                "<timestamp>" + timestamp + "</timestamp>" +
                "<nonce>" + nonce + "</nonce>" +
                "<dataMD5>" + dataMD5 + "</dataMD5>" +
                "<data>" + encodedDataBase64 + "</data>" +
                "</ser:transferDataToDmp>" +
                "</soap:Body>" +
                "</soap:Envelope>";
    }
    private static String buildRequestQueryXml( String signature, String timestamp, String nonce, String eventId) {
        return "<soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:ser=\"http://service.webService.sinosoft.com.cn/\">" +
                "<soap:Header/>" +
                "<soap:Body>" +
                "<ser:transferDataToDmp>" +
                "<userName>" + userName + "</userName>" +
                "<passWord>" + passWord + "</passWord>" +
                "<signature>" + signature + "</signature>" +
                "<timestamp>" + timestamp + "</timestamp>" +
                "<nonce>" + nonce + "</nonce>" +
                "<eventId>" + eventId + "</eventId>" +
                "</ser:transferDataToDmp>" +
                "</soap:Body>" +
                "</soap:Envelope>";
    }
    private static Map<String,Object> getRes( String requestXml, String timestamp) {
        Map<String, Object> res = new HashMap<>();
        // 创建 WebService 客户端
        HttpResponse response = HttpUtil.createPost("http://10.92.0.72:9090/dmp/ws/CommonWebServiceTransferCqjkzx?wsdl")
                .header("Content-Type", "text/xml; charset=UTF-8")
                .body(requestXml)
                .execute();
        res.put("data", requestXml);
        return  res;
        // 处理响应
//        if (response.isOk()) {
//            // DES 解密响应数据
//            String responseXml = response.body();
//            String returnData = responseXml.substring(responseXml.indexOf("<return>") + 8, responseXml.indexOf("</return>"));
//            DES des = new DES((token + timestamp).getBytes(StandardCharsets.UTF_8));
//            byte[] decodedData = Base64.decode(returnData);
//            String decryptedData = new String(des.decrypt(decodedData), StandardCharsets.UTF_8);
//            Map<String, Object> responseXmlToMap = XmlUtil.xmlToMap(decryptedData);
//            res.put("data", responseXmlToMap);
//        } else {
//            res.put("code", -1);
//            res.put("message", "第三方服务返回错误：" + response.getStatus());
//        }
//        return res;
    }
    public static Map<String,Object> csal1() {
        try {
            // XML 数据
            String eventId = "123456";
            // 生成时间戳和随机数
            String timestamp = DateUtil.format(DateUtil.date(), "yyyyMMddHHmmss");
            String nonce = UUID.randomUUID().toString();
            // 生成签名
            String signature = new BigInteger(DigestUtil.sha1((timestamp + nonce + token).getBytes(StandardCharsets.UTF_8))).toString(64);
            // 构建请求参数
            String requestXml = buildRequestQueryXml(signature, timestamp, nonce, eventId);
            return getRes( requestXml, timestamp);
        } catch (Exception e) {
            Map<String, Object> res = new HashMap<>();
            res.put("code", -1);
            res.put("message", "报错：" + e.toString());
            return res;
        }
    }
    public static Map<String, Object> csal() {
        try {
            // XML 数据
            String data = getXml();
            // 生成时间戳和随机数
            String timestamp = "1730974759";
            String nonce = "9d8b364e797047caaf50cc7ea269ea33";
            String[] arr = new String[]{timestamp , nonce , token};
            Arrays.sort(arr);
            StringBuffer content = new StringBuffer();
            for (int i = 0; i < arr.length; i++) {
                content.append(arr[i]);
            }
            // 生成签名
            String signature = new BigInteger(DigestUtil.sha1((content.toString()).getBytes(StandardCharsets.UTF_8))).toString(64);
            // 构建请求参数

            String requestXml = buildRequestXml(signature, timestamp, nonce, data);
            // 创建 WebService 客户端
            Map<String, Object> res = new HashMap<>();
            res.put("xml", token + timestamp);
            return res;
//            return getRes( requestXml, timestamp);
        } catch (Exception e) {
            Map<String, Object> res = new HashMap<>();
            res.put("code", -1);
            res.put("message", "报错：" + e.toString());
            return res;
        }
    }
}