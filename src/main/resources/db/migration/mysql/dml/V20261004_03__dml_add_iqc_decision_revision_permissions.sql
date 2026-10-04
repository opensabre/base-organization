-- Policy recalculation is separate from detector execution and human review.
INSERT INTO base_org_resource
    (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
    ('900169','重算结果政策','iqc:decision:recalculate','iqc','/api/iqc/conversation-results/{id}/decision-revisions','POST','基于已有事实创建政策重算记录','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
    ('900170','查看政策重算历史','iqc:decision:history:view','iqc','/api/iqc/conversation-results/{id}/decision-revisions','GET','查看独立政策重算记录','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);
INSERT INTO base_org_menu
    (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
VALUES
    ('900165','iqc','900001','BUTTON',NULL,'refresh','重算结果政策','{"perm":"iqc:decision:recalculate"}',108,now(3),now(3),'system','system'),
    ('900166','iqc','900001','BUTTON',NULL,'history','查看政策重算历史','{"perm":"iqc:decision:history:view"}',109,now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),href=VALUES(href),icon=VALUES(icon),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);
INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCDR',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE' AND existing.id IS NULL
AND ((role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER') AND resource.code='iqc:decision:recalculate')
  OR (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER','IQC_INSPECTOR','IQC_VIEWER') AND resource.code='iqc:decision:history:view'));
INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCDB',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE existing.id IS NULL AND ((role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER') AND menu.id='900165')
 OR (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER','IQC_INSPECTOR','IQC_VIEWER') AND menu.id='900166'));
