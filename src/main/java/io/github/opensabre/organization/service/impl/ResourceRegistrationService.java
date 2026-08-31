package io.github.opensabre.organization.service.impl;

import com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper;
import com.baomidou.mybatisplus.core.toolkit.IdWorker;
import io.github.opensabre.boot.entity.ResourceMappingSnapshot;
import io.github.opensabre.boot.entity.RestMappingInfo;
import io.github.opensabre.organization.dao.ResourceMapper;
import io.github.opensabre.organization.entity.po.Resource;
import io.github.opensabre.organization.entity.vo.ResourceRegistrationResult;
import io.github.opensabre.organization.service.IResourceRegistrationService;
import io.github.opensabre.organization.service.IResourceService;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.nio.charset.StandardCharsets;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

@Service
@RequiredArgsConstructor
public class ResourceRegistrationService implements IResourceRegistrationService {
    static final String SOURCE_ANNOTATION = "ANNOTATION";
    static final String SOURCE_DISCOVERED = "DISCOVERED";
    static final String STATUS_PENDING = "PENDING";
    static final String STATUS_STALE = "STALE";

    private final IResourceService resourceService;
    private final ResourceMapper resourceMapper;
    private final io.github.opensabre.organization.service.IProductService productService;

    @Override
    @Transactional
    public ResourceRegistrationResult register(ResourceMappingSnapshot snapshot, boolean markMissing) {
        if (snapshot == null || StringUtils.isBlank(snapshot.getApplication())) {
            throw new IllegalArgumentException("application must not be blank");
        }
        String application = snapshot.getApplication().trim();
        Set<RestMappingInfo> mappings = snapshot.getResources() == null ? Set.of() : snapshot.getResources();
        List<Resource> applicationResources = resourceService.list(new LambdaQueryWrapper<Resource>()
                .eq(Resource::getApplication, application));
        Map<String, Resource> byEndpoint = new HashMap<>();
        applicationResources.forEach(resource -> byEndpoint.put(endpointKey(resource.getMethod(), resource.getUrl()), resource));

        Set<String> declaredCodes = new HashSet<>();
        mappings.stream().map(RestMappingInfo::getCode).filter(StringUtils::isNotBlank).forEach(declaredCodes::add);
        Map<String, Resource> byCode = new HashMap<>();
        if (!declaredCodes.isEmpty()) {
            resourceService.list(new LambdaQueryWrapper<Resource>().in(Resource::getCode, declaredCodes))
                    .forEach(resource -> byCode.put(resource.getCode(), resource));
        }

        Date now = new Date();
        int created = 0;
        int updated = 0;
        Set<String> seenIds = new HashSet<>();
        List<Resource> changes = new ArrayList<>();
        for (RestMappingInfo mapping : mappings) {
            if (StringUtils.isBlank(mapping.getUrl()) || StringUtils.isBlank(mapping.getMethod())) {
                continue;
            }
            Resource resource = StringUtils.isNotBlank(mapping.getCode()) ? byCode.get(mapping.getCode()) : null;
            if (resource != null && !"legacy".equals(resource.getApplication())
                    && !application.equals(resource.getApplication())) {
                throw new IllegalArgumentException("resource code " + mapping.getCode()
                        + " is already owned by " + resource.getApplication());
            }
            if (resource == null) {
                resource = byEndpoint.get(endpointKey(mapping.getMethod(), mapping.getUrl()));
            }
            boolean isNew = resource == null;
            if (isNew) {
                resource = new Resource();
                resource.setId(IdWorker.getIdStr());
                resource.setCode(StringUtils.defaultIfBlank(mapping.getCode(), discoveredCode(application, mapping)));
                resource.setName(StringUtils.defaultIfBlank(mapping.getName(), mapping.getHandlerMethod()));
                resource.setType(StringUtils.defaultIfBlank(mapping.getType(), application));
                resource.setUrl(mapping.getUrl());
                resource.setMethod(mapping.getMethod());
                resource.setDescription(mapping.getDescription());
                resource.setProductCode(productService.resolveProductCode(application));
                resource.setStatus(STATUS_PENDING);
                resource.setFirstSeenAt(now);
                resource.setCreatedTime(now);
                resource.setCreatedBy("system");
                created++;
            } else {
                updated++;
            }
            resource.setApplication(application);
            if (StringUtils.isBlank(resource.getProductCode())) {
                resource.setProductCode(productService.resolveProductCode(application));
            }
            resource.setSource(mapping.isDeclaredPermission() ? SOURCE_ANNOTATION : SOURCE_DISCOVERED);
            resource.setHandler(mapping.getHandlerClass() + "#" + mapping.getHandlerMethod());
            resource.setLastSeenAt(now);
            resource.setMissingSince(null);
            resource.setAppVersion(snapshot.getVersion());
            resource.setUpdatedTime(now);
            resource.setUpdatedBy("system");
            if (mapping.isDeclaredPermission()) {
                resource.setCode(mapping.getCode());
                resource.setName(mapping.getName());
                resource.setType(StringUtils.defaultIfBlank(mapping.getType(), application));
                resource.setUrl(mapping.getUrl());
                resource.setMethod(mapping.getMethod());
                resource.setDescription(mapping.getDescription());
            }
            resourceMapper.upsertRegistration(resource);
            changes.add(resourceService.getOne(new LambdaQueryWrapper<Resource>()
                    .eq(Resource::getCode, resource.getCode())));
        }
        changes.stream().map(Resource::getId).filter(StringUtils::isNotBlank).forEach(seenIds::add);

        int stale = 0;
        if (markMissing) {
            for (Resource resource : applicationResources) {
                if (!seenIds.contains(resource.getId()) && isGenerated(resource.getSource())) {
                    resource.setStatus(STATUS_STALE);
                    resource.setMissingSince(now);
                    resource.setAppVersion(snapshot.getVersion());
                    resourceService.updateById(resource);
                    stale++;
                }
            }
        }
        return new ResourceRegistrationResult(created, updated, stale, mappings.size());
    }

    private boolean isGenerated(String source) {
        return SOURCE_ANNOTATION.equals(source) || SOURCE_DISCOVERED.equals(source);
    }

    private String endpointKey(String method, String url) {
        return StringUtils.upperCase(method) + " " + url;
    }

    private String discoveredCode(String application, RestMappingInfo mapping) {
        String identity = application + ":" + endpointKey(mapping.getMethod(), mapping.getUrl());
        return "discovered:" + UUID.nameUUIDFromBytes(identity.getBytes(StandardCharsets.UTF_8));
    }
}
