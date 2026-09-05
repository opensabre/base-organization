SET NAMES utf8mb4;

-- IQC 独立前端的权限资源。资源注册服务不可用时由版本化迁移兜底，避免业务服务启动顺序影响授权。
INSERT INTO base_org_resource
    (id, name, code, type, url, method, description, application, source, status,
     created_time, updated_time, created_by, updated_by)
VALUES
    (900001, '查看 Agent', 'iqc:agent:view', 'iqc', '/api/iqc/config/agents', 'GET', '查询 Agent', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900002, '管理 Agent', 'iqc:agent:manage', 'iqc', '/api/iqc/config/agents', 'POST', '创建和提交 Agent', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900003, '审批 Agent', 'iqc:agent:approve', 'iqc', '/api/iqc/config/agents/{id}/approve', 'POST', '审批 Agent', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900004, '上传会话', 'iqc:conversation:upload', 'iqc', '/api/iqc/conversations/import', 'POST', '上传并解析 txt 会话', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900005, '查看会话', 'iqc:conversation:view', 'iqc', '/api/iqc/conversations', 'GET', '查询 IQC 会话', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900006, '查看质检总览', 'iqc:dashboard:view', 'iqc', '/api/iqc/dashboard', 'GET', '查询 IQC 总览指标', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900007, '查看 IQC 字典', 'iqc:dictionary:view', 'iqc', '/api/iqc/dictionaries', 'GET', '读取 IQC 字典选项', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900008, '导出质检结果', 'iqc:result:export', 'iqc', '/api/iqc/results/export', 'GET', '导出 IQC 质检结果', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900009, '查看质检结果', 'iqc:result:view', 'iqc', '/api/iqc/results', 'GET', '查询 IQC 质检结果', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900010, '审批规则', 'iqc:rule:approve', 'iqc', '/api/iqc/config/rules/{id}/approve', 'POST', '审批 IQC 规则', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900011, '管理规则', 'iqc:rule:manage', 'iqc', '/api/iqc/config/rules', 'POST', '创建和提交 IQC 规则', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900012, '测试规则', 'iqc:rule:test', 'iqc', '/api/iqc/config/rules/{id}/test', 'POST', '测试 IQC 规则', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900013, '查看规则', 'iqc:rule:view', 'iqc', '/api/iqc/config/rules', 'GET', '查询 IQC 规则', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900014, '查看系统设置', 'iqc:settings:view', 'iqc', '/api/iqc/settings', 'GET', '查询 IQC 系统设置', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900015, '取消质检任务', 'iqc:task:cancel', 'iqc', '/api/iqc/tasks/{id}/cancel', 'POST', '取消 IQC 质检任务', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900016, '创建质检任务', 'iqc:task:create', 'iqc', '/api/iqc/tasks', 'POST', '创建 IQC 质检任务', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900017, '执行质检任务', 'iqc:task:execute', 'iqc', '/api/iqc/tasks/{id}/run', 'POST', '执行 IQC 质检任务', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900018, '查看质检任务', 'iqc:task:view', 'iqc', '/api/iqc/tasks', 'GET', '查询 IQC 质检任务', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900019, '查看质检模板', 'iqc:template:view', 'iqc', '/api/iqc/templates', 'GET', '查询 IQC 内置质检模板', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    name = VALUES(name), type = VALUES(type), url = VALUES(url), method = VALUES(method),
    description = VALUES(description), application = VALUES(application), source = VALUES(source),
    status = VALUES(status), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- IQC 前端权限由菜单树返回，使用隐藏菜单承载权限码，页面菜单仍由 iqc-platform-admin 自己渲染。
INSERT INTO base_org_menu
    (id, parent_id, type, href, icon, name, description, order_num, created_time, updated_time, created_by, updated_by)
VALUES
    (900001, -1, 'MENU', '/iqc', 'dashboard', 'IQC 质检平台', '{"perm":"iqc:dashboard:view"}', 100, now(3), now(3), 'system', 'system'),
    (900002, 900001, 'BUTTON', '/iqc/agents', 'robot', 'Agent 权限', '{"perm":"iqc:agent:view"}', 10, now(3), now(3), 'system', 'system'),
    (900003, 900001, 'BUTTON', '/iqc/agents/manage', 'robot', 'Agent 管理权限', '{"perm":"iqc:agent:manage"}', 11, now(3), now(3), 'system', 'system'),
    (900004, 900001, 'BUTTON', '/iqc/agents/approve', 'robot', 'Agent 审批权限', '{"perm":"iqc:agent:approve"}', 12, now(3), now(3), 'system', 'system'),
    (900005, 900001, 'BUTTON', '/iqc/conversations/upload', 'upload', '会话上传权限', '{"perm":"iqc:conversation:upload"}', 20, now(3), now(3), 'system', 'system'),
    (900006, 900001, 'BUTTON', '/iqc/conversations', 'message', '会话查看权限', '{"perm":"iqc:conversation:view"}', 21, now(3), now(3), 'system', 'system'),
    (900007, 900001, 'BUTTON', '/iqc/dashboard', 'dashboard', '总览权限', '{"perm":"iqc:dashboard:view"}', 30, now(3), now(3), 'system', 'system'),
    (900008, 900001, 'BUTTON', '/iqc/dictionaries', 'book', '字典权限', '{"perm":"iqc:dictionary:view"}', 40, now(3), now(3), 'system', 'system'),
    (900009, 900001, 'BUTTON', '/iqc/results/export', 'download', '结果导出权限', '{"perm":"iqc:result:export"}', 50, now(3), now(3), 'system', 'system'),
    (900010, 900001, 'BUTTON', '/iqc/results', 'file-search', '结果查看权限', '{"perm":"iqc:result:view"}', 51, now(3), now(3), 'system', 'system'),
    (900011, 900001, 'BUTTON', '/iqc/rules/approve', 'check', '规则审批权限', '{"perm":"iqc:rule:approve"}', 60, now(3), now(3), 'system', 'system'),
    (900012, 900001, 'BUTTON', '/iqc/rules/manage', 'edit', '规则管理权限', '{"perm":"iqc:rule:manage"}', 61, now(3), now(3), 'system', 'system'),
    (900013, 900001, 'BUTTON', '/iqc/rules/test', 'experiment', '规则测试权限', '{"perm":"iqc:rule:test"}', 62, now(3), now(3), 'system', 'system'),
    (900014, 900001, 'BUTTON', '/iqc/rules', 'file-protect', '规则查看权限', '{"perm":"iqc:rule:view"}', 63, now(3), now(3), 'system', 'system'),
    (900015, 900001, 'BUTTON', '/iqc/settings', 'setting', '设置权限', '{"perm":"iqc:settings:view"}', 70, now(3), now(3), 'system', 'system'),
    (900016, 900001, 'BUTTON', '/iqc/tasks/cancel', 'close', '任务取消权限', '{"perm":"iqc:task:cancel"}', 80, now(3), now(3), 'system', 'system'),
    (900017, 900001, 'BUTTON', '/iqc/tasks/create', 'plus', '任务创建权限', '{"perm":"iqc:task:create"}', 81, now(3), now(3), 'system', 'system'),
    (900018, 900001, 'BUTTON', '/iqc/tasks/execute', 'play', '任务执行权限', '{"perm":"iqc:task:execute"}', 82, now(3), now(3), 'system', 'system'),
    (900019, 900001, 'BUTTON', '/iqc/tasks', 'schedule', '任务查看权限', '{"perm":"iqc:task:view"}', 83, now(3), now(3), 'system', 'system'),
    (900020, 900001, 'BUTTON', '/iqc/templates', 'book', '模板查看权限', '{"perm":"iqc:template:view"}', 90, now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    parent_id = VALUES(parent_id), type = VALUES(type), href = VALUES(href), icon = VALUES(icon),
    name = VALUES(name), description = VALUES(description), order_num = VALUES(order_num),
    updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_resource (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT 990000 + resource.id, 101, resource.id, now(3), now(3), 'system', 'system'
FROM base_org_resource resource
WHERE resource.id BETWEEN 900001 AND 900019
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_menu (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT 991000 + menu.id, 101, menu.id, now(3), now(3), 'system', 'system'
FROM base_org_menu menu
WHERE menu.id BETWEEN 900001 AND 900020
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
