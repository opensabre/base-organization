-- Automatic retry policy reuses task navigation; no users, new MENU or global ADMIN grants.
-- Registered resource IDs/endpoints are retained; relation keys use the existing 20-character hash.
INSERT INTO base_org_resource
 (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
 ('900233','查看自动重试策略','iqc:task:retry-policy:view','iqc','/api/iqc/tasks/{id}/retry-policy','GET','查看自动重试策略；服务端核验原任务数据范围及原负责人身份','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900234','配置自动重试策略','iqc:task:retry-policy:configure','iqc','/api/iqc/tasks/{id}/retry-policy','PUT','配置自动重试策略；服务端核验原任务数据范围及原负责人身份','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900235','启停自动重试','iqc:task:retry-policy:availability','iqc','/api/iqc/tasks/{id}/retry-policy/availability','POST','启停自动重试；服务端核验原任务数据范围及原负责人身份','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE name=VALUES(name),type=VALUES(type),description=VALUES(description),application=VALUES(application),product_code=VALUES(product_code),source=VALUES(source),status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
SELECT '900233','iqc',tasks.parent_id,'BUTTON',NULL,'schedule','查看自动重试策略','{"perm":"iqc:task:retry-policy:view"}',233,now(3),now(3),'system','system' FROM base_org_menu tasks WHERE tasks.id='900019' AND tasks.product_code='iqc'
UNION ALL
SELECT '900234','iqc',tasks.parent_id,'BUTTON',NULL,'schedule','配置自动重试策略','{"perm":"iqc:task:retry-policy:configure"}',234,now(3),now(3),'system','system' FROM base_org_menu tasks WHERE tasks.id='900019' AND tasks.product_code='iqc'
UNION ALL
SELECT '900235','iqc',tasks.parent_id,'BUTTON',NULL,'schedule','启停自动重试','{"perm":"iqc:task:retry-policy:availability"}',235,now(3),now(3),'system','system' FROM base_org_menu tasks WHERE tasks.id='900019' AND tasks.product_code='iqc'
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),href=VALUES(href),icon=VALUES(icon),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPR',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE'
 AND resource.code IN ('iqc:task:retry-policy:view','iqc:task:retry-policy:configure','iqc:task:retry-policy:availability') AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER','IQC_INSPECTOR')
  OR (role.code='IQC_VIEWER' AND resource.code='iqc:task:retry-policy:view'));

INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPM',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.type='BUTTON' AND menu.id IN ('900233','900234','900235') AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER','IQC_INSPECTOR')
  OR (role.code='IQC_VIEWER' AND menu.id='900233'));
