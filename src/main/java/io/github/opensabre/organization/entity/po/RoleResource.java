package io.github.opensabre.organization.entity.po;

import io.github.opensabre.common.web.entity.po.BasePo;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class RoleResource extends BasePo {
    private String roleId;
    private String resourceId;
}
