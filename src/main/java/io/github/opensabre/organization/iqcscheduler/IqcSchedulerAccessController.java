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
    /** Fresh projection for the verified current IQC user, reusing the original rows and transaction. */
    @GetMapping("/current/{userId}")
    @ResourcePermission(register=false)
    public IqcSchedulerAccessService.Access current(@PathVariable String userId) {
        var claims=tokens.currentClaims();
        if(claims==null || !"iqc-platform".equals(claims.issuer()) || !"iqc-platform".equals(claims.source())
                || !"base-organization".equals(claims.audience()) || !"base-organization".equals(claims.destination())
                || claims.hop()<2 || claims.subject()==null || claims.subject().startsWith("service:")
                || claims.username()==null || claims.username().isBlank()
                || !(claims.subject().equals(userId) || claims.subject().equals(claims.username())))
            throw new SecurityException("IQC current user identity required");
        var projected=access.resolve(userId);
        if(!projected.accountValid() || !userId.equals(projected.userId()) || !claims.username().equals(projected.username()))
            throw new SecurityException("IQC current user account mismatch");
        return projected;
    }

}
