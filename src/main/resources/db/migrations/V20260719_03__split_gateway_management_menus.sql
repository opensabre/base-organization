-- 网关控制面拆为认证、全局策略和路由管理三个独立入口；保留既有路由地址。
INSERT INTO base_org_resource (id, name, code, type, url, method, description,
                               created_time, updated_time, created_by, updated_by)
VALUES (324, '发布网关全局策略', 'gateway:filter:update', 'gateway', '/gateway/routes/default-filters', 'PUT',
        '更新并发布网关全局过滤器与限流', now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE name = VALUES(name), code = VALUES(code), url = VALUES(url), method = VALUES(method),
                        description = VALUES(description), updated_time = now(), updated_by = 'system';

INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num,
                           created_time, updated_time, created_by, updated_by)
VALUES (161, 160, 'MENU', '/gateway/authentication', 'lock', '网关认证',
        '{"routeName":"GatewayAuthentication","component":"system/gateway/authentication/index","visible":1}', 10, now(), now(), 'system', 'system'),
       (162, 160, 'MENU', '/gateway/policies', 'setting', '全局策略',
        '{"routeName":"GatewayPolicy","component":"system/gateway/policy/index","visible":1}', 20, now(), now(), 'system', 'system'),
       (164, 162, 'BUTTON', '', '', '发布网关全局策略', '{"perm":"gateway:filter:update"}', 1, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE parent_id = VALUES(parent_id), href = VALUES(href), icon = VALUES(icon), name = VALUES(name),
                        description = VALUES(description), order_num = VALUES(order_num), updated_time = now(), updated_by = 'system';

UPDATE base_org_menu
SET parent_id = 161, name = '网关鉴权', order_num = 1, updated_time = now(), updated_by = 'system'
WHERE id = 159;

UPDATE base_org_menu
SET parent_id = 160, name = '路由管理',
    description = '{"routeName":"GatewayRouteManagement","component":"system/gateway/route/index","visible":1}',
    order_num = 30, updated_time = now(), updated_by = 'system'
WHERE id = 120;

INSERT INTO base_org_role_resource (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
VALUES (522, 101, 324, now(), now(), 'system', 'system'),
       (523, 103, 324, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_menu (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
VALUES (101161, 101, 161, now(), now(), 'system', 'system'),
       (103161, 103, 161, now(), now(), 'system', 'system'),
       (101162, 101, 162, now(), now(), 'system', 'system'),
       (103162, 103, 162, now(), now(), 'system', 'system'),
       (101164, 101, 164, now(), now(), 'system', 'system'),
       (103164, 103, 164, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
