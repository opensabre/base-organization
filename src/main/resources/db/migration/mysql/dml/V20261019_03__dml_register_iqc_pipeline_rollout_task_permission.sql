-- Real POST /pipelines/{id}/rollout/tasks; service also requires original pipeline task creation grant.
INSERT INTO base_org_resource
 (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
 ('900269','按灰度策略创建任务','iqc:pipeline:rollout:task:create','iqc','/api/iqc/pipelines/{id}/rollout/tasks','POST','新请求按保存策略分配并冻结来源；重放保持原任务','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE name=VALUES(name),type=VALUES(type),description=VALUES(description),application=VALUES(application),product_code=VALUES(product_code),source=VALUES(source),status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
SELECT '900269','iqc',pipeline_menu.id,'BUTTON',NULL,'lock','创建灰度任务','{"perm":"iqc:pipeline:rollout:task:create"}',269,now(3),now(3),'system','system'
FROM base_org_menu pipeline_menu WHERE pipeline_menu.id='900160' AND pipeline_menu.product_code='iqc'
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPR',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE'
 AND resource.code='iqc:pipeline:rollout:task:create' AND existing.id IS NULL
 AND role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER','IQC_INSPECTOR');

INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPM',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.type='BUTTON' AND menu.id='900269' AND existing.id IS NULL
 AND role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER','IQC_INSPECTOR');

-- Configuration revisions now supply the explicit rollout task endpoint.
UPDATE base_org_resource
SET description='灰度策略修订供后续新的灰度任务请求使用；原任务保留原分配',updated_time=now(3),updated_by='system'
WHERE application='iqc-platform' AND product_code='iqc'
 AND code IN ('iqc:pipeline:rollout:view','iqc:pipeline:rollout:history:view','iqc:pipeline:rollout:manage');
