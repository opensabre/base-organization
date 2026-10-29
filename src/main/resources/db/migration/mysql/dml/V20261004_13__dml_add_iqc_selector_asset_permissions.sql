-- Selector assets reuse Pipeline navigation. No accounts, global ADMIN grant or application runtime changes.
-- Preserve registered resource IDs and URL/method on code conflicts, following existing IQC permission migrations.
INSERT INTO base_org_resource
 (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
 ('900204','查看选择器目录','iqc:selector:asset:view','iqc','/api/iqc/selectors/assets','GET','查看选择器目录，由IQC服务核验本人/同组/管理员数据范围','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900205','查看选择器详情','iqc:selector:asset:detail:view','iqc','/api/iqc/selectors/assets/{id}','GET','查看选择器详情，由IQC服务核验本人/同组/管理员数据范围','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900206','创建选择器资产','iqc:selector:asset:create','iqc','/api/iqc/selectors/assets','POST','创建选择器资产，由IQC服务核验本人/同组/管理员数据范围','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900207','修订选择器资产','iqc:selector:asset:update','iqc','/api/iqc/selectors/assets/{id}','PUT','修订选择器资产，由IQC服务核验本人/同组/管理员数据范围','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900208','启停选择器资产','iqc:selector:asset:availability','iqc','/api/iqc/selectors/assets/{id}/availability','POST','启停选择器资产，由IQC服务核验本人/同组/管理员数据范围','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900209','查看选择器发布历史','iqc:selector:asset:versions:view','iqc','/api/iqc/selectors/assets/{id}/versions','GET','查看选择器发布历史，由IQC服务核验本人/同组/管理员数据范围','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900210','发布选择器版本','iqc:selector:asset:publish','iqc','/api/iqc/selectors/assets/{id}/publish','POST','发布选择器版本，由IQC服务核验本人/同组/管理员数据范围','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900211','查看精确选择器版本','iqc:selector:asset:version:view','iqc','/api/iqc/selectors/assets/{id}/versions/{versionNo}','GET','查看精确选择器版本，由IQC服务核验本人/同组/管理员数据范围','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900212','预览选择器发布版本','iqc:selector:asset:version:preview','iqc','/api/iqc/selectors/assets/{id}/versions/{versionNo}/preview','POST','预览选择器发布版本，由IQC服务核验本人/同组/管理员数据范围','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE name=VALUES(name),type=VALUES(type),description=VALUES(description),application=VALUES(application),product_code=VALUES(product_code),source=VALUES(source),status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
VALUES
 ('900204','iqc','900160','BUTTON',NULL,'file','查看选择器目录','{"perm":"iqc:selector:asset:view"}',204,now(3),now(3),'system','system'),
 ('900205','iqc','900160','BUTTON',NULL,'file','查看选择器详情','{"perm":"iqc:selector:asset:detail:view"}',205,now(3),now(3),'system','system'),
 ('900206','iqc','900160','BUTTON',NULL,'file','创建选择器资产','{"perm":"iqc:selector:asset:create"}',206,now(3),now(3),'system','system'),
 ('900207','iqc','900160','BUTTON',NULL,'file','修订选择器资产','{"perm":"iqc:selector:asset:update"}',207,now(3),now(3),'system','system'),
 ('900208','iqc','900160','BUTTON',NULL,'file','启停选择器资产','{"perm":"iqc:selector:asset:availability"}',208,now(3),now(3),'system','system'),
 ('900209','iqc','900160','BUTTON',NULL,'file','查看选择器发布历史','{"perm":"iqc:selector:asset:versions:view"}',209,now(3),now(3),'system','system'),
 ('900210','iqc','900160','BUTTON',NULL,'file','发布选择器版本','{"perm":"iqc:selector:asset:publish"}',210,now(3),now(3),'system','system'),
 ('900211','iqc','900160','BUTTON',NULL,'file','查看精确选择器版本','{"perm":"iqc:selector:asset:version:view"}',211,now(3),now(3),'system','system'),
 ('900212','iqc','900160','BUTTON',NULL,'file','预览选择器发布版本','{"perm":"iqc:selector:asset:version:preview"}',212,now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),href=VALUES(href),icon=VALUES(icon),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPR',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE' AND resource.code IN ('iqc:selector:asset:view','iqc:selector:asset:detail:view','iqc:selector:asset:create','iqc:selector:asset:update','iqc:selector:asset:availability','iqc:selector:asset:versions:view','iqc:selector:asset:publish','iqc:selector:asset:version:view','iqc:selector:asset:version:preview') AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER')
  OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND resource.code IN ('iqc:selector:asset:view','iqc:selector:asset:detail:view','iqc:selector:asset:versions:view','iqc:selector:asset:version:view','iqc:selector:asset:version:preview')));

INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPM',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.parent_id='900160' AND menu.type='BUTTON' AND menu.id IN ('900204','900205','900206','900207','900208','900209','900210','900211','900212') AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER')
  OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND menu.id IN ('900204','900205','900209','900211','900212')));
