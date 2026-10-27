SET NAMES utf8mb4;
-- Apply before matching IQC registration; preserve IDs/states, inherit explicit active grants only.
-- No new roles/accounts, no all-data or sensitive-content grants. Missing original seeds remain PENDING.

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCRE',LEFT(SHA2('iqc:result:view',256),15)),'查看结果列表','iqc:result:view','iqc','/api/iqc/results','GET','独立结果端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看结果列表',url='/api/iqc/results',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:result:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCRE',LEFT(SHA2('iqc:result:export',256),15)),'导出结果','iqc:result:export','iqc','/api/iqc/results/export','GET','独立结果端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='导出结果',url='/api/iqc/results/export',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:result:export' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCRE',LEFT(SHA2('iqc:result:detail:view',256),15)),'查看结果详情','iqc:result:detail:view','iqc','/api/iqc/results/{id}','GET','独立结果端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:result:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看结果详情',url='/api/iqc/results/{id}',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:result:detail:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCRE',LEFT(SHA2('iqc:result:summary:view',256),15)),'查看任务结果汇总','iqc:result:summary:view','iqc','/api/iqc/tasks/{id}/result-summary','GET','独立结果端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:result:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看任务结果汇总',url='/api/iqc/tasks/{id}/result-summary',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:result:summary:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCRE',LEFT(SHA2('iqc:result:labels:view',256),15)),'查看任务标签结果','iqc:result:labels:view','iqc','/api/iqc/tasks/{id}/label-results','GET','独立结果端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:result:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看任务标签结果',url='/api/iqc/tasks/{id}/label-results',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:result:labels:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCRE',LEFT(SHA2('iqc:result:label-insights:view',256),15)),'查看标签结果分布','iqc:result:label-insights:view','iqc','/api/iqc/tasks/{id}/label-insights','GET','独立结果端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:result:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看标签结果分布',url='/api/iqc/tasks/{id}/label-insights',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:result:label-insights:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCRE',LEFT(SHA2('iqc:result:conversation:view',256),15)),'查看任务会话结果','iqc:result:conversation:view','iqc','/api/iqc/tasks/{id}/conversations/{conversationId}/result-detail','GET','独立结果端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:result:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看任务会话结果',url='/api/iqc/tasks/{id}/conversations/{conversationId}/result-detail',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:result:conversation:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCRE',LEFT(SHA2('iqc:result:hierarchy:view',256),15)),'查看任务会话层级结果','iqc:result:hierarchy:view','iqc','/api/iqc/tasks/{id}/conversations/{conversationId}/result-hierarchy','GET','独立结果端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:result:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看任务会话层级结果',url='/api/iqc/tasks/{id}/conversations/{conversationId}/result-hierarchy',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:result:hierarchy:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCRE',LEFT(SHA2('iqc:result:conversation-history:view',256),15)),'查看会话结果历史','iqc:result:conversation-history:view','iqc','/api/iqc/conversations/{conversationId}/result-detail','GET','独立结果端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:result:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看会话结果历史',url='/api/iqc/conversations/{conversationId}/result-detail',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:result:conversation-history:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCRE',LEFT(SHA2('iqc:result:feedback:view',256),15)),'查看结果反馈','iqc:result:feedback:view','iqc','/api/iqc/quality-operations/feedback','GET','独立结果端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:result:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看结果反馈',url='/api/iqc/quality-operations/feedback',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:result:feedback:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCRE',LEFT(SHA2('iqc:result:labels:export',256),15)),'导出标签结果','iqc:result:labels:export','iqc','/api/iqc/tasks/{id}/label-results/export','GET','独立结果端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:result:export' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='导出标签结果',url='/api/iqc/tasks/{id}/label-results/export',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:result:labels:export' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCRE',LEFT(SHA2(CONCAT(CHAR_LENGTH(granted.role_id),':',granted.role_id,':',CHAR_LENGTH(target.id),':',target.id),256),15)),granted.role_id,target.id,now(3),now(3),'system','system'
FROM (SELECT 'iqc:result:view' AS old_code,'iqc:result:detail:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:summary:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:labels:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:label-insights:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:conversation:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:hierarchy:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:conversation-history:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:feedback:view' AS new_code
 UNION ALL SELECT 'iqc:result:export' AS old_code,'iqc:result:labels:export' AS new_code) mapping
JOIN base_org_resource original ON original.code=mapping.old_code AND original.application='iqc-platform' AND original.product_code='iqc' AND original.status='ACTIVE'
JOIN base_org_role_resource granted ON granted.resource_id=original.id
JOIN base_org_resource target ON target.code=mapping.new_code AND target.application='iqc-platform' AND target.product_code='iqc' AND target.status='ACTIVE'
LEFT JOIN base_org_role_resource existing ON existing.role_id=granted.role_id AND existing.resource_id=target.id
WHERE existing.id IS NULL;
