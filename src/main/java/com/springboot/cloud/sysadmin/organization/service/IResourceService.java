package com.springboot.cloud.sysadmin.organization.service;

import com.springboot.cloud.sysadmin.organization.entity.param.ResourceQueryParam;
import com.springboot.cloud.sysadmin.organization.entity.po.Resource;

import java.util.List;

public interface IResourceService {
    /**
     * 获取资源
     *
     * @param id
     * @return
     */
    Resource get(long id);

    /**
     * 新增资源
     *
     * @param resource
     * @return
     */
    long add(Resource resource);

    /**
     * 查询资源
     *
     * @return
     */
    List<Resource> query(ResourceQueryParam resourceQueryParam);

    /**
     * 根据userId查询角色拥有的资源
     *
     * @return
     */
    List<Resource> query(long userId);

    /**
     * 更新资源信息
     *
     * @param resource
     */
    void update(Resource resource);

    /**
     * 根据id删除资源
     *
     * @param id
     */
    void delete(long id);
}
