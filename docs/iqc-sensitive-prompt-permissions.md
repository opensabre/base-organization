# 冻结任务配置与Prompt独立读取

新增迁移V20261018_01__dml_register_iqc_sensitive_prompt_read.sql，资源/按钮900263，code iqc:sensitive:prompt:read，真实GET /api/iqc/tasks/{id}/configuration，按钮归原任务菜单900103。应用接口复用SensitiveReadAccessService和taskRead，先刷新task:view+Prompt固定基础授权，要求FULL+PII+Prompt均当前有效，再调用原taskService.get验证数据范围；无原文审计/no-store/nosniff。没有新ACL表、存储模型或framework修改。

默认角色IQC_ADMIN、IQC_QUALITY_MANAGER，沿用原20字符SHA2关联ID与自然键去重；不授IQC_INSPECTOR、IQC_VIEWER或系统ADMIN，不创建用户。Prompt不隐含完整会话/PII，不绕过原Task范围。原普通任务GET也按这三个独立grant控制冻结正文。

仅生成迁移草案并静态核对源码路径/权限码/ID与版本，无SQL执行。隔离MySQL新库/升级/重复执行、已有注册资源ID保留、实际组织资源投影与四角色正反请求尚待验证；迁移尚未部署，不能宣称授权已生效。原会话敏感迁移保持不改，新增真实路由后才登记Prompt资源。


## 模型诊断正文

新增V20261018_02，资源/按钮900264，原任务菜单900103，code iqc:task:model-call-data:view，真实GET /api/iqc/tasks/{id}/model-calls/{callId}/diagnostics。仅IQC_ADMIN/IQC_QUALITY_MANAGER，沿原关联ID与去重规范，不隐含其它grant；接口仍要求当前调用日志查看、Prompt、FULL和PII，原Task scope与调用归属均通过后才解密。过期不读正文，审计无正文。未执行SQL，隔离迁移和真实角色验证待完成，不宣称已生效。
