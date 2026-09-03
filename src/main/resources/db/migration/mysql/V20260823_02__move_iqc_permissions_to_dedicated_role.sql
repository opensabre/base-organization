SET NAMES utf8mb4;

-- IQC 使用独立角色，不依赖 ADMIN 的全局权限。
INSERT INTO base_org_role
    (id, code, name, description, created_time, updated_time, created_by, updated_by)
VALUES
    (104, 'IQC_ADMIN', 'IQC 管理员', 'IQC 质检平台业务管理员', now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    name = VALUES(name), description = VALUES(description), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 将已部署的 IQC API 资源和菜单授权迁移到 IQC_ADMIN。
INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT 992000 + resource.id, 104, resource.id, now(3), now(3), 'system', 'system'
FROM base_org_resource resource
WHERE resource.id BETWEEN 900001 AND 900019
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT 993000 + menu.id, 104, menu.id, now(3), now(3), 'system', 'system'
FROM base_org_menu menu
WHERE menu.id BETWEEN 900001 AND 900020
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 当前部署验证账号加入专用角色；后续账号应通过组织管理页面分配 IQC_ADMIN。
INSERT INTO base_org_user_role
    (id, user_id, role_id, created_time, updated_time, created_by, updated_by)
VALUES
    (104, 102, 104, now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 清理临时验证阶段挂在 ADMIN 上的 IQC 授权，避免角色边界失真。
DELETE rr
FROM base_org_role_resource rr
JOIN base_org_resource resource ON resource.id = rr.resource_id
WHERE rr.role_id = 101 AND resource.id BETWEEN 900001 AND 900019;

DELETE rm
FROM base_org_role_menu rm
JOIN base_org_menu menu ON menu.id = rm.menu_id
WHERE rm.role_id = 101 AND menu.id BETWEEN 900001 AND 900020;
