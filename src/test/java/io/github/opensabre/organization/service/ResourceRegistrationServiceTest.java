package io.github.opensabre.organization.service;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import io.github.opensabre.boot.entity.ResourceMappingSnapshot;
import io.github.opensabre.boot.entity.RestMappingInfo;
import io.github.opensabre.organization.entity.po.Resource;
import io.github.opensabre.organization.entity.vo.ResourceRegistrationResult;
import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class ResourceRegistrationServiceTest {
    @jakarta.annotation.Resource
    private IResourceRegistrationService registrationService;

    @jakarta.annotation.Resource
    private IResourceService resourceService;

    @Test
    void registerShouldCreatePendingResourceAndRemainIdempotent() {
        ResourceMappingSnapshot snapshot = ResourceMappingSnapshot.builder()
                .application("sample-service")
                .version("1.0.0")
                .resources(Set.of(RestMappingInfo.builder()
                        .url("/sample/{id}")
                        .method("GET")
                        .name("getSample")
                        .handlerClass("example.SampleController")
                        .handlerMethod("get")
                        .build()))
                .build();

        ResourceRegistrationResult first = registrationService.register(snapshot, false);
        ResourceRegistrationResult second = registrationService.register(snapshot, false);

        assertThat(first.created()).isEqualTo(1);
        assertThat(second.created()).isZero();
        assertThat(second.updated()).isEqualTo(1);
        Resource stored = resourceService.getOne(new LambdaQueryWrapper<Resource>()
                .eq(Resource::getApplication, "sample-service")
                .eq(Resource::getMethod, "GET")
                .eq(Resource::getUrl, "/sample/{id}"));
        assertThat(stored.getStatus()).isEqualTo("PENDING");
        assertThat(stored.getSource()).isEqualTo("DISCOVERED");
        assertThat(stored.getCode()).startsWith("discovered:");
    }

    @Test
    void declaredPermissionShouldUpdateExistingCodeWithoutChangingId() {
        Resource existing = resourceService.getOne(new LambdaQueryWrapper<Resource>()
                .eq(Resource::getCode, "resource_manager:view"));
        String existingId = existing.getId();
        ResourceMappingSnapshot snapshot = ResourceMappingSnapshot.builder()
                .application("base-organization")
                .version("1.0.0")
                .resources(Set.of(RestMappingInfo.builder()
                        .code("resource_manager:view")
                        .name("查看资源")
                        .type("resource")
                        .url("/resource/{id}")
                        .method("GET")
                        .handlerClass("example.ResourceController")
                        .handlerMethod("get")
                        .declaredPermission(true)
                        .build()))
                .build();

        registrationService.register(snapshot, false);

        Resource updated = resourceService.getOne(new LambdaQueryWrapper<Resource>()
                .eq(Resource::getCode, "resource_manager:view"));
        assertThat(updated.getId()).isEqualTo(existingId);
        assertThat(updated.getApplication()).isEqualTo("base-organization");
        assertThat(updated.getSource()).isEqualTo("ANNOTATION");
    }
}
