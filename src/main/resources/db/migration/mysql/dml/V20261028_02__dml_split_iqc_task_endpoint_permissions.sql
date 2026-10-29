SET NAMES utf8mb4;
-- Apply before matching IQC registration. Preserve IDs/states; inherit only explicit active grants.
-- Missing original resources stay PENDING and need original organization activation/grant workflow.

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCTE',LEFT(SHA2('iqc:task:view',256),15)),'查看任务目录','iqc:task:view','iqc','/api/iqc/tasks','GET','独立任务端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看任务目录',url='/api/iqc/tasks',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:task:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCTE',LEFT(SHA2('iqc:task:execute',256),15)),'运行任务','iqc:task:execute','iqc','/api/iqc/tasks/{id}/run','POST','独立任务端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='运行任务',url='/api/iqc/tasks/{id}/run',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:task:execute' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCTE',LEFT(SHA2('iqc:task:detail:view',256),15)),'查看任务详情','iqc:task:detail:view','iqc','/api/iqc/tasks/{id}','GET','独立任务端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:task:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看任务详情',url='/api/iqc/tasks/{id}',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:task:detail:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCTE',LEFT(SHA2('iqc:task:executions:view',256),15)),'查看任务执行记录','iqc:task:executions:view','iqc','/api/iqc/tasks/{id}/executions','GET','独立任务端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:task:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看任务执行记录',url='/api/iqc/tasks/{id}/executions',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:task:executions:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCTE',LEFT(SHA2('iqc:task:resume',256),15)),'恢复任务','iqc:task:resume','iqc','/api/iqc/tasks/{id}/resume','POST','独立任务端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:task:execute' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='恢复任务',url='/api/iqc/tasks/{id}/resume',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:task:resume' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCTE',LEFT(SHA2('iqc:task:pause',256),15)),'暂停任务','iqc:task:pause','iqc','/api/iqc/tasks/{id}/pause','POST','独立任务端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:task:execute' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='暂停任务',url='/api/iqc/tasks/{id}/pause',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:task:pause' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCTE',LEFT(SHA2('iqc:task:priority',256),15)),'调整任务优先级','iqc:task:priority','iqc','/api/iqc/tasks/{id}/priority','PUT','独立任务端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:task:execute' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='调整任务优先级',url='/api/iqc/tasks/{id}/priority',method='PUT',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:task:priority' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCTE',LEFT(SHA2(CONCAT(CHAR_LENGTH(granted.role_id),':',granted.role_id,':',CHAR_LENGTH(target.id),':',target.id),256),15)),granted.role_id,target.id,now(3),now(3),'system','system'
FROM (SELECT 'iqc:task:view' AS old_code,'iqc:task:detail:view' AS new_code
 UNION ALL SELECT 'iqc:task:view' AS old_code,'iqc:task:executions:view' AS new_code
 UNION ALL SELECT 'iqc:task:execute' AS old_code,'iqc:task:resume' AS new_code
 UNION ALL SELECT 'iqc:task:execute' AS old_code,'iqc:task:pause' AS new_code
 UNION ALL SELECT 'iqc:task:execute' AS old_code,'iqc:task:priority' AS new_code) mapping
JOIN base_org_resource original ON original.code=mapping.old_code AND original.application='iqc-platform' AND original.product_code='iqc' AND original.status='ACTIVE'
JOIN base_org_role_resource granted ON granted.resource_id=original.id
JOIN base_org_resource target ON target.code=mapping.new_code AND target.application='iqc-platform' AND target.product_code='iqc' AND target.status='ACTIVE'
LEFT JOIN base_org_role_resource existing ON existing.role_id=granted.role_id AND existing.resource_id=target.id
WHERE existing.id IS NULL;
