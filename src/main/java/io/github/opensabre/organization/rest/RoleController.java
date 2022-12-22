package io.github.opensabre.organization.rest;

import io.github.opensabre.common.core.entity.vo.Result;
import io.github.opensabre.organization.entity.form.RoleForm;
import io.github.opensabre.organization.entity.form.RoleQueryForm;
import io.github.opensabre.organization.entity.param.RoleQueryParam;
import io.github.opensabre.organization.entity.po.Role;
import io.github.opensabre.organization.service.IRoleService;
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
@RequestMapping("/role")
@Schema(name = "role")
@Slf4j
public class RoleController {

    @Resource
    private IRoleService roleService;

    @Operation(summary = "新增角色", description = "新增一个角色")
    @PostMapping
    public Result add(@Parameter(name = "roleForm", description = "新增角色form表单", required = true) @Valid @RequestBody RoleForm roleForm) {
        log.debug("name:{}", roleForm);
        Role role = roleForm.toPo(Role.class);
        return Result.success(roleService.add(role));
    }

    @Operation(summary = "删除角色", description = "根据url的id来指定删除对象")
    @DeleteMapping(value = "/{id}")
    public Result delete(@Parameter(name = "id", description = "角色ID", required = true) @PathVariable String id) {
        return Result.success(roleService.delete(id));
    }

    @Operation(summary = "修改角色", description = "修改指定角色信息")
    @PutMapping(value = "/{id}")
    public Result update(@Parameter(name = "id", description = "角色ID", required = true) @PathVariable String id,
                         @Parameter(name = "roleForm", description = "角色实体", required = true) @Valid @RequestBody RoleForm roleForm) {
        Role role = roleForm.toPo(id, Role.class);
        return Result.success(roleService.update(role));
    }

    @Operation(summary = "获取角色", description = "获取指定角色信息")
    @GetMapping(value = "/{id}")
    public Result get(@Parameter(name = "id", description = "角色ID", required = true) @PathVariable String id) {
        log.debug("get with id:{}", id);
        return Result.success(roleService.get(id));
    }

    @Operation(summary = "获取所有角色", description = "获取所有角色")
    @GetMapping(value = "/all")
    public Result get() {
        return Result.success(roleService.getAll());
    }

    @Operation(summary = "查询角色", description = "根据用户id查询用户所拥有的角色信息")
    @ApiResponses(
            @ApiResponse(responseCode = "200", description = "处理成功", content = @Content(schema = @Schema(implementation = Result.class)))
    )
    @GetMapping(value = "/user/{userId}")
    public Result query(@Parameter(name = "userId", description = "用户id", required = true) @PathVariable String userId) {
        log.debug("query with userId:{}", userId);
        return Result.success(roleService.query(userId));
    }

    @Operation(summary = "搜索角色", description = "根据条件搜索角色信息")
    @ApiResponses(
            @ApiResponse(responseCode = "200", description = "处理成功", content = @Content(schema = @Schema(implementation = Result.class)))
    )
    @PostMapping(value = "/conditions")
    public Result query(@Parameter(name = "roleQueryForm", description = "角色查询参数", required = true) @Valid @RequestBody RoleQueryForm roleQueryForm) {
        log.debug("query with name:{}", roleQueryForm);
        return Result.success(roleService.query(roleQueryForm.getPage(), roleQueryForm.toParam(RoleQueryParam.class)));
    }
}