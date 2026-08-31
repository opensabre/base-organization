package io.github.opensabre.organization.entity.po;

import io.github.opensabre.persistence.entity.po.BasePo;
import lombok.Data;
import lombok.EqualsAndHashCode;

/** 产品定义，承载独立管理端的品牌和默认导航信息。 */
@Data
@EqualsAndHashCode(callSuper = true)
public class Product extends BasePo {
    private String code;
    private String name;
    private String shortName;
    private String description;
    private String logoUrl;
    private String collapsedLogoUrl;
    private String faviconUrl;
    private String primaryColor;
    private String homePath;
    private boolean enabled;
    private int orderNum;
}
