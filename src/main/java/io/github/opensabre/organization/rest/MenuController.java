package io.github.opensabre.organization.rest;

import io.github.opensabre.common.core.entity.vo.Result;
import io.github.opensabre.governance.audit.annotations.Audit;
import io.github.opensabre.governance.audit.annotations.OperationType;
import io.github.opensabre.organization.entity.form.MenuForm;
import io.github.opensabre.organization.entity.form.MenuQueryForm;
import io.github.opensabre.organization.entity.param.MenuQueryParam;
import io.github.opensabre.organization.entity.po.Menu;
import io.github.opensabre.organization.entity.vo.MenuVo;
import io.github.opensabre.organization.service.IMenuService;
import io.github.opensabre.organization.service.CurrentUserService;
import io.github.opensabre.boot.annotations.ResourcePermission;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import jakarta.servlet.http.HttpServletRequest;
import java.util.List;

@RestController
@RequestMapping("/menu")
@Schema(name = "菜单")
@Slf4j
public class MenuController {

    private static final String DEFAULT_PRODUCT_CODE = "opensabre-admin";

    @Resource
    private IMenuService menuService;

    @Resource
    private CurrentUserService currentUserService;

    @Operation(summary = "新增菜单", description = "新增一个菜单")
    @PostMapping
    @Audit(operationType = OperationType.CREATE, description = "新增菜单", module = "MENU", response = true, key = "#menuForm.name")
    public boolean add(@Parameter(description = "新增菜单form表单", required = true) @Valid @RequestBody MenuForm menuForm) {
        log.debug("name:{}", menuForm);
        Menu menu = menuForm.toPo(Menu.class);
        defaultProductCode(menu);
        return menuService.add(menu);
    }

    @Operation(summary = "删除菜单", description = "根据url的id来指定删除对象")
    @DeleteMapping(value = "/{id}")
    @Audit(operationType = OperationType.DELETE, description = "删除菜单", module = "MENU", response = true, key = "#id")
    public boolean delete(@Parameter(description = "菜单ID", required = true)
                          @NotBlank(message = "菜单ID不能为空") @PathVariable String id) {
        return menuService.delete(id);
    }

    @Operation(summary = "修改菜单", description = "修改指定菜单信息")
    @PutMapping(value = "/{id}")
    @Audit(operationType = OperationType.UPDATE, description = "修改菜单", module = "MENU", response = true, key = "#id")
    public boolean update(@Parameter(description = "菜单ID", required = true)
                          @NotBlank(message = "菜单ID不能为空") @PathVariable String id,
                          @Parameter(description = "菜单实体", required = true) @Valid @RequestBody MenuForm menuForm) {
        Menu menu = menuForm.toPo(Menu.class);
        menu.setId(id);
        if (menu.getProductCode() == null || menu.getProductCode().isBlank()) {
            Menu existing = menuService.get(id);
            menu.setProductCode(existing == null || existing.getProductCode() == null
                    ? DEFAULT_PRODUCT_CODE : existing.getProductCode());
        }
        return menuService.update(menu);
    }

    @Operation(summary = "获取菜单", description = "获取指定菜单信息")
    @GetMapping(value = "/{id}")
    public Menu get(@Parameter(description = "菜单ID", required = true)
                    @NotBlank(message = "菜单ID不能为空") @PathVariable String id) {
        log.debug("get with id:{}", id);
        return menuService.get(id);
    }

    @Operation(summary = "查询菜单", description = "根据条件查询菜单信息，简单查询")
    @ApiResponses(
            @ApiResponse(responseCode = "200", description = "处理成功", content = @Content(schema = @Schema(implementation = Result.class)))
    )
    @GetMapping
    public List<Menu> query(@Parameter(description = "菜单名称", required = true)
                            @NotBlank(message = "菜单名称不能为空") @RequestParam String name) {
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
    public List<Menu> search(@Parameter(description = "菜单父ID", required = true)
                             @NotBlank(message = "菜单父ID不能为空") @PathVariable String id) {
        log.debug("query with parent id:{}", id);
        return menuService.queryByParentId(id);
    }

    @Operation(summary = "查询完整菜单树", description = "一次返回管理台菜单选择器所需的完整树")
    @GetMapping(value = "/tree")
    public List<MenuVo> queryTree() {
        return menuService.queryTree();
    }

    @Operation(summary = "查询产品菜单树", description = "返回指定产品和公共菜单的完整树")
    @GetMapping(value = "/tree/{productCode}")
    public List<MenuVo> queryTree(@PathVariable String productCode) {
        return menuService.queryTree(productCode);
    }

    @Operation(summary = "查询当前用户产品菜单", description = "根据登录用户角色、产品归属和公共菜单计算菜单树")
    @GetMapping(value = "/current")
    @ResourcePermission(code = "product_menu:view", name = "查看当前产品菜单", type = "menu")
    public List<MenuVo> queryCurrent(@RequestParam String productCode, HttpServletRequest request) {
        return menuService.queryByUserId(currentUserService.current(request).getId(), productCode);
    }

    @Operation(summary = "根据用户id查询菜单", description = "根据用户拥有的角色查询授权菜单树")
    @GetMapping(value = "/user/{userId}")
    public List<MenuVo> queryByUserId(@Parameter(description = "用户ID", required = true)
                                      @NotBlank(message = "用户ID不能为空") @PathVariable String userId) {
        log.debug("query with user id:{}", userId);
        return menuService.queryByUserId(userId);
    }

    private void defaultProductCode(Menu menu) {
        if (menu.getProductCode() == null || menu.getProductCode().isBlank()) {
            menu.setProductCode(DEFAULT_PRODUCT_CODE);
        }
    }
}
