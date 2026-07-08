package io.github.opensabre.organization.rest;

import io.github.opensabre.organization.service.IPositionService;
import io.github.opensabre.organization.service.IRoleMenuService;
import io.github.opensabre.organization.service.IRoleResourceService;
import io.github.opensabre.organization.service.IRoleService;
import io.github.opensabre.organization.entity.param.PositionQueryParam;
import org.junit.jupiter.api.Test;
import org.springframework.http.MediaType;
import org.springframework.test.util.ReflectionTestUtils;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;
import org.springframework.validation.beanvalidation.LocalValidatorFactoryBean;

import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.verifyNoInteractions;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.when;
import static org.assertj.core.api.Assertions.assertThat;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.put;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

class ControllerValidationTest {

    @Test
    void roleMenusShouldRejectEmptyIdsBeforeCallingService() throws Exception {
        IRoleMenuService roleMenuService = mock(IRoleMenuService.class);
        MockMvc mockMvc = roleMockMvc(roleMenuService, mock(IRoleResourceService.class));

        mockMvc.perform(put("/role/100/menus")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("[]"))
                .andExpect(status().isBadRequest());

        verifyNoInteractions(roleMenuService);
    }

    @Test
    void roleResourcesShouldRejectEmptyIdsBeforeCallingService() throws Exception {
        IRoleResourceService roleResourceService = mock(IRoleResourceService.class);
        MockMvc mockMvc = roleMockMvc(mock(IRoleMenuService.class), roleResourceService);

        mockMvc.perform(put("/role/100/resources")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content("[]"))
                .andExpect(status().isBadRequest());

        verifyNoInteractions(roleResourceService);
    }

    @Test
    void simpleQueryShouldAllowMissingNameToLoadAllPositions() throws Exception {
        IPositionService positionService = mock(IPositionService.class);
        when(positionService.query(any(PositionQueryParam.class))).thenReturn(java.util.List.of());
        PositionController positionController = new PositionController();
        ReflectionTestUtils.setField(positionController, "positionService", positionService);

        mockMvc(positionController)
                .perform(get("/position"))
                .andExpect(status().isOk());

        org.mockito.ArgumentCaptor<PositionQueryParam> captor = org.mockito.ArgumentCaptor.forClass(PositionQueryParam.class);
        verify(positionService).query(captor.capture());
        assertThat(captor.getValue().getName()).isNull();
    }

    private static MockMvc roleMockMvc(IRoleMenuService roleMenuService, IRoleResourceService roleResourceService) {
        RoleController roleController = new RoleController();
        ReflectionTestUtils.setField(roleController, "roleService", mock(IRoleService.class));
        ReflectionTestUtils.setField(roleController, "roleMenuService", roleMenuService);
        ReflectionTestUtils.setField(roleController, "roleResourceService", roleResourceService);
        return mockMvc(roleController);
    }

    private static MockMvc mockMvc(Object controller) {
        LocalValidatorFactoryBean validator = new LocalValidatorFactoryBean();
        validator.afterPropertiesSet();

        return MockMvcBuilders.standaloneSetup(controller)
                .setValidator(validator)
                .build();
    }
}
