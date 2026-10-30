# 当前授权投影的实际本机HTTP验证

基于组织PR56固定 `cd64ea5`。复用原 IqcSchedulerAccessDatabaseTest、H2数据与真实签名/过滤链，服务器只监听127.0.0.1随机端口，新增JDK HttpClient实际TCP请求；原MockMvc/数据库/缓存回归保留。生产代码、POM、framework、迁移及共享数据库不变。

新增两项测试共13次实际HTTP请求：

- 同一有效签名令牌携带IQC_ADMIN和恢复权限旧声明，数据库角色分别为现有IQC_ADMIN、IQC_QUALITY_MANAGER、IQC_INSPECTOR、IQC_VIEWER；响应只返回当前数据库角色及显式关系。恢复能力按原迁移的管理员/质量主管关系构造，删除关系即清授权、恢复关系即可重新投影，查看/质检角色不因令牌声明获得该能力。
- 同一令牌下，删除群组关系立即返回无groupId，删除用户角色关系立即清角色和资源码。

使用的是测试自有受控关系图，没有执行全部角色种子/迁移，也没有验证完整五职责页面、外部登录/网关PDP、owner/group/all业务查询、远程Redis或IQC实际写入。它补实际HTTP传输与当前关系投影证据，不能替代这些后续验收。

初轮原16008 terminal1，git-commit-id旧插件无法读取worktree HEAD，未进入编译/测试；沿项目既有方式只加CLI参数 `-Dmaven.gitcommitid.skip=true`，没有改POM或伪造Git元数据。最终原15998 terminal0：

```sh
JAVA_HOME=/Library/Java/JavaVirtualMachines/graalvm-21.jdk/Contents/Home mvn -o -Dmaven.gitcommitid.skip=true -Dtest=IqcSchedulerAccessDatabaseTest,UserServiceTest,UserControllerTest test
```

16项，0失败/错误/跳过，BUILD SUCCESS，56.732秒；日志 `/tmp/iqc-b-current-access-http-final.log` 与 `.exit=0`，Surefire XML留在target/surefire-reports。运行期间源码/测试冻结，之后仅追加本文档；diff检查通过。原框架诊断/校验警告保留，不称外部依赖已通过。
