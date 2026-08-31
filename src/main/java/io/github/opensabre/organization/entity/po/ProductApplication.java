package io.github.opensabre.organization.entity.po;

import io.github.opensabre.persistence.entity.po.BasePo;
import lombok.Data;
import lombok.EqualsAndHashCode;

/** 将服务注册名映射到产品，供资源自动注册时确定产品归属。 */
@Data
@EqualsAndHashCode(callSuper = true)
public class ProductApplication extends BasePo {
    private String productCode;
    private String application;
}
