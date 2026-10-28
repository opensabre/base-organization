# 70项资源当前授权数据库安全链验证

2026-10-28，固定基线08e2c62。扩展现有IqcSchedulerAccessDatabaseTest，复用项目H2隔离fixture、真实Spring安全过滤链、内部签名令牌、组织Controller、事务代理及生产Mapper，无生产修改或共享数据库操作。

原22646终态0，/tmp/iqc-b-org-70-current-grants-20261028.log.exit为0。离线test-compile/surefire，maven.gitcommitid.skip只跳元数据采集，显式ByteBuddy agent；fresh数据库类5项零失败错误跳过。

新增一个组合方法读取版本化70项独立资源契约，每项执行三次签名current HTTP调用（共210次）：ACTIVE资源精确返回该code；改为PENDING即不返回；恢复ACTIVE但删除角色资源关系仍不返回。每轮恢复夹具关系，资源code/method/url均取独立清单；每轮检查内部令牌上下文已清除。只核对返回resourceCodes，不把资源URL/method填入数据库当网关匹配证明。

原四方法同轮回归：无令牌/篡改令牌401，合法签名读取及撤权；资源/用户角色关系移除立即反映；非ACTIVE及其它应用/产品资源被排除；账号四有效标志与逻辑删除拒绝。启动中现有治理注册异步重试日志不改变这些断言。

范围是H2中的真实组织SQL和MockMvc完整生产安全过滤组合；非MySQL并发隔离、真实socket组织服务、网关/PDP或真实用户登录。与后端签名Feign本机夹具链分别有证据，尚未组成同一个跨服务真实部署验收。完整适用I1–I7继续进行，无语音转换工作。
