USE os_base_organization;
SET NAMES utf8mb4;

-- 网关菜单按当前实际页面收敛；不再保留早期占位菜单和旧链接兼容路由。
UPDATE base_org_menu
SET description = '{"routeName":"GatewayDashboard","component":"system/gateway/dashboard/index","visible":1}',
    updated_time = now(),
    updated_by = 'system'
WHERE id = 200;

UPDATE base_org_menu
SET parent_id = 160, order_num = 20, updated_time = now(), updated_by = 'system'
WHERE id = 201;

UPDATE base_org_menu
SET type = 'MENU',
    href = '/gateway/releases',
    name = '发布中心',
    description = '{"routeName":"GatewayReleases","component":"system/gateway/releases/index","visible":1}',
    order_num = 70,
    updated_time = now(),
    updated_by = 'system'
WHERE id = 207;

UPDATE base_org_menu
SET type = 'MENU',
    href = '/gateway/monitoring',
    name = '运行监控',
    description = '{"routeName":"GatewayMonitoring","component":"system/gateway/monitoring/index","visible":1}',
    order_num = 80,
    updated_time = now(),
    updated_by = 'system'
WHERE id = 211;

-- 操作权限归并到可见页面，菜单节点删除后权限能力仍然保留。
UPDATE base_org_menu SET parent_id = 161 WHERE id IN (159, 234, 235);
UPDATE base_org_menu SET parent_id = 162 WHERE id IN (164, 236, 237, 238);

DELETE FROM base_org_role_menu
WHERE menu_id IN (203, 204, 205, 206, 208, 209, 210, 212, 213, 214, 215, 216, 217, 218, 219);

DELETE FROM base_org_menu
WHERE id IN (203, 204, 205, 206, 208, 209, 210, 212, 213, 214, 215, 216, 217, 218, 219);
