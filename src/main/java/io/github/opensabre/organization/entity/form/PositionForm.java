package io.github.opensabre.organization.entity.form;

import io.github.opensabre.common.web.entity.form.BaseForm;
import io.github.opensabre.organization.entity.po.Position;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

import javax.validation.constraints.NotBlank;

@Schema
@Data
public class PositionForm extends BaseForm<Position> {

    @NotBlank(message = "职位名称不能为空")
    @Schema(title = "职位名称")
    private String name;

    @Schema(title = "职位描述")
    private String description;
}
