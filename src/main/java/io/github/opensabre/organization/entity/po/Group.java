package io.github.opensabre.organization.entity.po;

import com.baomidou.mybatisplus.annotation.TableLogic;
import io.github.opensabre.persistence.entity.po.BasePo;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class Group extends BasePo {
    private String name;
    private String parentId;
    private String description;
    @TableLogic
    private String deleted = "N";
}
