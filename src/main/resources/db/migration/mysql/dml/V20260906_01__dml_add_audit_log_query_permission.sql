SET NAMES utf8mb4;

-- 审计日志菜单已授予 ADMIN 与 IT；补齐网关 RESOURCE_REQUIRED 模式所需的 API 资源。
INSERT INTO base_org_resource
    (id, name, code, type, url, method, description, application, product_code, source, status,
     created_time, updated_time, created_by, updated_by)
VALUES
    (344, '查询审计日志', 'sysadmin:audit-log:query', 'audit',
     '/api/sysadmin/audit/log/conditions', 'POST', '根据条件分页查询审计日志',
     'base-sysadmin', 'opensabre-admin', 'MANUAL', 'ACTIVE',
     now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    type = VALUES(type),
    url = VALUES(url),
    method = VALUES(method),
    description = VALUES(description),
    application = VALUES(application),
    product_code = VALUES(product_code),
    source = VALUES(source),
    status = VALUES(status),
    updated_time = VALUES(updated_time),
    updated_by = VALUES(updated_by);

INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT 100000 + role.id * 1000 + resource.id, role.id, resource.id,
       now(3), now(3), 'system', 'system'
FROM base_org_role role
JOIN base_org_resource resource ON resource.id = 344
WHERE role.id IN (101, 103)
ON DUPLICATE KEY UPDATE
    updated_time = VALUES(updated_time),
    updated_by = VALUES(updated_by);
