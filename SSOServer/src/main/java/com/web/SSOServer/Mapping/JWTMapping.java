package com.web.SSOServer.Mapping;

import com.web.SSOServer.Model.ResJson;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import javax.servlet.http.HttpServletRequest;

/**
 * Test the jwt, if the token is valid then return "Login Successful"
 * If is not valid, the request will be intercepted by JwtFilter
 **/
@RestController
@RequestMapping("/JWT")
public class JWTMapping {
    @RequestMapping("/JwtCorrect")
    public ResJson JwtCorrect(HttpServletRequest request){
        String access = request.getAttribute("Access").toString();
        ResJson resJson = new ResJson();
        resJson.setStatuscode("200");
        resJson.setMessage(access);
        resJson.setData(" ");
        return resJson;
    }

    @RequestMapping("/token")
    public void checkJwt(HttpServletRequest request) {

    }

    @RequestMapping("/JwtException")
    public ResJson JwtException(HttpServletRequest request){
        ResJson resJson = new ResJson();
        resJson.setStatuscode("001");
        resJson.setMessage("Token error");
        resJson.setData(" ");
        return resJson;
    }


}
