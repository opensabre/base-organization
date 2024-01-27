package io.github.opensabre.organization.entity.po;

import com.baomidou.mybatisplus.annotation.TableField;
import com.baomidou.mybatisplus.annotation.TableLogic;
import io.github.opensabre.organization.entity.vo.UserVo;
import io.github.opensabre.persistence.entity.po.BasePo;
import lombok.*;

import java.util.Set;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class User extends BasePo<UserVo> {
    private String name;
    private String mobile;
    private String username;
    private String password;
    private String description;
    private Boolean enabled;
    private Boolean accountNonExpired;
    private Boolean credentialsNonExpired;
    private Boolean accountNonLocked;
    @TableField(exist = false)
    private Set<String> roleIds;
    @TableLogic
    private String deleted = "N";
}
