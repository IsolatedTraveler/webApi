package com.hb.api.utils;
import java.math.BigInteger;
import java.security.MessageDigest;
import java.util.Arrays;
import java.math.BigInteger;

public class SHA {
    private static final String KEY_SHA = "SHA-1";
    public static byte[] encryptSHA(byte[] data) throws Exception {

        MessageDigest sha = MessageDigest.getInstance(KEY_SHA);
        sha.update(data);
        //增加一位，解决符号问题
        byte[] _val = sha.digest();
        byte[] val = new byte[_val.length+1];
        val[0] = 0;
        for(int i=1;i<val.length;i++){
            val[i] = _val[i-1];
        }
        return val;
    }
    public static byte[] encryptSHA1(byte[] data) throws Exception {

        MessageDigest sha = MessageDigest.getInstance(KEY_SHA);
        sha.update(data);
        //增加一位，解决符号问题
        byte[] _val = sha.digest();
        byte[] val = new byte[_val.length+1];
        val[0] = 0;
        for(int i=1;i<val.length;i++){
            val[i] = _val[i-1];
        }
        return val;
    }
    public static String encryptSHA(String timestamp,String nonce,String token) throws Exception {
        //
        String[] arr = new String[]{timestamp,nonce,token};
        Arrays.sort(arr);
        StringBuffer content = new StringBuffer();
        for (int i = 0; i < arr.length; i++) {
            content.append(arr[i]);
        }
        return new BigInteger(encryptSHA(content.toString().getBytes("UTF-8"))).toString(64);
    }
    public static String  encryptSHA1(String timestamp,String nonce,String token) throws Exception {
        //
        String[] arr = new String[]{timestamp,nonce,token};
        Arrays.sort(arr);
        StringBuffer content = new StringBuffer();
        for (int i = 0; i < arr.length; i++) {
            content.append(arr[i]);
        }
        return new BigInteger(encryptSHA1(content.toString().getBytes("UTF-8"))).toString(64);
    }
}
