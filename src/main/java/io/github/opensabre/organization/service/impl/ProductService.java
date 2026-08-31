package io.github.opensabre.organization.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.spring.service.impl.ServiceImpl;
import io.github.opensabre.organization.dao.ProductApplicationMapper;
import io.github.opensabre.organization.dao.ProductMapper;
import io.github.opensabre.organization.entity.po.Product;
import io.github.opensabre.organization.entity.po.ProductApplication;
import io.github.opensabre.organization.service.IProductService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

/** 数据库产品配置及应用归属解析。 */
@Service
@RequiredArgsConstructor
public class ProductService extends ServiceImpl<ProductMapper, Product> implements IProductService {
    public static final String COMMON_PRODUCT = "COMMON";
    private final ProductApplicationMapper productApplicationMapper;

    @Override
    public Product getEnabled(String code) {
        Product product = getOne(new LambdaQueryWrapper<Product>().eq(Product::getCode, code).eq(Product::isEnabled, true));
        if (product == null) throw new IllegalArgumentException("产品不存在或已停用：" + code);
        return product;
    }

    @Override
    public List<Product> listOrdered() {
        return list(new LambdaQueryWrapper<Product>().orderByAsc(Product::getOrderNum));
    }

    @Override
    public String resolveProductCode(String application) {
        ProductApplication mapping = productApplicationMapper.selectOne(new LambdaQueryWrapper<ProductApplication>()
                .eq(ProductApplication::getApplication, application));
        return mapping == null ? COMMON_PRODUCT : mapping.getProductCode();
    }
}
