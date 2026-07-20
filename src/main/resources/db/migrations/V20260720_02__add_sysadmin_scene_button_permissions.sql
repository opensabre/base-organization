USE os_base_organization;
SET NAMES utf8mb4;

-- 与既有管理菜单一致：BUTTON 控制管理台写操作入口，API 权限仍由资源表负责。
INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num, created_time, updated_time, created_by, updated_by)
VALUES
 (170,114,'BUTTON','','','新增验证码场景','{"perm":"sysadmin:captcha-scene:create"}',1,now(),now(),'system','system'),
 (171,114,'BUTTON','','','修改验证码场景','{"perm":"sysadmin:captcha-scene:update"}',2,now(),now(),'system','system'),
 (172,114,'BUTTON','','','删除验证码场景','{"perm":"sysadmin:captcha-scene:delete"}',3,now(),now(),'system','system'),
 (173,115,'BUTTON','','','新增通知场景','{"perm":"sysadmin:notification-scene:create"}',1,now(),now(),'system','system'),
 (174,115,'BUTTON','','','修改通知场景','{"perm":"sysadmin:notification-scene:update"}',2,now(),now(),'system','system'),
 (175,115,'BUTTON','','','删除通知场景','{"perm":"sysadmin:notification-scene:delete"}',3,now(),now(),'system','system'),
 (176,115,'BUTTON','','','新增通知模板','{"perm":"sysadmin:notification-template:create"}',4,now(),now(),'system','system'),
 (177,115,'BUTTON','','','修改通知模板','{"perm":"sysadmin:notification-template:update"}',5,now(),now(),'system','system'),
 (178,115,'BUTTON','','','删除通知模板','{"perm":"sysadmin:notification-template:delete"}',6,now(),now(),'system','system'),
 (179,115,'BUTTON','','','重试通知记录','{"perm":"sysadmin:notification-record:retry"}',7,now(),now(),'system','system'),
 (180,119,'BUTTON','','','新增限次场景','{"perm":"sysadmin:ratelimit-scene:create"}',1,now(),now(),'system','system'),
 (181,119,'BUTTON','','','修改限次场景','{"perm":"sysadmin:ratelimit-scene:update"}',2,now(),now(),'system','system'),
 (182,119,'BUTTON','','','删除限次场景','{"perm":"sysadmin:ratelimit-scene:delete"}',3,now(),now(),'system','system'),
 (183,126,'BUTTON','','','新增计次场景','{"perm":"sysadmin:usage-scene:create"}',1,now(),now(),'system','system'),
 (184,126,'BUTTON','','','修改计次场景','{"perm":"sysadmin:usage-scene:update"}',2,now(),now(),'system','system'),
 (185,126,'BUTTON','','','删除计次场景','{"perm":"sysadmin:usage-scene:delete"}',3,now(),now(),'system','system')
ON DUPLICATE KEY UPDATE name=VALUES(name), description=VALUES(description), order_num=VALUES(order_num), updated_time=VALUES(updated_time), updated_by=VALUES(updated_by);

INSERT INTO base_org_role_menu (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT 100000 + CAST(r.id AS UNSIGNED) * 1000 + m.id, r.id, m.id, now(), now(), 'system', 'system'
FROM base_org_menu m JOIN base_org_role r ON r.id IN (101, 103)
WHERE m.id BETWEEN 170 AND 185
ON DUPLICATE KEY UPDATE updated_time=VALUES(updated_time), updated_by=VALUES(updated_by);
