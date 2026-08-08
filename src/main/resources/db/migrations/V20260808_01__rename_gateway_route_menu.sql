USE os_base_organization;
SET NAMES utf8mb4;

-- API 级路由与应用级路由已统一到同一入口，菜单使用更准确的总称。
UPDATE base_org_menu
SET name = '路由管理',
    updated_time = now(),
    updated_by = 'system'
WHERE id = 120
  AND href = '/gateway/api-routes';
