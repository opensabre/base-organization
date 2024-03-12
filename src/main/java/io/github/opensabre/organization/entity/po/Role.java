package io.github.opensabre.organization.entity.po;

import com.baomidou.mybatisplus.annotation.TableField;
import io.github.opensabre.persistence.entity.po.BasePo;
import io.swagger.v3.oas.annotations.media.Schema;
import lombok.*;

import java.util.Set;

@Data
@Schema(description = "角色")
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Role extends BasePo {
    @Schema(title = "角色编码", description = "用户设定的角色代码", example="ROLE_ADMIN")
    private String code;
    @Schema(title = "角色名称", description = "用户设定的角色名称", example="管理员")
    private String name;
    @Schema(title = "角色描述", description = "对角色的描述，如职能、权限、范围等", example="超级管理员，IT系统管理")
    private String description;

    @TableField(exist = false)
    private Set<String> resourceIds;
}
