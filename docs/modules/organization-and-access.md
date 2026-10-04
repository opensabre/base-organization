# 组织与权限

## 模块介绍

该模块维护平台的组织身份与访问控制主数据，覆盖用户、群组、岗位、角色、菜单、按钮和接口资源。

## 功能

- 用户、群组、岗位、角色管理；
- 用户—角色、角色—菜单、角色—资源关系管理；
- 面向管理端的菜单树查询；
- 面向网关/服务端的 URL 与 HTTP 方法资源授权。

## 使用

新增管理端能力时，页面菜单、页面内按钮和服务端资源要分别配置。按钮权限来源于菜单树中的 `BUTTON` 节点描述；接口访问授权来源于资源与角色资源关系。具体 API 以各 Controller 为准。

菜单名称调整应保留稳定 ID、路由路径和权限编码，避免角色菜单关系及前端路由失效；只有业务能力发生
变化时才调整权限编码。生产升级使用迁移脚本修改既有数据，全新环境则同步修改初始化 DDL。

## 关键流程

```text
管理员配置用户/角色 → 分配菜单与资源 → 用户登录
                                   ├─ 管理端：获取菜单树和按钮权限
                                   └─ 网关：按 URL + HTTP 方法校验资源授权
```

## IQC 标签中心授权

`V20260915_01__dml_add_iqc_label_navigation_and_permissions.sql` 为 IQC 产品补充
「标签中心 → 标签树 / 标签集合 / 候选标签」导航及 7 个页面、操作权限码。
管理员（`IQC_ADMIN`）与质量主管（`IQC_QUALITY_MANAGER`）拥有管理、发布、审核权限；
质检员（`IQC_INSPECTOR`）与查看者（`IQC_VIEWER`）仅获得三个页面的查询权限。
迁移不创建用户、用户角色关系、OAuth 客户端或其他环境专属数据，不授权系统 `ADMIN`。

升级时按资源 `code` 激活已注册的 `PENDING` 资源并保留其 ID、URL 与方法；
新环境插入受控资源种子。页面菜单、按钮权限与角色资源关系分别建立。
前端生产导航来自 `/org/menu/current?productCode=iqc`，仅部署静态页面不会产生入口。
发布后应重新加载前端权限，并验证上述四类角色的菜单与操作边界；
不能用 SPA 路由 HTTP 200 或未登录接口 401 代替登录验收。

CI 的 `IQC Label Permission Regression` 在显式标记的隔离 MySQL 容器中验证新环境、
已注册资源的升级、重复执行、用户数据不变及角色正反权限边界；测试脚本拒绝未标记容器。
该任务成功后上传版本化迁移资源供发布使用；镜像构建同时等待 Maven、Flyway 和权限回归通过。

本地也可显式设置 `MYSQL_TEST_MODE=local-socket` 执行同一回归脚本；脚本会核对 loopback 绑定、
测试端口、专用 `/private/tmp/iqc-mysql-validation.*` 数据目录与 socket，并在退出时清除本次临时库。
2026-10-03 在 MySQL 8.0.34 上，新库及升级库场景均通过；仍须在真实网关和登录环境验证授权效果。

## 规划

### IQC 业务方案（待部署）

`V20260917_01__dml_add_iqc_scheme_permissions.sql` 新增专家业务方案页面及发布/使用按钮。
沿用既有模板页面和任务执行权限，不创建账号，不授予系统 ADMIN。

- `IQC_ADMIN` / `IQC_QUALITY_MANAGER`：方案维护、试跑、发布、查看及使用。
- `IQC_INSPECTOR`：查看已发布模板并使用，不可维护或发布。
- `IQC_VIEWER`：只查看已发布模板，不可创建/执行任务。

菜单使用 `iqc:scheme:manage` / `iqc:scheme:publish` / `iqc:scheme:use` 展示分组；
服务端 9 个端点各使用独立资源码（manage、create、update、preview、trial:create、trial:view、publish、view、use）。
现有资源注册以唯一 code 定位并更新单个 URL/method，因此不能把多个新增端点注册为同一资源码；
`iqc:scheme:view` 也不能复用旧内置规则素材的 `iqc:template:view`。

隔离测试仍复用 `scripts/test-iqc-label-permissions.sh`，增加方案权限断言，覆盖新环境、
已注册资源 ID/端点保留、重复执行及四类角色的正反授权。未在共享数据库执行；
发布后仍须实际登录验证菜单、接口和任务数据范围。

2026-10-03 的 MySQL 升级回归使用 19 位合成已注册资源 ID，曾发现角色/资源关联主键拼接后超过
`base_org_role_resource.id` 的 20 字符限制。方案、标签复核和业务结果权限迁移现用 20 字符稳定哈希键，
同时按角色/资源自然键避免已有关系产生重复授权；新库、升级库、重复执行和四角色断言均已通过。

### IQC 标签值复核接口（待部署）

`V20260927_01__dml_add_iqc_label_review_resources.sql` 将标签值复核的申请、历史、跨任务待办和裁决分别登记为独立 URL/方法资源。资源注册按唯一 `code` 更新单个端点，不能让这四条 API 与旧消息/业务复核共用同一个资源 code。前端仍沿用 `iqc:review:view/create/decide` 按钮权限，不新增菜单。

`IQC_ADMIN`、`IQC_QUALITY_MANAGER` 获得四条接口资源；`IQC_INSPECTOR`、`IQC_VIEWER` 仅获得历史与待办查询。隔离权限回归核对新库、已有待注册资源 ID 保留、重复执行及正反角色边界；正式发布前还须经真实网关登录验证 URL 授权和任务数据范围。迁移未在共享库执行。

### IQC 业务会话结果分页（待部署）

`V20260928_01__dml_add_iqc_business_result_resource.sql` 为 `GET /api/iqc/results/business`
提供独立资源码 `iqc:result:business:view`，不覆盖旧 `iqc:result:view` 的注册端点。
四类 IQC 角色均可读取，任务本人／同组／管理员的数据范围继续由 IQC 服务校验；
不新增菜单、按钮、用户或系统 ADMIN 授权。前端沿用结果中心入口。

既有隔离权限脚本已增加新库、重复执行、已注册资源 ID 保留、四角色正向和其他角色
负向断言。最初仅完成脚本语法检查；2026-10-03 通过脚本本地 socket 模式在 MySQL 8.0.34
完成新库与升级库回归。上线前仍须经真实网关登录验收；未在共享库执行。

- 固化授权数据变更的审计和回滚规范；
- 补齐菜单、按钮、资源的批量校验工具；
- 为跨租户/跨组织授权明确边界与测试用例。
