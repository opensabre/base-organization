# IQC 端点拆分权限迁移独立验证（2026-10-28）

固定基线 `1f51edd`（含 `4ffe28e`、`290c5aa`），仅新增验证脚本与本记录，不修改迁移或生产代码。

`scripts/test-iqc-endpoint-permissions.py` 使用专用本机 MySQL 8.0，启动前校验 datadir、socket、loopback bind 和测试端口。每组随机新 schema，应用正式组织 baseline 与其它 DML，显式移除本次 29 个能力的旧资源/关系，构造对应场景后执行三份端点迁移两次，finally 仅删除该组 schema。这里的 fresh 是这些能力缺失的场景；不是完整 Flyway 新库或升级路径证明。

原进程 69983 退出 0，`/tmp/iqc-b-endpoint-permission-20261028.log.exit` 为 0。八组均通过：

- 原能力缺失：七个原能力和 22 个新能力保持 PENDING，没有自动角色授权。
- 原 ACTIVE：保持 20 位旧注册 ID，按每个原能力独立的 20 位角色 ID 精确继承对应新能力关系；不串角色。移除一个新能力关系后，SQL active relation 查询为 0。
- 原 PENDING、STALE：继承状态，无新授权，即使旧关系存在也不复制。
- 新资源预先 PENDING、原 ACTIVE：新 ID/状态保持，无新授权。
- 新资源预先 ACTIVE、原 PENDING：新 ID/状态保持，不因新资源 ACTIVE 从禁用原能力复制授权。
- 原资源属其它 application 或 product：不改旧身份/状态、不复制到 IQC 新能力。

所有场景精确核对目标能力的角色关系集合，重复执行两次的资源身份/状态/URL/方法和关系 ID/集合完全相同；用户、用户角色、角色、菜单与角色菜单计数不变。20 位关系列和注册 ID 经实际 MySQL 写入，避免长度超限。测试关系中的角色 ID 是显式合成 fixture，不代表真实用户已有这些角色。

复现需要先启动专用本机测试实例，再设置 `MYSQL_TEST_ALLOWED_DATADIR`、`MYSQL_TEST_SOCKET`、`MYSQL_TEST_PORT`、可选 `MYSQL_TEST_BINARY`，执行 `python3 scripts/test-iqc-endpoint-permissions.py`。拒绝使用共享数据库，不读取生产凭据。

范围：证明实际 SQL 种子/迁移继承和幂等行为；没有运行组织服务、ResourceMapper/Feign/PDP、真实登录/HTTP、完整 Flyway schema history。撤销的是新能力关系，未在撤销后重放迁移；Flyway 本应只执行一次，不能把一次性继承 DML当持续授权同步。当前适用 PRD I1–I7 仍未全部完成。
