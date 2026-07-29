# base-organization 文档索引

本目录记录组织、角色、菜单与资源权限服务的实现边界。

- [架构与职责](architecture.md)
- [开发与数据库迁移](development.md)
- [0.7 安全与治理菜单权限](modules/security-and-governance-menus.md)

菜单只控制管理端入口和按钮可见性；API 是否允许访问由 `base_org_resource` 与角色资源授权独立决定。
