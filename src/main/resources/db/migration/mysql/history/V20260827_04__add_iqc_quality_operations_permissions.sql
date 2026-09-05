SET NAMES utf8mb4;

-- 质量运营导航与细粒度操作权限，仅授予 IQC_ADMIN（104）。
INSERT INTO base_org_menu
    (id, parent_id, type, href, icon, name, description, order_num,
     created_time, updated_time, created_by, updated_by)
VALUES
    (900119, 900001, 'MENU', '/iqc/quality-operations', 'audit', '质量运营', '{"perm":"iqc:review:view"}', 45, now(3), now(3), 'system', 'system'),
    (900028, 900119, 'BUTTON', '/iqc/quality-operations/feedback', 'message', '结果反馈权限', '{"perm":"iqc:result:feedback"}', 10, now(3), now(3), 'system', 'system'),
    (900029, 900119, 'BUTTON', '/iqc/quality-operations/reviews', 'audit', '复核查看权限', '{"perm":"iqc:review:view"}', 20, now(3), now(3), 'system', 'system'),
    (900030, 900119, 'BUTTON', '/iqc/quality-operations/reviews/create', 'audit', '发起复核权限', '{"perm":"iqc:review:create"}', 30, now(3), now(3), 'system', 'system'),
    (900031, 900119, 'BUTTON', '/iqc/quality-operations/reviews/decide', 'check', '复核裁决权限', '{"perm":"iqc:review:decide"}', 40, now(3), now(3), 'system', 'system'),
    (900032, 900119, 'BUTTON', '/iqc/quality-operations/samples', 'database', '样本查看权限', '{"perm":"iqc:sample:view"}', 50, now(3), now(3), 'system', 'system'),
    (900033, 900119, 'BUTTON', '/iqc/quality-operations/samples/manage', 'database', '样本管理权限', '{"perm":"iqc:sample:manage"}', 60, now(3), now(3), 'system', 'system'),
    (900034, 900119, 'BUTTON', '/iqc/quality-operations/reports', 'bar-chart', '质检报表权限', '{"perm":"iqc:report:view"}', 70, now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    parent_id = VALUES(parent_id), type = VALUES(type), href = VALUES(href), icon = VALUES(icon),
    name = VALUES(name), description = VALUES(description), order_num = VALUES(order_num),
    updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT CAST(993000 + CAST(menu.id AS DECIMAL(20, 0)) AS CHAR),
       '104', menu.id, now(3), now(3), 'system', 'system'
FROM base_org_menu menu
WHERE menu.id IN ('900119', '900028', '900029', '900030', '900031', '900032', '900033', '900034')
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 资源本身仍由 iqc-platform 的治理注册负责，避免重复维护接口资源。
INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT CAST(993000 + CAST(resource.id AS DECIMAL(20, 0)) AS CHAR),
       '104', resource.id, now(3), now(3), 'system', 'system'
FROM base_org_resource resource
WHERE resource.application = 'iqc-platform'
  AND resource.code IN ('iqc:result:feedback', 'iqc:review:view', 'iqc:review:create', 'iqc:review:decide',
                        'iqc:sample:view', 'iqc:sample:manage', 'iqc:report:view')
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
