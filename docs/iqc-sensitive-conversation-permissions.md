# 会话敏感读取权限迁移

迁移：`V20261016_01__dml_register_iqc_sensitive_conversation_reads.sql`。
来源：IQC 应用 b5ccdf5 的真实 GET 路由与 ResourcePermission；不注册尚无真实接口的 Prompt 权限。

| 资源/按钮ID | code | GET URL | 默认角色 |
| --- | --- | --- | --- |
| 900261 | iqc:sensitive:conversation:read | /api/iqc/conversations/{id}/full-content | IQC_ADMIN、IQC_QUALITY_MANAGER、IQC_INSPECTOR |
| 900262 | iqc:sensitive:pii:read | /api/iqc/conversations/{id}/pii-content | IQC_ADMIN、IQC_QUALITY_MANAGER |

按钮归现有会话中心900102。沿用base_org_resource/menu/role_resource/role_menu和原SHA2关联ID规范；不新增ACL表，不授IQC_VIEWER或系统ADMIN，不改变原基础查看和数据范围授权。PII grant不包含全文grant，API仍须分别校验当前权限；菜单隐藏不替代后端鉴权。

本轮仅静态核对ID、版本唯一性、路由/注解一致性与角色条件。未执行SQL；新库全路径、升级路径、Flyway validate和二次migrate无变化、真实角色资源投影及多账号正反调用均待隔离MySQL验收。不得据此声称权限已在环境生效。语音转换/ASR不在当前交付范围。

仓库原布局校验已通过（2026-10-16）：`bash base-k8s/scripts/validate-flyway-migrations.sh /Users/zhoutaoo/WorkSpaces/IdeaProjects/opensabre/.worktrees iqc-prd-b-action-permissions`，退出0，输出`Flyway migration layout is valid for 1 services.`。这不等同Flyway数据库migrate/validate，也不等同角色实际生效。
