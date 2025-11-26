package io.github.opensabre.organization.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.github.opensabre.organization.entity.param.RoleQueryParam;
import io.github.opensabre.organization.entity.po.Role;

import java.util.List;

public interface IRoleService {
    /**
     * 获取角色
     *
     * @param id 唯一ID
     * @return Role对象
     */
    Role get(String id);

    /**
     * 通过角色code获取角色
     *
     * @param code 角色code
     * @return Role对象
     */
    Role getByCode(String code);

    /**
     * 获取所有角色
     *
     * @return
     */
    List<Role> getAll();

    /**
     * 新增角色
     *
     * @param role
     * @return
     */
    boolean add(Role role);

    /**
     * 查询角色
     *
     * @return
     */
    IPage<Role> query(Page page, RoleQueryParam roleQueryParam);

    /**
     * 根据用户id查询用户拥有的角色
     *
     * @return
     */
    List<Role> query(String userId);

    /**
     * 更新角色信息
     *
     * @param role
     */
    boolean update(Role role);

    /**
     * 根据id删除角色
     *
     * @param id
     */
    boolean delete(String id);
}
