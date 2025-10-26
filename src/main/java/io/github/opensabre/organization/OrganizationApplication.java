package io.github.opensabre.organization;

import com.alicp.jetcache.anno.config.EnableMethodCache;
import io.github.opensabre.boot.annotations.EnabledAudit;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@EnabledAudit
@SpringBootApplication
@EnableMethodCache(basePackages = {"io.github.opensabre.organization"})
public class OrganizationApplication {
    public static void main(String[] args) {
        SpringApplication.run(OrganizationApplication.class, args);
    }
}
