package io.github.opensabre.organization.service.impl;

import com.alicp.jetcache.anno.CacheType;
import com.alicp.jetcache.anno.Cached;
import com.baomidou.mybatisplus.annotation.InterceptorIgnore;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import io.github.opensabre.organization.dao.ResourceMapper;
import io.github.opensabre.organization.entity.param.ResourceQueryParam;
import io.github.opensabre.organization.entity.po.Resource;
import io.github.opensabre.organization.entity.po.Role;
import io.github.opensabre.organization.entity.po.RoleResource;
import io.github.opensabre.organization.entity.po.User;
import io.github.opensabre.organization.service.IResourceService;
import io.github.opensabre.organization.service.IRoleResourceService;
import io.github.opensabre.organization.service.IRoleService;
import io.github.opensabre.organization.service.IUserService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

@Service
@Slf4j
public class ResourceService extends ServiceImpl<ResourceMapper, Resource> implements IResourceService {

    @jakarta.annotation.Resource
    private IRoleResourceService roleResourceService;

    @jakarta.annotation.Resource
    private IRoleService roleService;

    @jakarta.annotation.Resource
    private IUserService userService;

//    @javax.annotation.Resource
//    private EventSender eventSender;

    @Override
    public boolean add(Resource resource) {
//        eventSender.send(BusConfig.ROUTING_KEY, resource);
        return this.save(resource);
    }

    @Override
    @Cached(name = "resource::", key = "#id", cacheType = CacheType.BOTH)
    public boolean delete(String id) {
        return this.removeById(id);
    }

    @Override
    @Cached(name = "resource::", key = "#resource.id", cacheType = CacheType.BOTH)
    public boolean update(Resource resource) {
        return this.updateById(resource);
    }

    @Override
    @Cached(name = "resource::", key = "#id", cacheType = CacheType.BOTH)
    public Resource get(String id) {
        return this.getById(id);
    }

    @Override
    public Page query(Page page, ResourceQueryParam resourceQueryParam) {
        QueryWrapper<Resource> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(StringUtils.isNotBlank(resourceQueryParam.getName()), "name", resourceQueryParam.getName());
        queryWrapper.eq(StringUtils.isNotBlank(resourceQueryParam.getType()), "type", resourceQueryParam.getType());
        queryWrapper.eq(StringUtils.isNotBlank(resourceQueryParam.getUrl()), "url", resourceQueryParam.getUrl());
        queryWrapper.eq(StringUtils.isNotBlank(resourceQueryParam.getMethod()), "method", resourceQueryParam.getMethod());
        return this.page(page, queryWrapper);
    }

    @Override
    public List<Resource> getAll() {
        return this.list();
    }

    @Override
    @Cached(name = "resource4user::", key = "#username", cacheType = CacheType.BOTH)
    public List<Resource> query(String username) {
        //根据用户名查询到用户所拥有的角色
        User user = userService.getByUniqueId(username);
        List<Role> roles = roleService.query(user.getId());
        //提取用户所拥有角色id列表
        Set<String> roleIds = roles.stream().map(role -> role.getId()).collect(Collectors.toSet());
        //根据角色列表查询到角色的资源的关联关系
        List<RoleResource> roleResources = roleResourceService.queryByRoleIds(roleIds);
        //根据资源列表查询出所有资源对象
        Set<String> resourceIds = roleResources.stream().map(roleResource -> roleResource.getResourceId()).collect(Collectors.toSet());
        //根据resourceId列表查询出resource对象
        return this.listByIds(resourceIds);
    }
}
