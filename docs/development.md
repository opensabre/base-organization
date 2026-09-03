# 开发与数据库迁移

## 启动与数据

1. 全新环境执行 `src/main/resources/db/os-base-org-ddl.sql` 和对应初始数据脚本。
2. 数据库变更写入 `src/main/resources/db/migration/mysql/`，由发布阶段的独立 Flyway 进程执行；应用 Pod 启动时不执行迁移。
3. 配置注册中心、数据库等环境依赖后，以 Maven 启动服务。

## 菜单与权限迁移

1. 使用稳定且不冲突的菜单、资源 ID。
2. 可重复迁移优先使用 `ON DUPLICATE KEY UPDATE`；不能重复执行的脚本必须明确记录执行状态。
3. 页面按钮和 API 资源保持一致的权限语义，但分别建立授权关系。
4. Flyway 历史是切换后的唯一事实来源；新增版本迁移必须同时覆盖全新环境和升级环境。
5. 执行前查询目标记录，执行后验证菜单名称、父子关系、前端路径和权限编码。

## 审计时间毫秒精度迁移

`V20260818_01__use_millisecond_precision_for_audit_timestamps.sql` 将组织服务 11 张表的
`created_time`、`updated_time` 升级为 `DATETIME(3)`；`updated_time` 使用
`ON UPDATE CURRENT_TIMESTAMP(3)` 自动维护。该迁移保留 `DATETIME` 的无时区语义、非空约束、
默认值、注释和既有索引。

迁移前已被 `DATETIME` 截断的毫秒无法恢复。发布前先备份目标库并记录该版本已执行；如需回滚，
可将两字段改回 `DATETIME`，但回滚会再次丢弃迁移后写入的毫秒。

## 验证清单

- 用户、角色、菜单、资源 CRUD 与关联关系正确；
- 登录用户获取到的菜单树符合角色菜单授权；
- 资源 URL/HTTP 方法授权符合角色资源授权；
- `MenuServiceTest` 通过；
- 管理员角色的菜单树和资源授权符合预期；
- 新增菜单同时验证全新初始化与既有数据库升级结果。
