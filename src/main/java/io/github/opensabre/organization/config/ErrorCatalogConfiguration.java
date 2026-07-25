package io.github.opensabre.organization.config;

import io.github.opensabre.governance.errorcatalog.ErrorCatalogProvider;
import io.github.opensabre.organization.exception.OrganizationErrorType;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

/** Declares organization business errors for the centralized error-code directory. */
@Configuration
public class ErrorCatalogConfiguration {
    @Bean
    public ErrorCatalogProvider organizationErrorCatalogProvider() {
        return ErrorCatalogProvider.of("organization", OrganizationErrorType.values());
    }
}
