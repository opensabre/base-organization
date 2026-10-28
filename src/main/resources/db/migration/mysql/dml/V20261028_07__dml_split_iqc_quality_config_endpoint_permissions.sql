SET NAMES utf8mb4;
-- Apply before matching IQC registration. Preserve IDs/states and explicit active grants.
-- Approval grants derive only from approval; template materialization derives from rule:manage, not template:view.
-- No new roles/accounts/sensitive/all grants. Missing originals remain PENDING.

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCQE',LEFT(SHA2('iqc:agent:view',256),15)),'查看智能体列表','iqc:agent:view','iqc','/api/iqc/config/agents','GET','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看智能体列表',url='/api/iqc/config/agents',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:agent:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCQE',LEFT(SHA2('iqc:agent:approve',256),15)),'批准智能体','iqc:agent:approve','iqc','/api/iqc/config/agents/{id}/approve','POST','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='批准智能体',url='/api/iqc/config/agents/{id}/approve',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:agent:approve' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCQE',LEFT(SHA2('iqc:rule:view',256),15)),'查看规则列表','iqc:rule:view','iqc','/api/iqc/config/rules','GET','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看规则列表',url='/api/iqc/config/rules',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:rule:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCQE',LEFT(SHA2('iqc:rule:manage',256),15)),'创建规则','iqc:rule:manage','iqc','/api/iqc/config/rules','POST','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='创建规则',url='/api/iqc/config/rules',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:rule:manage' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCQE',LEFT(SHA2('iqc:rule:approve',256),15)),'批准规则','iqc:rule:approve','iqc','/api/iqc/config/rules/{id}/approve','POST','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='批准规则',url='/api/iqc/config/rules/{id}/approve',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:rule:approve' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:agent:reject',256),15)),'驳回智能体','iqc:agent:reject','iqc','/api/iqc/config/agents/{id}/reject','POST','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:agent:approve' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='驳回智能体',url='/api/iqc/config/agents/{id}/reject',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:agent:reject' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:agent:versions:view',256),15)),'查看智能体历史','iqc:agent:versions:view','iqc','/api/iqc/config/agents/{id}/versions','GET','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:agent:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看智能体历史',url='/api/iqc/config/agents/{id}/versions',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:agent:versions:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:agent:versions:compare',256),15)),'比较智能体版本','iqc:agent:versions:compare','iqc','/api/iqc/config/agents/{id}/versions/compare','GET','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:agent:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='比较智能体版本',url='/api/iqc/config/agents/{id}/versions/compare',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:agent:versions:compare' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:agent:version:effect:view',256),15)),'查看智能体版本效果','iqc:agent:version:effect:view','iqc','/api/iqc/config/agents/{id}/versions/{versionNo}/effect','GET','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:agent:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看智能体版本效果',url='/api/iqc/config/agents/{id}/versions/{versionNo}/effect',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:agent:version:effect:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:rule:submit',256),15)),'提交规则审批','iqc:rule:submit','iqc','/api/iqc/config/rules/{id}/submit','POST','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:rule:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='提交规则审批',url='/api/iqc/config/rules/{id}/submit',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:rule:submit' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:rule:reject',256),15)),'驳回规则','iqc:rule:reject','iqc','/api/iqc/config/rules/{id}/reject','POST','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:rule:approve' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='驳回规则',url='/api/iqc/config/rules/{id}/reject',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:rule:reject' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:rule:versions:view',256),15)),'查看规则历史','iqc:rule:versions:view','iqc','/api/iqc/config/rules/{id}/versions','GET','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:rule:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看规则历史',url='/api/iqc/config/rules/{id}/versions',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:rule:versions:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:rule:version:manage',256),15)),'创建规则版本','iqc:rule:version:manage','iqc','/api/iqc/config/rules/{id}/versions','POST','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:rule:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='创建规则版本',url='/api/iqc/config/rules/{id}/versions',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:rule:version:manage' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:rule-set:view',256),15)),'查看规则集列表','iqc:rule-set:view','iqc','/api/iqc/config/rule-sets','GET','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:rule:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看规则集列表',url='/api/iqc/config/rule-sets',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:rule-set:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:rule-set:manage',256),15)),'创建规则集','iqc:rule-set:manage','iqc','/api/iqc/config/rule-sets','POST','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:rule:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='创建规则集',url='/api/iqc/config/rule-sets',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:rule-set:manage' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:rule-set:versions:view',256),15)),'查看规则集历史','iqc:rule-set:versions:view','iqc','/api/iqc/config/rule-sets/{id}/versions','GET','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:rule:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看规则集历史',url='/api/iqc/config/rule-sets/{id}/versions',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:rule-set:versions:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:rule-set:version:manage',256),15)),'创建规则集版本','iqc:rule-set:version:manage','iqc','/api/iqc/config/rule-sets/{id}/versions','POST','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:rule:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='创建规则集版本',url='/api/iqc/config/rule-sets/{id}/versions',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:rule-set:version:manage' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:rule-set:submit',256),15)),'提交规则集审批','iqc:rule-set:submit','iqc','/api/iqc/config/rule-sets/{id}/submit','POST','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:rule:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='提交规则集审批',url='/api/iqc/config/rule-sets/{id}/submit',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:rule-set:submit' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:rule-set:approve',256),15)),'批准规则集','iqc:rule-set:approve','iqc','/api/iqc/config/rule-sets/{id}/approve','POST','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:rule:approve' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='批准规则集',url='/api/iqc/config/rule-sets/{id}/approve',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:rule-set:approve' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:rule-set:reject',256),15)),'驳回规则集','iqc:rule-set:reject','iqc','/api/iqc/config/rule-sets/{id}/reject','POST','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:rule:approve' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='驳回规则集',url='/api/iqc/config/rule-sets/{id}/reject',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:rule-set:reject' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2('iqc:template:materialize',256),15)),'从模板创建规则','iqc:template:materialize','iqc','/api/iqc/templates/{id}/rules','POST','独立质检配置端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:rule:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='从模板创建规则',url='/api/iqc/templates/{id}/rules',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:template:materialize' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCQE',LEFT(SHA2(CONCAT(CHAR_LENGTH(granted.role_id),':',granted.role_id,':',CHAR_LENGTH(target.id),':',target.id),256),15)),granted.role_id,target.id,now(3),now(3),'system','system'
FROM (SELECT 'iqc:agent:approve' AS old_code,'iqc:agent:reject' AS new_code
 UNION ALL SELECT 'iqc:agent:view' AS old_code,'iqc:agent:versions:view' AS new_code
 UNION ALL SELECT 'iqc:agent:view' AS old_code,'iqc:agent:versions:compare' AS new_code
 UNION ALL SELECT 'iqc:agent:view' AS old_code,'iqc:agent:version:effect:view' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:rule:submit' AS new_code
 UNION ALL SELECT 'iqc:rule:approve' AS old_code,'iqc:rule:reject' AS new_code
 UNION ALL SELECT 'iqc:rule:view' AS old_code,'iqc:rule:versions:view' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:rule:version:manage' AS new_code
 UNION ALL SELECT 'iqc:rule:view' AS old_code,'iqc:rule-set:view' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:rule-set:manage' AS new_code
 UNION ALL SELECT 'iqc:rule:view' AS old_code,'iqc:rule-set:versions:view' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:rule-set:version:manage' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:rule-set:submit' AS new_code
 UNION ALL SELECT 'iqc:rule:approve' AS old_code,'iqc:rule-set:approve' AS new_code
 UNION ALL SELECT 'iqc:rule:approve' AS old_code,'iqc:rule-set:reject' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:template:materialize' AS new_code) mapping
JOIN base_org_resource original ON original.code=mapping.old_code AND original.application='iqc-platform' AND original.product_code='iqc' AND original.status='ACTIVE'
JOIN base_org_role_resource granted ON granted.resource_id=original.id
JOIN base_org_resource target ON target.code=mapping.new_code AND target.application='iqc-platform' AND target.product_code='iqc' AND target.status='ACTIVE'
LEFT JOIN base_org_role_resource existing ON existing.role_id=granted.role_id AND existing.resource_id=target.id
WHERE existing.id IS NULL;
