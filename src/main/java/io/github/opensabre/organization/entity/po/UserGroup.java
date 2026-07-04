package io.github.opensabre.organization.entity.po;

import io.github.opensabre.persistence.entity.po.BasePo;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class UserGroup extends BasePo {
    private String userId;
    private String groupId;
}
