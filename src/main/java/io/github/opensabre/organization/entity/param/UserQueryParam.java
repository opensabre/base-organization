package io.github.opensabre.organization.entity.param;

import io.github.opensabre.persistence.entity.param.BaseParam;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class UserQueryParam extends BaseParam {
    private String name;
    private String mobile;
    private String username;
}
