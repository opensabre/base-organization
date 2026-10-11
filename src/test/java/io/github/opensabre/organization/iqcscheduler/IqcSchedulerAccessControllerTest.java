package io.github.opensabre.organization.iqcscheduler;

import io.github.opensabre.security.context.InternalTokenUserContext;
import io.github.opensabre.security.token.InternalTokenClaims;
import java.time.Instant;
import java.util.Set;
import java.util.List;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/** Verified-claims boundary; real token verification and HTTP remain separate integration gates. */
class IqcSchedulerAccessControllerTest {
    private final InternalTokenUserContext tokens=mock(InternalTokenUserContext.class);
    private final IqcSchedulerAccessService access=mock(IqcSchedulerAccessService.class);
    private final IqcSchedulerAccessController controller=new IqcSchedulerAccessController(tokens,access);
    private InternalTokenClaims identity(String subject,String username,int hop){
        var claims=mock(InternalTokenClaims.class);
        when(tokens.currentClaims()).thenReturn(claims);
        when(claims.issuer()).thenReturn("iqc-platform");when(claims.source()).thenReturn("iqc-platform");
        when(claims.audience()).thenReturn("base-organization");when(claims.destination()).thenReturn("base-organization");
        when(claims.subject()).thenReturn(subject);when(claims.username()).thenReturn(username);when(claims.hop()).thenReturn(hop);
        when(claims.roles()).thenReturn(List.of());when(claims.scopes()).thenReturn(List.of());when(claims.authorities()).thenReturn(List.of());
        return claims;
    }
    private IqcSchedulerAccessService.Access projection(String id,String owner,boolean valid){
        return new IqcSchedulerAccessService.Access("iqc-scheduler-access-v1",id,owner,valid,"group",Set.of(),Set.of("iqc:action:recover"),Instant.now());
    }
    @Test void missingClaimsNeverReadOrganizationRows(){
        assertThrows(SecurityException.class,()->controller.current("user"));verifyNoInteractions(access);
    }
    @Test void verifiedUserReusesOriginalProjectionForBothSupportedSubjectForms(){
        var result=projection("user","alice",true);when(access.resolve("user")).thenReturn(result);
        identity("alice","alice",2);assertSame(result,controller.current("user"));
        identity("user","alice",2);assertSame(result,controller.current("user"));
    }
    @Test void serviceIdentityCannotUseCurrentUserEndpoint(){
        identity("service:iqc-platform",null,1);
        assertThrows(SecurityException.class,()->controller.current("user"));verifyNoInteractions(access);
    }
    @Test void currentUserCannotUseBackgroundServiceEndpoint(){
        identity("alice","alice",2);
        assertThrows(SecurityException.class,()->controller.resolve("user"));verifyNoInteractions(access);
    }
    @Test void wrongOriginTargetHopOrSubjectRejectBeforeProjection(){
        var claims=identity("alice","alice",2);when(claims.issuer()).thenReturn("other");
        assertThrows(SecurityException.class,()->controller.current("user"));
        claims=identity("alice","alice",2);when(claims.destination()).thenReturn("other");
        assertThrows(SecurityException.class,()->controller.current("user"));
        identity("alice","alice",1);assertThrows(SecurityException.class,()->controller.current("user"));
        identity("foreign","alice",2);assertThrows(SecurityException.class,()->controller.current("user"));verifyNoInteractions(access);
    }
    @Test void foreignInvalidOrMismatchedAccountProjectionCannotBeReturned(){
        identity("alice","alice",2);
        for(var result:List.of(projection("user","bob",true),projection("other","alice",true),projection("user","alice",false))){
            when(access.resolve("user")).thenReturn(result);assertThrows(SecurityException.class,()->controller.current("user"));
        }
    }
    @Test void originalBackgroundEndpointStillAllowsOnlyServiceIdentity(){
        identity("service:iqc-platform",null,1);var result=projection("user","alice",true);
        when(access.resolve("user")).thenReturn(result);assertSame(result,controller.resolve("user"));
    }
}
