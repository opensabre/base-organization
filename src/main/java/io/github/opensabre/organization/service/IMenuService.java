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
     * 根据用户id查询授权菜单树
     *
     * @param userId 用户id
     * @return 授权菜单树
     */
    List<MenuVo> queryByUserId(String userId);

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
