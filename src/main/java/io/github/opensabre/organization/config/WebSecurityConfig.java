package io.github.opensabre.organization.config;

import io.github.opensabre.organization.service.IResourceService;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AuthorizeHttpRequestsConfigurer;
import org.springframework.security.config.core.GrantedAuthorityDefaults;
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

        httpSecurity.authorizeHttpRequests()
                .anyRequest().authenticated()
                .and().cors()
                .and().sessionManagement().sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                .and()
                .oauth2ResourceServer()
                .jwt()
                .jwtAuthenticationConverter(jwtAuthenticationConverter());
        return httpSecurity.build();
    }

    /**
     * 初使化权限信息，从数据库中拉取所有的资源信息
     *
     * @param httpSecurity
     * @throws Exception
     */
    private void initResource(HttpSecurity httpSecurity) throws Exception {
        AuthorizeHttpRequestsConfigurer<HttpSecurity>.AuthorizationManagerRequestMatcherRegistry registry = httpSecurity.authorizeHttpRequests();
        this.resourceService.getAll().forEach(resource -> {
            registry.antMatchers(HttpMethod.valueOf(resource.getMethod()), resource.getUrl()).hasAuthority(resource.getCode());
        });
    }

    /**
     * 从 jwt claim 中获取的权限信息，默认是从 scope 或 scp 字段中获取，将获取到的Authority默认 SCOPE_ 前缀去掉
     * 如果需要同多个字段中获取权限或者是通过url请求获取的权限，则需要自己提供jwtAuthenticationConverter()这个方法的实现
     *
     * @return JwtAuthenticationConverter
     */
    private JwtAuthenticationConverter jwtAuthenticationConverter() {
        JwtAuthenticationConverter converter = new JwtAuthenticationConverter();
        JwtGrantedAuthoritiesConverter authoritiesConverter = new JwtGrantedAuthoritiesConverter();
        // 去掉权限默认的 SCOPE_ 的前缀
        authoritiesConverter.setAuthorityPrefix(StringUtils.EMPTY);
        converter.setJwtGrantedAuthoritiesConverter(authoritiesConverter);
        return converter;
    }

    /**
     * rolePrefix设置为空
     *
     * @return GrantedAuthorityDefaults
     */
    @Bean
    public GrantedAuthorityDefaults grantedAuthorityDefaults() {
        return new GrantedAuthorityDefaults(StringUtils.EMPTY);
    }

}
