package io.github.opensabre.organization.dao;

import com.baomidou.mybatisplus.annotation.InterceptorIgnore;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import io.github.opensabre.organization.entity.po.Resource;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
@InterceptorIgnore(illegalSql = "1")
public interface ResourceMapper extends BaseMapper<Resource> {
}