package io.github.opensabre.organization.entity.form;

import jakarta.validation.Validation;
import jakarta.validation.Validator;
import org.junit.jupiter.api.Test;

import static org.assertj.core.api.Assertions.assertThat;

class MenuFormValidationTest {

    private final Validator validator = Validation.buildDefaultValidatorFactory().getValidator();

    @Test
    void shouldAllowEmptyHrefForButton() {
        MenuForm form = menuForm("BUTTON", "");

        assertThat(validator.validate(form)).isEmpty();
    }

    @Test
    void shouldRequireHrefForRouteMenu() {
        MenuForm form = menuForm("MENU", "");

        assertThat(validator.validate(form))
                .extracting(violation -> violation.getMessage())
                .contains("菜单路径不能为空");
    }

    @Test
    void shouldCopyNumericOrderNumToMenu() {
        MenuForm form = menuForm("MENU", "/system/menu");
        form.setOrderNum(12);

        assertThat(form.toPo(io.github.opensabre.organization.entity.po.Menu.class).getOrderNum()).isEqualTo(12);
    }

    private MenuForm menuForm(String type, String href) {
        MenuForm form = new MenuForm();
        form.setParentId("120");
        form.setName("发布 OAuth2 认证方式");
        form.setType(type);
        form.setHref(href);
        return form;
    }
}
