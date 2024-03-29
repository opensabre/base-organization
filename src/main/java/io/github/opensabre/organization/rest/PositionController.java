package io.github.opensabre.organization.rest;

import io.github.opensabre.common.core.entity.vo.Result;
import io.github.opensabre.organization.entity.form.PositionForm;
import io.github.opensabre.organization.entity.param.PositionQueryParam;
import io.github.opensabre.organization.entity.po.Position;
import io.github.opensabre.organization.service.IPositionService;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.Parameters;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.*;

import jakarta.annotation.Resource;
import jakarta.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/position")
@Schema(name = "岗位")
@Slf4j
public class PositionController {

    @Resource
    private IPositionService positionService;

    @Operation(summary = "新增职位", description = "新增一个职位")
    @Parameter(name = "positionForm", description = "新增职位form表单", required = true)
    @PostMapping
    public boolean add(@Valid @RequestBody PositionForm positionForm) {
        log.debug("name:{}", positionForm);
        Position position = positionForm.toPo(Position.class);
        return positionService.add(position);
    }

    @Operation(summary = "删除职位", description = "根据url的id来指定删除对象")
    @Parameter(name = "id", description = "职位ID", required = true)
    @DeleteMapping(value = "/{id}")
    public boolean delete(@PathVariable String id) {
        return positionService.delete(id);
    }

    @Operation(summary = "修改职位", description = "修改指定职位信息")
    @Parameters({
            @Parameter(name = "id", description = "职位ID", required = true),
            @Parameter(name = "positionForm", description = "职位实体", required = true)
    })
    @PutMapping(value = "/{id}")
    public boolean update(@PathVariable String id, @Valid @RequestBody PositionForm positionForm) {
        Position position = positionForm.toPo(Position.class);
        position.setId(id);
        return positionService.update(position);
    }

    @Operation(summary = "获取职位", description = "获取指定职位信息")
    @Parameter(name = "id", description = "职位ID", required = true)
    @GetMapping(value = "/{id}")
    public Position get(@PathVariable String id) {
        log.debug("get with id:{}", id);
        return positionService.get(id);
    }

    @Operation(summary = "查询职位", description = "根据条件查询职位信息，简单查询")
    @Parameter(description = "职位名称", required = true)
    @ApiResponses(
            @ApiResponse(responseCode = "200", description = "处理成功", content = @Content(schema = @Schema(implementation = Result.class)))
    )
    @GetMapping
    public List<Position> query(@RequestParam String name) {
        log.debug("query with name:{}", name);
        return positionService.query(new PositionQueryParam(name));
    }
}