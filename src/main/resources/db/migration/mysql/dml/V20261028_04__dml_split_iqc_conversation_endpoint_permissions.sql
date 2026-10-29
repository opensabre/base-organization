SET NAMES utf8mb4;
-- Apply before matching IQC registration; preserve IDs/states, inherit explicit active grants only.
-- No new roles/accounts or sensitive-content grants. Missing original seeds remain PENDING.

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCCE',LEFT(SHA2('iqc:conversation:view',256),15)),'查看会话列表','iqc:conversation:view','iqc','/api/iqc/conversations','GET','独立会话端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看会话列表',url='/api/iqc/conversations',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:conversation:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCCE',LEFT(SHA2('iqc:conversation:upload',256),15)),'导入TXT会话','iqc:conversation:upload','iqc','/api/iqc/conversations/import','POST','独立会话端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='导入TXT会话',url='/api/iqc/conversations/import',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:conversation:upload' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCCE',LEFT(SHA2('iqc:conversation:detail:view',256),15)),'查看会话预览','iqc:conversation:detail:view','iqc','/api/iqc/conversations/{id}','GET','独立会话端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:conversation:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看会话预览',url='/api/iqc/conversations/{id}',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:conversation:detail:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCCE',LEFT(SHA2('iqc:conversation:api-stats:view',256),15)),'查看API会话统计','iqc:conversation:api-stats:view','iqc','/api/iqc/conversations/api-stats','GET','独立会话端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:conversation:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看API会话统计',url='/api/iqc/conversations/api-stats',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:conversation:api-stats:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCCE',LEFT(SHA2('iqc:conversation:batch-upload',256),15)),'批量导入TXT会话','iqc:conversation:batch-upload','iqc','/api/iqc/conversations/batch-import','POST','独立会话端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:conversation:upload' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='批量导入TXT会话',url='/api/iqc/conversations/batch-import',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:conversation:batch-upload' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCCE',LEFT(SHA2('iqc:conversation:zip-upload',256),15)),'导入ZIP会话','iqc:conversation:zip-upload','iqc','/api/iqc/conversations/zip-import','POST','独立会话端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:conversation:upload' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='导入ZIP会话',url='/api/iqc/conversations/zip-import',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:conversation:zip-upload' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCCE',LEFT(SHA2('iqc:conversation:ingest',256),15)),'接入JSON会话','iqc:conversation:ingest','iqc','/api/iqc/conversations/ingest','POST','独立会话端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:conversation:upload' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='接入JSON会话',url='/api/iqc/conversations/ingest',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:conversation:ingest' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCCE',LEFT(SHA2('iqc:conversation:batch-ingest',256),15)),'批量接入JSON会话','iqc:conversation:batch-ingest','iqc','/api/iqc/conversations/ingest-batch','POST','独立会话端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:conversation:upload' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='批量接入JSON会话',url='/api/iqc/conversations/ingest-batch',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:conversation:batch-ingest' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCCE',LEFT(SHA2(CONCAT(CHAR_LENGTH(granted.role_id),':',granted.role_id,':',CHAR_LENGTH(target.id),':',target.id),256),15)),granted.role_id,target.id,now(3),now(3),'system','system'
FROM (SELECT 'iqc:conversation:view' AS old_code,'iqc:conversation:detail:view' AS new_code
 UNION ALL SELECT 'iqc:conversation:view' AS old_code,'iqc:conversation:api-stats:view' AS new_code
 UNION ALL SELECT 'iqc:conversation:upload' AS old_code,'iqc:conversation:batch-upload' AS new_code
 UNION ALL SELECT 'iqc:conversation:upload' AS old_code,'iqc:conversation:zip-upload' AS new_code
 UNION ALL SELECT 'iqc:conversation:upload' AS old_code,'iqc:conversation:ingest' AS new_code
 UNION ALL SELECT 'iqc:conversation:upload' AS old_code,'iqc:conversation:batch-ingest' AS new_code) mapping
JOIN base_org_resource original ON original.code=mapping.old_code AND original.application='iqc-platform' AND original.product_code='iqc' AND original.status='ACTIVE'
JOIN base_org_role_resource granted ON granted.resource_id=original.id
JOIN base_org_resource target ON target.code=mapping.new_code AND target.application='iqc-platform' AND target.product_code='iqc' AND target.status='ACTIVE'
LEFT JOIN base_org_role_resource existing ON existing.role_id=granted.role_id AND existing.resource_id=target.id
WHERE existing.id IS NULL;
