# IQC 端点拆分权限迁移独立验证（2026-10-28）

固定基线 `1f51edd`（含 `4ffe28e`、`290c5aa`），仅新增验证脚本与本记录，不修改迁移或生产代码。

`scripts/test-iqc-endpoint-permissions.py` 使用专用本机 MySQL 8.0，启动前校验 datadir、socket、loopback bind 和测试端口。每组随机新 schema，应用正式组织 baseline 与其它 DML，显式移除本次 29 个能力的旧资源/关系，构造对应场景后执行三份端点迁移两次，finally 仅删除该组 schema。这里的 fresh 是这些能力缺失的场景；不是完整 Flyway 新库或升级路径证明。

初轮 69983 退出 0、八组通过；补充端点契约与既有资源边界后，原进程 75192 退出 0，`/tmp/iqc-b-endpoint-permission-contract-20261028.log.exit` 为 0，十组均通过：

- 原能力缺失：七个原能力和 22 个新能力保持 PENDING，没有自动角色授权。
- 原 ACTIVE：保持 20 位旧注册 ID，按每个原能力独立的 20 位角色 ID 精确继承对应新能力关系；不串角色。移除一个新能力关系后，SQL active relation 查询为 0。
- 原 PENDING、STALE：继承状态，无新授权，即使旧关系存在也不复制。
- 新资源预先 PENDING、原 ACTIVE：新 ID/状态保持，无新授权。
- 新资源预先 ACTIVE、原 PENDING：新 ID/状态保持，不因新资源 ACTIVE 从禁用原能力复制授权。
- 原 ACTIVE 且新资源预先 ACTIVE：保留 20 位新资源 ID，精确继承其原能力对应角色关系。
- 原 ACTIVE 且新资源预先 STALE：不激活、不复制授权。
- 原资源属其它 application 或 product：不改旧身份/状态、不复制到 IQC 新能力。

版本化 `src/test/resources/db/migration/iqc-endpoint-permission-contract.tsv` 固定 29 个能力的 URL/HTTP 方法，与后端实际 MVC 注册验证使用的独立契约相同；每组逐项断言 IQC 资源精确匹配，跨应用/产品的 fixture URL/方法保持原值。

所有场景精确核对目标能力的角色关系集合，重复执行两次的资源身份/状态/URL/方法和关系 ID/集合完全相同；用户、用户角色、角色、菜单与角色菜单计数不变。20 位关系列和注册 ID 经实际 MySQL 写入，避免长度超限。测试关系中的角色 ID 是显式合成 fixture，不代表真实用户已有这些角色。

复现需要先启动专用本机测试实例，再设置 `MYSQL_TEST_ALLOWED_DATADIR`、`MYSQL_TEST_SOCKET`、`MYSQL_TEST_PORT`、可选 `MYSQL_TEST_BINARY`，执行 `python3 scripts/test-iqc-endpoint-permissions.py`。拒绝使用共享数据库，不读取生产凭据。

范围：证明实际 SQL 种子/迁移继承和幂等行为；没有运行组织服务、ResourceMapper/Feign/PDP、真实登录/HTTP、完整 Flyway schema history。撤销的是新能力关系，未在撤销后重放迁移；Flyway 本应只执行一次，不能把一次性继承 DML当持续授权同步。当前适用 PRD I1–I7 仍未全部完成。

## 五份迁移扩展验证

2026-10-28 同步固定 `0d646be`（含会话 `ae66fb8`），扩展同一验证器至 12 个原能力、33 个新能力，共 45 项独立 URL/HTTP 方法契约。第四、五份迁移包含已处理会话的查询/导入、MCP 修改/启停、专家方案历史与基础状态，无语音转换工作。

原进程 6010 终态 0，`/tmp/iqc-b-five-endpoint-permissions-retry-20261028.log.exit` 为 0，十组全部通过，每组五份实际 SQL 执行两次，核对精确关系、旧 ID/状态、跨应用/产品边界和运行数据计数不变。退出后专用 socket 已清除。首轮受限环境启动 mysqld signal 11、退出 1，未执行验证、不计通过；重试使用相同专用 datadir 并在正确验证工作树运行。

本轮仅增加 SQL 证据。45 项尚不代表后端全部实际 MVC 注册已验证：旧 29 项 MVC 证据范围不变，新增 16 项 MVC 和当前权限前置仍待补齐。真实登录、网关/PDP 与完整 Flyway 路径仍未证明。

## 第六份标签迁移扩展

固定迁移 `46b7f24`，同一脚本扩至18个原能力、52个新能力、70项独立接口契约，六份迁移每场景执行两遍。原进程7749终态0，`/tmp/iqc-b-six-endpoint-permissions-20261028.log.exit` 为0，十组全部通过，专用socket退出。每遍额外核对原 `iqc:label:approve` 的资源身份/状态/URL/方法与全部关系ID/集合不变。各合成原能力角色精确仅获自身对应子能力；查看角色未获管理子能力，标签管理未扩大至原标签发布授权。标签集合发布沿原集合管理继承，与标签发布权分别核验。

这些是实际SQL授权关系证据，不能替代真实登录HTTP、网关/PDP拒绝或用户可见按钮验收。生产迁移未修改，无共享数据库操作。
