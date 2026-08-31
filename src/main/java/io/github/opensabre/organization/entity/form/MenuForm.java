package io.github.opensabre.organization.entity.form;

import io.github.opensabre.common.web.entity.form.BaseForm;
import io.github.opensabre.organization.entity.po.Menu;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;
import org.springframework.util.StringUtils;

import jakarta.validation.constraints.AssertTrue;
import jakarta.validation.constraints.NotBlank;

@EqualsAndHashCode(callSuper = true)
@Schema
@Data
public class MenuForm extends BaseForm<Menu> {

    @Schema(title = "产品编码", description = "产品编码或 COMMON")
    private String productCode;

    @NotBlank(message = "菜单父id不能为空")
    @Schema(title = "菜单父id")
    private String parentId;

    @NotBlank(message = "菜单名称不能为空")
    @Schema(title = "菜单名称")
    private String name;

    @NotBlank(message = "菜单类型不能为空")
    @Schema(title = "菜单类型")
    private String type;

    @Schema(title = "菜单路径")
    private String href;

    /** 按钮不对应前端路由，其他菜单类型必须配置路径。 */
    @AssertTrue(message = "菜单路径不能为空")
    public boolean isHrefValidForMenuType() {
        return "BUTTON".equalsIgnoreCase(type) || "B".equalsIgnoreCase(type) || StringUtils.hasText(href);
    }

    @Schema(title = "菜单图标")
    private String icon;

    @Schema(title = "菜单序号")
    private Integer orderNum;

    @Schema(title = "菜单描述")
    private String description;
}
