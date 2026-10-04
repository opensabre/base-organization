# IQC Finding / Pipeline 权限迁移

沿用组织服务资源注册、产品菜单按钮和 IQC 业务角色模型。未创建用户、用户角色、OAuth 客户端或系统 ADMIN 授权。现有 ResourceRegistrationService 按唯一 code 定位资源并更新 URL/method，因此每个接口使用独立资源码。

| Method | URL | 资源 code |
|---|---|---|
| GET | `/api/iqc/findings/catalog` | `iqc:finding:view` |
| GET | `/api/iqc/findings/catalog/{id}` | `iqc:finding:detail:view` |
| POST | `/api/iqc/findings/catalog` | `iqc:finding:manage` |
| PUT | `/api/iqc/findings/catalog/{id}` | `iqc:finding:update` |
| POST | `/api/iqc/findings/catalog/{id}/publish` | `iqc:finding:publish` |
| POST | `/api/iqc/findings/catalog/{id}/availability` | `iqc:finding:availability` |
| GET | `/api/iqc/findings/catalog/{id}/versions` | `iqc:finding:versions:view` |
| GET | `/api/iqc/pipelines` | `iqc:pipeline:view` |
| GET | `/api/iqc/pipelines/{id}` | `iqc:pipeline:detail:view` |
| POST | `/api/iqc/pipelines` | `iqc:pipeline:manage` |
| PUT | `/api/iqc/pipelines/{id}` | `iqc:pipeline:update` |
| POST | `/api/iqc/pipelines/{id}/publish` | `iqc:pipeline:publish` |
| POST | `/api/iqc/pipelines/{id}/availability` | `iqc:pipeline:availability` |
| GET | `/api/iqc/pipelines/{id}/versions` | `iqc:pipeline:versions:view` |
| POST | `/api/iqc/pipelines/{id}/trial` | `iqc:pipeline:execute` |

IQC_ADMIN、IQC_QUALITY_MANAGER 获得全部 15 个接口。IQC_INSPECTOR、IQC_VIEWER 仅获得两个域的集合/详情/版本查询共 6 个接口；不能创建、更新、发布、设置可用性或试跑。

基础动作按钮编码为 iqc:finding:view/manage/publish 和 iqc:pipeline:view/manage/publish/execute。稳定按钮 ID：900150–900152、900160–900163，parent=900001，type=BUTTON，href=NULL。页面尚未交付，没有创建 MENU 或虚假 SPA 路由。前端接入时可在后续迁移中将同 ID 挂到真正页面下，保持权限编码和角色关联。

新库通过正常 Flyway baseline 后执行此 DML；升级环境按资源唯一 code 激活既有 PENDING，ON DUPLICATE KEY 不覆盖已有 ID、URL、method。角色资源通过查询实际 resource.id 建立关联，不假设预置资源 ID。菜单及资源关联采用固定 20 字符哈希主键，并按 role/menu、role/resource 自然键排除已有关系，因此重复运行不重复授予权限。资源种子 ID 为 900150–900156、900160–900167（不使用 900157–900159）。

控制器注解必须与表格一致，不能重复使用 view/manage 码。权限只保护产品接口，记录的数据范围仍由 IQC 服务 IqcDataScope 校验。查询角色可查看的草稿/版本范围必须由服务层设计明确，授权迁移不能代替对象级检查。

未在共享数据库执行，未新增或执行测试。发布验收需要隔离 MySQL 新库/已注册 PENDING/重复运行场景，以及四类角色真实登录验证；前端按钮需在 UI 实现后接入。没有据此声称已部署或完成权限验收。

依据：workspace AGENTS；Wiki access-control；raw/base-organization organization-and-access；现有 V20260915_01 标签权限、V20260917_01 方案权限及 ResourceRegistrationService。

## 已发布流水线任务入口

