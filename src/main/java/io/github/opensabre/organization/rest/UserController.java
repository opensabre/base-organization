package io.github.opensabre.organization.rest;

import io.github.opensabre.common.core.entity.vo.Result;
import io.github.opensabre.organization.entity.form.UserForm;
import io.github.opensabre.organization.entity.form.UserQueryForm;
import io.github.opensabre.organization.entity.form.UserUpdateForm;
import io.github.opensabre.organization.entity.param.UserQueryParam;
import io.github.opensabre.organization.entity.po.User;
import io.github.opensabre.organization.service.IUserService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.annotation.Resource;
import javax.validation.Valid;

@RestController
@RequestMapping("/user")
@Schema(name = "user")
@Slf4j
public class UserController {

    @Resource
    private IUserService userService;

    @Operation(summary = "新增用户", description = "新增一个用户")
    @PostMapping
    public Result add(@Parameter(name = "userForm", description = "新增用户form表单", required = true) @Valid @RequestBody UserForm userForm) {
        log.debug("name:{}", userForm);
        User user = userForm.toPo(User.class);
        return Result.success(userService.add(user));
    }

    @Operation(summary = "删除用户", description = "根据url的id来指定删除对象，逻辑删除")
    @DeleteMapping(value = "/{id}")
    public Result delete(@Parameter(name = "id", description = "用户ID", required = true) @PathVariable String id) {
        return Result.success(userService.delete(id));
    }

    @Operation(summary = "修改用户", description = "修改指定用户信息")
    @PutMapping(value = "/{id}")
    public Result update(@Parameter(description = "用户ID", required = true) @PathVariable String id,
                         @Parameter(description = "用户实体", required = true) @Valid @RequestBody UserUpdateForm userUpdateForm) {
        User user = userUpdateForm.toPo(User.class);
        user.setId(id);
        return Result.success(userService.update(user));
    }

    @Operation(summary = "获取用户", description = "获取指定用户信息")
    @GetMapping(value = "/{id}")
    public Result get(@Parameter(name = "id", description = "用户ID", required = true) @PathVariable String id) {
        log.debug("get with id:{}", id);
        return Result.success(userService.get(id));
    }

    @Operation(summary = "获取用户", description = "根据用户唯一标识（username or mobile）获取用户信息")
    @ApiResponses(
            @ApiResponse(responseCode = "200", description = "处理成功", content = @Content(schema = @Schema(implementation = Result.class)))
    )
    @GetMapping
    public Result query(@Parameter(description = "用户唯一标识", required = true) @RequestParam String uniqueId) {
        log.debug("query with username or mobile:{}", uniqueId);
        return Result.success(userService.getByUniqueId(uniqueId));
    }

    @Operation(summary = "搜索用户", description = "根据条件查询用户信息")
    @ApiResponses(
            @ApiResponse(responseCode = "200", description = "处理成功", content = @Content(schema = @Schema(implementation = Result.class)))
    )
    @PostMapping(value = "/conditions")
    public Result search(@Parameter(description = "用户查询参数", required = true) @Valid @RequestBody UserQueryForm userQueryForm) {
        log.debug("search with userQueryForm:{}", userQueryForm);
        return Result.success(userService.query(userQueryForm.getPage(), userQueryForm.toParam(UserQueryParam.class)));
    }
}