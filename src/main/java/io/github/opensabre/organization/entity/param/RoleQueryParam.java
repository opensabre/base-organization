package io.github.opensabre.organization.entity.param;

import io.github.opensabre.common.web.entity.param.BaseParam;
import io.github.opensabre.organization.entity.po.Role;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RoleQueryParam extends BaseParam<Role> {
    private String code;
    private String name;
}
