USE os_base_organization;
SET NAMES utf8mb4;

-- 服务目录属于研发资产管理，不作为网关路由配置的一部分。
-- 保留既有菜单 ID、页面路由和角色授权，只纠正菜单归属及排序。
UPDATE base_org_menu
SET parent_id = 117,
    order_num = 30,
    updated_time = now(),
    updated_by = 'system'
WHERE id = 201
  AND href = '/gateway/services';
