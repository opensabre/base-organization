SET NAMES utf8mb4;

-- 专家维护/发布与普通模板使用分别授权；复用既有模板菜单和任务执行权限。
INSERT INTO base_org_menu
    (id, product_code, parent_id, type, href, icon, name, description, order_num,
     created_time, updated_time, created_by, updated_by)
VALUES
    ('900131', 'iqc', '900001', 'MENU', '/iqc/schemes', 'book', '业务方案（专家）', '{"perm":"iqc:scheme:manage"}', 65, now(3), now(3), 'system', 'system'),
    ('900132', 'iqc', '900131', 'BUTTON', '/iqc/schemes/publish', 'check', '发布业务模板', '{"perm":"iqc:scheme:publish"}', 10, now(3), now(3), 'system', 'system'),
    ('900133', 'iqc', '900107', 'BUTTON', '/iqc/templates/use', 'play', '使用业务模板', '{"perm":"iqc:scheme:use"}', 10, now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    product_code = VALUES(product_code), parent_id = VALUES(parent_id), type = VALUES(type),
    href = VALUES(href), icon = VALUES(icon), name = VALUES(name), description = VALUES(description),
    order_num = VALUES(order_num), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_resource
    (id, name, code, type, url, method, description, application, product_code, source, status,
     created_time, updated_time, created_by, updated_by)
VALUES
    ('900131', '维护业务方案', 'iqc:scheme:manage', 'iqc', '/api/iqc/schemes', 'GET', '业务方案草稿维护与试跑', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900132', '发布业务方案', 'iqc:scheme:publish', 'iqc', '/api/iqc/schemes/{id}/publish', 'POST', '确认试跑并发布业务模板', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900133', '使用业务模板', 'iqc:scheme:use', 'iqc', '/api/iqc/schemes/{id}/versions/{versionNo}/tasks', 'POST', '按已发布业务模板创建任务', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900134', '查看业务模板', 'iqc:scheme:view', 'iqc', '/api/iqc/schemes/published', 'GET', '查询已发布业务模板', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900135', '创建业务方案', 'iqc:scheme:create', 'iqc', '/api/iqc/schemes', 'POST', '创建业务方案草稿', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900136', '修订业务方案', 'iqc:scheme:update', 'iqc', '/api/iqc/schemes/{id}', 'PUT', '修订业务方案草稿', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900137', '检查业务方案', 'iqc:scheme:preview', 'iqc', '/api/iqc/schemes/{id}/preview', 'POST', '检查草稿结构和依赖', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900138', '试跑业务方案', 'iqc:scheme:trial:create', 'iqc', '/api/iqc/schemes/{id}/trials', 'POST', '创建草稿试跑任务', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900139', '查看方案试跑', 'iqc:scheme:trial:view', 'iqc', '/api/iqc/schemes/{id}/trials', 'GET', '查询最近方案试跑任务', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    status = VALUES(status), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 不创建账号，不授予系统 ADMIN，不向查看者授予执行或专家操作。
INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('IQCSM', role.id, '-', menu.id), role.id, menu.id,
       now(3), now(3), 'system', 'system'
FROM base_org_role role CROSS JOIN base_org_menu menu
WHERE menu.id IN ('900131', '900132', '900133')
  AND (role.code IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER')
       OR (role.code = 'IQC_INSPECTOR' AND menu.id = '900133'))
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('IQCSR', LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id), ':', role.id, ':',
                                    CHAR_LENGTH(resource.id), ':', resource.id), 256), 15)),
       role.id, resource.id,
       now(3), now(3), 'system', 'system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing
       ON existing.role_id = role.id AND existing.resource_id = resource.id
WHERE resource.code IN ('iqc:scheme:manage', 'iqc:scheme:publish', 'iqc:scheme:use', 'iqc:scheme:view',
                       'iqc:scheme:create', 'iqc:scheme:update', 'iqc:scheme:preview', 'iqc:scheme:trial:create', 'iqc:scheme:trial:view')
  AND resource.application = 'iqc-platform' AND resource.product_code = 'iqc' AND resource.status = 'ACTIVE'
  AND (role.code IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER')
       OR (role.code = 'IQC_INSPECTOR' AND resource.code IN ('iqc:scheme:use', 'iqc:scheme:view'))
       OR (role.code = 'IQC_VIEWER' AND resource.code = 'iqc:scheme:view'))
  AND existing.id IS NULL;
