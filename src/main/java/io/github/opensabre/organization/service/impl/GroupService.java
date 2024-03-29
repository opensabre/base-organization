package io.github.opensabre.organization.service.impl;

import com.alicp.jetcache.anno.CacheInvalidate;
import com.alicp.jetcache.anno.CacheType;
import com.alicp.jetcache.anno.Cached;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import io.github.opensabre.organization.dao.GroupMapper;
import io.github.opensabre.organization.entity.param.GroupQueryParam;
import io.github.opensabre.organization.entity.po.Group;
import io.github.opensabre.organization.service.IGroupService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@Slf4j
public class GroupService extends ServiceImpl<GroupMapper, Group> implements IGroupService {

    private final String CACHE_PREFIX_KEY = "group:";

    @Override
    public boolean add(Group group) {
        return this.save(group);
    }

    @Override
    @CacheInvalidate(name = CACHE_PREFIX_KEY, key = "#id")
    public boolean delete(String id) {
        return this.removeById(id);
    }

    @Override
    @CacheInvalidate(name = CACHE_PREFIX_KEY, key = "#group.id")
    public boolean update(Group group) {
        return this.updateById(group);
    }

    @Override
    @Cached(name = CACHE_PREFIX_KEY, key = "#id", cacheType = CacheType.BOTH)
    public Group get(String id) {
        return this.getById(id);
    }

    @Override
    public List<Group> query(GroupQueryParam groupQueryParam) {
        QueryWrapper<Group> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq("name", groupQueryParam.getName());
        return this.list(queryWrapper);
    }

    @Override
    public List<Group> queryByParentId(String id) {
        return this.list(new QueryWrapper<Group>().eq("parent_id", id));
    }
}
