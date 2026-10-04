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
