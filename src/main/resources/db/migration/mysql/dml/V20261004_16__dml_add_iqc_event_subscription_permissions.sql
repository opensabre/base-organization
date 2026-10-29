-- Event subscriptions reuse the existing periodic schedule MENU; no new page, user or global ADMIN grant.
-- Preserve registered resource IDs and endpoints; role relation IDs remain 20 characters.
INSERT INTO base_org_resource
 (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
 ('900224','查看事件订阅目录','iqc:subscription:view','iqc','/api/iqc/event-subscriptions','GET','查看事件订阅目录，由IQC核验数据范围及当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900225','查看事件订阅','iqc:subscription:detail:view','iqc','/api/iqc/event-subscriptions/{id}','GET','查看事件订阅，由IQC核验数据范围及当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900226','创建事件订阅','iqc:subscription:create','iqc','/api/iqc/event-subscriptions','POST','创建事件订阅，由IQC核验数据范围及当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900227','修订事件订阅','iqc:subscription:update','iqc','/api/iqc/event-subscriptions/{id}','PUT','修订事件订阅，由IQC核验数据范围及当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900228','发布事件订阅修订','iqc:subscription:publish','iqc','/api/iqc/event-subscriptions/{id}/publish','POST','发布事件订阅修订，由IQC核验数据范围及当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900229','启停事件订阅','iqc:subscription:availability','iqc','/api/iqc/event-subscriptions/{id}/availability','POST','启停事件订阅，由IQC核验数据范围及当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900230','查看事件订阅历史','iqc:subscription:versions:view','iqc','/api/iqc/event-subscriptions/{id}/versions','GET','查看事件订阅历史，由IQC核验数据范围及当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900231','查看事件订阅实例','iqc:subscription:instances:view','iqc','/api/iqc/event-subscriptions/{id}/instances','GET','查看事件订阅实例，由IQC核验数据范围及当前有效授权','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE name=VALUES(name),type=VALUES(type),description=VALUES(description),application=VALUES(application),product_code=VALUES(product_code),source=VALUES(source),status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
SELECT '900224','iqc',schedule.id,'BUTTON',NULL,'schedule','查看事件订阅目录','{"perm":"iqc:subscription:view"}',224,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
UNION ALL
SELECT '900225','iqc',schedule.id,'BUTTON',NULL,'schedule','查看事件订阅','{"perm":"iqc:subscription:detail:view"}',225,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
UNION ALL
SELECT '900226','iqc',schedule.id,'BUTTON',NULL,'schedule','创建事件订阅','{"perm":"iqc:subscription:create"}',226,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
UNION ALL
SELECT '900227','iqc',schedule.id,'BUTTON',NULL,'schedule','修订事件订阅','{"perm":"iqc:subscription:update"}',227,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
UNION ALL
SELECT '900228','iqc',schedule.id,'BUTTON',NULL,'schedule','发布事件订阅修订','{"perm":"iqc:subscription:publish"}',228,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
UNION ALL
SELECT '900229','iqc',schedule.id,'BUTTON',NULL,'schedule','启停事件订阅','{"perm":"iqc:subscription:availability"}',229,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
UNION ALL
SELECT '900230','iqc',schedule.id,'BUTTON',NULL,'schedule','查看事件订阅历史','{"perm":"iqc:subscription:versions:view"}',230,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
UNION ALL
SELECT '900231','iqc',schedule.id,'BUTTON',NULL,'schedule','查看事件订阅实例','{"perm":"iqc:subscription:instances:view"}',231,now(3),now(3),'system','system' FROM base_org_menu schedule WHERE schedule.product_code='iqc' AND schedule.type='MENU' AND schedule.href='/tasks/schedules'
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),href=VALUES(href),icon=VALUES(icon),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPR',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE' AND resource.code IN ('iqc:subscription:view','iqc:subscription:detail:view','iqc:subscription:create','iqc:subscription:update','iqc:subscription:publish','iqc:subscription:availability','iqc:subscription:versions:view','iqc:subscription:instances:view') AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER')
  OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND resource.code IN ('iqc:subscription:view','iqc:subscription:detail:view','iqc:subscription:versions:view','iqc:subscription:instances:view')));

INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPM',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.type='BUTTON' AND menu.parent_id IN (SELECT id FROM base_org_menu WHERE product_code='iqc' AND type='MENU' AND href='/tasks/schedules') AND menu.id IN ('900224','900225','900226','900227','900228','900229','900230','900231') AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER')
  OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND menu.id IN ('900224','900225','900230','900231')));
