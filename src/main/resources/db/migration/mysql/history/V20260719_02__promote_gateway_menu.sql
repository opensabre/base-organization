-- 网关将承载路由、认证方式及后续控制面能力，提升为一级菜单；保留既有路由页面地址与按钮权限。
INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num,
                           created_time, updated_time, created_by, updated_by)
VALUES (160, -1, 'MENU', '/gateway', 'api', '网关',
        '{"routeName":"Gateway","visible":1}', 85, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE parent_id = VALUES(parent_id), href = VALUES(href), icon = VALUES(icon),
                        name = VALUES(name), description = VALUES(description), order_num = VALUES(order_num),
                        updated_time = now(), updated_by = 'system';

UPDATE base_org_menu
SET parent_id = 160, order_num = 10, updated_time = now(), updated_by = 'system'
WHERE id = 120;
