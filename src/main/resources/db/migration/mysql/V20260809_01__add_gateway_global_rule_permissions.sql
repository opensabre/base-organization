SET NAMES utf8mb4;

INSERT INTO base_org_resource
    (id, name, code, type, url, method, description,
     created_time, updated_time, created_by, updated_by)
VALUES
    (340, '查询网关全局规则', 'gateway:global-rule:read', 'gateway',
     '/api/gateway-admin/policies', 'GET', '查询网关全局安全响应头和跨域规则', now(), now(), 'system', 'system'),
    (341, '修改网关全局过滤器', 'gateway:global-rule:update', 'gateway',
     '/api/gateway-admin/policies', 'PUT', '保存网关 default-filters 草稿', now(), now(), 'system', 'system'),
    (342, '修改网关跨域规则', 'gateway:cors:update', 'gateway',
     '/api/gateway-admin/policies', 'PUT', '保存网关全局跨域规则草稿', now(), now(), 'system', 'system'),
    (343, '发布网关全局规则', 'gateway:global-rule:publish', 'gateway',
     '/api/gateway-admin/releases', 'POST', '预检并发布网关全局规则', now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE
    name = VALUES(name), code = VALUES(code), type = VALUES(type), url = VALUES(url),
    method = VALUES(method), description = VALUES(description), updated_time = now(), updated_by = 'system';

INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT 100000 + role.id * 1000 + resource.id, role.id, resource.id,
       now(), now(), 'system', 'system'
FROM base_org_role role
JOIN base_org_resource resource ON resource.id IN (340, 341, 342, 343)
WHERE role.id IN (101, 103)
ON DUPLICATE KEY UPDATE updated_time = now(), updated_by = 'system';

INSERT INTO base_org_menu
    (id, parent_id, type, href, icon, name, description, order_num,
     created_time, updated_time, created_by, updated_by)
VALUES
    (164, 205, 'BUTTON', '', '', '修改全局过滤器',
     '{"perm":"gateway:global-rule:update"}', 1, now(), now(), 'system', 'system'),
    (236, 205, 'BUTTON', '', '', '发布全局规则',
     '{"perm":"gateway:global-rule:publish"}', 2, now(), now(), 'system', 'system'),
    (237, 206, 'BUTTON', '', '', '修改跨域规则',
     '{"perm":"gateway:cors:update"}', 1, now(), now(), 'system', 'system'),
    (238, 206, 'BUTTON', '', '', '发布跨域规则',
     '{"perm":"gateway:global-rule:publish"}', 2, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE
    parent_id = VALUES(parent_id), type = VALUES(type), href = VALUES(href), icon = VALUES(icon),
    name = VALUES(name), description = VALUES(description), order_num = VALUES(order_num),
    updated_time = now(), updated_by = 'system';

INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT 100000 + role.id * 1000 + menu.id, role.id, menu.id,
       now(), now(), 'system', 'system'
FROM base_org_role role
JOIN base_org_menu menu ON menu.id IN (164, 236, 237, 238)
WHERE role.id IN (101, 103)
  AND NOT EXISTS (
      SELECT 1 FROM base_org_role_menu existing
      WHERE existing.role_id = role.id AND existing.menu_id = menu.id
  )
ON DUPLICATE KEY UPDATE updated_time = now(), updated_by = 'system';

DELETE duplicate
FROM base_org_role_menu duplicate
JOIN base_org_role_menu keeper
  ON keeper.role_id = duplicate.role_id
 AND keeper.menu_id = duplicate.menu_id
 AND keeper.id < duplicate.id
WHERE duplicate.role_id IN (101, 103)
  AND duplicate.menu_id IN (164, 236, 237, 238);
