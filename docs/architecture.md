# 架构与边界

`base-organization` 管理用户、组织/群组、岗位、角色、菜单和资源，以及角色菜单、角色资源、用户角色等授权关系。它是管理端动态菜单和网关资源授权所依赖的组织权限事实源。

| 领域 | 代码入口 |
| --- | --- |
| 用户与用户角色 | `UserController`、`UserService`、`UserRoleService` |
| 群组/组织与岗位 | `GroupController`、`PositionController` |
| 角色与授权关系 | `RoleController`、`RoleMenuService`、`RoleResourceService` |
| 菜单和资源 | `MenuController`、`ResourceController` |

## 权限模型

- `base_org_menu`：目录、页面和按钮元数据。
- `base_org_role_menu`：角色可见的菜单与按钮。
- `base_org_resource`：HTTP 方法与 URL 对应的权限资源。
- `base_org_role_resource`：角色可访问的 API 资源。

菜单和资源是两套相关但不同的授权模型：

- `MENU`、`CATALOG` 节点决定管理端导航结构；`BUTTON` 节点向前端提供按钮权限编码。
- 页面可见不代表接口已授权，接口已授权也不会自动生成页面菜单。
- 新增写操作必须分别核对页面路由、按钮权限、接口资源及相应的角色授权关系。

当前资源由 Organization 管理接口维护，尚未启用应用资源声明的自动注册流程。不要假设
`@ResourcePermission` 会自动把资源写入本服务数据库。数据模型和迁移以 `resources/db/` 为准，不能
只根据管理台菜单判断接口授权。
