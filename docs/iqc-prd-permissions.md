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

## 数据集页面入口

V20261004_08 配合本批数据集页面，将既有按钮 900185 提升为 MENU，路径 `/iqc/evaluation/datasets`，名称“评测数据集”，顺序 38；沿用原图标及 `iqc:dataset:view` 权限描述，保留菜单 ID 和全部角色关联。900186–900192 的数据集操作按钮挂到该页面下。金标按钮 900180–900184 保持既有位置，金标入口使用已有质量运营样本页，不新增金标 MENU。页面只提供金标与数据集能力，尚不代表评测执行中心已经交付。

本迁移不新增接口资源或用户授权。未运行 SQL、测试、部署或真实角色登录验收；导航路由及按钮权限仍需随 UI 发布后验证。
# I3 冻结数据集评测执行接口

V20261004_09 注册4个独立资源与按钮900193–900196，挂已交付的数据集菜单900185；无新MENU，无用户/用户角色变化。ADMIN/QUALITY_MANAGER可创建评测（包括精确草稿目标），四类IQC角色可按Task数据范围读取样本摘要、精确轨迹和报告。执行、暂停、恢复、取消仍沿用已有任务API资源，不新增平行执行接口。未执行SQL、测试、网关或角色验收；评测任务/报告前端仍待接入。

## 单变量 Benchmark 与评测任务页面

V20261004_10 新增 MENU 900197「评测任务与对照」，路径 `/iqc/evaluation/tasks`，父菜单复用 Dataset 900185 的现有父节点，顺序39，权限描述 `iqc:evaluation:report:view`。四类 IQC 角色均获得入口；既有09按钮900193–900196保留ID、权限码与角色关系，移到此入口下。新资源及按钮900198–900200均通过已有组织能力配置，无新持久模型或授权抽象。新增版本与ID在编写前已检索未占用。

| Method | URL | 资源/按钮 code | 角色 |
|---|---|---|---|
| POST | `/api/iqc/evaluation/benchmarks` | `iqc:benchmark:create` | IQC_ADMIN / IQC_QUALITY_MANAGER |
| GET | `/api/iqc/evaluation/benchmarks/{baselineTaskId}` | `iqc:benchmark:view` | 四类 IQC 角色 |
| GET | `/api/iqc/evaluation/benchmarks/{baselineTaskId}/report` | `iqc:benchmark:report:view` | 四类 IQC 角色 |

服务须继续校验两个任务的数据范围、冻结数据集一致与单变量条件；资源授权不替代这些约束。执行、暂停、恢复和取消复用原任务接口权限。资源按唯一code激活已注册PENDING并保留已有ID/URL/method，角色资源查询真实资源ID；关系使用固定20字符哈希键并按自然键去重。仅授予四类产品角色，不授权系统ADMIN，不创建用户或用户角色关系。

本批仅完成本地静态编写与代码审阅，未新增或执行测试，未运行SQL、部署、网关或四角色登录验收。实际菜单及接口边界须在发布后验证。

## UNKNOWN 动作核对权限（B 独立分支）

V20261010_01 对应 IQC 后端 b2c3fa6 的真实 POST `/api/iqc/conversation-results/{id}/actions/{actionExecutionId}/reconcile`，独立资源码 `iqc:action:reconcile`，资源/按钮900249。按钮复用任务菜单900019所在父节点；不新增页面、平行角色或账号。仅 IQC_ADMIN / IQC_QUALITY_MANAGER 获得资源和按钮，INSPECTOR、VIEWER、系统 ADMIN 及其他角色不因此自动获得。后端仍校验原负责人稳定身份与数据范围，权限不允许代替其他负责人确认产物，也不授予发送、重试或gold审核能力。

按 code 更新已注册资源，保留原 ID/URL/method；角色关联查实际资源 ID，沿既有自然键排重。已有迁移和baseline保持不变。扩展已有 `scripts/test-iqc-label-permissions.sh`，没有创建第二份权限测试框架；新增SQL断言检查实际POST、按钮父级、两角色正授权及其他角色负边界。

验证：迁移布局检查、bash语法和diff检查通过；隔离MySQL权限回归会话37921 exit0，新环境与PENDING注册资源升级各重复执行两次，旧回归与新断言均PASS，保留生成注册ID2100000000000000041，用户/用户角色数未变化，测试库自动清理。完整Flyway会话46822 exit0，新安装应用38份迁移至20261010.01；升级先应用37份至20261004.29，再只应用本次1份，validate与重复migrate无新增均通过，权限断言PASS，测试库自动清理。Flyway使用本地既有依赖和临时Java验证器，不宣称临时验证器为仓库CI新增步骤；仓库既有可复用Flyway CI仍负责远程验收。日志 `/private/tmp/iqc-b-reconcile-permissions.log`、`/private/tmp/iqc-b-reconcile-permissions-flyway.log`。

未推送、合入A、部署、修改共享组织账号、运行浏览器或真实四角色登录；UI操作入口、网关和服务鉴权链、完整尝试审计及PRD其他能力仍未验收。独立权限分支以b9d2dde为基线，后端B b2c3fa6保持不变。


## 阻塞动作恢复资源（待数据库验收）

V20261011_01注册真实POST `/api/iqc/conversation-results/{id}/actions/{actionExecutionId}/recover`，复用原资源/任务菜单/角色表，资源及按钮900250、`iqc:action:recover`。仅IQC_ADMIN和IQC_QUALITY_MANAGER获授权；后端还要求当前负责人身份、固定生产权限与原动作业务权限。恢复重新核验冻结政策，不清除原领取或回执，UNKNOWN不可回队。断言文件iqc-action-recovery-permissions-assertions.sql用于迁移后及重复执行验证；本批仅编写，未执行SQL。

