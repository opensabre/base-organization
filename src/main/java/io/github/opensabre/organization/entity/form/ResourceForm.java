package io.github.opensabre.organization.entity.form;

import io.github.opensabre.common.web.entity.form.BaseForm;
import io.github.opensabre.organization.entity.po.Resource;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import lombok.EqualsAndHashCode;

import jakarta.validation.constraints.NotBlank;

@EqualsAndHashCode(callSuper = true)
@Schema
@Data
public class ResourceForm extends BaseForm<Resource> {

    @NotBlank(message = "资源名称不能为空")
    @Schema(title = "资源名称")
    private String name;

    @NotBlank(message = "资源编码不能为空")
    @Schema(title = "资源编码")
    private String code;

    @NotBlank(message = "资源类型不能为空")
    @Schema(title = "资源类型")
    private String type;

    @NotBlank(message = "资源路径不能为空")
    @Schema(title = "资源路径")
    private String url;

    @NotBlank(message = "资源方法不能为空")
    @Schema(title = "资源方法")
    private String method;

    @Schema(title = "资源描述")
    private String description;
}
