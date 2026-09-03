SET NAMES utf8mb4;

-- BUTTON 菜单只决定管理台操作可见性；API 访问权限仍由 base_org_resource 管理。
-- 当前用户接口属于后端 API 授权资源，与下方 BUTTON 菜单权限分离。
INSERT INTO base_org_resource (id, name, code, type, url, method, description, created_time, updated_time, created_by, updated_by)
VALUES (322, '获取当前登录用户', 'user_manager:current', 'user', '/user/current', 'GET', '获取当前认证用户信息', now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE name = VALUES(name), type = VALUES(type), url = VALUES(url), method = VALUES(method),
                        description = VALUES(description), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_resource (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
VALUES (517, 101, 322, now(), now(), 'system', 'system'),
       (518, 102, 322, now(), now(), 'system', 'system'),
       (519, 103, 322, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE role_id = VALUES(role_id), resource_id = VALUES(resource_id),
                        updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num, created_time, updated_time, created_by, updated_by)
VALUES
 (122, 109, 'MENU', '/sysadmin/configs', 'setting', '系统配置', '{"routeName":"Config","component":"system/config/index","visible":1}', 70, now(), now(), 'system', 'system'),
 (123, 101, 'MENU', '/admin/tenants', 'tenant', '租户管理', '{"routeName":"Tenant","component":"system/tenant/index","visible":1}', 70, now(), now(), 'system', 'system'),
 (130, 102, 'BUTTON', '', '', '新增用户', '{"perm":"sys:user:create"}', 1, now(), now(), 'system', 'system'),
 (131, 102, 'BUTTON', '', '', '修改用户', '{"perm":"sys:user:update"}', 2, now(), now(), 'system', 'system'),
 (132, 102, 'BUTTON', '', '', '删除用户', '{"perm":"sys:user:delete"}', 3, now(), now(), 'system', 'system'),
 (133, 102, 'BUTTON', '', '', '导入用户', '{"perm":"sys:user:import"}', 4, now(), now(), 'system', 'system'),
 (134, 102, 'BUTTON', '', '', '导出用户', '{"perm":"sys:user:export"}', 5, now(), now(), 'system', 'system'),
 (135, 102, 'BUTTON', '', '', '重置用户密码', '{"perm":"sys:user:reset-password"}', 6, now(), now(), 'system', 'system'),
 (136, 103, 'BUTTON', '', '', '新增菜单', '{"perm":"sys:menu:create"}', 1, now(), now(), 'system', 'system'),
 (137, 103, 'BUTTON', '', '', '修改菜单', '{"perm":"sys:menu:update"}', 2, now(), now(), 'system', 'system'),
 (138, 103, 'BUTTON', '', '', '删除菜单', '{"perm":"sys:menu:delete"}', 3, now(), now(), 'system', 'system'),
 (139, 104, 'BUTTON', '', '', '分配角色权限', '{"perm":"sys:role:assign"}', 1, now(), now(), 'system', 'system'),
 (140, 105, 'BUTTON', '', '', '新增组织', '{"perm":"sys:dept:create"}', 1, now(), now(), 'system', 'system'),
 (141, 105, 'BUTTON', '', '', '修改组织', '{"perm":"sys:dept:update"}', 2, now(), now(), 'system', 'system'),
 (142, 105, 'BUTTON', '', '', '删除组织', '{"perm":"sys:dept:delete"}', 3, now(), now(), 'system', 'system'),
 (143, 116, 'BUTTON', '', '', '强制下线', '{"perm":"security:online-user:kickout"}', 1, now(), now(), 'system', 'system'),
 (144, 120, 'BUTTON', '', '', '新增网关路由', '{"perm":"gateway:route:create"}', 1, now(), now(), 'system', 'system'),
 (145, 120, 'BUTTON', '', '', '修改网关路由', '{"perm":"gateway:route:update"}', 2, now(), now(), 'system', 'system'),
 (146, 120, 'BUTTON', '', '', '删除网关路由', '{"perm":"gateway:route:delete"}', 3, now(), now(), 'system', 'system'),
 (147, 121, 'BUTTON', '', '', '创建站内信', '{"perm":"sys:internal-message:create"}', 1, now(), now(), 'system', 'system'),
 (148, 121, 'BUTTON', '', '', '修改站内信', '{"perm":"sys:internal-message:update"}', 2, now(), now(), 'system', 'system'),
 (149, 121, 'BUTTON', '', '', '删除站内信', '{"perm":"sys:internal-message:delete"}', 3, now(), now(), 'system', 'system'),
 (150, 121, 'BUTTON', '', '', '发布站内信', '{"perm":"sys:internal-message:publish"}', 4, now(), now(), 'system', 'system'),
 (151, 121, 'BUTTON', '', '', '撤回站内信', '{"perm":"sys:internal-message:revoke"}', 5, now(), now(), 'system', 'system')
,(152, 122, 'BUTTON', '', '', '新增系统配置', '{"perm":"sys:config:create"}', 1, now(), now(), 'system', 'system')
,(153, 122, 'BUTTON', '', '', '修改系统配置', '{"perm":"sys:config:update"}', 2, now(), now(), 'system', 'system')
,(154, 122, 'BUTTON', '', '', '删除系统配置', '{"perm":"sys:config:delete"}', 3, now(), now(), 'system', 'system')
,(155, 122, 'BUTTON', '', '', '刷新系统配置缓存', '{"perm":"sys:config:refresh"}', 4, now(), now(), 'system', 'system')
,(156, 123, 'BUTTON', '', '', '新增租户', '{"perm":"sys:tenant:create"}', 1, now(), now(), 'system', 'system')
,(157, 123, 'BUTTON', '', '', '修改租户', '{"perm":"sys:tenant:update"}', 2, now(), now(), 'system', 'system')
,(158, 123, 'BUTTON', '', '', '删除租户', '{"perm":"sys:tenant:delete"}', 3, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE parent_id=VALUES(parent_id), type=VALUES(type), name=VALUES(name), description=VALUES(description), order_num=VALUES(order_num), updated_time=VALUES(updated_time), updated_by=VALUES(updated_by);

INSERT INTO base_org_role_menu (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT 100000 + CAST(r.id AS UNSIGNED) * 1000 + m.id, r.id, m.id, now(), now(), 'system', 'system'
FROM base_org_menu m JOIN base_org_role r ON r.id IN (101, 103)
WHERE m.id IN (122, 123) OR m.id BETWEEN 130 AND 158
ON DUPLICATE KEY UPDATE updated_time=VALUES(updated_time), updated_by=VALUES(updated_by);
