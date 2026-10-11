# 风险与告警权限集成验证

2026-10-11，合并权限版本 fbf11b8 后，在专属 MySQL 8.0 实例执行正式组织 baseline 与 V20261011_02 至 08 七份 DML，完整序列重复两次。实例端口 34307 和 datadir 必须匹配任务专属目录，使用新随机 schema，finally 仅删除该 schema。执行退出 0。

六个资源 900251–900256 的身份、ACTIVE 状态、HTTP/BACKGROUND 方法与来源逐项检查通过；创建风险与发送告警最终均为 MANUAL。读风险、历史和中心分别只授予既有四类读角色；创建、处置与告警仅授予 IQC_ADMIN、IQC_QUALITY_MANAGER。资源与菜单关联的角色集合及数量均精确匹配，重复执行未增加重复关系。风险中心为 MENU，其余为 BUTTON。

日志：`/private/tmp/iqc-b-risk-alert-permission-validation.log`。该验证覆盖正式 SQL 的种子与重复执行行为，未运行完整 Flyway 新库/升级历史路径，未验证登录、HTTP 授权链、注册快照运行或共享环境。迁移布局检查同时覆盖组织与通知两树并通过；完整 PRD 仍待开发和验收。
