USE os_base_organization;
SET NAMES utf8mb4;

-- 错误码目录属于开发治理能力，页面路由和既有角色授权保持不变。
UPDATE base_org_menu
SET parent_id = 117,
    order_num = 20,
    updated_time = now(),
    updated_by = 'system'
WHERE id = 186
  AND href = '/sysadmin/error-catalog';
