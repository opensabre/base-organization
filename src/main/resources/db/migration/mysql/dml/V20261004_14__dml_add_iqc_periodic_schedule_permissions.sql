-- Periodic schedules reuse existing task navigation and current grants. No users or global ADMIN grants.
-- Preserve already registered resource IDs and URL/method. Role relation IDs are 20 characters.
INSERT INTO base_org_resource
 (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
 ('900214','查看周期调度目录','iqc:schedule:view','iqc','/api/iqc/periodic-schedules','GET','查看周期调度目录，由IQC核验数据范围与当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900215','查看周期调度详情','iqc:schedule:detail:view','iqc','/api/iqc/periodic-schedules/{id}','GET','查看周期调度详情，由IQC核验数据范围与当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900216','创建周期调度','iqc:schedule:create','iqc','/api/iqc/periodic-schedules','POST','创建周期调度，由IQC核验数据范围与当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900217','修订周期调度','iqc:schedule:update','iqc','/api/iqc/periodic-schedules/{id}','PUT','修订周期调度，由IQC核验数据范围与当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900218','发布周期调度','iqc:schedule:publish','iqc','/api/iqc/periodic-schedules/{id}/publish','POST','发布周期调度，由IQC核验数据范围与当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900219','启停周期调度','iqc:schedule:availability','iqc','/api/iqc/periodic-schedules/{id}/availability','POST','启停周期调度，由IQC核验数据范围与当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900220','查看周期调度版本','iqc:schedule:versions:view','iqc','/api/iqc/periodic-schedules/{id}/versions','GET','查看周期调度版本，由IQC核验数据范围与当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900221','查看周期调度实例','iqc:schedule:instances:view','iqc','/api/iqc/periodic-schedules/{id}/instances','GET','查看周期调度实例，由IQC核验数据范围与当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900222','预览周期调度','iqc:schedule:preview','iqc','/api/iqc/periodic-schedules/preview','POST','预览周期调度，由IQC核验数据范围与当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE name=VALUES(name),type=VALUES(type),description=VALUES(description),application=VALUES(application),product_code=VALUES(product_code),source=VALUES(source),status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
SELECT '900213','iqc',tasks.parent_id,'MENU','/tasks/schedules','schedule','周期调度','{"perm":"iqc:schedule:view"}',84,now(3),now(3),'system','system'
FROM base_org_menu tasks
WHERE tasks.id='900019' AND tasks.product_code='iqc'
 AND NOT EXISTS (SELECT 1 FROM base_org_menu present WHERE present.product_code='iqc' AND present.type='MENU' AND present.href='/tasks/schedules')
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),href=VALUES(href),icon=VALUES(icon),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
SELECT '900214','iqc',schedule.id,'BUTTON',NULL,'schedule','查看周期调度目录','{"perm":"iqc:schedule:view"}',214,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
UNION ALL
SELECT '900215','iqc',schedule.id,'BUTTON',NULL,'schedule','查看周期调度详情','{"perm":"iqc:schedule:detail:view"}',215,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
UNION ALL
SELECT '900216','iqc',schedule.id,'BUTTON',NULL,'schedule','创建周期调度','{"perm":"iqc:schedule:create"}',216,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
UNION ALL
SELECT '900217','iqc',schedule.id,'BUTTON',NULL,'schedule','修订周期调度','{"perm":"iqc:schedule:update"}',217,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
UNION ALL
SELECT '900218','iqc',schedule.id,'BUTTON',NULL,'schedule','发布周期调度','{"perm":"iqc:schedule:publish"}',218,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
UNION ALL
SELECT '900219','iqc',schedule.id,'BUTTON',NULL,'schedule','启停周期调度','{"perm":"iqc:schedule:availability"}',219,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
UNION ALL
SELECT '900220','iqc',schedule.id,'BUTTON',NULL,'schedule','查看周期调度版本','{"perm":"iqc:schedule:versions:view"}',220,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
UNION ALL
SELECT '900221','iqc',schedule.id,'BUTTON',NULL,'schedule','查看周期调度实例','{"perm":"iqc:schedule:instances:view"}',221,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
UNION ALL
SELECT '900222','iqc',schedule.id,'BUTTON',NULL,'schedule','预览周期调度','{"perm":"iqc:schedule:preview"}',222,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),href=VALUES(href),icon=VALUES(icon),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPR',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE' AND resource.code IN ('iqc:schedule:view','iqc:schedule:detail:view','iqc:schedule:create','iqc:schedule:update','iqc:schedule:publish','iqc:schedule:availability','iqc:schedule:versions:view','iqc:schedule:instances:view','iqc:schedule:preview') AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER')
  OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND resource.code IN ('iqc:schedule:view','iqc:schedule:detail:view','iqc:schedule:versions:view','iqc:schedule:instances:view','iqc:schedule:preview')));

INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPM',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.type='BUTTON' AND menu.parent_id IN (SELECT id FROM base_org_menu WHERE product_code='iqc' AND type='MENU' AND href='/tasks/schedules') AND menu.id IN ('900214','900215','900216','900217','900218','900219','900220','900221','900222') AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER')
  OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND menu.id IN ('900214','900215','900220','900221','900222')));

INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPM',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.type='MENU' AND menu.href='/tasks/schedules' AND existing.id IS NULL
 AND role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER','IQC_INSPECTOR','IQC_VIEWER');
