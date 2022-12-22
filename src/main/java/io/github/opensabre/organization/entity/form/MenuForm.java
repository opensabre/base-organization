package io.github.opensabre.organization.entity.form;

import io.github.opensabre.common.web.entity.form.BaseForm;
import io.github.opensabre.organization.entity.po.Menu;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.validation.constraints.NotBlank;

@EqualsAndHashCode(callSuper = true)
@Schema
@Data
public class MenuForm extends BaseForm<Menu> {

    @NotBlank(message = "菜单父id不能为空")
    @Schema(title = "菜单父id")
    private String parentId;

    @NotBlank(message = "菜单名称不能为空")
    @Schema(title = "菜单名称")
    private String name;

    @NotBlank(message = "菜单类型不能为空")
    @Schema(title = "菜单类型")
    private String type;

    @NotBlank(message = "菜单路径不能为空")
    @Schema(title = "菜单路径")
    private String href;

    @Schema(title = "菜单图标")
    private String icon;

    @Schema(title = "菜单序号")
    private String orderNum;

    @Schema(title = "菜单描述")
    private String description;
}
