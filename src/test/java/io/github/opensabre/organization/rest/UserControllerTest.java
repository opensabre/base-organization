package io.github.opensabre.organization.rest;

import io.github.opensabre.common.core.util.UserContextHolder;
import io.github.opensabre.organization.entity.po.User;
import io.github.opensabre.organization.entity.vo.UserVo;
import io.github.opensabre.organization.service.IUserService;
import org.junit.jupiter.api.Test;
import org.mockito.ArgumentCaptor;
import org.springframework.http.MediaType;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.Mockito.when;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.post;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

class UserControllerTest {

    @Test
    void addShouldRejectMissingPasswordBeforeCallingService() throws Exception {
        IUserService userService = mock(IUserService.class);
        MockMvc mockMvc = mockMvc(userService);

        mockMvc.perform(post("/user")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "username": "tester",
                                  "mobile": "13800000000",
                                  "name": "测试用户"
                                }
                                """))
                .andExpect(status().isBadRequest());

        verifyNoInteractions(userService);
    }

    @Test
    void updateShouldAllowMissingPassword() throws Exception {
        IUserService userService = mock(IUserService.class);
        when(userService.update(any(User.class))).thenReturn(true);
        MockMvc mockMvc = mockMvc(userService);

        mockMvc.perform(put("/user/100")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("""
                                {
                                  "username": "tester",
                                  "mobile": "13800000000",
                                  "name": "测试用户"
                                }
                                """))
                .andExpect(status().isOk());

        ArgumentCaptor<User> userCaptor = ArgumentCaptor.forClass(User.class);
        verify(userService).update(userCaptor.capture());
        assertThat(userCaptor.getValue().getId()).isEqualTo("100");
        assertThat(userCaptor.getValue().getPassword()).isNull();
    }

    @Test
    void currentShouldResolveTheGatewayAuthenticatedUser() throws Exception {
        IUserService userService = mock(IUserService.class);
        User user = new User();
        user.setId("200");
        when(userService.getByUniqueId("tester")).thenReturn(user);
        when(userService.get("200")).thenReturn(new UserVo(user));
        MockMvc mockMvc = mockMvc(userService);

        UserContextHolder.getInstance().setContext(java.util.Map.of("user_name", "tester"));
        try {
            mockMvc.perform(get("/user/current"))
                    .andExpect(status().isOk());
        } finally {
            UserContextHolder.getInstance().clear();
        }

        verify(userService).getByUniqueId("tester");
        verify(userService).get("200");
    }

    private static MockMvc mockMvc(IUserService userService) {
        UserController userController = new UserController();
        ReflectionTestUtils.setField(userController, "userService", userService);

        LocalValidatorFactoryBean validator = new LocalValidatorFactoryBean();
        validator.afterPropertiesSet();

        return MockMvcBuilders.standaloneSetup(userController)
                .setValidator(validator)
                .build();
    }
}
