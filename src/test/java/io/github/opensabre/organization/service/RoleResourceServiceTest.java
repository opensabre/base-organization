package io.github.opensabre.organization.service;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import jakarta.annotation.Resource;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class RoleResourceServiceTest {

    @Resource
    private IRoleResourceService roleResourceService;

    @Test
    void saveBatchShouldReplaceAndClearRoleResources() {
        assertThat(roleResourceService.saveBatch("102", Set.of("101", "102"))).isTrue();
        assertThat(roleResourceService.queryByRoleId("102")).containsExactlyInAnyOrder("101", "102");

        assertThat(roleResourceService.saveBatch("102", Set.of())).isTrue();
        assertThat(roleResourceService.queryByRoleId("102")).isEmpty();
    }
}
