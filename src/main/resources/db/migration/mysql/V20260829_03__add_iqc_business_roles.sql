SET NAMES utf8mb4;

-- IQC 岗位角色：管理员（104）已由前序迁移创建；这里补充质量主管、质检员和只读查看者。
INSERT INTO base_org_role
    (id, code, name, description, created_time, updated_time, created_by, updated_by)
VALUES
    ('105', 'IQC_QUALITY_MANAGER', 'IQC 质量主管', '负责质检标准、规则审批、复核和质量报表', now(3), now(3), 'system', 'system'),
    ('106', 'IQC_INSPECTOR', 'IQC 质检员', '负责会话导入、任务执行和质检结果处理', now(3), now(3), 'system', 'system'),
    ('107', 'IQC_VIEWER', 'IQC 查看者', '只读查看 IQC 会话、任务、结果和质量数据', now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    name = VALUES(name), description = VALUES(description), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 页面菜单权限。IQC 前端根据菜单树和菜单上的 perm 控制页面/操作显示。
-- 质量主管：查看全链路数据，管理和审批规则，并负责复核、样本和报表。
INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('IQC105M', menu.id), '105', menu.id, now(3), now(3), 'system', 'system'
FROM base_org_menu menu
WHERE menu.id IN (
    '900001', '900101', '900102', '900103', '900104', '900105', '900106', '900107', '900110',
    '900111', '900112', '900113', '900114', '900115', '900116', '900117', '900118', '900119',
    '900028', '900029', '900030', '900031', '900032', '900033', '900034'
)
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 质检员：可以导入会话、创建/执行任务和处理结果，不授予规则审批、模型及系统设置权限。
INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('IQC106M', menu.id), '106', menu.id, now(3), now(3), 'system', 'system'
FROM base_org_menu menu
WHERE menu.id IN (
    '900001', '900101', '900102', '900103', '900104', '900107', '900110',
    '900019', '900005', '900006', '900007', '900009', '900010', '900016', '900017', '900018',
    '900028', '900029', '900032'
)
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 查看者：仅保留查询型页面和报表，不授予导入、创建、执行、反馈或管理权限。
INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('IQC107M', menu.id), '107', menu.id, now(3), now(3), 'system', 'system'
FROM base_org_menu menu
WHERE menu.id IN (
    '900001', '900101', '900102', '900103', '900104', '900119',
    '900006', '900007', '900010', '900014', '900019', '900029', '900032', '900034'
)
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 接口资源权限按 code 绑定，避免依赖资源注册时生成的自增/迁移 ID。
-- 质量主管权限。
INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('105', RIGHT(resource.id, 16)), '105', resource.id, now(3), now(3), 'system', 'system'
FROM base_org_resource resource
WHERE resource.application = 'iqc-platform'
  AND resource.code IN (
      'iqc:agent:view', 'iqc:conversation:view', 'iqc:dashboard:view', 'iqc:dictionary:view',
      'iqc:result:export', 'iqc:result:view', 'iqc:rule:approve', 'iqc:rule:manage',
      'iqc:rule:test', 'iqc:rule:view', 'iqc:task:cancel', 'iqc:task:create',
      'iqc:task:execute', 'iqc:task:view', 'iqc:template:view', 'iqc:result:feedback',
      'iqc:review:view', 'iqc:review:create', 'iqc:review:decide', 'iqc:sample:view',
      'iqc:sample:manage', 'iqc:report:view'
  )
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 质检员权限。
INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('106', RIGHT(resource.id, 16)), '106', resource.id, now(3), now(3), 'system', 'system'
FROM base_org_resource resource
WHERE resource.application = 'iqc-platform'
  AND resource.code IN (
      'iqc:conversation:upload', 'iqc:conversation:view', 'iqc:dashboard:view',
      'iqc:dictionary:view', 'iqc:result:export', 'iqc:result:view', 'iqc:task:create',
      'iqc:task:execute', 'iqc:task:view', 'iqc:template:view', 'iqc:result:feedback',
      'iqc:review:view', 'iqc:sample:view'
  )
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 查看者权限。
INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('107', RIGHT(resource.id, 16)), '107', resource.id, now(3), now(3), 'system', 'system'
FROM base_org_resource resource
WHERE resource.application = 'iqc-platform'
  AND resource.code IN (
      'iqc:conversation:view', 'iqc:dashboard:view', 'iqc:dictionary:view',
      'iqc:result:view', 'iqc:rule:view', 'iqc:task:view', 'iqc:template:view',
      'iqc:review:view', 'iqc:sample:view', 'iqc:report:view'
  )
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
