SET NAMES utf8mb4;

-- 每条 URL/method 使用独立资源 code；菜单按钮权限沿用业务动作分组。
-- 升级按 code 激活 PENDING 并保留已注册 ID/URL/method；全新库提供同等资源种子。
INSERT INTO base_org_resource
    (id, name, code, type, url, method, description, application, product_code, source, status,
     created_time, updated_time, created_by, updated_by)
VALUES
    ('900150', '事实查看目录', 'iqc:finding:view', 'iqc', '/api/iqc/findings/catalog', 'GET', '事实查看目录', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900151', '事实查看详情', 'iqc:finding:detail:view', 'iqc', '/api/iqc/findings/catalog/{id}', 'GET', '事实查看详情', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900152', '事实创建草稿', 'iqc:finding:manage', 'iqc', '/api/iqc/findings/catalog', 'POST', '事实创建草稿', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900153', '事实修订草稿', 'iqc:finding:update', 'iqc', '/api/iqc/findings/catalog/{id}', 'PUT', '事实修订草稿', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900154', '事实发布版本', 'iqc:finding:publish', 'iqc', '/api/iqc/findings/catalog/{id}/publish', 'POST', '事实发布版本', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900155', '事实设置可用性', 'iqc:finding:availability', 'iqc', '/api/iqc/findings/catalog/{id}/availability', 'POST', '事实设置可用性', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900156', '事实查看版本', 'iqc:finding:versions:view', 'iqc', '/api/iqc/findings/catalog/{id}/versions', 'GET', '事实查看版本', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900160', '流水线查看目录', 'iqc:pipeline:view', 'iqc', '/api/iqc/pipelines', 'GET', '流水线查看目录', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900161', '流水线查看详情', 'iqc:pipeline:detail:view', 'iqc', '/api/iqc/pipelines/{id}', 'GET', '流水线查看详情', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900162', '流水线创建草稿', 'iqc:pipeline:manage', 'iqc', '/api/iqc/pipelines', 'POST', '流水线创建草稿', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900163', '流水线修订草稿', 'iqc:pipeline:update', 'iqc', '/api/iqc/pipelines/{id}', 'PUT', '流水线修订草稿', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900164', '流水线发布版本', 'iqc:pipeline:publish', 'iqc', '/api/iqc/pipelines/{id}/publish', 'POST', '流水线发布版本', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900165', '流水线设置可用性', 'iqc:pipeline:availability', 'iqc', '/api/iqc/pipelines/{id}/availability', 'POST', '流水线设置可用性', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900166', '流水线查看版本', 'iqc:pipeline:versions:view', 'iqc', '/api/iqc/pipelines/{id}/versions', 'GET', '流水线查看版本', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900167', '试跑流水线', 'iqc:pipeline:execute', 'iqc', '/api/iqc/pipelines/{id}/trial', 'POST', '试跑流水线', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    status = VALUES(status), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 前端页面尚未交付，只登记稳定按钮 ID；NULL href 不生成虚假导航路由。
INSERT INTO base_org_menu
    (id, product_code, parent_id, type, href, icon, name, description, order_num,
     created_time, updated_time, created_by, updated_by)
VALUES
    ('900150', 'iqc', '900001', 'BUTTON', NULL, 'settings', '查看事实目录', '{"perm":"iqc:finding:view"}', 100, now(3), now(3), 'system', 'system'),
    ('900151', 'iqc', '900001', 'BUTTON', NULL, 'settings', '管理事实目录', '{"perm":"iqc:finding:manage"}', 101, now(3), now(3), 'system', 'system'),
    ('900152', 'iqc', '900001', 'BUTTON', NULL, 'settings', '发布事实定义', '{"perm":"iqc:finding:publish"}', 102, now(3), now(3), 'system', 'system'),
    ('900160', 'iqc', '900001', 'BUTTON', NULL, 'settings', '查看流水线', '{"perm":"iqc:pipeline:view"}', 103, now(3), now(3), 'system', 'system'),
    ('900161', 'iqc', '900001', 'BUTTON', NULL, 'settings', '管理流水线', '{"perm":"iqc:pipeline:manage"}', 104, now(3), now(3), 'system', 'system'),
    ('900162', 'iqc', '900001', 'BUTTON', NULL, 'settings', '发布流水线', '{"perm":"iqc:pipeline:publish"}', 105, now(3), now(3), 'system', 'system'),
    ('900163', 'iqc', '900001', 'BUTTON', NULL, 'settings', '试跑流水线', '{"perm":"iqc:pipeline:execute"}', 106, now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    product_code = VALUES(product_code), parent_id = VALUES(parent_id), type = VALUES(type),
    href = VALUES(href), icon = VALUES(icon), name = VALUES(name), description = VALUES(description),
    order_num = VALUES(order_num), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 哈希关联主键固定 20 字符，兼容已注册的 19 位资源/角色 ID；自然键避免重复授权。
INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('IQCPM', LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id), ':', role.id, ':',
                                     CHAR_LENGTH(menu.id), ':', menu.id), 256), 15)),
       role.id, menu.id, now(3), now(3), 'system', 'system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id = role.id AND existing.menu_id = menu.id
WHERE menu.id IN ('900150', '900151', '900152', '900160', '900161', '900162', '900163')
  AND (role.code IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER')
       OR (role.code IN ('IQC_INSPECTOR', 'IQC_VIEWER') AND menu.id IN ('900150', '900160')))
  AND existing.id IS NULL;

INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('IQCPR', LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id), ':', role.id, ':',
                                     CHAR_LENGTH(resource.id), ':', resource.id), 256), 15)),
       role.id, resource.id, now(3), now(3), 'system', 'system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id = role.id AND existing.resource_id = resource.id
WHERE resource.code IN (
    'iqc:finding:view',
    'iqc:finding:detail:view',
    'iqc:finding:manage',
    'iqc:finding:update',
    'iqc:finding:publish',
    'iqc:finding:availability',
    'iqc:finding:versions:view',
    'iqc:pipeline:view',
    'iqc:pipeline:detail:view',
    'iqc:pipeline:manage',
    'iqc:pipeline:update',
    'iqc:pipeline:publish',
    'iqc:pipeline:availability',
    'iqc:pipeline:versions:view',
    'iqc:pipeline:execute'
)
  AND resource.application = 'iqc-platform' AND resource.product_code = 'iqc' AND resource.status = 'ACTIVE'
  AND (role.code IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER')
       OR (role.code IN ('IQC_INSPECTOR', 'IQC_VIEWER') AND resource.code IN
           ('iqc:finding:view', 'iqc:finding:detail:view', 'iqc:finding:versions:view',
            'iqc:pipeline:view', 'iqc:pipeline:detail:view', 'iqc:pipeline:versions:view')))
  AND existing.id IS NULL;
