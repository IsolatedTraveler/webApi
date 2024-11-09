package com.hb.api.controller;

import jakarta.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.client.RestTemplate;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.Enumeration;

@RestController
public class RouteController {

    private final String proxyUrl;
    private final RestTemplate restTemplate;

    @Autowired
    public RouteController(@Value("${proxy.url}") String proxyUrl, RestTemplate restTemplate) {
        this.proxyUrl = proxyUrl;
        this.restTemplate = restTemplate;
    }

    @RequestMapping("/")
    public String index() {
        return "forward:/index.html";
    }

    @RequestMapping("/**")
    public ResponseEntity<?> forwardRequests(HttpServletRequest request) {
        try {
            String path = request.getRequestURI().substring(1); // 去掉第一个斜杠
            String fullPath = proxyUrl + path; // 构建目标URL

            // 获取请求方法
            String methodString = request.getMethod();
            HttpMethod method = HttpMethod.valueOf(methodString);

            // 创建HTTP头信息
            HttpHeaders headers = new HttpHeaders();
            Enumeration<String> headerNames = request.getHeaderNames();
            while (headerNames.hasMoreElements()) {
                String headerName = headerNames.nextElement();
                Enumeration<String> headersValues = request.getHeaders(headerName);
                while (headersValues.hasMoreElements()) {
                    headers.add(headerName, headersValues.nextElement());
                }
            }
            // 读取请求体
            StringBuilder requestBody = new StringBuilder();
            if ("POST".equalsIgnoreCase(methodString)) {
                try (BufferedReader reader = request.getReader()) {
                    String line;
                    while ((line = reader.readLine()) != null) {
                        requestBody.append(line);
                    }
                }
            }

            // 处理GET请求参数
            if (method == HttpMethod.GET && request.getQueryString() != null) {
                fullPath += "?" + request.getQueryString() ;
            }

            System.out.println("fullPath: " + fullPath);
            // 创建请求实体
            HttpEntity<String> entity = new HttpEntity<>(requestBody.toString(), headers);

            // 使用RestTemplate发起请求
            ResponseEntity<String> response = restTemplate.exchange(
                    fullPath,
                    method,
                    entity,
                    String.class
            );

            // 返回响应给客户端
            return ResponseEntity.status(response.getStatusCode())
                    .headers(response.getHeaders())
                    .body(response.getBody());

        } catch (IOException e) {
            return ResponseEntity.status(500).body("Internal Server Error: " + e.getMessage());
        } catch (Exception e) {
            return ResponseEntity.status(500).body("Unknown Error: " + e.getMessage());
        }
    }
}