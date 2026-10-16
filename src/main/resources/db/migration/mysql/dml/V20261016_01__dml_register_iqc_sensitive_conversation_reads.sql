-- Independent sensitive reads; no SYSTEM ADMIN or viewer shortcut, no Prompt route invented.
INSERT INTO base_org_resource
 (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
 ('900261','查看完整会话内容','iqc:sensitive:conversation:read','iqc','/api/iqc/conversations/{id}/full-content','GET','在原数据范围内读取完整且PII脱敏的会话','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900262','查看会话客户PII','iqc:sensitive:pii:read','iqc','/api/iqc/conversations/{id}/pii-content','GET','独立PII授权；无全文权限时仍只返回预览','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE name=VALUES(name),type=VALUES(type),description=VALUES(description),application=VALUES(application),product_code=VALUES(product_code),source=VALUES(source),status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
SELECT '900261','iqc',conversation.id,'BUTTON',NULL,'lock','查看完整会话内容','{"perm":"iqc:sensitive:conversation:read"}',261,now(3),now(3),'system','system' FROM base_org_menu conversation WHERE conversation.id='900102' AND conversation.product_code='iqc'
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
SELECT '900262','iqc',conversation.id,'BUTTON',NULL,'lock','查看会话客户PII','{"perm":"iqc:sensitive:pii:read"}',262,now(3),now(3),'system','system' FROM base_org_menu conversation WHERE conversation.id='900102' AND conversation.product_code='iqc'
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPR',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE'
 AND resource.code IN ('iqc:sensitive:conversation:read','iqc:sensitive:pii:read') AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER') OR (role.code='IQC_INSPECTOR' AND resource.code='iqc:sensitive:conversation:read'));

INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPM',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.type='BUTTON' AND menu.id IN ('900261','900262') AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER') OR (role.code='IQC_INSPECTOR' AND menu.id='900261'));
