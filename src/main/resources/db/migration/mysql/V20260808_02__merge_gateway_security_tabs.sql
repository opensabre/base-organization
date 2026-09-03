SET NAMES utf8mb4;

-- 安全管理改为单页 Tab，原菜单保留为隐藏兼容路由，避免旧链接和权限关系失效。
UPDATE base_org_menu
SET type = 'MENU',
    href = '/gateway/security',
    icon = 'lock',
    name = '安全管理',
    description = '{"routeName":"GatewaySecurity","component":"system/gateway/security/index","visible":1}',
    order_num = 50,
    updated_time = now(),
    updated_by = 'system'
WHERE id = 161;

UPDATE base_org_menu
SET parent_id = 160,
    description = '{"routeName":"GatewayAuthentication","component":"system/gateway/security/index","visible":0}',
    order_num = 51,
    updated_time = now(),
    updated_by = 'system'
WHERE id = 203;

UPDATE base_org_menu
SET parent_id = 160,
    description = '{"routeName":"GatewayAccessLists","component":"system/gateway/security/index","visible":0}',
    order_num = 52,
    updated_time = now(),
    updated_by = 'system'
WHERE id = 204;

-- 已拥有旧认证配置或黑白名单菜单的角色，同时获得新的安全管理入口。
INSERT INTO base_org_role_menu (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT 100000 + role_id * 1000 + 161, role_id, 161, now(), now(), 'system', 'system'
FROM base_org_role_menu
WHERE menu_id IN (203, 204)
GROUP BY role_id
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
