package io.github.opensabre.organization.rest;

import io.github.opensabre.boot.annotations.ResourcePermission;
import io.github.opensabre.boot.entity.ResourceMappingSnapshot;
import io.github.opensabre.organization.entity.vo.ResourceRegistrationResult;
import io.github.opensabre.organization.service.IResourceRegistrationService;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestHeader;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/internal/resource-registrations")
@RequiredArgsConstructor
public class ResourceRegistrationController {
    private final IResourceRegistrationService registrationService;
    @Value("${opensabre.governance.registration-token:}")
    private String registrationToken;

    @PutMapping("/{application}")
    @ResourcePermission(register = false)
    public ResourceRegistrationResult register(@PathVariable String application,
                                               @RequestParam(defaultValue = "false") boolean markMissing,
                                               @RequestHeader("X-Opensabre-Resource-Registration-Token") String token,
                                               @RequestBody ResourceMappingSnapshot snapshot) {
        if (registrationToken.isBlank() || !java.security.MessageDigest.isEqual(
                registrationToken.getBytes(java.nio.charset.StandardCharsets.UTF_8),
                token.getBytes(java.nio.charset.StandardCharsets.UTF_8))) {
            throw new SecurityException("invalid resource registration token");
        }
        if (snapshot == null) {
            throw new IllegalArgumentException("snapshot must not be null");
        }
        snapshot.setApplication(application);
        return registrationService.register(snapshot, markMissing);
    }
}
