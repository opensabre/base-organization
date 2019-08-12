package com.springboot.cloud.sysadmin.organization.service;

import java.util.Set;

public interface IUserRoleService {

    /**
     * 给用户添加角色
     *
     * @param userId
     * @param roleIds
     * @return
     */
    boolean saveBatch(long userId, Set<Long> roleIds);

    /**
     * 给用户添加角色
     *
     * @param userId
     * @param roleIds
     * @return
     */
    boolean saveOrUpdateBatch(long userId, Set<Long> roleIds);

    /**
     * 删除用户拥有的角色
     *
     * @param userId
     * @return
     */
    boolean removeByUserId(long userId);

    /**
     * 查询用户拥有角色id
     *
     * @param userId
     * @return
     */
    Set<Long> queryByUserId(long userId);
}
