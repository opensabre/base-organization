package io.github.opensabre.organization.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import io.github.opensabre.organization.entity.po.Role;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public interface RoleMapper extends BaseMapper<Role> {
}