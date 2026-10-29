-- Model gateway call diagnostics reuse IQC navigation; only IQC_ADMIN receives this global diagnostic permission.
-- Registered resource IDs/endpoints are retained; relation keys use the existing 20-character hash.
INSERT INTO base_org_resource
 (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
 ('900237','查看模型容量','iqc:model-gateway:capacity:view','iqc','/api/iqc/model-gateway/capacity/{modelKey}','GET','质检管理员管理模型容量及核对恢复','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900238','配置模型容量','iqc:model-gateway:capacity:configure','iqc','/api/iqc/model-gateway/capacity/{modelKey}','PUT','质检管理员管理模型容量及核对恢复','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900239','恢复模型并发占用','iqc:model-gateway:calls:release','iqc','/api/iqc/model-gateway/calls/{callId}/capacity-release','POST','质检管理员管理模型容量及核对恢复','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE name=VALUES(name),type=VALUES(type),description=VALUES(description),application=VALUES(application),product_code=VALUES(product_code),source=VALUES(source),status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
SELECT '900237','iqc',tasks.parent_id,'BUTTON',NULL,'schedule','查看模型容量','{"perm":"iqc:model-gateway:capacity:view"}',237,now(3),now(3),'system','system' FROM base_org_menu tasks WHERE tasks.id='900019' AND tasks.product_code='iqc'
UNION ALL
SELECT '900238','iqc',tasks.parent_id,'BUTTON',NULL,'schedule','配置模型容量','{"perm":"iqc:model-gateway:capacity:configure"}',238,now(3),now(3),'system','system' FROM base_org_menu tasks WHERE tasks.id='900019' AND tasks.product_code='iqc'
UNION ALL
SELECT '900239','iqc',tasks.parent_id,'BUTTON',NULL,'schedule','恢复模型并发占用','{"perm":"iqc:model-gateway:calls:release"}',239,now(3),now(3),'system','system' FROM base_org_menu tasks WHERE tasks.id='900019' AND tasks.product_code='iqc'
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPR',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE'
 AND resource.code IN ('iqc:model-gateway:capacity:view','iqc:model-gateway:capacity:configure','iqc:model-gateway:calls:release') AND existing.id IS NULL
 AND role.code='IQC_ADMIN';

INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPM',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.type='BUTTON' AND menu.id IN ('900237','900238','900239') AND existing.id IS NULL
 AND role.code='IQC_ADMIN';
