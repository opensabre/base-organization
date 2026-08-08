USE os_base_organization;
SET NAMES utf8mb4;

INSERT INTO base_org_resource
    (id, name, code, type, url, method, description,
     created_time, updated_time, created_by, updated_by)
VALUES
    (337, '查询网关黑白名单', 'gateway:access-list:read', 'gateway',
     '/api/gateway-admin/policies', 'GET', '查询网关 IP 黑白名单策略',
     now(), now(), 'system', 'system'),
    (338, '修改网关黑白名单', 'gateway:access-list:update', 'gateway',
     '/api/gateway-admin/policies', 'PUT', '保存网关 IP 黑白名单策略草稿',
     now(), now(), 'system', 'system'),
    (339, '发布网关黑白名单', 'gateway:access-list:publish', 'gateway',
     '/api/gateway-admin/releases', 'POST', '校验并发布网关配置版本',
     now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE
    name = VALUES(name), code = VALUES(code), type = VALUES(type),
    url = VALUES(url), method = VALUES(method), description = VALUES(description),
    updated_time = now(), updated_by = 'system';

INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT 100000 + role.id * 1000 + resource.id, role.id, resource.id,
       now(), now(), 'system', 'system'
FROM base_org_role role
JOIN base_org_resource resource ON resource.id IN (337, 338, 339)
WHERE role.id IN (101, 103)
ON DUPLICATE KEY UPDATE updated_time = now(), updated_by = 'system';

INSERT INTO base_org_menu
    (id, parent_id, type, href, icon, name, description, order_num,
     created_time, updated_time, created_by, updated_by)
VALUES
    (234, 204, 'BUTTON', '', '', '修改黑白名单',
     '{"perm":"gateway:access-list:update"}', 1, now(), now(), 'system', 'system'),
    (235, 204, 'BUTTON', '', '', '发布黑白名单',
     '{"perm":"gateway:access-list:publish"}', 2, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE
    parent_id = VALUES(parent_id), type = VALUES(type), href = VALUES(href),
    icon = VALUES(icon), name = VALUES(name), description = VALUES(description),
    order_num = VALUES(order_num), updated_time = now(), updated_by = 'system';

INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT 100000 + role.id * 1000 + menu.id, role.id, menu.id,
       now(), now(), 'system', 'system'
FROM base_org_role role
JOIN base_org_menu menu ON menu.id IN (234, 235)
WHERE role.id IN (101, 103)
ON DUPLICATE KEY UPDATE updated_time = now(), updated_by = 'system';
