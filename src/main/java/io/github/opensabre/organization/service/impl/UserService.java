package io.github.opensabre.organization.service.impl;

import com.alicp.jetcache.anno.CacheInvalidate;
import com.alicp.jetcache.anno.CacheType;
import com.alicp.jetcache.anno.Cached;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.core.toolkit.CollectionUtils;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.spring.service.impl.ServiceImpl;
import io.github.opensabre.organization.dao.GroupMapper;
import io.github.opensabre.organization.dao.UserGroupMapper;
import io.github.opensabre.organization.dao.UserMapper;
import io.github.opensabre.organization.entity.param.UserQueryParam;
import io.github.opensabre.organization.entity.po.Group;
import io.github.opensabre.organization.entity.po.User;
import io.github.opensabre.organization.entity.po.UserGroup;
import io.github.opensabre.organization.entity.vo.UserVo;
import io.github.opensabre.organization.exception.UserNotFoundException;
import io.github.opensabre.organization.service.IUserRoleService;
import io.github.opensabre.organization.service.IUserService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import jakarta.annotation.Resource;
import java.util.Collections;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.Set;
import java.util.function.Function;
import java.util.stream.Collectors;

@Service
@Slf4j
public class UserService extends ServiceImpl<UserMapper, User> implements IUserService {
    /**
     * cache prefix key
     */
    private static final String CACHE_PREFIX_KEY = "user:";

    @Resource
    private IUserRoleService userRoleService;

    @Resource
    private UserGroupMapper userGroupMapper;

    @Resource
    private GroupMapper groupMapper;

    @Resource
    PasswordEncoder passwordEncoder;

    @Override
    @Transactional
    public boolean add(User user) {
        //密码不为空，表示重新设置了密码，保存密码
        if (StringUtils.isNotBlank(user.getPassword()))
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        //保存用户信息
        boolean result = this.save(user);
        //保存用户与角色的关系
        userRoleService.saveBatch(user.getId(), user.getRoleIds());
        //保存用户与组织的关系
        saveUserGroup(user.getId(), user.getGroupId());
        return result;
    }

    @Override
    @Transactional
    @CacheInvalidate(name = CACHE_PREFIX_KEY, key = "#id")
    public boolean delete(String id) {
        //删除用户
        this.removeById(id);
        //删除用户与角色的关系
        boolean roleRemoved = userRoleService.removeByUserId(id);
        removeUserGroup(id);
        return roleRemoved;
    }

    @Override
    @Transactional
    @CacheInvalidate(name = CACHE_PREFIX_KEY, key = "#user.id")
    public boolean update(User user) {
        //密码不为空，表示重新设置了密码，保存密码
        if (StringUtils.isNotBlank(user.getPassword()))
            user.setPassword(passwordEncoder.encode(user.getPassword()));
        //保存用户信息
        boolean isSuccess = this.updateById(user);
        //保存用户与角色关系
        userRoleService.saveBatch(user.getId(), user.getRoleIds());
        //保存用户与组织关系
        saveUserGroup(user.getId(), user.getGroupId());
        return isSuccess;
    }

    @Override
    @Cached(name = CACHE_PREFIX_KEY, key = "#id", cacheType = CacheType.BOTH)
    public UserVo get(String id) {
        //根据id查询用户
        User user = this.getById(id);
        //无此用户时抛异常
        if (Objects.isNull(user)) {
            throw new UserNotFoundException("user not found with id:" + id);
        }
        //查询用户与角色关系信息
        user.setRoleIds(userRoleService.queryByUserId(id));
        UserVo userVo = new UserVo(user);
        fillGroup(Collections.singletonList(userVo));
        return userVo;
    }

    @Override
    @Cached(name = CACHE_PREFIX_KEY, key = "#uniqueId", cacheType = CacheType.BOTH)
    public User getByUniqueId(String uniqueId) {
        //根据用户名或手机号查询用户信息
        User user = this.getOne(new QueryWrapper<User>()
                .eq("username", uniqueId)
                .or()
                .eq("mobile", uniqueId));
        //无此用户时抛异常
        if (Objects.isNull(user)) {
            throw new UserNotFoundException("user not found with uniqueId:" + uniqueId);
        }
        //查询用户与角色关系信息
        user.setRoleIds(userRoleService.queryByUserId(user.getId()));
        return user;
    }

    @Override
    public IPage<UserVo> query(Page page, UserQueryParam userQueryParam) {
        QueryWrapper<User> queryWrapper = new QueryWrapper<>();
        queryWrapper.eq(StringUtils.isNotBlank(userQueryParam.getName()), "name", userQueryParam.getName());
        queryWrapper.eq(StringUtils.isNotBlank(userQueryParam.getUsername()), "username", userQueryParam.getUsername());
        queryWrapper.eq(StringUtils.isNotBlank(userQueryParam.getMobile()), "mobile", userQueryParam.getMobile());
        queryWrapper.apply(StringUtils.isNotBlank(userQueryParam.getGroupId()),
                "id in (select user_id from base_org_user_group where group_id = {0})",
                userQueryParam.getGroupId());
        // 分页查询用户
        IPage<User> iPageUser = this.page(page, queryWrapper);
        // 转换成VO返回
        IPage<UserVo> userVoPage = iPageUser.convert(UserVo::new);
        fillGroup(userVoPage.getRecords());
        return userVoPage;
    }

    private void saveUserGroup(String userId, String groupId) {
        removeUserGroup(userId);
        if (StringUtils.isBlank(groupId)) {
            return;
        }
        userGroupMapper.insert(UserGroup.builder().userId(userId).groupId(groupId).build());
    }

    private void removeUserGroup(String userId) {
        QueryWrapper<UserGroup> queryWrapper = new QueryWrapper<>();
        queryWrapper.lambda().eq(UserGroup::getUserId, userId);
        userGroupMapper.delete(queryWrapper);
    }

    private void fillGroup(List<UserVo> users) {
        if (CollectionUtils.isEmpty(users)) {
            return;
        }
        Set<String> userIds = users.stream().map(UserVo::getId).collect(Collectors.toSet());
        QueryWrapper<UserGroup> queryWrapper = new QueryWrapper<>();
        queryWrapper.lambda().in(UserGroup::getUserId, userIds);
        List<UserGroup> userGroups = userGroupMapper.selectList(queryWrapper);
        if (CollectionUtils.isEmpty(userGroups)) {
            return;
        }
        Set<String> groupIds = userGroups.stream().map(UserGroup::getGroupId).collect(Collectors.toSet());
        Map<String, Group> groupMap = groupMapper.selectBatchIds(groupIds)
                .stream()
                .collect(Collectors.toMap(Group::getId, Function.identity()));
        Map<String, UserGroup> userGroupMap = userGroups.stream()
                .collect(Collectors.toMap(UserGroup::getUserId, Function.identity(), (first, ignored) -> first));
        users.forEach(user -> {
            UserGroup userGroup = userGroupMap.get(user.getId());
            if (Objects.isNull(userGroup)) {
                return;
            }
            user.setGroupId(userGroup.getGroupId());
            Group group = groupMap.get(userGroup.getGroupId());
            if (Objects.nonNull(group)) {
                user.setGroupName(group.getName());
            }
        });
    }
}
