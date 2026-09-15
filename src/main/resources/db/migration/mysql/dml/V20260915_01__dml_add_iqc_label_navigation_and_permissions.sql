SET NAMES utf8mb4;

-- 页面入口与按钮权限属于组织服务；不创建线上用户、令牌或 OAuth 客户端。
INSERT INTO base_org_menu
    (id, product_code, parent_id, type, href, icon, name, description, order_num,
     created_time, updated_time, created_by, updated_by)
VALUES
    ('900121', 'iqc', '900001', 'MENU', '/iqc/labels', 'tags', '标签中心', NULL, 35, now(3), now(3), 'system', 'system'),
    ('900122', 'iqc', '900121', 'MENU', '/iqc/labels/tree', 'tags', '标签树', '{"perm":"iqc:label:view"}', 10, now(3), now(3), 'system', 'system'),
    ('900123', 'iqc', '900121', 'MENU', '/iqc/labels/collections', 'book', '标签集合', '{"perm":"iqc:label-collection:view"}', 20, now(3), now(3), 'system', 'system'),
    ('900124', 'iqc', '900121', 'MENU', '/iqc/labels/candidates', 'bulb', '候选标签', '{"perm":"iqc:label-candidate:view"}', 30, now(3), now(3), 'system', 'system'),
    ('900125', 'iqc', '900122', 'BUTTON', '/iqc/labels/manage', 'edit', '标签管理', '{"perm":"iqc:label:manage"}', 10, now(3), now(3), 'system', 'system'),
    ('900126', 'iqc', '900122', 'BUTTON', '/iqc/labels/approve', 'check', '标签发布', '{"perm":"iqc:label:approve"}', 20, now(3), now(3), 'system', 'system'),
    ('900127', 'iqc', '900123', 'BUTTON', '/iqc/labels/collections/manage', 'edit', '标签集合管理', '{"perm":"iqc:label-collection:manage"}', 10, now(3), now(3), 'system', 'system'),
    ('900128', 'iqc', '900124', 'BUTTON', '/iqc/labels/candidates/review', 'check', '候选标签审核', '{"perm":"iqc:label-candidate:review"}', 10, now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    product_code = VALUES(product_code), parent_id = VALUES(parent_id), type = VALUES(type),
    href = VALUES(href), icon = VALUES(icon), name = VALUES(name), description = VALUES(description),
    order_num = VALUES(order_num), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 新环境提供受控资源种子；升级环境按唯一 code 激活已注册资源，保留原有 ID 与端点。
INSERT INTO base_org_resource
    (id, name, code, type, url, method, description, application, product_code, source, status,
     created_time, updated_time, created_by, updated_by)
VALUES
    ('900121', '查看标签树', 'iqc:label:view', 'iqc', '/api/iqc/labels/tree', 'GET', '查询洞察标签树', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900122', '管理标签', 'iqc:label:manage', 'iqc', '/api/iqc/labels', 'POST', '管理洞察标签草稿', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900123', '发布标签', 'iqc:label:approve', 'iqc', '/api/iqc/labels/{id}/publish', 'POST', '发布洞察标签', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900124', '查看标签集合', 'iqc:label-collection:view', 'iqc', '/api/iqc/label-collections', 'GET', '查询标签集合', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900125', '管理标签集合', 'iqc:label-collection:manage', 'iqc', '/api/iqc/label-collections', 'POST', '管理标签集合', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900126', '查看候选标签', 'iqc:label-candidate:view', 'iqc', '/api/iqc/label-candidates', 'GET', '查询 AI 候选标签池', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900127', '审核候选标签', 'iqc:label-candidate:review', 'iqc', '/api/iqc/label-candidates/{id}/approve', 'POST', '审核 AI 候选标签', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    status = VALUES(status), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 只授权既有 IQC 业务角色，不依赖账号 ID，不扩大系统 ADMIN 的产品权限。
-- 管理员、质量主管拥有全部能力；质检员、查看者仅获得三个只读页面。
INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('IQCLM', role.id, '-', menu.id), role.id, menu.id,
       now(3), now(3), 'system', 'system'
FROM base_org_role role
CROSS JOIN base_org_menu menu
WHERE menu.id BETWEEN '900121' AND '900128'
  AND (role.code IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER')
       OR (role.code IN ('IQC_INSPECTOR', 'IQC_VIEWER') AND menu.type = 'MENU'))
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('IQCLR', role.id, '-', menu.id), role.id, resource.id,
       now(3), now(3), 'system', 'system'
FROM base_org_role role
CROSS JOIN base_org_menu menu
JOIN base_org_resource resource ON resource.code = JSON_UNQUOTE(JSON_EXTRACT(menu.description, '$.perm'))
WHERE menu.id BETWEEN '900122' AND '900128'
  AND resource.application = 'iqc-platform' AND resource.product_code = 'iqc'
  AND resource.status = 'ACTIVE'
  AND (role.code IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER')
       OR (role.code IN ('IQC_INSPECTOR', 'IQC_VIEWER') AND menu.type = 'MENU'))
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
