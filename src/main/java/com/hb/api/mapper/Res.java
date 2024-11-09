package com.hb.api.mapper;

import com.hb.api.utils.DealJson;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Res {
    private final DealJson dealJson = new DealJson();
    private int code;
    private String message;
    private List<Map<String, Object>> data;
    private int total;

    public void setCode(int code) {
        this.code = code;
    }

    public void setMessage(String message) {
        this.message = message;
    }
    public void setData(List<Map<String, Object>> data) {
        this.data = data;
    }
    public void setTotal(int total) {
        this.total = total;
    }
    public String getRes() {
        Map<String, Object> map = new HashMap<>();
        map.put("code", this.code);
        map.put("data", this.data);
        map.put("total", this.total);
        map.put("message", this.message);
        return dealJson.mapToJson(map);
    }

}
