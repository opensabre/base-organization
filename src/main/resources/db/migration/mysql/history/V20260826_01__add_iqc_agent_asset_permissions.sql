SET NAMES utf8mb4;

-- IQC 独立前端自行渲染 Agent 子菜单；组织菜单树提供可见性和按钮权限码。
INSERT INTO base_org_menu
    (id, parent_id, type, href, icon, name, description, order_num,
     created_time, updated_time, created_by, updated_by)
VALUES
    (900021, 900001, 'BUTTON', '/iqc/agent-models', 'api', '模型配置查看权限', '{"perm":"iqc:model:view"}', 13, now(3), now(3), 'system', 'system'),
    (900022, 900001, 'BUTTON', '/iqc/agent-models/manage', 'api', '模型配置管理权限', '{"perm":"iqc:model:manage"}', 14, now(3), now(3), 'system', 'system'),
    (900023, 900001, 'BUTTON', '/iqc/agent-models/test', 'experiment', '模型连接测试权限', '{"perm":"iqc:model:test"}', 15, now(3), now(3), 'system', 'system'),
    (900024, 900001, 'BUTTON', '/iqc/agent-mcps', 'deployment-unit', 'MCP 查看权限', '{"perm":"iqc:mcp:view"}', 16, now(3), now(3), 'system', 'system'),
    (900025, 900001, 'BUTTON', '/iqc/agent-mcps/manage', 'deployment-unit', 'MCP 管理权限', '{"perm":"iqc:mcp:manage"}', 17, now(3), now(3), 'system', 'system'),
    (900026, 900001, 'BUTTON', '/iqc/agent-skills', 'tool', 'Skill 查看权限', '{"perm":"iqc:skill:view"}', 18, now(3), now(3), 'system', 'system'),
    (900027, 900001, 'BUTTON', '/iqc/agent-skills/manage', 'tool', 'Skill 管理权限', '{"perm":"iqc:skill:manage"}', 19, now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    parent_id = VALUES(parent_id), type = VALUES(type), href = VALUES(href), icon = VALUES(icon),
    name = VALUES(name), description = VALUES(description), order_num = VALUES(order_num),
    updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 仅授权 IQC_ADMIN 专用角色，不把业务权限扩散到全局 ADMIN 或其他角色。
INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT CAST(994000 + CAST(menu.id AS DECIMAL(20, 0)) AS CHAR),
       '104', menu.id, now(3), now(3), 'system', 'system'
FROM base_org_menu menu
WHERE menu.id BETWEEN '900021' AND '900027'
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 接口资源由 iqc-platform 治理注册产生；菜单迁移只关联现有资源，不复制资源模型。
INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT CAST(994000 + CAST(resource.id AS DECIMAL(20, 0)) AS CHAR),
       '104', resource.id,
       now(3), now(3), 'system', 'system'
FROM base_org_resource resource
WHERE resource.application = 'iqc-platform'
  AND resource.code IN ('iqc:model:view', 'iqc:model:manage', 'iqc:model:test',
                        'iqc:mcp:view', 'iqc:mcp:manage', 'iqc:skill:view', 'iqc:skill:manage')
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
