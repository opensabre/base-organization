package io.github.opensabre.organization.entity.po;

import com.baomidou.mybatisplus.annotation.InterceptorIgnore;
import io.github.opensabre.persistence.entity.po.BasePo;
import lombok.*;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
@EqualsAndHashCode(callSuper = true)
public class Resource extends BasePo {
    private String code;
    private String type;
    private String url;
    private String method;
    private String name;
    private String description;
}


