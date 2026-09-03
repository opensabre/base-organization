SET NAMES utf8mb4;

-- 网关路由由 Nacos 配置中心管理；当前版本仅提供只读展示页面。
INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num, created_time, updated_time, created_by, updated_by)
VALUES (120, 109, 'MENU', '/sysadmin/gateway-routes', 'api', '网关路由', '{"routeName":"GatewayRoute","component":"system/gateway-route/index","visible":1}', 60, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE parent_id = VALUES(parent_id),
                        type = VALUES(type),
                        href = VALUES(href),
                        icon = VALUES(icon),
                        name = VALUES(name),
                        description = VALUES(description),
                        order_num = VALUES(order_num),
                        updated_time = VALUES(updated_time),
                        updated_by = VALUES(updated_by);

INSERT INTO base_org_role_menu (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
VALUES (141, 101, 120, now(), now(), 'system', 'system'),
       (146, 103, 120, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE role_id = VALUES(role_id),
                        menu_id = VALUES(menu_id),
                        updated_time = VALUES(updated_time),
                        updated_by = VALUES(updated_by);
