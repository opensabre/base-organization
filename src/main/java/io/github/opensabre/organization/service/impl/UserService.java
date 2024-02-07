package io.github.opensabre.organization.service.impl;

import com.alicp.jetcache.anno.CacheInvalidate;
import com.alicp.jetcache.anno.CacheType;
import com.alicp.jetcache.anno.Cached;
import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import com.baomidou.mybatisplus.extension.service.impl.ServiceImpl;
import io.github.opensabre.organization.dao.UserMapper;
import io.github.opensabre.organization.entity.param.UserQueryParam;
import io.github.opensabre.organization.entity.po.User;
import io.github.opensabre.organization.entity.vo.UserVo;
import io.github.opensabre.organization.exception.UserNotFoundException;
import io.github.opensabre.organization.service.IUserRoleService;
import io.github.opensabre.organization.service.IUserService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.annotation.Resource;
import java.util.Objects;

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
        return result;
    }

    @Override
    @Transactional
    @CacheInvalidate(name = CACHE_PREFIX_KEY, key = "#id")
    public boolean delete(String id) {
        //删除用户
        this.removeById(id);
        //删除用户与角色的关系
        return userRoleService.removeByUserId(id);
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
        return new UserVo(user);
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
        // 分页查询用户
        IPage<User> iPageUser = this.page(page, queryWrapper);
        // 转换成VO返回
        return iPageUser.convert(UserVo::new);
    }
}
