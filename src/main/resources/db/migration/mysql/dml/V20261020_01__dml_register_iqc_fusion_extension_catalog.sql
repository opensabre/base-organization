-- Read-only deployment-installed pure Fusion strategies; no arbitrary client implementation registration.
INSERT INTO base_org_resource
 (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
 ('900270','查看融合扩展目录','iqc:pipeline:fusion:strategy:view','iqc','/api/iqc/pipelines/fusion-strategies','GET','读取已安装扩展的精确版本、实现摘要与默认参数，不执行融合','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE name=VALUES(name),type=VALUES(type),description=VALUES(description),application=VALUES(application),product_code=VALUES(product_code),source=VALUES(source),status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
SELECT '900270','iqc',pipeline_menu.id,'BUTTON',NULL,'lock','融合扩展目录','{"perm":"iqc:pipeline:fusion:strategy:view"}',270,now(3),now(3),'system','system'
FROM base_org_menu pipeline_menu WHERE pipeline_menu.id='900160' AND pipeline_menu.product_code='iqc'
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPR',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE'
 AND resource.code='iqc:pipeline:fusion:strategy:view' AND existing.id IS NULL
 AND role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER','IQC_INSPECTOR','IQC_VIEWER');

INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPM',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.type='BUTTON' AND menu.id='900270' AND existing.id IS NULL
 AND role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER','IQC_INSPECTOR','IQC_VIEWER');

