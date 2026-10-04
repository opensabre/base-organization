-- Creating from a published pipeline is distinct from expert draft trials.
INSERT INTO base_org_resource
    (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
    ('900168','使用已发布流水线创建任务','iqc:pipeline:task:create','iqc','/api/iqc/pipelines/{id}/tasks','POST',
     '固定流水线版本与资产快照创建任务','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);
INSERT INTO base_org_menu
    (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
VALUES
    ('900164','iqc','900001','BUTTON',NULL,'play','使用已发布流水线','{"perm":"iqc:pipeline:task:create"}',107,now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),href=VALUES(href),
    icon=VALUES(icon),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);
INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPP',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),
    role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER','IQC_INSPECTOR') AND resource.code='iqc:pipeline:task:create'
    AND resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE' AND existing.id IS NULL;
INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPB',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),
    role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER','IQC_INSPECTOR') AND menu.id='900164' AND existing.id IS NULL;
