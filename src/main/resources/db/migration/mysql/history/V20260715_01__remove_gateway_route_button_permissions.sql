SET NAMES utf8mb4;

-- 网关路由当前是只读页面。移除隐藏按钮子项，避免前端将页面菜单渲染为空子菜单。
DELETE FROM base_org_role_menu WHERE menu_id IN (121, 122, 123, 124);
DELETE FROM base_org_menu WHERE id IN (121, 122, 123, 124);
