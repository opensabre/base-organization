package io.github.opensabre.organization.entity.vo;

import io.github.opensabre.common.web.entity.vo.BaseVo;
import io.github.opensabre.organization.entity.po.Menu;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.beans.BeanUtils;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Data
@NoArgsConstructor
public class MenuVo extends BaseVo {

    public MenuVo(Menu menu) {
        BeanUtils.copyProperties(menu, this);
    }

    private String parentId;
    private String name;
    private String type;
    private String href;
    private String icon;
    private int orderNum;
    private String description;
    private List<MenuVo> children = new ArrayList<>();
    private String createdBy;
    private String updatedBy;
    private Date createdTime;
    private Date updatedTime;
}
