package io.github.opensabre.organization.entity.param;

import io.github.opensabre.common.web.entity.param.BaseParam;
import io.github.opensabre.organization.entity.po.Position;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class PositionQueryParam extends BaseParam<Position> {
    private String name;
}
