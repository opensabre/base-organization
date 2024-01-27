package io.github.opensabre.organization.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.github.opensabre.organization.entity.param.ResourceQueryParam;
import io.github.opensabre.organization.entity.po.Resource;

import java.util.List;

public interface IResourceService {
    /**
     * 获取资源
     *
     * @param id
     * @return
     */
    Resource get(String id);

    /**
     * 新增资源
     *
     * @param resource
     * @return
     */
    boolean add(Resource resource);

    /**
     * 查询资源,分页
     *
     * @return
     */
    Page query(Page page, ResourceQueryParam resourceQueryParam);

    /**
     * 查询所有资源
     *
     * @return
     */
    List<Resource> getAll();

    /**
     * 根据username查询角色拥有的资源
     *
     * @return
     */
    List<Resource> query(String username);

    /**
     * 更新资源信息
     *
     * @param resource
     */
    boolean update(Resource resource);

    /**
     * 根据id删除资源
     *
     * @param id
     */
    boolean delete(String id);
}
