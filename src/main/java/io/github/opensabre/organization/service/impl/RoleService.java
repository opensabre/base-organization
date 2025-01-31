package io.github.opensabre.organization.service.impl;

import com.alicp.jetcache.anno.CacheInvalidate;
import com.alicp.jetcache.anno.CacheType;
import com.alicp.jetcache.anno.Cached;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import io.github.opensabre.organization.dao.RoleMapper;
import io.github.opensabre.organization.entity.param.RoleQueryParam;
import io.github.opensabre.organization.entity.po.Role;
import io.github.opensabre.organization.exception.RoleNotFoundException;
import io.github.opensabre.organization.service.IRoleResourceService;
import io.github.opensabre.organization.service.IRoleService;
import io.github.opensabre.organization.service.IUserRoleService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import jakarta.annotation.Resource;
import java.util.List;
import java.util.Objects;
import java.util.Set;

@Service
@Slf4j
public class RoleService extends ServiceImpl<RoleMapper, Role> implements IRoleService {

    private final String CACHE_PREFIX_KEY = "role:";
    @Resource
    private IUserRoleService userRoleService;

    @Resource
    private IRoleResourceService roleResourceService;

    @Override
    public boolean add(Role role) {
        boolean isSuccess = this.save(role);
        roleResourceService.saveBatch(role.getId(), role.getResourceIds());
        return isSuccess;
    }

    @Override
    @CacheInvalidate(name = CACHE_PREFIX_KEY, key = "#id")
    public boolean delete(String id) {
        roleResourceService.removeByRoleId(id);
        return this.removeById(id);
    }

    @Override
    @CacheInvalidate(name = CACHE_PREFIX_KEY, key = "#role.id")
    public boolean update(Role role) {
        boolean isSuccess = this.updateById(role);
        roleResourceService.saveBatch(role.getId(), role.getResourceIds());
        return isSuccess;
    }

    @Override
    @Cached(name = CACHE_PREFIX_KEY, key = "#id", cacheType = CacheType.BOTH)
    public Role get(String id) {
        Role role = this.getById(id);
        if (Objects.isNull(role)) {
            throw new RoleNotFoundException("role not found with id:" + id);
        }
        role.setResourceIds(roleResourceService.queryByRoleId(id));
        return role;
    }

    @Override
    public List<Role> getAll() {
        return this.list();
    }

    @Override
    @Cached(name = "role4user:", key = "#userId", cacheType = CacheType.BOTH)
    public List<Role> query(String userId) {
        Set<String> roleIds = userRoleService.queryByUserId(userId);
        return this.listByIds(roleIds);
    }

    @Override
    public IPage<Role> query(Page page, RoleQueryParam roleQueryParam) {
        QueryWrapper<Role> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(StringUtils.isNotBlank(roleQueryParam.getName()), "name", roleQueryParam.getName());
        queryWrapper.eq(StringUtils.isNotBlank(roleQueryParam.getCode()), "code", roleQueryParam.getCode());
        return this.page(page, queryWrapper);
    }
}
