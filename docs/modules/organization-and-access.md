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

### IQC Selector 独立资产（已编码，待部署）

`V20261004_13__dml_add_iqc_selector_asset_permissions.sql` 沿用检测流水线菜单900160，为选择器资产目录、详情、新建、修订、启停、历史、发布、精确版本读取和版本预览分别登记9个资源/按钮（900204–900212）。资源按code激活，保留已注册ID和URL/方法；角色关联按实际resource.id及自然键幂等，关联ID沿用20字符稳定哈希。

IQC_ADMIN、IQC_QUALITY_MANAGER获得全部九项；IQC_INSPECTOR、IQC_VIEWER仅获得目录、详情、历史、精确版本与预览。正式任务创建仍使用既有iqc:pipeline:task:create，数据范围由IQC核验。未创建用户/角色、不授权全局ADMIN。未运行SQL、权限测试、真实登录或部署。

### IQC 周期调度当前授权查询（实现前取舍）

现有 `UserService.getByUniqueId` / `RoleService.query` / `ResourceService.query` 提供普通交互身份与权限查询，其中角色/用户资源链路有 JetCache，且不存在调度专用、单事务且不输出密码的当前授权投影。Cron 触发不得把创建时角色永久继承，也不能以system代替负责人。

新增 `GET /internal/iqc/scheduler-access/{userId}` 只复用现有用户、角色、用户角色、角色资源和用户群组表/Mapper，在只读REPEATABLE_READ事务直接读取当前行；不新增或复制身份/授权持久化，不改Framework。入口使用已有 `InternalTokenUserContext.currentClaims()` 核验已验签的 `service:iqc-platform`、issuer/source=`iqc-platform`、destination/audience=`base-organization`、首跳且无用户角色/权限声明；不接受外部用户、网关或请求头自行声明服务身份，不注册菜单/用户API资源。

返回仅含用户ID/username、账号有效状态、可确定的单一有效group、当前角色与ACTIVE的IQC资源code、读取时间。缺失/停用/锁定/过期用户返回无权限投影；组织关系歧义不扩大到多group。查询失败/超限即失败关闭。结果是触发时授权证据，不是授权写入或永久角色快照。

### IQC 周期调度资源与导航（已编码，待部署）

`V20261004_14__dml_add_iqc_periodic_schedule_permissions.sql` 复用现有任务导航900019的父级，仅在不存在同产品、同href的MENU时新增周期调度入口900213（`/tasks/schedules`）。按钮和菜单角色授权按实际MENU ID关联，避免为已存在的同一入口再造MENU。九个独立资源/按钮900214–900222分别对应目录GET、详情GET、创建POST、修订PUT、发布POST、启停POST、版本历史GET、周期实例GET及预览POST；服务端基址为`/api/iqc/periodic-schedules`，资源码依次为`iqc:schedule:view/detail:view/create/update/publish/availability/versions:view/instances:view/preview`。

IQC_ADMIN、IQC_QUALITY_MANAGER获得全部九项；IQC_INSPECTOR、IQC_VIEWER仅获得目录、详情、版本历史、实例与预览。资源更新保留已注册ID及URL/方法，关系使用现有自然键防重和20字符稳定哈希ID，不创建用户或角色，不授予全局ADMIN。

API资源授权不替代IQC数据范围核验。周期触发必须使用当前授权查询投影，并要求负责人当前仍具备`iqc:schedule:publish`及正式流水线任务创建/执行等所需授权；不凭创建时角色快照持续执行，不以system放大范围。读取异常、缺失有效用户或撤权时失败关闭。此迁移已按周期调度接口清单完成资源与按钮映射；未执行SQL、测试、实际网关登录或部署，真实角色导航、资源鉴权及触发时撤权效果仍待运行验收。

### IQC 事件/API触发接收（已编码，待部署）

