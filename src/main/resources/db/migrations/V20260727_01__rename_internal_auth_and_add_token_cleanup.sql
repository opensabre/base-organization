USE os_base_organization;
SET NAMES utf8mb4;

-- 统一安全认证术语，并为失效授权记录清理提供独立的按钮与API权限。
UPDATE base_org_menu
SET name = '内部认证',
    updated_time = now(),
    updated_by = 'system'
WHERE id = 220;

INSERT INTO base_org_resource
    (id, name, code, type, url, method, description,
     created_time, updated_time, created_by, updated_by)
VALUES
    (333, '清理已失效OAuth2授权记录', 'auth:authorization:cleanup', 'authorization',
     '/api/auth/authorizations/expired/cleanup', 'DELETE',
     '删除所有Token、授权码和设备码均已过期的服务端授权记录',
     now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE
    name = VALUES(name),
    code = VALUES(code),
    type = VALUES(type),
    url = VALUES(url),
    method = VALUES(method),
    description = VALUES(description),
    updated_time = now(),
    updated_by = 'system';

INSERT INTO base_org_menu
    (id, parent_id, type, href, icon, name, description, order_num,
     created_time, updated_time, created_by, updated_by)
VALUES
    (232, 110, 'BUTTON', '', '', '清理已失效 Token',
     '{"perm":"auth:authorization:cleanup"}',
     2, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE
    parent_id = VALUES(parent_id),
    type = VALUES(type),
    href = VALUES(href),
    icon = VALUES(icon),
    name = VALUES(name),
    description = VALUES(description),
    order_num = VALUES(order_num),
    updated_time = now(),
    updated_by = 'system';

INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT 100000 + role.id * 1000 + resource.id, role.id, resource.id,
       now(), now(), 'system', 'system'
FROM base_org_role role
JOIN base_org_resource resource ON resource.id = 333
WHERE role.id IN (101, 103)
ON DUPLICATE KEY UPDATE
    updated_time = now(),
    updated_by = 'system';

INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT 100000 + role.id * 1000 + menu.id, role.id, menu.id,
       now(), now(), 'system', 'system'
FROM base_org_role role
JOIN base_org_menu menu ON menu.id = 232
WHERE role.id IN (101, 103)
ON DUPLICATE KEY UPDATE
    updated_time = now(),
    updated_by = 'system';
