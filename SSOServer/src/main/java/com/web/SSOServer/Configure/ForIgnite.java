package com.web.SSOServer.Configure;

import com.web.SSOServer.Model.*;
import org.apache.ignite.Ignite;
import org.apache.ignite.Ignition;
import org.apache.ignite.configuration.CacheConfiguration;
import org.apache.ignite.configuration.IgniteConfiguration;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.util.ArrayList;
import java.util.List;

@Configuration
public class ForIgnite {
    /**
     * 初始化ignite节点信息
     */
    @Bean
    public Ignite igniteInstance(){
        IgniteConfiguration cfg = new IgniteConfiguration();
        cfg.setIgniteInstanceName("NodeForUser");
        cfg.setPeerClassLoadingEnabled(true);
        CacheConfiguration ccfg = new CacheConfiguration("usCache");
        ccfg.setIndexedTypes(Long.class, User.class);
        cfg.setCacheConfiguration(ccfg);
        return Ignition.start(cfg);
    }


    @Autowired
    UserIgniteRepository userIgniteRepository;

    @Bean
    public int insertUser(){
        List<Access> member_roles = new ArrayList<Access>();
        member_roles.add(Access.MEMBER);
        List<Access> admin_roles = new ArrayList<Access>();
        admin_roles.add(Access.ADMIN);

        User u1=new User("111", "111", member_roles);
        User u2=new User("222", "222", admin_roles);

        userIgniteRepository.save(u1.getId(),u1);
        userIgniteRepository.save(u2.getId(),u2);
        return 0;
    }
}