恢复资源实际隔离MySQL验收99496 exit0：扩展原test-iqc-label-permissions.sh，严格核验本地socket/@@datadir/port/bind_address后，在独立临时库验证fresh与upgrade均PASS，各重复执行两次。恢复资源/按钮角色边界断言通过，升级保留既有生成资源ID2100000000000000042，用户/用户角色数量不变。原标签/方案/复核/业务结果/核对资源断言同时通过。脚本包含临时库退出清理；未部署或写共享数据库。locale提示不影响结果；实际登录用户HTTP授权仍另需验收。

## 人工恢复的当前用户组织投影

原scheduler-access服务专用入口只允许service:iqc-platform/hop1；真实人工Feign保留用户subject并增加hop，不能复用该入口。现最小扩展同controller `/internal/iqc/scheduler-access/current/{userId}`，复用原一致快照投影，不新增持久模型；严格核对IQC来源/组织目标、非服务用户主体、username和实际目标账号。后台入口限制保持，当前接口无目录管理或发送授权。

组织编译91529通过（只在验证命令跳过不兼容worktree的git元数据插件）。87475 exit0：controller身份7项+实际令牌签发/验签传播1项，零失败错误跳过。真实InternalTokenRequestFactory从用户入站建立hop2及父链，实际controller接受当前用户且原后台入口拒绝；篡改/异目标拒绝。Access数据库服务为替身，这不是Feign网络/MVC Filter/组织数据库全链路证明，后续需补。

实际数据库补验：IqcSchedulerAccessDatabaseTest 复用现有 organization-service-fixture.sql、H2 数据源和生产 Mapper/事务代理，无外层测试事务，仅创建清理 iqc-db-* 专用记录。99698 terminal exit0，3项零失败错误跳过：逐次撤销资源/角色关联立即反映；停用、其他应用/产品资源被排除；四项账号有效标志失效或逻辑删除均返回无权限。日志 /private/tmp/iqc-b-org-access-database-mockweb.log。初次 NONE Web 模式因现有安全配置需要 HttpSecurity 在启动阶段失败，改用原项目默认 Mock Web 模式后通过，未改生产安全配置。启动治理注册出现无 base-sysadmin 实例的异步重试警告，不涉及已验证 SQL 断言；本次不是 MySQL 隔离级别并发验证或组织 HTTP Filter 全链路验收。

组织MVC+SQL组合补验：扩展同一数据库测试，以生产FilterChainProxy挂入webAppContextSetup MockMvc，实际InternalTokenService签发、实际过滤器验签和controller读取原Mapper；缺令牌/篡改401，合法hop2用户返回真实权限，撤权后的下一请求不再返回该权限，请求结束currentClaims清理。85469 terminal exit0，原SQL3项+新增MVC1项共4项零失败错误跳过，日志 /private/tmp/iqc-b-org-access-security-database-agent.log。远程InternalTokenConfigurationRefresher明确MockitoBean替身，避免隔离测试依赖Nacos；无替换签发/验签/过滤器/控制器/投影。测试属性关闭无关治理注册，生产配置未改。验证命令需 -Dmaven.gitcommitid.skip=true 及 -DargLine=-javaagent:/Users/zhoutaoo/.m2/repository/org/mockito/mockito-core/5.23.0/mockito-core-5.23.0.jar（本机实际依赖版本），解决受限环境Mockito运行时self-attach失败。不覆盖真实网络端口、IQC完整恢复流程、MySQL并发隔离或远程配置刷新；实际Feign传输另有B9b875c0独立证据。

风险查询 V20261011_02/资源按钮900251复用原结果动作历史四角色授权与原结果scope，GET /api/iqc/conversation-results/{id}/risk-events 对应实际后端接口，code iqc:risk:view。只读不授risk:create或处理权限，不建立风险另一路数据范围。迁移尚未执行，实际授权/重复执行验收仍待。

风险创建 V20261011_03/资源按钮900252仅IQC_ADMIN/QUALITY_MANAGER，code iqc:risk:create、method BACKGROUND、内部能力引用/internal/iqc/risk-events/create对应实际RiskEventActionService.create。复用原后台入队能力声明/原角色关系，应用注册快照保留该资源。不是HTTP人工创建接口，不授风险读取或处置权限；未执行迁移，实际授予/撤销/重复执行验收待。

风险处理V20261011_04/资源按钮900253仅IQC_ADMIN/QUALITY_MANAGER，risk:handle映射真实POST /api/iqc/conversation-results/{id}/risk-events/{riskEventId}/handle，scope仍沿原结果范围。查询和创建权限不自动取得处理权；此迁移未执行，实际身份/授权/重复执行验收待。

风险create修正V20261011_08（保留03的ID及角色关系）：BACKGROUND能力改MANUAL来源，防完整HTTP快照/旧应用漏报导致STALE。应用注册器须同时移除该能力的自动声明，否则下一轮会重新置ANNOTATION；不能只跑此迁移。后台仍按固定risk:create当前grant校验，不放宽授权。迁移未运行，快照/实际权限验收待。

风险历史V20261011_05/资源按钮900254，risk:history:view实际GET /api/iqc/conversation-results/{id}/risk-events/{riskEventId}/history，复用原四类只读角色及原结果scope，不授风险创建/处理。未运行迁移、真实授权/重复执行验收待。
