package com.web.SSOServer.Model;

import org.apache.ignite.springdata.repository.IgniteRepository;
import org.apache.ignite.springdata.repository.config.RepositoryConfig;

@RepositoryConfig(cacheName = "usCache")
public interface UserIgniteRepository extends IgniteRepository<User, Long> {
    /**
     * Find a user with name in Ignite DB.
     * @param username User name.
     * @return The user whose name is the given name.
     */
    User findByUsername(String username);
}
