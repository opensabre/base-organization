USE os_base_organization;
SET NAMES utf8mb4;

INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num, created_time, updated_time, created_by, updated_by)
VALUES (119, 109, 'MENU', '/sysadmin/ratelimit-scenes', 'timer', '限次场景', '{"routeName":"RateLimitScenes","component":"sysadmin/ratelimit-scenes/index","visible":1}', 55, now(), now(), 'system', 'system')
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
VALUES (139, 101, 119, now(), now(), 'system', 'system'),
       (140, 103, 119, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE role_id = VALUES(role_id),
                        menu_id = VALUES(menu_id),
                        updated_time = VALUES(updated_time),
                        updated_by = VALUES(updated_by);
