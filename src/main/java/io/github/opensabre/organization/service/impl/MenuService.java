package io.github.opensabre.organization.service.impl;

import com.alicp.jetcache.anno.CacheInvalidate;
import com.alicp.jetcache.anno.CacheType;
import com.alicp.jetcache.anno.Cached;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.CollectionUtils;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import io.github.opensabre.organization.dao.MenuMapper;
import io.github.opensabre.organization.entity.param.MenuQueryParam;
import io.github.opensabre.organization.entity.po.Menu;
import io.github.opensabre.organization.entity.po.RoleMenu;
import io.github.opensabre.organization.entity.vo.MenuVo;
import io.github.opensabre.organization.service.IMenuService;
import io.github.opensabre.organization.service.IRoleMenuService;
import io.github.opensabre.organization.service.IUserRoleService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@Slf4j
public class MenuService extends ServiceImpl<MenuMapper, Menu> implements IMenuService {

    private final String CACHE_PREFIX_KEY = "menu:";

    @Resource
    private IUserRoleService userRoleService;

    @Resource
    private IRoleMenuService roleMenuService;

    @Override
    public boolean add(Menu menu) {
        return this.save(menu);
    }

    @Override
    @CacheInvalidate(name = CACHE_PREFIX_KEY, key = "#id")
    public boolean delete(String id) {
        return this.removeById(id);
    }

    @Override
    @CacheInvalidate(name = CACHE_PREFIX_KEY, key = "#menu.id")
    public boolean update(Menu menu) {
        return this.updateById(menu);
    }

    @Override
    @Cached(name = CACHE_PREFIX_KEY, key = "#id", cacheType = CacheType.BOTH)
    public Menu get(String id) {
        return this.getById(id);
    }

    @Override
    public List<Menu> query(MenuQueryParam menuQueryParam) {
        QueryWrapper<Menu> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(null != menuQueryParam.getName(), "name", menuQueryParam.getName());
        return this.list(queryWrapper);
    }

    @Override
    public List<Menu> queryByParentId(String id) {
        return this.list(new QueryWrapper<Menu>().eq("parent_id", id));
    }

    @Override
    public List<MenuVo> queryByUserId(String userId) {
        Set<String> roleIds = userRoleService.queryByUserId(userId);
        List<RoleMenu> roleMenus = roleMenuService.queryByRoleIds(roleIds);
        Set<String> menuIds = roleMenus.stream().map(RoleMenu::getMenuId).collect(Collectors.toSet());
        if (CollectionUtils.isEmpty(menuIds)) {
            return Collections.emptyList();
        }

        Map<String, Menu> menuMap = this.listByIds(menuIds).stream()
                .collect(Collectors.toMap(Menu::getId, Function.identity(), (left, right) -> left));
        fillParentMenus(menuMap);

        return buildMenuTree(menuMap.values().stream().toList());
    }

    private void fillParentMenus(Map<String, Menu> menuMap) {
        Set<String> pendingParentIds = menuMap.values().stream()
                .map(Menu::getParentId)
                .filter(parentId -> Objects.nonNull(parentId) && !"-1".equals(parentId))
                .filter(parentId -> !menuMap.containsKey(parentId))
                .collect(Collectors.toCollection(HashSet::new));

        while (!pendingParentIds.isEmpty()) {
            List<Menu> parentMenus = this.listByIds(pendingParentIds);
            pendingParentIds.clear();

            for (Menu parentMenu : parentMenus) {
                if (menuMap.putIfAbsent(parentMenu.getId(), parentMenu) == null
                        && Objects.nonNull(parentMenu.getParentId())
                        && !"-1".equals(parentMenu.getParentId())
                        && !menuMap.containsKey(parentMenu.getParentId())) {
                    pendingParentIds.add(parentMenu.getParentId());
                }
            }
        }
    }

    private List<MenuVo> buildMenuTree(List<Menu> menus) {
        List<MenuVo> menuVos = menus.stream().map(MenuVo::new).collect(Collectors.toList());
        Map<String, List<MenuVo>> childrenByParentId = menuVos.stream()
                .collect(Collectors.groupingBy(MenuVo::getParentId));
        Set<String> menuIds = menuVos.stream().map(MenuVo::getId).collect(Collectors.toSet());

        menuVos.forEach(menu -> menu.setChildren(sortMenuVos(childrenByParentId.get(menu.getId()))));

        return sortMenuVos(menuVos.stream()
                .filter(menu -> !menuIds.contains(menu.getParentId()))
                .collect(Collectors.toList()));
    }

    private List<Menu> sortMenus(List<Menu> menus) {
        if (CollectionUtils.isEmpty(menus)) {
            return new ArrayList<>();
        }
        return menus.stream()
                .sorted(Comparator.comparingInt(Menu::getOrderNum))
                .collect(Collectors.toList());
    }

    private List<MenuVo> sortMenuVos(List<MenuVo> menus) {
        if (CollectionUtils.isEmpty(menus)) {
            return new ArrayList<>();
        }
        return menus.stream()
                .sorted(Comparator.comparingInt(MenuVo::getOrderNum))
                .collect(Collectors.toList());
    }
}
