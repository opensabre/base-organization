package io.github.opensabre.organization.service;

import io.github.opensabre.organization.entity.po.User;
import io.github.opensabre.organization.entity.vo.UserVo;
import io.github.opensabre.organization.exception.UserNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import tools.jackson.databind.JsonNode;
import tools.jackson.databind.ObjectMapper;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

/** 从网关已验证并转发的 JWT 中解析当前组织用户。 */
@Service
@Slf4j
@RequiredArgsConstructor
public class CurrentUserService {
    private static final String AUTHORIZATION_HEADER = "Authorization";
    private static final String GATEWAY_TOKEN_HEADER = "x-client-token";
    private final IUserService userService;
    private final ObjectMapper objectMapper = new ObjectMapper();

    public UserVo current(HttpServletRequest request) {
        String username = resolveUsername(request);
        if (StringUtils.isBlank(username)) throw new UserNotFoundException("current username is missing");
        User user = userService.getByUniqueId(username);
        return userService.get(user.getId());
    }

    private String resolveUsername(HttpServletRequest request) {
        String authorization = StringUtils.defaultIfBlank(
                request.getHeader(AUTHORIZATION_HEADER), request.getHeader(GATEWAY_TOKEN_HEADER));
        String token = StringUtils.removeStartIgnoreCase(StringUtils.trimToEmpty(authorization), "Bearer ");
        String[] tokenParts = token.split("\\.");
        if (tokenParts.length < 2) return StringUtils.EMPTY;
        try {
            String payload = new String(Base64.getUrlDecoder().decode(tokenParts[1]), StandardCharsets.UTF_8);
            JsonNode claims = objectMapper.readTree(payload);
            return claims.path("sub").asText(StringUtils.EMPTY);
        } catch (IllegalArgumentException exception) {
            log.warn("Cannot parse current-user JWT payload");
            return StringUtils.EMPTY;
        }
    }
}
