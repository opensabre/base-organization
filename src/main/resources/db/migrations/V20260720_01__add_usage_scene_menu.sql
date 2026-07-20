USE os_base_organization;
SET NAMES utf8mb4;

INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num, created_time, updated_time, created_by, updated_by)
VALUES (126, 109, 'MENU', '/sysadmin/usage-scenes', 'collection-tag', '计次场景',
        '{"routeName":"UsageScenes","component":"sysadmin/usage-scenes/index","visible":1}',
        68, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE parent_id = VALUES(parent_id), href = VALUES(href), icon = VALUES(icon), name = VALUES(name),
                        description = VALUES(description), order_num = VALUES(order_num), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_menu (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
VALUES (156, 101, 126, now(), now(), 'system', 'system'),
       (157, 103, 126, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
