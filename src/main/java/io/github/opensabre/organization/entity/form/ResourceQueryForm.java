package io.github.opensabre.organization.entity.form;

import io.github.opensabre.organization.entity.param.ResourceQueryParam;
import io.github.opensabre.persistence.entity.form.BaseQueryForm;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import jakarta.validation.constraints.Past;
import java.util.Date;

@Schema
@Data
public class ResourceQueryForm extends BaseQueryForm<ResourceQueryParam> {

    @Schema(title = "资源名称")
    private String name;

    @Schema(title = "资源编码")
    private String code;

    @Schema(title = "资源路径")
    private String url;

    @Schema(title = "资源方法")
    private String method;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    @Past(message = "查询开始时间必须小于当前日期")
    @Schema(title = "查询开始时间")
    private Date createdTimeStart;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    @Past(message = "查询结束时间必须小于当前日期")
    @Schema(title = "查询结束时间")
    private Date createdTimeEnd;
}
