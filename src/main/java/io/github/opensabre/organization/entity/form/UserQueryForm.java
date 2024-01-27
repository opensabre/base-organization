package io.github.opensabre.organization.entity.form;

import io.github.opensabre.organization.entity.param.UserQueryParam;
import io.github.opensabre.persistence.entity.form.BaseQueryForm;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import org.springframework.format.annotation.DateTimeFormat;

import javax.validation.constraints.Past;
import java.util.Date;

@Schema
@Data
public class UserQueryForm extends BaseQueryForm<UserQueryParam> {

    @Schema(title = "用户名")
    private String username;

    @Schema(title = "用户姓名")
    private String name;

    @Schema(title = "手机号")
    private String mobile;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    @Past(message = "查询开始时间必须小于当前日期")
    @Schema(title = "查询开始时间")
    private Date createdTimeStart;

    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    @Past(message = "查询结束时间必须小于当前日期")
    @Schema(title = "查询结束时间")
    private Date createdTimeEnd;
}
