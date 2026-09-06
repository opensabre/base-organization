SET NAMES utf8mb4;

-- DLS 导入必须使用独立资源，避免 iqc:rule:manage 的单一资源记录被其他规则接口覆盖。
INSERT INTO base_org_resource
    (id, name, code, type, url, method, description, application, product_code, source, status,
     created_time, updated_time, created_by, updated_by)
VALUES
    (900120, '导入 DLS 规则', 'iqc:rule:import', 'iqc',
     '/api/iqc/config/rules/import-dls', 'POST', '预检并导入 DLS Excel 规则库',
     'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE',
     now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    name = VALUES(name), type = VALUES(type), url = VALUES(url), method = VALUES(method),
    description = VALUES(description), application = VALUES(application),
    product_code = VALUES(product_code), source = VALUES(source), status = VALUES(status),
    updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- IQC 前端从菜单树提取按钮权限码。
INSERT INTO base_org_menu
    (id, product_code, parent_id, type, href, icon, name, description, order_num,
     created_time, updated_time, created_by, updated_by)
VALUES
    (900120, 'iqc', 900001, 'BUTTON', '/iqc/rules/import-dls', 'upload',
     'DLS 导入权限', '{"perm":"iqc:rule:import"}', 64,
     now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    product_code = VALUES(product_code), parent_id = VALUES(parent_id), type = VALUES(type),
    href = VALUES(href), icon = VALUES(icon), name = VALUES(name), description = VALUES(description),
    order_num = VALUES(order_num), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 保持现有行为：已拥有规则管理权限的角色自动获得 DLS 导入 API 与按钮权限。
INSERT INTO base_org_role_resource
    (id, resource_id, role_id, created_time, updated_time, created_by, updated_by)
SELECT DISTINCT CONCAT('IQCIMP-R-', grants.role_id), target.id, grants.role_id,
       now(3), now(3), 'system', 'system'
FROM base_org_role_resource grants
JOIN base_org_resource managed ON managed.id = grants.resource_id
JOIN base_org_resource target ON target.code = 'iqc:rule:import'
WHERE managed.code = 'iqc:rule:manage'
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_menu
    (id, menu_id, role_id, created_time, updated_time, created_by, updated_by)
SELECT DISTINCT CONCAT('IQCIMP-M-', grants.role_id), target.id, grants.role_id,
       now(3), now(3), 'system', 'system'
FROM base_org_role_resource grants
JOIN base_org_resource managed ON managed.id = grants.resource_id
JOIN base_org_menu target ON target.id = 900120
WHERE managed.code = 'iqc:rule:manage'
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
