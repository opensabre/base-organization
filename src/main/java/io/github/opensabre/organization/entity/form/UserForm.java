package io.github.opensabre.organization.entity.form;

import io.github.opensabre.common.web.entity.form.BaseForm;
import io.github.opensabre.organization.entity.po.User;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Data;
import org.hibernate.validator.constraints.Length;

import javax.validation.constraints.NotBlank;
import java.util.Set;

@Schema
@Data
public class UserForm extends BaseForm<User> {

    @Schema(title = "用户账号")
    @NotBlank(message = "用户名不能为空")
    @Length(min = 3, max = 20, message = "用户名长度在3到20个字符")
    private String username;

    @Schema(title = "用户密码")
    @NotBlank(message = "用户密码不能为空")
    @Length(min = 5, max = 20, message = "密码长度在5到20个字符")
    private String password;

    @Schema(title = "用户手机号")
    @NotBlank(message = "用户手机号不能为空")
    private String mobile;

    @Schema(title = "用户姓名")
    @NotBlank(message = "用户姓名不能为空")
    private String name;

    @Schema(title = "用户描述")
    private String description;

    @Schema(title = "用户拥有的角色id列表")
    private Set<String> roleIds;

    @Schema(title = "用户状态，true为可用")
    private Boolean enabled = true;

    @Schema(title = "用户账号是否过期，true为未过期")
    private Boolean accountNonExpired = true;

    @Schema(title = "用户密码是否过期，true为未过期")
    private Boolean credentialsNonExpired = true;

    @Schema(title = "用户账号是否被锁定，true为未锁定")
    private Boolean accountNonLocked = true;
}
