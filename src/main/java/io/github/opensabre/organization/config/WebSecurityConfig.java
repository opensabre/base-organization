package io.github.opensabre.organization.config;

import io.github.opensabre.organization.service.IResourceService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.ExpressionUrlAuthorizationConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.oauth2.server.resource.authentication.JwtAuthenticationConverter;
import org.springframework.security.oauth2.server.resource.authentication.JwtGrantedAuthoritiesConverter;
import org.springframework.security.web.SecurityFilterChain;

import javax.annotation.Resource;

@Slf4j
@Configuration
@EnableWebSecurity
@EnableGlobalMethodSecurity(prePostEnabled = true)
public class WebSecurityConfig {

    @Resource
    IResourceService resourceService;

    @Bean
    public SecurityFilterChain httpSecurityFilterChain(HttpSecurity httpSecurity) throws Exception {

        initResource(httpSecurity);

        httpSecurity.authorizeRequests()
                .mvcMatchers("/user**").permitAll()
                .mvcMatchers("/user*").hasAuthority("read")
                .anyRequest().authenticated()
                .and().cors()
                .and().sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .oauth2ResourceServer()
                .jwt()
                .jwtAuthenticationConverter(jwtAuthenticationConverter());
        return httpSecurity.build();
    }

    private void initResource(HttpSecurity httpSecurity) throws Exception {
        ExpressionUrlAuthorizationConfigurer<HttpSecurity>.ExpressionInterceptUrlRegistry registry = httpSecurity.authorizeRequests();
        this.resourceService.getAll().forEach(resource -> {
            registry.antMatchers(HttpMethod.valueOf(resource.getMethod()), resource.getUrl()).hasAuthority(resource.getCode());
        });
    }

    /**
     * 从 JWT 的 scope 中获取的权限 取消 SCOPE_ 的前缀
     * 设置从 jwt claim 中那个字段获取权限
     * 如果需要同多个字段中获取权限或者是通过url请求获取的权限，则需要自己提供jwtAuthenticationConverter()这个方法的实现
     *
     * @return JwtAuthenticationConverter
     */
    private JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
        JwtGrantedAuthoritiesConverter authoritiesConverter = new JwtGrantedAuthoritiesConverter();
        // 去掉 SCOPE_ 的前缀
        authoritiesConverter.setAuthorityPrefix("");
        // 从jwt claim 中那个字段获取权限，模式是从 scope 或 scp 字段中获取
        authoritiesConverter.setAuthoritiesClaimName("scope");
        converter.setJwtGrantedAuthoritiesConverter(authoritiesConverter);
        return converter;
    }

}
