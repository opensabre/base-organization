SET NAMES utf8mb4;

INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num, created_time, updated_time, created_by, updated_by)
VALUES (117, -1, 'MENU', '/development', 'code', '研发管理', '研发工具与接口文档', 90, now(), now(), 'system', 'system'),
       (118, 117, 'MENU', '/development/api-docs', 'document', 'API文档', '{"iframeUrl":"/doc.html","visible":1}', 10, now(), now(), 'system', 'system')
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
VALUES (135, 101, 117, now(), now(), 'system', 'system'),
       (136, 101, 118, now(), now(), 'system', 'system'),
       (137, 103, 117, now(), now(), 'system', 'system'),
       (138, 103, 118, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE role_id = VALUES(role_id),
                        menu_id = VALUES(menu_id),
                        updated_time = VALUES(updated_time),
                        updated_by = VALUES(updated_by);
