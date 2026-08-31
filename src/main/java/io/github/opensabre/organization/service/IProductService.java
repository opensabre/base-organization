package io.github.opensabre.organization.service;

import com.baomidou.mybatisplus.spring.service.IService;
import io.github.opensabre.organization.entity.po.Product;

import java.util.List;

/** 产品配置服务。 */
public interface IProductService extends IService<Product> {
    Product getEnabled(String code);
    List<Product> listOrdered();
    String resolveProductCode(String application);
}
