package io.github.opensabre.organization.service;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.baomidou.mybatisplus.extension.plugins.pagination.Page;
import io.github.opensabre.organization.entity.param.UserQueryParam;
import io.github.opensabre.organization.entity.vo.UserVo;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import jakarta.annotation.Resource;

import java.time.Instant;
import java.time.temporal.ChronoUnit;
import java.util.Date;

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
        assertThat(page.getRecords()).allSatisfy(user -> {
            assertThat(user.getGroupId()).isEqualTo("101");
            assertThat(user.getGroupName()).isEqualTo("总公司");
        });
        assertThat(page.getRecords()).extracting(UserVo::getGender).containsOnly("M");
        assertThat(page.getTotal()).isEqualTo(2);
    }

    @Test
    void queryShouldFilterByCreatedTimeRange() {
        UserQueryParam queryParam = new UserQueryParam();
        queryParam.setCreatedTimeStart(Date.from(Instant.now().minus(1, ChronoUnit.DAYS)));
        queryParam.setCreatedTimeEnd(Date.from(Instant.now().plus(1, ChronoUnit.DAYS)));

        IPage<UserVo> matchingPage = userService.query(new Page<>(1, 10), queryParam);

        assertThat(matchingPage.getRecords()).extracting(UserVo::getId)
                .containsExactlyInAnyOrder("101", "102");

        queryParam.setCreatedTimeStart(Date.from(Instant.now().plus(1, ChronoUnit.DAYS)));
        queryParam.setCreatedTimeEnd(Date.from(Instant.now().plus(2, ChronoUnit.DAYS)));

        IPage<UserVo> nonMatchingPage = userService.query(new Page<>(1, 10), queryParam);

        assertThat(nonMatchingPage.getRecords()).isEmpty();
    }
}
