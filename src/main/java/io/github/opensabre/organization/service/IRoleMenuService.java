package io.github.opensabre.organization.service;

import io.github.opensabre.organization.entity.po.RoleMenu;

import java.util.List;
import java.util.Set;

public interface IRoleMenuService {

    /**
     * 根据角色id列表查询菜单关系
     *
     * @param roleIds 角色id集合
     * @return 角色菜单关系集合
     */
    List<RoleMenu> queryByRoleIds(Set<String> roleIds);
}
