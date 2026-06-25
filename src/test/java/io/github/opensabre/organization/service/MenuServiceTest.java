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

        assertThat(menus).extracting(MenuVo::getId).containsExactly("101");
        assertThat(menus.get(0).getChildren()).extracting(MenuVo::getId).containsExactly("102", "103");
    }
}
