package io.github.opensabre.organization.iqcscheduler;

import io.github.opensabre.boot.annotations.ResourcePermission;
import io.github.opensabre.security.context.InternalTokenUserContext;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

/** Service-only current access lookup. Caller identity comes only from verified framework claims. */
@RestController @RequiredArgsConstructor
@RequestMapping("/internal/iqc/scheduler-access")
public class IqcSchedulerAccessController {
    private final InternalTokenUserContext tokens;
    private final IqcSchedulerAccessService access;
    @GetMapping("/{userId}")
    @ResourcePermission(register=false)
    public IqcSchedulerAccessService.Access resolve(@PathVariable String userId) {
        var claims=tokens.currentClaims();
        if(claims==null || !"iqc-platform".equals(claims.issuer()) || !"iqc-platform".equals(claims.source())
                || !"service:iqc-platform".equals(claims.subject()) || !"base-organization".equals(claims.audience())
                || !"base-organization".equals(claims.destination()) || claims.hop()!=1
                || !claims.roles().isEmpty() || !claims.scopes().isEmpty() || !claims.authorities().isEmpty())
            throw new SecurityException("IQC scheduler service identity required");
        return access.resolve(userId);
    }
}
