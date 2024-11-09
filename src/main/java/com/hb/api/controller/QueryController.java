package com.hb.api.controller;

import com.google.gson.Gson;
import com.hb.api.mapper.Res;
import com.hb.api.mapper.ResSuccess;
import com.hb.api.utils.DealJson;
import org.apache.commons.io.IOUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import jakarta.servlet.http.HttpServletRequest;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/rest/query")
public class QueryController {

    private static final Logger logger = LoggerFactory.getLogger(QueryController.class);
    private final Res res = new Res();
    private  final DealJson dealJson = new DealJson();
    private final ResSuccess resSuccess = new ResSuccess();

    @RequestMapping("/{jk}")
    public String queryWithML(HttpServletRequest request, @PathVariable("jk") String jk) {
        return handleRequest(request, jk);
    }
    private Map<String, Object> getRequestParams(HttpServletRequest request) {
        String method = request.getMethod();
        if ("GET".equalsIgnoreCase(method)) {
            return getParams(request, false);
        } else if ("POST".equalsIgnoreCase(method)) {
            return getParams(request, true);
        }  else {
            return getParams(request, true);
        }
    }
    private Map<String, Object> getParams(HttpServletRequest request, Boolean judge) {
        Map<String, Object> map1 = urlParams(request);
        Map<String, Object> map2 = postParams(request);
        if (judge) {
            map1.put("type", "post");
            return objectAssign(map2, map1);
        } else {
            map2.put("type", "get");
            return objectAssign(map1, map2);
        }
    }
    private Map<String, Object> objectAssign(Map<String, Object> target, Map<String, Object> source) {
        if (target == null || target.isEmpty()){
            return  source;
        } else if (source == null || source.isEmpty()) {
            return  target;
        }
        target.putAll(source);
        return target;
    }
    private Map<String, Object> urlParams(HttpServletRequest request) {
        try {
            String data = IOUtils.toString(request.getInputStream(), StandardCharsets.UTF_8);
            Map<String, Object> map = dealJson.jsonToMap(data);
            if (map == null || map.isEmpty()) {
                map = new HashMap<>();
            }
            return map;
        } catch (IOException e) {
            return  new HashMap<>();
        }
    }
    private Map<String, Object> postParams(HttpServletRequest request) {
        Map<String, Object> map = new HashMap<>();
        Map<String, String[]> parameterMap = request.getParameterMap();
        parameterMap.forEach((key, values) -> {
            try {
                map.put(key, dealJson.jsonToMap(values[0]));
            } catch (Exception e) {
                map.put(key, values[0]);
            }
        });
        return  map;
    }
    private String handleRequest(HttpServletRequest request, String path) {
        logger.info("Handling request for path: {}", path);
        Map<String, Object> map = getRequestParams(request);
        Gson gson = new Gson();
        return gson.toJson(map);
    }
}