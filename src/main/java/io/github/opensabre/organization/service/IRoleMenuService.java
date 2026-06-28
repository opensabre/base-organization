package io.github.opensabre.organization.service;

import io.github.opensabre.organization.entity.po.RoleMenu;

import java.util.List;
import java.util.Set;

public interface IRoleMenuService {

    /**
     * 保存角色菜单关系，先删除旧关系再保存新关系
     *
     * @param roleId 角色id
     * @param menuIds 菜单id集合
     * @return 是否保存成功
     */
    boolean saveBatch(String roleId, Set<String> menuIds);

    /**
     * 根据角色id删除菜单关系
     *
     * @param roleId 角色id
     * @return 是否删除成功
     */
    boolean removeByRoleId(String roleId);

    /**
     * 根据角色id查询菜单id集合
     *
     * @param roleId 角色id
     * @return 菜单id集合
     */
    Set<String> queryByRoleId(String roleId);

    /**
     * 根据角色id列表查询菜单关系
     *
     * @param roleIds 角色id集合
     * @return 角色菜单关系集合
     */
    List<RoleMenu> queryByRoleIds(Set<String> roleIds);
}
