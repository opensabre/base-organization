package io.github.opensabre.organization.entity.form;

import io.github.opensabre.common.web.entity.form.BaseForm;
import io.github.opensabre.organization.entity.po.Product;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Data;
import lombok.EqualsAndHashCode;

/** 产品新增和编辑表单。 */
@Data
@EqualsAndHashCode(callSuper = true)
public class ProductForm extends BaseForm<Product> {
    @NotBlank
    @Pattern(regexp = "COMMON|[a-z][a-z0-9-]{1,63}", message = "产品编码只能使用 COMMON 或小写字母、数字和连字符")
    private String code;
    @NotBlank private String name;
    @NotBlank private String shortName;
    private String description;
    private String logoUrl;
    private String collapsedLogoUrl;
    private String faviconUrl;
    @Pattern(regexp = "^$|^#[0-9A-Fa-f]{6}$", message = "主题色必须是六位十六进制颜色")
    private String primaryColor;
    @NotBlank private String homePath;
    private boolean enabled = true;
    private Integer orderNum = 0;
}
