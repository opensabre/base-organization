package io.github.opensabre.organization.rest;

import com.baomidou.mybatisplus.core.metadata.IPage;
import io.github.opensabre.common.core.entity.vo.Result;
import io.github.opensabre.organization.entity.form.UserForm;
import io.github.opensabre.organization.entity.form.UserQueryForm;
import io.github.opensabre.organization.entity.param.UserQueryParam;
import io.github.opensabre.organization.entity.po.User;
import io.github.opensabre.organization.entity.vo.UserVo;
import io.github.opensabre.organization.service.IUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

@Schema(name = "用户")
@ApiResponses(
        @ApiResponse(responseCode = "200", description = "处理成功", content = @Content(schema = @Schema(implementation = Result.class)))
)
@Slf4j
@RestController
@RequestMapping("/user")
public class UserController {

    @Resource
    private IUserService userService;

    @Operation(summary = "新增用户", description = "新增一个用户")
    @PostMapping
    public boolean add(@Parameter(name = "userForm", description = "新增用户form表单", required = true) @Valid @RequestBody UserForm userForm) {
        log.debug("name:{}", userForm);
        User user = userForm.toPo(User.class);
        return userService.add(user);
    }

    @Operation(summary = "删除用户", description = "根据url的id来指定删除对象，逻辑删除")
    @DeleteMapping(value = "/{id}")
    public boolean delete(@Parameter(name = "id", description = "用户ID", required = true) @PathVariable String id) {
        return userService.delete(id);
    }

    @Operation(summary = "修改用户", description = "修改指定用户信息")
    @PutMapping(value = "/{id}")
    public boolean update(@Parameter(description = "用户ID", required = true) @PathVariable String id,
                          @Parameter(description = "用户实体", required = true) @Valid @RequestBody UserForm userForm) {
        User user = userForm.toPo(User.class);
        user.setId(id);
        return userService.update(user);
    }

    @Operation(summary = "获取用户", description = "根据用户ID获取指定用户信息", security = @SecurityRequirement(name = "Authorization"))
    @GetMapping(value = "/{id}")
    public UserVo get(@Parameter(name = "id", description = "用户ID", required = true) @PathVariable String id) {
        log.info("get with id:{}", id);
        return userService.get(id);
    }

    @Operation(summary = "获取用户", description = "根据用户唯一标识（username or mobile）获取用户信息")
    @GetMapping
    public User query(@Parameter(description = "用户唯一标识", required = true) @RequestParam("uniqueId") String uniqueId) {
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