package io.github.opensabre.organization.entity.param;

import io.github.opensabre.common.web.entity.param.BaseParam;
import io.github.opensabre.organization.entity.po.User;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class UserQueryParam extends BaseParam<User> {
    private String name;
    private String mobile;
    private String username;
}
