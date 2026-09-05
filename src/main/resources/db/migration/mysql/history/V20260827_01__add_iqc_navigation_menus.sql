SET NAMES utf8mb4;

-- IQC 页面导航节点由组织菜单树驱动；按钮节点仍保留用于操作权限。
INSERT INTO base_org_menu
    (id, parent_id, type, href, icon, name, description, order_num, created_time, updated_time, created_by, updated_by)
VALUES
    (900101, 900001, 'MENU', '/iqc/dashboard', 'dashboard', '睿检总览', '{"perm":"iqc:dashboard:view"}', 10, now(3), now(3), 'system', 'system'),
    (900102, 900001, 'MENU', '/iqc/conversations', 'message', '会话中心', '{"perm":"iqc:conversation:view"}', 20, now(3), now(3), 'system', 'system'),
    (900103, 900001, 'MENU', '/iqc/tasks', 'schedule', '质检任务', '{"perm":"iqc:task:view"}', 30, now(3), now(3), 'system', 'system'),
    (900104, 900001, 'MENU', '/iqc/results', 'file-search', '质检结果', '{"perm":"iqc:result:view"}', 40, now(3), now(3), 'system', 'system'),
    (900105, 900001, 'MENU', '/iqc/agents', 'robot', 'Agent 管理', NULL, 50, now(3), now(3), 'system', 'system'),
    (900106, 900001, 'MENU', '/iqc/rules', 'setting', '规则中心', NULL, 60, now(3), now(3), 'system', 'system'),
    (900107, 900001, 'MENU', '/iqc/templates', 'book', '模板中心', '{"perm":"iqc:template:view"}', 70, now(3), now(3), 'system', 'system'),
    (900108, 900001, 'MENU', '/iqc/settings', 'setting', '系统设置', '{"perm":"iqc:settings:view"}', 80, now(3), now(3), 'system', 'system'),
    (900109, 900001, 'MENU', '/iqc/audit-logs', 'file-text', '操作日志', '{"perm":"iqc:settings:view"}', 90, now(3), now(3), 'system', 'system'),
    (900110, 900105, 'MENU', '/iqc/agents', 'robot', 'Agent 列表', '{"perm":"iqc:agent:view"}', 10, now(3), now(3), 'system', 'system'),
    (900111, 900105, 'MENU', '/iqc/agent-models', 'api', '模型配置', '{"perm":"iqc:model:view"}', 20, now(3), now(3), 'system', 'system'),
    (900112, 900105, 'MENU', '/iqc/agent-mcps', 'deployment-unit', 'MCP 管理', '{"perm":"iqc:mcp:view"}', 30, now(3), now(3), 'system', 'system'),
    (900113, 900105, 'MENU', '/iqc/agent-skills', 'tool', 'Skill 管理', '{"perm":"iqc:skill:view"}', 40, now(3), now(3), 'system', 'system'),
    (900114, 900106, 'MENU', '/iqc/rules/library', 'file-protect', '规则库', '{"perm":"iqc:rule:view"}', 10, now(3), now(3), 'system', 'system'),
    (900115, 900106, 'MENU', '/iqc/rules/composite', 'file-protect', '组合规则', '{"perm":"iqc:rule:view"}', 20, now(3), now(3), 'system', 'system'),
    (900116, 900106, 'MENU', '/iqc/rules/sets', 'file-protect', '规则集', '{"perm":"iqc:rule:view"}', 30, now(3), now(3), 'system', 'system'),
    (900117, 900106, 'MENU', '/iqc/rules/test-center', 'experiment', '测试中心', '{"perm":"iqc:rule:test"}', 40, now(3), now(3), 'system', 'system'),
    (900118, 900106, 'MENU', '/iqc/rules/approvals', 'check', '审批与发布', '{"perm":"iqc:rule:approve"}', 50, now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    parent_id = VALUES(parent_id), type = VALUES(type), href = VALUES(href), icon = VALUES(icon),
    name = VALUES(name), description = VALUES(description), order_num = VALUES(order_num),
    updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_menu (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT 995000 + menu.id, '104', menu.id, now(3), now(3), 'system', 'system'
FROM base_org_menu menu
WHERE menu.id BETWEEN 900101 AND 900118
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
