package io.github.opensabre.organization.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import io.github.opensabre.organization.entity.po.ProductApplication;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface ProductApplicationMapper extends BaseMapper<ProductApplication> {
}
