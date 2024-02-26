package io.github.opensabre.organization.entity.form;

import io.github.opensabre.common.web.entity.form.BaseForm;
import io.github.opensabre.organization.entity.po.Group;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import jakarta.validation.constraints.NotBlank;

@EqualsAndHashCode(callSuper = true)
@Schema
@Data
public class GroupForm extends BaseForm<Group> {

    @NotBlank(message = "用户组父id不能为空")
    @Schema(title = "用户组父id")
    private String parentId;

    @NotBlank(message = "用户组名称不能为空")
    @Schema(title = "用户组名称")
    private String name;

    @Schema(title = "用户组描述")
    private String description;
}
