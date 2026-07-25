USE os_base_organization;
SET NAMES utf8mb4;

INSERT INTO base_org_menu
    (id, parent_id, type, href, icon, name, description, order_num,
     created_time, updated_time, created_by, updated_by)
VALUES
    (220, 108, 'MENU', '/auth/authorization', 'key', 'Token管理',
     '{"routeName":"OAuthAuthorization","component":"auth/authorization/index","visible":1}',
     20, now(), now(), 'system', 'system'),
    (221, 220, 'BUTTON', '', '', '撤销OAuth2授权',
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
    (101220, 101, 220, now(), now(), 'system', 'system'),
    (103220, 103, 220, now(), now(), 'system', 'system'),
    (101221, 101, 221, now(), now(), 'system', 'system'),
    (103221, 103, 221, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE
    updated_time = now(),
    updated_by = 'system';
