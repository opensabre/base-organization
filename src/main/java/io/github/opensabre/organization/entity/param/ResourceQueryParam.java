package io.github.opensabre.organization.entity.param;

import io.github.opensabre.common.web.entity.param.BaseParam;
import io.github.opensabre.organization.entity.po.Resource;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ResourceQueryParam extends BaseParam<Resource> {
    private String name;
    private String code;
    private String type;
    private String url;
    private String method;
}
