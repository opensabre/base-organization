package io.github.opensabre.organization.event;

import io.github.opensabre.boot.event.ResourceMappingsRegisteredEvent;
import io.github.opensabre.organization.entity.vo.ResourceRegistrationResult;
import io.github.opensabre.organization.service.IResourceRegistrationService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.stereotype.Component;

@Component
@RequiredArgsConstructor
@Slf4j
public class LocalResourceMappingRegistrationListener {
    private final IResourceRegistrationService registrationService;

    @EventListener
    public void register(ResourceMappingsRegisteredEvent event) {
        ResourceRegistrationResult result = registrationService.register(event.getSnapshot(), false);
        log.info("Local resources registered: application={}, created={}, updated={}, total={}",
                event.getSnapshot().getApplication(), result.created(), result.updated(), result.total());
    }
}
