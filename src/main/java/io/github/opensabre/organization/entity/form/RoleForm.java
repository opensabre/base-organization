package io.github.opensabre.organization.entity.form;

import io.github.opensabre.common.web.entity.form.BaseForm;
import io.github.opensabre.organization.entity.po.Role;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import jakarta.validation.constraints.NotBlank;
import java.util.Set;

@EqualsAndHashCode(callSuper = true)
@Schema
@Data
public class RoleForm extends BaseForm<Role> {

    @NotBlank(message = "角色编码不能为空")
    @Schema(title = "角色编码", description = "用户设定的角色代码", example="ROLE_ADMIN")
    private String code;

    @NotBlank(message = "角色名称不能为空")
    @Schema(title = "角色名称", description = "用户设定的角色名称", example="管理员")
    private String name;

    @Schema(title = "角色描述", description = "对角色的描述，如职能、权限、范围等", example="超级管理员，IT系统管理")
    private String description;

    @Schema(title = "角色拥有的资源id列表")
    private Set<String> resourceIds;

}
