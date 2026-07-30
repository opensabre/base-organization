# 架构与职责

`base-organization` 维护用户、组织、角色、菜单和 API 资源授权。管理端登录后根据菜单生成动态路由，根据按钮 `perm` 控制操作入口；网关/授权链根据资源表执行 API 权限判断。

## 权限模型

- `base_org_menu`：目录、页面和按钮元数据。
- `base_org_role_menu`：角色可见菜单与按钮。
- `base_org_resource`：HTTP 方法与 URL 对应的权限资源。
- `base_org_role_resource`：角色可访问的 API 资源。

按钮权限不能代替后端 API 授权。新增写操作必须同时配置资源、角色资源、按钮和角色菜单。
