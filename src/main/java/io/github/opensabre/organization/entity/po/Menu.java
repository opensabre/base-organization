package io.github.opensabre.organization.entity.po;

import io.github.opensabre.persistence.entity.po.BasePo;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Menu extends BasePo {
    private String parentId;
    private String name;
    private String type;
    private String href;
    private String icon;
    private int orderNum;
    private String description;
}
