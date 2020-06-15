package com.web.SSOServer.Model;
public class ResJson<T> {
    private String statusCode;
    private String msg;
    private T data;
    public ResJson() {}
    public ResJson(String statusCode, String message, T data) {
        this.statusCode = statusCode;
        this.msg = message;
        this.data = data;
    }
    public String getStatuscode() {
        return statusCode;
    }
    public void setStatuscode(String status_code) {
        this.statusCode = status_code;
    }
    public String getMessage() {
        return msg;
    }
    public void setMessage(String message) {
        this.msg = message;
    }
    public T getData() {
        return data;
    }
    public void setData(T data) {
        this.data = data;
    }
}
