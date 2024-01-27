package io.github.opensabre.organization.rest;

import io.github.opensabre.common.core.entity.vo.Result;
import io.github.opensabre.organization.entity.form.MenuForm;
import io.github.opensabre.organization.entity.form.MenuQueryForm;
import io.github.opensabre.organization.entity.param.MenuQueryParam;
import io.github.opensabre.organization.entity.po.Menu;
import io.github.opensabre.organization.service.IMenuService;
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
import java.util.List;

@RestController
@RequestMapping("/menu")
@Schema(name = "menu")
@Slf4j
public class MenuController {

    @Resource
    private IMenuService menuService;

    @Operation(summary = "新增菜单", description = "新增一个菜单")
    @PostMapping
    public boolean add(@Parameter(description = "新增菜单form表单", required = true) @Valid @RequestBody MenuForm menuForm) {
        log.debug("name:{}", menuForm);
        Menu menu = menuForm.toPo(Menu.class);
        return menuService.add(menu);
    }

    @Operation(summary = "删除菜单", description = "根据url的id来指定删除对象")
    @DeleteMapping(value = "/{id}")
    public boolean delete(@Parameter(description = "菜单ID", required = true) @PathVariable String id) {
        return menuService.delete(id);
    }

    @Operation(summary = "修改菜单", description = "修改指定菜单信息")
    @PutMapping(value = "/{id}")
    public boolean update(@Parameter(description = "菜单ID", required = true) @PathVariable String id,
                          @Parameter(description = "菜单实体", required = true) @Valid @RequestBody MenuForm menuForm) {
        Menu menu = menuForm.toPo(Menu.class);
        menu.setId(id);
        return menuService.update(menu);
    }

    @Operation(summary = "获取菜单", description = "获取指定菜单信息")
    @GetMapping(value = "/{id}")
    public Menu get(@Parameter(description = "菜单ID", required = true) @PathVariable String id) {
        log.debug("get with id:{}", id);
        return menuService.get(id);
    }

    @Operation(summary = "查询菜单", description = "根据条件查询菜单信息，简单查询")
    @ApiResponses(
            @ApiResponse(responseCode = "200", description = "处理成功", content = @Content(schema = @Schema(implementation = Result.class)))
    )
    @GetMapping
    public List<Menu> query(@Parameter(description = "菜单名称", required = true) @RequestParam String name) {
        log.debug("query with name:{}", name);
        MenuQueryParam menuQueryParam = new MenuQueryParam(name);
        return menuService.query(menuQueryParam);
    }

    @Operation(summary = "搜索菜单", description = "根据条件查询菜单信息")
    @ApiResponses(
            @ApiResponse(responseCode = "200", description = "处理成功", content = @Content(schema = @Schema(implementation = Result.class)))
    )
    @PostMapping(value = "/conditions")
    public List<Menu> search(@Parameter(description = "菜单查询参数", required = true) @Valid @RequestBody MenuQueryForm menuQueryForm) {
        log.debug("search with menuQueryForm:{}", menuQueryForm);
        return menuService.query(menuQueryForm.toParam(MenuQueryParam.class));
    }

    @Operation(summary = "根据父id查询菜单", description = "根据父id查询菜单列表")
    @GetMapping(value = "/parent/{id}")
    public List<Menu> search(@Parameter(description = "菜单父ID", required = true) @PathVariable String id) {
        log.debug("query with parent id:{}", id);
        return menuService.queryByParentId(id);
    }
}