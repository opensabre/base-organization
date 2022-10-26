package io.github.opensabre.organization.entity.param;

import io.github.opensabre.common.web.entity.param.BaseParam;
import io.github.opensabre.organization.entity.po.Group;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class GroupQueryParam extends BaseParam<Group> {
    private String name;
}
