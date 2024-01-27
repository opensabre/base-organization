package io.github.opensabre.organization.entity.po;

import com.baomidou.mybatisplus.annotation.TableField;
import io.github.opensabre.persistence.entity.po.BasePo;
import lombok.*;

import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Role extends BasePo {
    private String code;
    private String name;
    private String description;

    @TableField(exist = false)
    private Set<String> resourceIds;
}
