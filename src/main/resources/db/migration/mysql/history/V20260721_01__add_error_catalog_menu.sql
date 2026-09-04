SET NAMES utf8mb4;

-- 全局错误码目录为只读管理页，授权给系统管理员和开发管理员角色。
INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num, created_time, updated_time, created_by, updated_by)
VALUES (186, 109, 'MENU', '/sysadmin/error-catalog', 'warning', '错误码目录',
        '{"routeName":"ErrorCatalog","component":"sysadmin/error-catalog/index","visible":1}',
        75, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE parent_id = VALUES(parent_id), href = VALUES(href), icon = VALUES(icon), name = VALUES(name),
                        description = VALUES(description), order_num = VALUES(order_num), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_menu (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
VALUES (186, 101, 186, now(), now(), 'system', 'system'),
       (187, 103, 186, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