V20261004_02 新增 POST /api/iqc/pipelines/{id}/tasks 的独立资源 iqc:pipeline:task:create。IQC_ADMIN、IQC_QM、IQC_INSPECTOR 可创建已发布版本任务；VIEWER 不授予。沿用现有组织资源注册与关系表，未执行数据库迁移。

V20261004_03：重算创建仅 IQC_ADMIN/IQC_QUALITY_MANAGER；历史查看同 IQC_ADMIN/IQC_QUALITY_MANAGER/IQC_INSPECTOR/IQC_VIEWER，实际数据范围仍由源任务校验。未运行迁移。

V20261004_04：保留900150及既有授权，将查看事实目录升级为/iqc/findings页面；补齐详情/更新/可用性/历史按钮权限，与既有API授权对应。ADMIN/QUALITY_MANAGER管理，INSPECTOR/VIEWER查询。未运行数据库迁移。

V20261004_05：补齐Pipeline详情/版本/更新/启停按钮权限，与V01既有接口资源授权对应；使发布政策版本选择可按菜单权限工作。此次仍无Pipeline配置页导航，页面交付后再提升900160。未执行迁移或角色登录验收。

V20261004_06：保留900160及角色关联，提升/iqc/pipelines配置页入口；将既有流水线操作按钮移到该菜单下。没有创建新接口资源或用户授权；未运行迁移/角色登录验收。

## I3 金标与评测数据集

V20261004_07 复用组织资源、角色资源、按钮与角色菜单关系，登记金标 5 个、数据集 8 个独立端点。资源和按钮各使用 ID 900180–900192，分属不同表；已静态检索已有迁移未占用。按钮挂既有根 900001，href=NULL，不创建未交付页面的 MENU。

| Method | URL | 资源/按钮 code |
|---|---|---|
| GET | `/api/iqc/quality-operations/samples/{sampleId}/gold` | `iqc:gold:view` |
| PUT | `/api/iqc/quality-operations/samples/{sampleId}/gold` | `iqc:gold:annotate` |
| POST | `/api/iqc/quality-operations/samples/{sampleId}/gold/reviews` | `iqc:gold:review` |
| GET | `/api/iqc/quality-operations/samples/{sampleId}/gold/versions` | `iqc:gold:versions:view` |
| GET | `/api/iqc/quality-operations/samples/{sampleId}/gold/versions/{versionNo}` | `iqc:gold:version:view` |
| GET | `/api/iqc/evaluation/datasets` | `iqc:dataset:view` |
| GET | `/api/iqc/evaluation/datasets/{id}` | `iqc:dataset:detail:view` |
| POST | `/api/iqc/evaluation/datasets` | `iqc:dataset:manage` |
| PUT | `/api/iqc/evaluation/datasets/{id}` | `iqc:dataset:update` |
| POST | `/api/iqc/evaluation/datasets/{id}/freeze` | `iqc:dataset:freeze` |
| POST | `/api/iqc/evaluation/datasets/{id}/availability` | `iqc:dataset:availability` |
| GET | `/api/iqc/evaluation/datasets/{id}/versions` | `iqc:dataset:versions:view` |
| GET | `/api/iqc/evaluation/datasets/{id}/versions/{versionNo}` | `iqc:dataset:version:view` |

IQC_ADMIN、IQC_QUALITY_MANAGER 获得全部 13 个接口及对应按钮。IQC_INSPECTOR 获得 7 个 GET 查询接口与金标标注；IQC_VIEWER 仅获得 7 个 GET 查询接口。独立金标审核和数据集创建、更新、冻结、可用性管理只授予管理员与质量主管；审核服务仍须校验标注人与审核人不能相同，接口权限不能代替该业务约束与对象数据范围。

按 code 激活已注册资源，保留其 ID/URL/method；关联查询实际资源 ID，以固定 20 字符哈希主键和自然键排重。不创建用户、用户角色或系统 ADMIN 授权。静态核对控制器 13 个唯一资源码与 URL/method；没有新增或执行测试，没有运行 SQL、部署、四角色登录或网关验收。UI 尚未交付，按钮可见性也未验收。
