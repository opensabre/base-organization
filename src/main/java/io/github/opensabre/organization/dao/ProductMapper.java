package io.github.opensabre.organization.dao;

import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import io.github.opensabre.organization.entity.po.Product;
import org.apache.ibatis.annotations.Mapper;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
public interface ProductMapper extends BaseMapper<Product> {
}
