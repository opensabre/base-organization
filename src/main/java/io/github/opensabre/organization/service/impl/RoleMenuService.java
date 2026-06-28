package io.github.opensabre.organization.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.CollectionUtils;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import io.github.opensabre.organization.dao.RoleMenuMapper;
import io.github.opensabre.organization.entity.po.RoleMenu;
import io.github.opensabre.organization.service.IRoleMenuService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Service
public class RoleMenuService extends ServiceImpl<RoleMenuMapper, RoleMenu> implements IRoleMenuService {

    @Override
    @Transactional
    public boolean saveBatch(String roleId, Set<String> menuIds) {
        this.removeByRoleId(roleId);
        if (CollectionUtils.isEmpty(menuIds)) {
            return true;
        }

        List<RoleMenu> roleMenus = menuIds.stream()
                .map(menuId -> RoleMenu.builder().roleId(roleId).menuId(menuId).build())
                .collect(Collectors.toCollection(ArrayList::new));
        return super.saveBatch(roleMenus);
    }

    @Override
    public boolean removeByRoleId(String roleId) {
        QueryWrapper<RoleMenu> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("role_id", roleId);
        return this.remove(queryWrapper);
    }

    @Override
    public Set<String> queryByRoleId(String roleId) {
        QueryWrapper<RoleMenu> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("role_id", roleId);
        return this.list(queryWrapper).stream()
                .map(RoleMenu::getMenuId)
                .collect(Collectors.toSet());
    }

    @Override
    public List<RoleMenu> queryByRoleIds(Set<String> roleIds) {
        if (CollectionUtils.isEmpty(roleIds)) {
            return Collections.emptyList();
        }
        QueryWrapper<RoleMenu> queryWrapper = new QueryWrapper<>();
        queryWrapper.in("role_id", roleIds);
        return this.list(queryWrapper);
    }
}
