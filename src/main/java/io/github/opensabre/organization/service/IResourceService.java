package io.github.opensabre.organization.service;

import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.github.opensabre.organization.entity.param.ResourceQueryParam;
import io.github.opensabre.organization.entity.po.Resource;

import java.util.List;
import java.util.Set;

public interface IResourceService {
    /**
     * 获取资源
     *
     * @param id 唯一ID
     * @return Resource
     */
    Resource get(String id);

    /**
     * 获取资源
     *
     * @param ids 唯一ID集合
     * @return List<Resource> 资源集合
     */
    List<Resource> fetch(Set<String> ids);

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
     * 根据角色code查询角色拥有的资源
     *
     * @return List<Resource>
     */
    List<Resource> queryByRole(String roleCode);

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
