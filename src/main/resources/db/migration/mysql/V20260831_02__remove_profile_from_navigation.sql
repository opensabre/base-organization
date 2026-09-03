SET NAMES utf8mb4;

-- 个人中心是用户头像下拉中的固定入口，不应作为产品导航菜单。
DELETE FROM base_org_role_menu WHERE menu_id = '980001';
DELETE FROM base_org_menu WHERE id = '980001';
