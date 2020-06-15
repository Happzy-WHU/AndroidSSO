package com.web.SSOServer.Model;

public enum Access {
    ADMIN, MEMBER;

   @Override
    public String toString(){
        return this.name();
    }
}
