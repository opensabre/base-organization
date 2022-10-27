package io.github.opensabre.organization.rest;

import io.github.opensabre.common.core.entity.vo.Result;
import io.github.opensabre.organization.entity.form.GroupForm;
import io.github.opensabre.organization.entity.form.GroupQueryForm;
import io.github.opensabre.organization.entity.param.GroupQueryParam;
import io.github.opensabre.organization.entity.po.Group;
import io.github.opensabre.organization.service.IGroupService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/group")
@Tag(name = "group")
@Slf4j
public class GroupController {

    @Autowired
    private IGroupService groupService;

    @Operation(summary = "新增用户组", description = "新增一个用户组")
    @PostMapping
    public Result add(@Parameter(description = "新增用户组form表单", required = true) @Valid @RequestBody GroupForm groupForm) {
        log.debug("name:{}", groupForm);
        return Result.success(groupService.add(groupForm.toPo(Group.class)));
    }

    @Operation(summary = "删除用户组", description = "根据url的id来指定删除对象")
    @DeleteMapping(value = "/{id}")
    public Result delete(@Parameter(description = "用户组ID", required = true) @PathVariable String id) {
        return Result.success(groupService.delete(id));
    }

    @Operation(summary = "修改用户组", description = "修改指定用户组信息")
    @PutMapping(value = "/{id}")
    public Result update(@Parameter(description = "用户组ID", required = true) @PathVariable String id,
                         @Parameter(description = "用户组实体", required = true) @Valid @RequestBody GroupForm groupForm) {
        Group group = groupForm.toPo(Group.class);
        group.setId(id);
        return Result.success(groupService.update(group));
    }

    @Operation(summary = "获取用户组", description = "获取指定用户组信息")
    @GetMapping(value = "/{id}")
    public Result get(@Parameter(description = "用户组ID", required = true) @PathVariable String id) {
        log.debug("get with id:{}", id);
        return Result.success(groupService.get(id));
    }

    @Operation(summary = "查询用户组", description = "根据条件查询用户组信息，简单查询")
    @ApiResponses(
            @ApiResponse(responseCode = "200", description = "处理成功", content = @Content(schema = @Schema(implementation = Result.class)))
    )
    @GetMapping
    public Result query(@Parameter(description = "用户组名称", required = true) @RequestParam String name) {
        log.debug("query with name:{}", name);
        GroupQueryParam groupQueryParam = new GroupQueryParam();
        groupQueryParam.setName(name);
        return Result.success(groupService.query(groupQueryParam));
    }

    @Operation(summary = "搜索用户组", description = "根据条件查询用户组信息")
    @ApiResponses(
            @ApiResponse(responseCode = "200", description = "处理成功", content = @Content(schema = @Schema(implementation = Result.class)))
    )
    @PostMapping(value = "/conditions")
    public Result search(@Parameter(description = "用户组查询参数", required = true) @Valid @RequestBody GroupQueryForm groupQueryForm) {
        log.debug("search with groupQueryForm:{}", groupQueryForm);
        return Result.success(groupService.query(groupQueryForm.toParam(GroupQueryParam.class)));
    }

    @Operation(summary = "根据父id查询用户组", description = "根据父id查询用户组列表")
    @GetMapping(value = "/parent/{id}")
    public Result search(@Parameter(description = "用户组父ID", required = true) @PathVariable String id) {
        log.debug("query with parent id:{}", id);
        return Result.success(groupService.queryByParentId(id));
    }
}