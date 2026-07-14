USE os_base_organization;
SET NAMES utf8mb4;

-- 网关路由由 Nacos 配置中心管理；按钮菜单同时作为前端操作权限标识。
INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num, created_time, updated_time, created_by, updated_by)
VALUES (120, 109, 'MENU', '/sysadmin/gateway-routes', 'api', '网关路由', '{"routeName":"GatewayRoute","component":"system/gateway-route/index","visible":1}', 60, now(), now(), 'system', 'system'),
       (121, 120, 'BUTTON', 'gateway:route:query', '', '查询网关路由', '查询配置中心中的网关路由', 10, now(), now(), 'system', 'system'),
       (122, 120, 'BUTTON', 'gateway:route:create', '', '新增网关路由', '发布新增网关路由到配置中心', 20, now(), now(), 'system', 'system'),
       (123, 120, 'BUTTON', 'gateway:route:update', '', '编辑网关路由', '发布修改后的网关路由到配置中心', 30, now(), now(), 'system', 'system'),
       (124, 120, 'BUTTON', 'gateway:route:delete', '', '删除网关路由', '从配置中心删除网关路由', 40, now(), now(), 'system', 'system')
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
       (142, 101, 121, now(), now(), 'system', 'system'),
       (143, 101, 122, now(), now(), 'system', 'system'),
       (144, 101, 123, now(), now(), 'system', 'system'),
       (145, 101, 124, now(), now(), 'system', 'system'),
       (146, 103, 120, now(), now(), 'system', 'system'),
       (147, 103, 121, now(), now(), 'system', 'system'),
       (148, 103, 122, now(), now(), 'system', 'system'),
       (149, 103, 123, now(), now(), 'system', 'system'),
       (150, 103, 124, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE role_id = VALUES(role_id),
                        menu_id = VALUES(menu_id),
                        updated_time = VALUES(updated_time),
                        updated_by = VALUES(updated_by);
