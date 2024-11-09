package com.hb.api.utils;

import com.google.gson.Gson;
import com.google.gson.reflect.TypeToken;

import java.lang.reflect.Type;
import java.util.Map;

public class DealJson {

    private static final Gson gson = new Gson();


    public Map<String, Object> jsonToMap(String json) {
        Type type = new TypeToken<Map<String, Object>>(){}.getType();
        return gson.fromJson(json, type);
    }

    public String mapToJson(Map<String, Object> map) {
        return gson.toJson(map);
    }
}