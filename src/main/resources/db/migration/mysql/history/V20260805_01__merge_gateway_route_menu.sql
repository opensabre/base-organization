SET NAMES utf8mb4;

-- 统一入口：原路由管理并入 API 路由管理的应用级路由页签。
UPDATE base_org_menu
SET href = '/gateway/api-routes',
    name = 'API 路由管理',
    description = '{"routeName":"GatewayApiRoutes","component":"system/gateway/api-routes/index","visible":1}',
    order_num = 30,
    updated_time = now(),
    updated_by = 'system'
WHERE id = 120;

-- 清理后加的重复菜单，保留历史菜单 ID 120 及其既有角色授权关系。
DELETE FROM base_org_role_menu WHERE menu_id = 240;
DELETE FROM base_org_menu WHERE id = 240;
