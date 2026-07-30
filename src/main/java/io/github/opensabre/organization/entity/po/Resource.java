package io.github.opensabre.organization.entity.po;

import io.github.opensabre.persistence.entity.po.BasePo;
import lombok.*;

import java.util.Date;

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
    private String application;
    private String source;
    private String status;
    private String handler;
    private Date firstSeenAt;
    private Date lastSeenAt;
    private Date missingSince;
    private String appVersion;
}

