package com.web.SSOServer.Mapping;

import com.web.SSOServer.Model.*;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.SignatureAlgorithm;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.ServletException;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@RestController
@RequestMapping("/Login")
public class LoginMapping {


    @Autowired
    private UserIgniteRepository userIgniteRepository;
    /**
     * Check user`s login info, then create a jwt token returned to front end
     * @param receive
     * @return jwt token
     * @throws ServletException
     */
    @RequestMapping(value = "/login", method = RequestMethod.POST)
    public ResJson login(@RequestBody() Receive receive) throws ServletException {

        ResJson result = new ResJson();

        if(userIgniteRepository.findByUsername(receive.getUsername()) == null){
            result.setStatuscode("002");
            result.setMessage("no user"+ receive.getUsername());
            result.setData(" ");
            return result;
        }

        // Check if the password is wrong
        if(!receive.getPassword().equals(userIgniteRepository.findByUsername(receive.getUsername()).getPassword())){
            result.setStatuscode("003");
            result.setMessage("password is wrong");
            result.setData(" ");
            return result;
        }

        User user = userIgniteRepository.findByUsername(receive.getUsername());
        List<Access> access = user.getRoles();
        String accessStr = access.get(0).toString();

        // Create Jwt token
        String jwtToken = Jwts.builder().setSubject(receive.getUsername()).claim("access", accessStr).setIssuedAt(new Date())
                .signWith(SignatureAlgorithm.HS256, "secret").compact();

        result.setStatuscode("200");
        result.setMessage(accessStr);
        result.setData(jwtToken);
        return result;
    }

    /**
     * User register with whose username and password
     * @param receive
     * @return Success message
     * @throws ServletException
     */
    @RequestMapping(value = "/register", method = RequestMethod.POST)
    public ResJson register(@RequestBody() Receive receive) throws ServletException {

        ResJson result = new ResJson();

        // Check if the username is used
        if(userIgniteRepository.findByUsername(receive.getUsername()) != null){
            result.setStatuscode("004");
            result.setMessage("username is used");
            result.setData(" ");
            return result;
        }

        // Give a default access : MEMBER
        List<Access> roles = new ArrayList<Access>();
        roles.add(Access.MEMBER);
        String accessStr = roles.get(0).toString();

        // Create Jwt token
        String jwtToken = Jwts.builder().setSubject(receive.getUsername()).claim("access", accessStr).setIssuedAt(new Date())
                .signWith(SignatureAlgorithm.HS256, "secret").compact();
        // Create a person in ignite
        User user = new User(receive.getUsername(), receive.getPassword(), roles);
        userIgniteRepository.save(user.getId(),user);

        result.setStatuscode("201");
        result.setMessage(accessStr);
        result.setData(jwtToken);
        return result;
    }


}
