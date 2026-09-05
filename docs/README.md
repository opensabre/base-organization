# base-organization 文档索引

本目录记录组织、角色、菜单与资源权限服务的实现边界。接口与数据事实以源代码和数据库脚本为准。

| 文档 | 用途 |
| --- | --- |
| [数据模型与 ER 图](data-model.md) | 全部业务表、领域分组和逻辑关系 |
| [架构与边界](architecture.md) | 服务职责、领域模型和权限边界 |
| [开发与数据库迁移](development.md) | 数据库初始化、升级和验证 |
| [模块：组织与权限](modules/organization-and-access.md) | 功能、使用和关键流程 |
| [0.7 安全与治理菜单权限](modules/security-and-governance-menus.md) | 安全治理菜单和按钮权限 |
| [规划](roadmap.md) | 后续演进项 |

## 维护规则

- Controller 映射是 API 事实源，位于 `src/main/java/**/rest/`。
- DDL、初始数据及迁移脚本位于 `src/main/resources/db/`。
- 菜单只控制管理端入口和按钮可见性；API 访问由资源及角色资源授权独立决定。
- 菜单、按钮或 URL 资源权限变更必须同步更新模块文档和管理端联动说明。
