package io.github.opensabre.organization.rest;

import io.github.opensabre.boot.entity.ResourceMappingSnapshot;
import io.github.opensabre.organization.entity.vo.ResourceRegistrationResult;
import io.github.opensabre.organization.service.IResourceRegistrationService;
import org.junit.jupiter.api.Test;
import org.springframework.test.util.ReflectionTestUtils;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.mock;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

/** Verifies the internal trust boundary for resource snapshot registration. */
class ResourceRegistrationControllerTest {

    @Test
    void invalidTokenShouldBeRejected() {
        ResourceRegistrationController controller = controller(mock(IResourceRegistrationService.class));

        assertThatThrownBy(() -> controller.register("sample", false, "wrong", new ResourceMappingSnapshot()))
                .isInstanceOf(SecurityException.class);
    }

    @Test
    void validTokenShouldRegisterPathApplication() {
        IResourceRegistrationService service = mock(IResourceRegistrationService.class);
        ResourceRegistrationResult expected = new ResourceRegistrationResult(1, 0, 0, 1);
        ResourceMappingSnapshot snapshot = new ResourceMappingSnapshot();
        when(service.register(snapshot, true)).thenReturn(expected);
        ResourceRegistrationController controller = controller(service);

        ResourceRegistrationResult actual = controller.register("sample", true, "test-token", snapshot);

        assertThat(actual).isSameAs(expected);
        assertThat(snapshot.getApplication()).isEqualTo("sample");
        verify(service).register(snapshot, true);
    }

    private ResourceRegistrationController controller(IResourceRegistrationService service) {
        ResourceRegistrationController controller = new ResourceRegistrationController(service);
        ReflectionTestUtils.setField(controller, "registrationToken", "test-token");
        return controller;
    }
}
