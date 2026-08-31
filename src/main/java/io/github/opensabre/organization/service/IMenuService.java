package io.github.opensabre.organization.service;

import io.github.opensabre.organization.entity.param.MenuQueryParam;
import io.github.opensabre.organization.entity.po.Menu;
import io.github.opensabre.organization.entity.vo.MenuVo;

import java.util.List;

public interface IMenuService {
    /**
     * 获取菜单
     *
     * @param id
     * @return
     */
    Menu get(String id);

    /**
     * 新增菜单
     *
     * @param menu
     * @return
     */
    boolean add(Menu menu);

    /**
     * 查询菜单
     *
     * @return
     */
    List<Menu> query(MenuQueryParam menuQueryParam);

    /**
     * 根据父id查询菜单
     *
     * @return
     */
    List<Menu> queryByParentId(String id);

    /**
     * 查询完整菜单树，用于管理台的菜单选择器。
     *
     * @return 完整菜单树
     */
    List<MenuVo> queryTree();

    /**
     * 根据用户id查询授权菜单树
     *
     * @param userId 用户id
     * @return 授权菜单树
     */
    List<MenuVo> queryByUserId(String userId);

    /** 根据用户和产品查询授权菜单；公共菜单仍需角色授权。 */
    List<MenuVo> queryByUserId(String userId, String productCode);

    /** 查询指定产品及公共菜单的完整管理树。 */
    List<MenuVo> queryTree(String productCode);

    /**
     * 更新菜单信息
     *
     * @param menu
     */
    boolean update(Menu menu);

    /**
     * 根据id删除菜单
     *
     * @param id
     */
    boolean delete(String id);
}
