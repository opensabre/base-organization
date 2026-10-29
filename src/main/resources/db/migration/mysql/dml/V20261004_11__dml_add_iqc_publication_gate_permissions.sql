-- Reuse Pipeline navigation and existing audit; force publishing is IQC_ADMIN only.
INSERT INTO base_org_resource
 (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
 ('900201','查看流水线发布准入','iqc:pipeline:gate:view','iqc','/api/iqc/pipelines/{id}/publication-gate','GET','查看当前冻结修订的质量与回归准入报告','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900202','管理员例外发布流水线','iqc:pipeline:force:publish','iqc','/api/iqc/pipelines/{id}/force-publish','POST','管理员填写原因后例外发布并保存准入证据','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE name=VALUES(name),type=VALUES(type),description=VALUES(description),application=VALUES(application),product_code=VALUES(product_code),source=VALUES(source),status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
VALUES
 ('900201','iqc','900160','BUTTON',NULL,'file','查看发布准入','{"perm":"iqc:pipeline:gate:view"}',144,now(3),now(3),'system','system'),
 ('900202','iqc','900160','BUTTON',NULL,'file','管理员例外发布','{"perm":"iqc:pipeline:force:publish"}',145,now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),href=VALUES(href),icon=VALUES(icon),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPR',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE'
 AND resource.code IN ('iqc:pipeline:gate:view','iqc:pipeline:force:publish')
 AND existing.id IS NULL
 AND (role.code='IQC_ADMIN' OR (role.code IN ('IQC_QUALITY_MANAGER','IQC_INSPECTOR','IQC_VIEWER') AND resource.code='iqc:pipeline:gate:view'));

INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPM',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.id IN ('900201','900202') AND existing.id IS NULL
 AND (role.code='IQC_ADMIN' OR (role.code IN ('IQC_QUALITY_MANAGER','IQC_INSPECTOR','IQC_VIEWER') AND menu.id='900201'));
