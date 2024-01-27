package io.github.opensabre.organization.entity.param;

import io.github.opensabre.persistence.entity.param.BaseParam;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class RoleQueryParam extends BaseParam {
    private String code;
    private String name;
}
