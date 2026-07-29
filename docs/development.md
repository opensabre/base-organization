# 开发与数据库迁移

数据库初始化脚本位于 `src/main/resources/db/os-base-org-ddl.sql`，增量脚本位于 `src/main/resources/db/migrations/`。

新增或调整菜单时：

1. 使用稳定且不冲突的菜单、资源 ID。
2. 通过 `ON DUPLICATE KEY UPDATE` 保持迁移可重复执行。
3. 页面按钮和 API 资源使用同一权限语义。
4. 同步更新初始化 DDL 与增量迁移。
5. 运行 `MenuServiceTest`，并验证管理员角色的菜单树和资源授权。
