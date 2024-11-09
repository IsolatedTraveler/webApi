package com.hb.api.controller;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/rest")
public class PayController {
    @RequestMapping("h5payuserinfo")
    public String payUserInfo(HttpServletRequest request, HttpServletResponse response)
    {
        return "payUserInfo";
    }
}
