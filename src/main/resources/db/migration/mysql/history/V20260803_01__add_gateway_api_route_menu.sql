SET NAMES utf8mb4;

-- API 级路由管理独立于历史的显式 Nacos 路由页面，避免两种管理对象混淆。
INSERT INTO base_org_menu
    (id, parent_id, type, href, icon, name, description, order_num,
     created_time, updated_time, created_by, updated_by)
VALUES
    (240, 160, 'MENU', '/gateway/api-routes', 'api', 'API 路由管理',
     '{"routeName":"GatewayApiRoutes","component":"system/gateway/api-routes/index","visible":1}',
     35, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE
    parent_id = VALUES(parent_id),
    type = VALUES(type),
    href = VALUES(href),
    icon = VALUES(icon),
    name = VALUES(name),
    description = VALUES(description),
    order_num = VALUES(order_num),
    updated_time = VALUES(updated_time),
    updated_by = VALUES(updated_by);

INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT 100000 + role.id * 1000 + menu.id, role.id, menu.id,
       now(), now(), 'system', 'system'
FROM base_org_role role
JOIN base_org_menu menu ON menu.id = 240
WHERE role.id IN (101, 103)
ON DUPLICATE KEY UPDATE
    updated_time = VALUES(updated_time),
    updated_by = VALUES(updated_by);
