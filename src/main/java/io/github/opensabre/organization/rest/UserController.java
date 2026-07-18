package io.github.opensabre.organization.rest;

import com.baomidou.mybatisplus.core.metadata.IPage;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import io.github.opensabre.governance.audit.annotations.Audit;
import io.github.opensabre.governance.audit.annotations.OperationType;
import io.github.opensabre.common.core.entity.vo.Result;
import io.github.opensabre.organization.entity.form.UserForm;
import io.github.opensabre.organization.entity.form.UserQueryForm;
import io.github.opensabre.organization.entity.param.UserQueryParam;
import io.github.opensabre.organization.entity.po.User;
import io.github.opensabre.organization.entity.vo.UserVo;
import io.github.opensabre.organization.exception.UserNotFoundException;
import io.github.opensabre.organization.service.IUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.lang3.StringUtils;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

import java.nio.charset.StandardCharsets;
import java.util.Base64;

@Schema(name = "用户")
@ApiResponses(
        @ApiResponse(responseCode = "200", description = "处理成功", content = @Content(schema = @Schema(implementation = Result.class)))
)
@Slf4j
@RestController
@RequestMapping("/user")
public class UserController {

    private static final String AUTHORIZATION_HEADER = "Authorization";
    private static final String GATEWAY_TOKEN_HEADER = "x-client-token";

    private final ObjectMapper objectMapper = new ObjectMapper();

    @Resource
    private IUserService userService;

    @Audit(operationType = OperationType.CREATE, description = "新增用户", module = "USER", response = true, key = "#userForm.username")
    @Operation(summary = "新增用户", description = "新增一个用户")
    @PostMapping
    public boolean add(@Parameter(name = "userForm", description = "新增用户form表单", required = true)
                       @Validated(UserForm.Add.class) @RequestBody UserForm userForm) {
        log.debug("name:{}", userForm);
        User user = userForm.toPo(User.class);
        return userService.add(user);
    }

    @Audit(operationType = OperationType.DELETE, description = "删除用户", module = "USER", response = true, key = "#id")
    @Operation(summary = "删除用户", description = "根据url的id来指定删除对象，逻辑删除")
    @DeleteMapping(value = "/{id}")
    public boolean delete(@Parameter(name = "id", description = "用户ID", required = true)
                          @NotBlank(message = "用户ID不能为空") @PathVariable String id) {
        return userService.delete(id);
    }

    @Audit(operationType = OperationType.UPDATE, description = "修改用户信息", module = "USER", response = true, key="#userForm.username")
    @Operation(summary = "修改用户", description = "修改指定用户信息")
    @PutMapping(value = "/{id}")
    public boolean update(@Parameter(description = "用户ID", required = true)
                          @NotBlank(message = "用户ID不能为空") @PathVariable String id,
                          @Parameter(description = "用户实体", required = true)
                          @Validated(UserForm.Update.class) @RequestBody UserForm userForm) {
        User user = userForm.toPo(User.class);
        user.setId(id);
        return userService.update(user);
    }

    @Operation(summary = "获取用户", description = "根据用户ID获取指定用户信息", security = @SecurityRequirement(name = "Authorization"))
    @GetMapping(value = "/{id}")
    public UserVo get(@Parameter(name = "id", description = "用户ID", required = true)
                      @NotBlank(message = "用户ID不能为空") @PathVariable String id) {
        log.info("get with id:{}", id);
        return userService.get(id);
    }

    /**
     * 获取当前已认证用户。
     *
     * 临时直接解析网关转发的 JWT subject。
     * 管理台据此取得真实用户 ID，再加载该用户的角色菜单，不能使用固定用户 ID。
     *
     * @return 当前用户信息
     */
    @Operation(summary = "获取当前用户", description = "根据请求 JWT subject 获取用户信息", security = @SecurityRequirement(name = "Authorization"))
    @GetMapping(value = "/current")
    public UserVo current(HttpServletRequest request) {
        String username = resolveCurrentUsername(request);
        if (StringUtils.isBlank(username)) {
            throw new UserNotFoundException("current username is missing");
        }
        User user = userService.getByUniqueId(username);
        return userService.get(user.getId());
    }

    /**
     * 解析当前用户名。
     *
     * Framework 0.5 发布前，UserContextHolder 在当前链路中不可用。
     * 网关已完成 JWT 校验，此处只从 Authorization 或 x-client-token Header 的 JWT payload
     * 读取 subject；不接受请求体或查询参数提供的用户名。
     *
     * @param request 当前请求
     * @return 当前用户名；无法解析时为空字符串
     */
    private String resolveCurrentUsername(HttpServletRequest request) {
        String authorization = StringUtils.defaultIfBlank(
                request.getHeader(AUTHORIZATION_HEADER), request.getHeader(GATEWAY_TOKEN_HEADER));
        String token = StringUtils.removeStartIgnoreCase(StringUtils.trimToEmpty(authorization), "Bearer ");
        String[] tokenParts = token.split("\\.");
        if (tokenParts.length < 2) {
            return StringUtils.EMPTY;
        }
        try {
            String payload = new String(Base64.getUrlDecoder().decode(tokenParts[1]), StandardCharsets.UTF_8);
            JsonNode claims = objectMapper.readTree(payload);
            return claims.path("sub").asText(StringUtils.EMPTY);
        } catch (IllegalArgumentException | java.io.IOException e) {
            log.warn("Cannot parse current-user JWT payload");
            return StringUtils.EMPTY;
        }
    }

    @Audit(operationType = OperationType.QUERY, description = "通过用户唯一键", module = "USER", response = true, key="#uniqueId")
    @Operation(summary = "获取用户", description = "根据用户唯一标识（username or mobile）获取用户信息")
    @GetMapping
    public User query(@Parameter(description = "用户唯一标识", required = true)
                      @NotBlank(message = "用户唯一标识不能为空") @RequestParam("uniqueId") String uniqueId) {
        log.debug("query with username or mobile:{}", uniqueId);
        return userService.getByUniqueId(uniqueId);
    }

    @Operation(summary = "搜索用户", description = "根据条件查询用户信息")
    @PostMapping(value = "/conditions")
    public IPage<UserVo> search(@Parameter(description = "用户查询参数", required = true) @Valid @RequestBody UserQueryForm userQueryForm) {
        log.debug("search with userQueryForm:{}", userQueryForm);
        return userService.query(userQueryForm.getPage(), userQueryForm.toParam(UserQueryParam.class));
    }
}
