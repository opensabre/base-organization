package io.github.opensabre.organization.service;

import io.github.opensabre.organization.entity.vo.MenuVo;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import jakarta.annotation.Resource;
import java.util.List;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class MenuServiceTest {

    @Resource
    private IMenuService menuService;

    @Test
    void queryByUserIdShouldReturnAuthorizedMenuTree() {
        List<MenuVo> menus = menuService.queryByUserId("101");

        assertThat(menus).extracting(MenuVo::getId).containsExactly("101", "108", "109", "160", "117");
        assertThat(menus).extracting(MenuVo::getName).containsExactly("基础管理", "安全认证", "系统管理", "网关路由", "研发管理");
        assertThat(menus.get(0).getChildren()).extracting(MenuVo::getId).containsExactly("102", "103", "104", "105", "106", "107", "123");
        assertThat(menus.get(1).getChildren()).extracting(MenuVo::getId).containsExactly("110", "116");
        assertThat(menus.get(1).getChildren().get(1).getHref()).isEqualTo("/auth/online-user");
        assertThat(menus.get(2).getChildren()).extracting(MenuVo::getId).containsExactly("111", "112", "113", "114", "115", "119", "121", "126", "122");
        assertThat(menus.get(2).getHref()).isEqualTo("/sysadmin");
        assertThat(menus.get(2).getChildren().get(0).getHref()).isEqualTo("/sysadmin/audit-log");
        assertThat(menus.get(3).getChildren()).extracting(MenuVo::getId)
                .containsExactly("200", "201", "120", "202", "161", "162", "207", "211", "216");
        assertThat(menus.get(3).getChildren().get(2).getHref()).isEqualTo("/gateway/routes");
        assertThat(menus.get(4).getChildren()).extracting(MenuVo::getId).containsExactly("118");
        assertThat(menus.get(4).getChildren().get(0).getHref()).isEqualTo("/development/api-docs");
    }
}
