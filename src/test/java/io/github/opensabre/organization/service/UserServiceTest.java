package io.github.opensabre.organization.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.github.opensabre.organization.entity.param.UserQueryParam;
import io.github.opensabre.organization.entity.vo.UserVo;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import jakarta.annotation.Resource;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class UserServiceTest {

    @Resource
    private IUserService userService;

    @Test
    void queryShouldFilterByGroupId() {
        UserQueryParam queryParam = new UserQueryParam();
        queryParam.setGroupId("101");

        IPage<UserVo> page = userService.query(new Page<>(1, 10), queryParam);

        assertThat(page.getRecords()).extracting(UserVo::getId).containsExactlyInAnyOrder("101", "102");
        assertThat(page.getTotal()).isEqualTo(2);
    }
}
