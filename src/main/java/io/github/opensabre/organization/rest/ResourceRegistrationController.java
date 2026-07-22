package io.github.opensabre.organization.rest;

import io.github.opensabre.boot.annotations.ResourcePermission;
import io.github.opensabre.boot.entity.ResourceMappingSnapshot;
import io.github.opensabre.organization.entity.vo.ResourceRegistrationResult;
import io.github.opensabre.organization.service.IResourceRegistrationService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/internal/resource-registrations")
@RequiredArgsConstructor
public class ResourceRegistrationController {
    private final IResourceRegistrationService registrationService;

    @PutMapping("/{application}")
    @ResourcePermission(register = false)
    public ResourceRegistrationResult register(@PathVariable String application,
                                               @RequestParam(defaultValue = "false") boolean markMissing,
                                               @RequestBody ResourceMappingSnapshot snapshot) {
        snapshot.setApplication(application);
        return registrationService.register(snapshot, markMissing);
    }
}
