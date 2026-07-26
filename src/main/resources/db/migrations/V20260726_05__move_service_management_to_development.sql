USE os_base_organization;
SET NAMES utf8mb4;

-- 服务目录面向研发人员，保留原页面路由和既有角色授权。
UPDATE base_org_menu
SET parent_id = 117,
    order_num = 30,
    updated_time = now(),
    updated_by = 'system'
WHERE id = 201
  AND href = '/gateway/services';
