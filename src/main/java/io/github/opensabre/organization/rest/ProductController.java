package io.github.opensabre.organization.rest;

import io.github.opensabre.organization.entity.form.ProductForm;
import io.github.opensabre.organization.entity.po.Product;
import io.github.opensabre.organization.service.IProductService;
import io.github.opensabre.boot.annotations.ResourcePermission;
import io.swagger.v3.oas.annotations.Operation;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotBlank;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/** 产品品牌和导航配置 API。 */
@RestController
@RequestMapping("/products")
@RequiredArgsConstructor
public class ProductController {
    private final IProductService productService;

    @GetMapping
    @Operation(summary = "查询产品列表")
    @ResourcePermission(code = "product_manager:view", name = "查看产品", type = "product")
    public List<Product> list() {
        return productService.listOrdered();
    }

    @GetMapping("/{code}/profile")
    @Operation(summary = "查询启用的产品品牌信息")
    @ResourcePermission(code = "product_profile:view", name = "查看产品品牌", type = "product")
    public Product profile(@NotBlank @PathVariable String code) {
        return productService.getEnabled(code);
    }

    @PostMapping
    @Operation(summary = "新增产品")
    @ResourcePermission(code = "product_manager:add", name = "新增产品", type = "product")
    public boolean add(@Valid @RequestBody ProductForm form) {
        return productService.save(form.toPo(Product.class));
    }

    @PutMapping("/{code}")
    @Operation(summary = "修改产品")
    @ResourcePermission(code = "product_manager:edit", name = "修改产品", type = "product")
    public boolean update(@PathVariable String code, @Valid @RequestBody ProductForm form) {
        Product existing = productService.getOne(new com.baomidou.mybatisplus.core.conditions.query.LambdaQueryWrapper<Product>()
                .eq(Product::getCode, code));
        if (existing == null) throw new IllegalArgumentException("产品不存在：" + code);
        Product product = form.toPo(Product.class);
        product.setId(existing.getId());
        product.setCode(code);
        return productService.updateById(product);
    }
}
