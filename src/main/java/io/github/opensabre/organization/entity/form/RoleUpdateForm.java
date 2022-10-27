package io.github.opensabre.organization.entity.form;

import io.github.opensabre.common.web.entity.form.BaseForm;
import io.github.opensabre.organization.entity.po.Role;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import java.util.Set;

@Schema
@Data
public class RoleUpdateForm extends BaseForm<Role> {

    @Schema(title = "角色编码")
    private String code;

    @Schema(title = "角色名称")
    private String name;

    @Schema(title = "角色描述")
    private String description;

    @Schema(title = "角色拥有的资源id列表")
    private Set<String> resourceIds;

}