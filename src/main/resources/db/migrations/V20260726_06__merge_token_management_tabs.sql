USE os_base_organization;
SET NAMES utf8mb4;

-- 客户端与 OAuth2 授权记录共享一个页面入口，终止授权权限继续由按钮菜单控制。
UPDATE base_org_menu
SET description = '{"routeName":"OAuthClientManagement","component":"auth/client-management/index","visible":1}',
    updated_time = now(),
    updated_by = 'system'
WHERE id = 110;

INSERT INTO base_org_menu
    (id, parent_id, type, href, icon, name, description, order_num,
     created_time, updated_time, created_by, updated_by)
VALUES
    (220, 108, 'MENU', '/auth/internal-token-keys', 'key', '内部 Token 管理',
     '{"routeName":"InternalTokenKeys","component":"sysadmin/internal-token-keys/index","visible":1}',
     30, now(), now(), 'system', 'system'),
    (221, 220, 'BUTTON', '', '', '轮换内部 Token 密钥',
     '{"perm":"sysadmin:internal-token-key:rotate"}',
     1, now(), now(), 'system', 'system'),
    (222, 220, 'BUTTON', '', '', '退役 previous 密钥',
     '{"perm":"sysadmin:internal-token-key:retire"}',
     2, now(), now(), 'system', 'system'),
    (231, 110, 'BUTTON', '', '', '终止 OAuth2 服务端授权',
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
SELECT 100000 + role.id * 1000 + menu.id, role.id, menu.id,
       now(), now(), 'system', 'system'
FROM base_org_role role
JOIN base_org_menu menu ON menu.id IN (220, 221, 222, 231)
WHERE role.id IN (101, 103)
ON DUPLICATE KEY UPDATE
    updated_time = now(),
    updated_by = 'system';

-- 删除独立 Token 管理入口；API 资源与角色资源授权保持不变。
DELETE FROM base_org_role_menu WHERE menu_id = 230;
DELETE FROM base_org_menu WHERE id = 230;
