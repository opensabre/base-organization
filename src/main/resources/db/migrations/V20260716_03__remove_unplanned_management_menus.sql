USE os_base_organization;
SET NAMES utf8mb4;

-- V20260716_02 错将“系统配置”和“租户管理”作为页面菜单初始化。
-- 122 是既有的“使用统计”菜单；恢复它并清除误加的菜单及其 BUTTON 权限。
DELETE FROM base_org_role_menu
WHERE menu_id IN (123, 152, 153, 154, 155, 156, 157, 158);

DELETE FROM base_org_menu
WHERE id IN (123, 152, 153, 154, 155, 156, 157, 158);

INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num, created_time, updated_time, created_by, updated_by)
VALUES (122, 109, 'MENU', '/sysadmin/usage-statistics', 'histogram', '使用统计',
        '{"routeName":"UsageStatistics","component":"sysadmin/usage-statistics/index","visible":1}',
        70, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE parent_id = VALUES(parent_id), type = VALUES(type), href = VALUES(href),
                        icon = VALUES(icon), name = VALUES(name), description = VALUES(description),
                        order_num = VALUES(order_num), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_menu (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
VALUES (149, 101, 122, now(), now(), 'system', 'system'),
       (150, 103, 122, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE role_id = VALUES(role_id), menu_id = VALUES(menu_id),
                        updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
