package io.github.opensabre.organization.entity.form;

import io.github.opensabre.common.web.entity.form.BaseForm;
import io.github.opensabre.organization.entity.po.Position;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import javax.validation.constraints.NotBlank;

@EqualsAndHashCode(callSuper = true)
@Schema
@Data
public class PositionForm extends BaseForm<Position> {

    @NotBlank(message = "职位名称不能为空")
    @Schema(title = "职位名称")
    private String name;

    @Schema(title = "职位描述")
    private String description;
}
