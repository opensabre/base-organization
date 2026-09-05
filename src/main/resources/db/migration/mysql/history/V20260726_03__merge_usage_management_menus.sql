SET NAMES utf8mb4;

-- 将计次场景与使用统计收口为一个页面，按钮权限继续挂在菜单 126 下。
UPDATE base_org_menu
SET href = '/sysadmin/usage-management',
    icon = 'collection-tag',
    name = '计次管理',
    description = '{"routeName":"UsageManagement","component":"sysadmin/usage-management/index","visible":1}',
    order_num = 68,
    updated_time = now(),
    updated_by = 'system'
WHERE id = 126;

-- 仅清理历史“使用统计”菜单，避免误删复用同一 ID 的其他菜单。
DELETE role_menu
FROM base_org_role_menu role_menu
JOIN base_org_menu menu ON menu.id = role_menu.menu_id
WHERE menu.id = 122
  AND menu.href = '/sysadmin/usage-statistics';

DELETE FROM base_org_menu
WHERE id = 122
  AND href = '/sysadmin/usage-statistics';
