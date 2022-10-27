package io.github.opensabre.organization.entity.form;

import io.github.opensabre.common.web.entity.form.BaseQueryForm;
import io.github.opensabre.organization.entity.param.GroupQueryParam;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import javax.validation.constraints.NotBlank;
import javax.validation.constraints.Past;
import java.util.Date;

@Schema
@Data
public class GroupQueryForm extends BaseQueryForm<GroupQueryParam> {

    @NotBlank(message = "用户组名称不能为空")
    @Schema(title = "用户组名称", required = true)
    private String name;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    @Past(message = "查询开始时间必须小于当前日期")
    @Schema(title = "查询开始时间")
    private Date createdTimeStart;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    @Past(message = "查询结束时间必须小于当前日期")
    @Schema(title = "查询结束时间")
    private Date createdTimeEnd;
}
