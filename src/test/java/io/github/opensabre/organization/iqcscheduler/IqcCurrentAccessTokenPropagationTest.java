package io.github.opensabre.organization.iqcscheduler;

import io.github.opensabre.security.config.InternalTokenProperties;
import io.github.opensabre.security.context.InternalTokenUserContext;
import io.github.opensabre.security.token.*;
import java.time.Instant;
import java.util.List;
import java.util.Map;
import java.util.Set;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.Mockito.*;

/** Actual signing/verification and next-hop factory; HTTP/Feign transport is a separate gate. */
class IqcCurrentAccessTokenPropagationTest {
    @Test void signedUserHopIsAcceptedOnlyByCurrentUserBoundary(){
        var properties=new InternalTokenProperties();properties.setEnabled(true);
        properties.setActiveKeyId("test");properties.setActiveKey("MDEyMzQ1Njc4OWFiY2RlZjAxMjM0NTY3ODlhYmNkZWY=");
        properties.setAllowedIssuers(Set.of("base-gateway","iqc-platform"));
        var json=new tools.jackson.databind.ObjectMapper();
        var signing=new DefaultInternalTokenService(json,properties);
        var iqc=new InternalTokenUserContext(json);var organization=new InternalTokenUserContext(json);
        var access=mock(IqcSchedulerAccessService.class);
        var controller=new IqcSchedulerAccessController(organization,access);
        var projected=new IqcSchedulerAccessService.Access("iqc-scheduler-access-v1","user","alice",true,"group",Set.of(),Set.of("iqc:action:recover"),Instant.now());
        when(access.resolve("user")).thenReturn(projected);
        try{
            var inbound=signing.issue(new InternalTokenRequest("base-gateway","user","alice","iqc-platform",List.of(),List.of(),1,null,null,Map.of()));
            var verified=signing.verify(inbound,"iqc-platform");iqc.bind(verified);
            var outbound=signing.issue(new InternalTokenRequestFactory(iqc).create("iqc-platform","base-organization"));
            var next=signing.verify(outbound,"base-organization");
            assertEquals("user",next.subject());assertEquals("alice",next.username());assertEquals(2,next.hop());
            assertEquals(verified.tokenId(),next.parentTokenId());assertNotEquals(verified.tokenId(),next.tokenId());
            organization.bind(next);assertSame(projected,controller.current("user"));
            assertThrows(SecurityException.class,()->controller.resolve("user"));
            assertThrows(RuntimeException.class,()->signing.verify(outbound,"other-service"));
            assertThrows(RuntimeException.class,()->signing.verify(outbound+"tampered","base-organization"));
        }finally{organization.clear();iqc.clear();}
    }
    /** Production gateway forwards a JWT; the first Servlet-to-service signature has hop one. */
    @Test void externalJwtFirstServletHopUsesCurrentUserBoundary(){
        var properties=new InternalTokenProperties();properties.setEnabled(true);
        properties.setActiveKeyId("test");properties.setActiveKey("MDEyMzQ1Njc4OWFiY2RlZjAxMjM0NTY3ODlhYmNkZWY=");
        properties.setAllowedIssuers(Set.of("iqc-platform"));
        var json=new tools.jackson.databind.ObjectMapper();var signing=new DefaultInternalTokenService(json,properties);
        var iqc=new InternalTokenUserContext(json);var organization=new InternalTokenUserContext(json);
        var access=mock(IqcSchedulerAccessService.class);var controller=new IqcSchedulerAccessController(organization,access);
        var projected=new IqcSchedulerAccessService.Access("iqc-scheduler-access-v1","user","alice",true,"group",Set.of(),Set.of("iqc:task:view"),Instant.now());
        when(access.resolve("user")).thenReturn(projected);
        var security=org.springframework.security.core.context.SecurityContextHolder.getContext();
        var previous=security.getAuthentication();
        try {
            var jwt=org.springframework.security.oauth2.jwt.Jwt.withTokenValue("verified-external-fixture")
                    .header("alg","RS256").subject("user").claim("preferred_username","alice").build();
            security.setAuthentication(new org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationToken(jwt,List.of()));
            var provider=new io.github.opensabre.security.principal.SpringSecurityInternalTokenPrincipalProvider();
            var outbound=signing.issue(new InternalTokenRequestFactory(iqc,provider).create("iqc-platform","base-organization"));
            var verified=signing.verify(outbound,"base-organization");
            assertEquals(1,verified.hop());assertNull(verified.parentTokenId());
            assertEquals("user",verified.subject());assertEquals("alice",verified.username());
            organization.bind(verified);assertSame(projected,controller.current("user"));
            assertThrows(SecurityException.class,()->controller.resolve("user"));
            assertThrows(RuntimeException.class,()->signing.verify(outbound,"other-service"));
            assertThrows(RuntimeException.class,()->signing.verify(outbound+"tampered","base-organization"));
        } finally { organization.clear();iqc.clear();security.setAuthentication(previous); }
    }

}