`V20261004_15__dml_add_iqc_trigger_receive_permission.sql` 为`POST /api/iqc/triggers`登记独立资源`iqc:trigger:receive`及按钮900223。复用现有任务导航900019的父级，不新增页面MENU或重复详情/取消/删除接口。资源按code保留已注册ID、URL和方法；角色关联复用自然键防重与20字符稳定哈希。仅IQC_ADMIN、IQC_QUALITY_MANAGER、IQC_INSPECTOR获得接收权限，IQC_VIEWER不获得；不创建用户/角色、不授予全局ADMIN。

接收保存WAITING_INPUT任务，后续物化使用负责人当前有效授权，同时要求`iqc:pipeline:task:create`、`iqc:task:execute`、`iqc:trigger:receive`；携带会话内容还要求`iqc:conversation:upload`。创建时授权不替代物化时授权，查询失败或撤权失败关闭。详情、取消、删除沿用原任务资源及数据范围校验。迁移未执行SQL、测试、编译、登录验收或部署，运行角色与撤权效果待验收。


### IQC 模型/Skill 独立端点授权（待验证/部署）

V20261028_01 拆分模型更新/启停和 Skill 更新/启停/回滚/历史读取。原 model:manage、skill:manage 固定为创建接口，skill:view 固定为列表。原资源 ID、状态和授权关系保留；新端点只继承其原能力的状态，角色关系仅从 ACTIVE 原资源复制到 ACTIVE 新资源。不新建账号/角色，不向系统 ADMIN 或全部 IQC 角色泛授。已存在新资源的状态也不覆盖。

在匹配的 IQC 版本启动注册前执行本迁移。新环境同样走 Flyway；缺失原资源时创建 PENDING 种子，不推断默认角色授权，须沿原组织管理流程激活并授权。若新代码已先注册出 PENDING 拆分资源，迁移不会擅自激活，必须逐项核对并显式审批。前端原 manage/view 操作组保持，服务端逐端点授权；Skill 的敏感读取也检查新码。

当前仅提供源码迁移，未执行共享库。需独立验证新库/升级/重复执行/已注册ID保留/未激活与撤权/每个URL方法，以及真实网关五职责授权。此修复不等于所有旧 Controller 的同码多端点均已完成审计。


### IQC 任务独立端点授权（待验证/部署）

V20261028_02 将 task:view 保留给任务目录，详情和执行历史分别为 task:detail:view / task:executions:view；task:execute 保留给运行，恢复/暂停/优先级分别为 task:resume / task:pause / task:priority。沿 V20261028_01 的旧ID/状态和显式授权继承规则，不创建角色或账号，新环境缺失原资源保持 PENDING，已注册拆分资源状态保留。先迁移再启动匹配 IQC 注册；未在共享库执行，真实 SQL/HTTP/网关及撤权验收仍待。批次恢复的负责人和当前 GRANTS 不因拆分而移除。


### IQC 结果独立端点授权（待验证/部署）

V20261028_03 保留 result:view 给结果列表、result:export 给普通导出，详情/汇总/标签列表/标签分布/任务会话/层级/会话历史/反馈列表和标签导出各用独立资源码。对应 IQC Controller 的敏感前置同步新码，导出仍要求完整会话和PII；不授予敏感读取或扩大数据范围。状态、旧ID及显式关系继承规则与前两份拆分迁移一致。新环境同走Flyway，缺失原能力保持PENDING并通过原组织流程激活/授权；先迁移后启动匹配服务注册。未执行共享SQL，独立SQL/HTTP/真实网关验证待完成。


### IQC 会话独立端点授权（待验证/部署）

V20261028_04 保留 conversation:view 给列表、conversation:upload 给单TXT导入。预览详情/API统计和批TXT/ZIP/JSON/批JSON各用独立码，按旧有效资源的显式角色关系继承。已有ID/状态保留、缺失原资源保持PENDING，先迁移再匹配IQC注册。完整会话与PII的独立敏感授权不变，内嵌内容触发原upload复合检查不变，不包含语音解码或转写。未执行共享SQL，独立SQL/MVC/实际网关及来源数据授权仍待。
