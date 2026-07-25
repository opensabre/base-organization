USE os_base_organization;
SET NAMES utf8mb4;

-- API资源保护实际访问，菜单和按钮仅控制管理台可见性。
INSERT INTO base_org_resource
    (id, name, code, type, url, method, description,
     created_time, updated_time, created_by, updated_by)
VALUES
    (330, '查询OAuth2授权记录', 'auth:authorization:query', 'authorization',
     '/api/auth/authorizations/conditions', 'POST', '分页查询OAuth2服务端授权记录',
     now(), now(), 'system', 'system'),
    (331, '查看OAuth2授权记录', 'auth:authorization:view', 'authorization',
     '/api/auth/authorizations/{id}', 'GET', '查看OAuth2服务端授权详情',
     now(), now(), 'system', 'system'),
    (332, '终止OAuth2服务端授权', 'auth:authorization:revoke', 'authorization',
     '/api/auth/authorizations/{id}', 'DELETE', '删除服务端授权并阻止Refresh Token继续使用',
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

INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT 100000 + r.id * 1000 + resource.id, r.id, resource.id,
       now(), now(), 'system', 'system'
FROM base_org_resource resource
JOIN base_org_role r ON r.id IN (101, 103)
WHERE resource.id IN (330, 331, 332)
ON DUPLICATE KEY UPDATE
    updated_time = now(),
    updated_by = 'system';

INSERT INTO base_org_menu
    (id, parent_id, type, href, icon, name, description, order_num,
     created_time, updated_time, created_by, updated_by)
VALUES
    (230, 108, 'MENU', '/auth/authorization', 'key', 'Token管理',
     '{"routeName":"OAuthAuthorization","component":"auth/authorization/index","visible":1}',
     20, now(), now(), 'system', 'system'),
    (231, 230, 'BUTTON', '', '', '终止OAuth2服务端授权',
     '{"perm":"auth:authorization:revoke"}',
     1, now(), now(), 'system', 'system')
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

INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
VALUES
    (201230, 101, 230, now(), now(), 'system', 'system'),
    (203230, 103, 230, now(), now(), 'system', 'system'),
    (201231, 101, 231, now(), now(), 'system', 'system'),
    (203231, 103, 231, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE
    updated_time = now(),
    updated_by = 'system';
