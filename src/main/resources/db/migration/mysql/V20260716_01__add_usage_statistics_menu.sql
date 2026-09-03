SET NAMES utf8mb4;

-- 对象使用量统计页面，提供验证码、通知和限次场景的统一分析入口。
INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num, created_time, updated_time, created_by, updated_by)
VALUES (122, 109, 'MENU', '/sysadmin/usage-statistics', 'histogram', '使用统计', '{"routeName":"UsageStatistics","component":"sysadmin/usage-statistics/index","visible":1}', 70, now(), now(), 'system', 'system')
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
VALUES (149, 101, 122, now(), now(), 'system', 'system'),
       (150, 103, 122, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE role_id = VALUES(role_id),
                        menu_id = VALUES(menu_id),
                        updated_time = VALUES(updated_time),
                        updated_by = VALUES(updated_by);
