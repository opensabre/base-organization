package io.github.opensabre.organization.rest;

import io.github.opensabre.common.core.entity.vo.Result;
import io.github.opensabre.organization.entity.form.ResourceForm;
import io.github.opensabre.organization.entity.form.ResourceQueryForm;
import io.github.opensabre.organization.entity.param.ResourceQueryParam;
import io.github.opensabre.organization.entity.po.Resource;
import io.github.opensabre.organization.service.IResourceService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;

@RestController
@RequestMapping("/resource")
@Schema(name = "resource")
@Slf4j
public class ResourceController {

    @javax.annotation.Resource
    private IResourceService resourceService;

    @Operation(summary = "新增资源", description = "新增一个资源")
    @PostMapping
    public Result add(@Parameter(name = "resourceForm", description = "新增资源form表单", required = true) @Valid @RequestBody ResourceForm resourceForm) {
        log.debug("name:{}", resourceForm);
        Resource resource = resourceForm.toPo(Resource.class);
        return Result.success(resourceService.add(resource));
    }

    @Operation(summary = "删除资源", description = "根据url的id来指定删除对象")
    @DeleteMapping(value = "/{id}")
    public Result delete(@Parameter(name = "id", description = "资源ID", required = true) @PathVariable String id) {
        return Result.success(resourceService.delete(id));
    }

    @Operation(summary = "修改资源", description = "修改指定资源信息")
    @PutMapping(value = "/{id}")
    public Result update(@Parameter(name = "id", description = "资源ID", required = true) @PathVariable String id,
                         @Parameter(name = "resourceForm", description = "资源实体", required = true) @Valid @RequestBody ResourceForm resourceForm) {
        Resource resource = resourceForm.toPo(id, Resource.class);
        return Result.success(resourceService.update(resource));
    }

    @Operation(summary = "获取资源", description = "获取指定资源信息")
    @GetMapping(value = "/{id}")
    public Result get(@Parameter(name = "id", description = "资源ID", required = true) @PathVariable String id) {
        log.debug("get with id:{}", id);
        return Result.success(resourceService.get(id));
    }

    @Operation(summary = "查询资源", description = "根据userId查询用户所拥有的资源信息")
    @ApiResponses(
            @ApiResponse(responseCode = "200", description = "处理成功", content = @Content(schema = @Schema(implementation = Result.class)))
    )
    @GetMapping(value = "/user/{username}")
    public Result queryByUsername(@Parameter(name = "userId", description = "用户id", required = true) @PathVariable String username) {
        log.debug("query with username:{}", username);
        return Result.success(resourceService.query(username));
    }

    @Operation(summary = "查询所有资源", description = "查询所有资源信息")
    @ApiResponses(
            @ApiResponse(responseCode = "200", description = "处理成功", content = @Content(schema = @Schema(implementation = Result.class)))
    )
    @GetMapping(value = "/all")
    public Result queryAll() {
        return Result.success(resourceService.getAll());
    }

    @Operation(summary = "搜索资源", description = "根据条件搜索资源信息")
    @ApiResponses(
            @ApiResponse(responseCode = "200", description = "处理成功", content = @Content(schema = @Schema(implementation = Result.class)))
    )
    @PostMapping(value = "/conditions")
    public Result query(@Parameter(name = "resourceQueryForm", description = "资源查询参数", required = true) @Valid @RequestBody ResourceQueryForm resourceQueryForm) {
        log.debug("query with name:{}", resourceQueryForm);
        return Result.success(resourceService.query(resourceQueryForm.getPage(), resourceQueryForm.toParam(ResourceQueryParam.class)));
    }
}