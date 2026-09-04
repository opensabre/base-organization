SET NAMES utf8mb4;

-- 同一权限码只能对应一个网关 URL。Agent 的多个 POST 操作拆成独立资源，避免注册顺序覆盖创建接口。
INSERT INTO base_org_resource
    (id, name, code, type, url, method, description, application, source, status,
     created_time, updated_time, created_by, updated_by)
VALUES
    (900002, '管理 Agent', 'iqc:agent:manage', 'iqc', '/api/iqc/config/agents', 'POST', '创建 Agent', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900020, '提交 Agent 审批', 'iqc:agent:submit', 'iqc', '/api/iqc/config/agents/{id}/submit', 'POST', '提交 Agent 审批', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900021, '停用 Agent', 'iqc:agent:disable', 'iqc', '/api/iqc/config/agents/{id}/disable', 'POST', '停用已发布 Agent', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900022, '创建 Agent 版本', 'iqc:agent:version:manage', 'iqc', '/api/iqc/config/agents/{id}/versions', 'POST', '创建 Agent 版本', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    (900023, '回滚 Agent 版本', 'iqc:agent:version:rollback', 'iqc', '/api/iqc/config/agents/{id}/versions/{versionNo}/rollback', 'POST', '回滚 Agent 版本', 'iqc-platform', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    name = VALUES(name), url = VALUES(url), method = VALUES(method), description = VALUES(description),
    application = VALUES(application), source = VALUES(source), status = VALUES(status),
    updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_resource (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT 992000 + resource.id, 104, resource.id, now(3), now(3), 'system', 'system'
FROM base_org_resource resource
WHERE resource.id BETWEEN 900020 AND 900023
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
