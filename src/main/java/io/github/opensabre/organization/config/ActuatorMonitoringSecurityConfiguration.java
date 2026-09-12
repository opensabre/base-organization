package io.github.opensabre.organization.config;

import io.github.opensabre.security.actuator.ActuatorMonitoringAccess;
import io.github.opensabre.security.webmvc.InternalTokenAuthenticationFilter;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.authentication.HttpStatusEntryPoint;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.access.intercept.AuthorizationFilter;
import org.springframework.http.HttpStatus;

/** Protects control-plane Actuator metric reads with OpenSabre internal tokens. */
@Configuration(proxyBeanMethods = false)
public class ActuatorMonitoringSecurityConfiguration {

    @Bean
    SecurityFilterChain actuatorMonitoringSecurityFilterChain(
            HttpSecurity http,
            InternalTokenAuthenticationFilter internalTokenAuthenticationFilter)
            throws Exception {
        http
                .csrf(csrf -> csrf.disable())
                .sessionManagement(session ->
                        session.sessionCreationPolicy(SessionCreationPolicy.STATELESS))
                .exceptionHandling(exceptions -> exceptions
                        .authenticationEntryPoint(new HttpStatusEntryPoint(HttpStatus.UNAUTHORIZED)))
                .authorizeHttpRequests(authorize -> authorize
                        .requestMatchers(ActuatorMonitoringAccess.metricPathArray())
                        .hasAuthority(ActuatorMonitoringAccess.AUTHORITY)
                        .anyRequest().permitAll())
                .addFilterBefore(internalTokenAuthenticationFilter, AuthorizationFilter.class);
        return http.build();
    }
}
