package io.github.opensabre.organization.entity.form;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.github.opensabre.organization.entity.param.UserQueryParam;
import io.github.opensabre.persistence.entity.form.BaseQueryForm;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;

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

    @Schema(title = "用户组ID")
    private String groupId;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Schema(title = "查询开始时间")
    private Date createdTimeStart;

    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    @Schema(title = "查询结束时间")
    private Date createdTimeEnd;
}
