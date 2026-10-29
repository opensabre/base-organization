# 当前菜单与 API 同库撤权、用户缓存碰撞修复（2026-10-29）

组织基线36f2acc。真实签名internal token贯穿生产security/filter与两个Controller，同一个H2数据库用户、角色、菜单和资源关系；构造账号username与ID相等，保留该合法边界，不改fixture避开缺陷。

## 复现与修复

原48416仅使用真实签名`x-client-token`，`GET /menu/current?productCode=iqc`进入CurrentUserService/UserService后500：User实体不能转为UserVo。get(id)与getByUniqueId(username/mobile)原来使用相同`user:`前缀与相同字符串键。按唯一标识查询缓存User后，按ID读取视图取到了错误类型。原72359最小真实代理/数据库测试独立复现相同ClassCastException，terminal1；日志`/tmp/iqc-b-user-cache-collision-red-20261029.log`。

最小应用修复仅在UserService中拆分`user-view:`与`user-lookup:`缓存命名空间，视图update/delete同步失效到新名字。两种缓存均换名，避免部署后读取旧`user:`中已经存入的错误类型；缓存按需重新建立。沿用原JetCache、Mapper与服务，不增加API/表/缓存基础服务，不修改Framework或Gateway。

新增实际代理回归验证lookup→view与view→lookup两种预热顺序，及更新后视图内容刷新、删除后视图不得命中旧值。没有仅反射检查注解来代替行为证明。

## 同库 Controller 行为

新增currentMenuAndCurrentApiProjectionTrackIndependentRevocation，生产MenuController.current、CurrentUserService、MenuService/Mapper及原scheduler current Controller/事务共用同一枚签名令牌：

1. 有子BUTTON与API资源关系时，菜单自动补父节点、返回按钮，API current返回准确能力。
2. 撤API资源关系，菜单仍可见，API current立即为空，证明菜单不能代替接口授权。
3. 恢复API并撤菜单关系，菜单为空，API仍存在；恢复菜单可再次读取。
4. 撤销用户角色关系，两者均为空。异产品菜单不混入IQC树，每请求后签名身份上下文清空。

双Bearer/internal凭据请求明确401。首轮42527曾错误混用两凭据，4669误放第二个同名header，均为失败测试准备、不计通过；最终helper没有模拟JWT，仅使用框架实际签验internal token。菜单CurrentUserService解析的是该签名令牌subject；该fixture用户名与ID相同，不据此声称其它subject映射组合已经验证。

## 最终结果与边界

原72404 terminal0，`/tmp/iqc-b-user-cache-menu-fix-20261029.log.exit=0`，离线`test-compile surefire:test`并使用ByteBuddy javaagent、跳过git元数据采集：IqcSchedulerAccessDatabaseTest 9项49.907s、UserServiceTest 2项9.943s、UserControllerTest 3项1.968s，共14项，失败/错误/跳过均0。原91能力每项3次签名current请求与群组/账号/撤权回归同轮通过。diff检查通过。既有治理注册因本机无base-sysadmin产生重试警告，未把其当真实外部服务通过。

这是实际Spring security/Controller、事务、Mapper、JetCache代理与H2证据；令牌由测试签发，不运行真实登录、Gateway/PDP、网络端口、MySQL菜单迁移或真实Redis序列化。菜单迁移另见隔离MySQL报告，不能拼接冒称完整端到端。五职责、跨组业务、供应商、A–E、监控与百万容量及全部适用I1–I7仍继续。输入为已处理会话，无语音转换工作。
