package io.github.opensabre.organization.service;

import io.github.opensabre.boot.entity.ResourceMappingSnapshot;
import io.github.opensabre.organization.entity.vo.ResourceRegistrationResult;

public interface IResourceRegistrationService {
    ResourceRegistrationResult register(ResourceMappingSnapshot snapshot, boolean markMissing);
}
