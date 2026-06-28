package io.github.opensabre.organization.service.impl;

import com.alicp.jetcache.anno.CacheInvalidate;
import com.alicp.jetcache.anno.CacheType;
import com.alicp.jetcache.anno.Cached;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.CollectionUtils;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import io.github.opensabre.organization.dao.RoleResourceMapper;
import io.github.opensabre.organization.entity.po.RoleResource;
import io.github.opensabre.organization.service.IRoleResourceService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Slf4j
@Service
public class RoleResourceService extends ServiceImpl<RoleResourceMapper, RoleResource> implements IRoleResourceService {

    private static final String CACHE_PREFIX_KEY = "resource4role:";

    @Override
    @Transactional
    @CacheInvalidate(area = "shortTime", name = CACHE_PREFIX_KEY, key = "#roleId")
    public boolean saveBatch(String roleId, Set<String> resourceIds) {
        removeByRoleId(roleId);
        if (CollectionUtils.isEmpty(resourceIds))
            return true;
        Set<RoleResource> userRoles = resourceIds.stream().map(resourceId -> new RoleResource(roleId, resourceId)).collect(Collectors.toSet());
        return saveBatch(userRoles);
    }

    @Override
    @Transactional
    @CacheInvalidate(area = "shortTime", name = CACHE_PREFIX_KEY, key = "#roleId")
    public boolean removeByRoleId(String roleId) {
        QueryWrapper<RoleResource> queryWrapper = new QueryWrapper<>();
        queryWrapper.lambda().eq(RoleResource::getRoleId, roleId);
        return remove(queryWrapper);
    }

    @Override
    @Cached(area = "shortTime", name = CACHE_PREFIX_KEY, key = "#roleId", cacheType = CacheType.BOTH)
    public Set<String> queryByRoleId(String roleId) {
        QueryWrapper<RoleResource> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("role_id", roleId);
        List<RoleResource> userRoleList = list(queryWrapper);
        return userRoleList.stream().map(RoleResource::getResourceId).collect(Collectors.toSet());
    }

    @Override
    public List<RoleResource> queryByRoleIds(Set<String> roleIds) {
        QueryWrapper<RoleResource> queryWrapper = new QueryWrapper<>();
        queryWrapper.in("role_id", roleIds);
        return this.list(queryWrapper);
    }
}
