SET NAMES utf8mb4;

-- One resource code per URL/method. Run before the matching IQC release.
-- Preserve existing IDs, resource states and role grants; no accounts or role-wide grants.
-- New installations seed PENDING anchors: activation and grants remain an explicit organization operation.

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCAE',LEFT(SHA2('iqc:model:manage',256),15)),'创建模型配置','iqc:model:manage','iqc','/api/iqc/agent-assets/models','POST','独立端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='创建模型配置',url='/api/iqc/agent-assets/models',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:model:manage' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCAE',LEFT(SHA2('iqc:skill:manage',256),15)),'创建Skill','iqc:skill:manage','iqc','/api/iqc/agent-assets/skills','POST','独立端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='创建Skill',url='/api/iqc/agent-assets/skills',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:skill:manage' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCAE',LEFT(SHA2('iqc:skill:view',256),15)),'查看Skill','iqc:skill:view','iqc','/api/iqc/agent-assets/skills','GET','独立端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看Skill',url='/api/iqc/agent-assets/skills',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:skill:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCAE',LEFT(SHA2('iqc:model:update',256),15)),'修改模型配置','iqc:model:update','iqc','/api/iqc/agent-assets/models/{id}','PUT','独立端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:model:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='修改模型配置',url='/api/iqc/agent-assets/models/{id}',method='PUT',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:model:update' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCAE',LEFT(SHA2('iqc:model:enable',256),15)),'启用模型配置','iqc:model:enable','iqc','/api/iqc/agent-assets/models/{id}/enable','POST','独立端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:model:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='启用模型配置',url='/api/iqc/agent-assets/models/{id}/enable',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:model:enable' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCAE',LEFT(SHA2('iqc:model:disable',256),15)),'停用模型配置','iqc:model:disable','iqc','/api/iqc/agent-assets/models/{id}/disable','POST','独立端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:model:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='停用模型配置',url='/api/iqc/agent-assets/models/{id}/disable',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:model:disable' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCAE',LEFT(SHA2('iqc:skill:update',256),15)),'修改Skill','iqc:skill:update','iqc','/api/iqc/agent-assets/skills/{id}','PUT','独立端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:skill:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='修改Skill',url='/api/iqc/agent-assets/skills/{id}',method='PUT',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:skill:update' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCAE',LEFT(SHA2('iqc:skill:enable',256),15)),'启用Skill','iqc:skill:enable','iqc','/api/iqc/agent-assets/skills/{id}/enable','POST','独立端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:skill:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='启用Skill',url='/api/iqc/agent-assets/skills/{id}/enable',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:skill:enable' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCAE',LEFT(SHA2('iqc:skill:disable',256),15)),'停用Skill','iqc:skill:disable','iqc','/api/iqc/agent-assets/skills/{id}/disable','POST','独立端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:skill:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='停用Skill',url='/api/iqc/agent-assets/skills/{id}/disable',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:skill:disable' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCAE',LEFT(SHA2('iqc:skill:rollback',256),15)),'回滚Skill','iqc:skill:rollback','iqc','/api/iqc/agent-assets/skills/{id}/versions/{versionNo}/rollback','POST','独立端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:skill:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='回滚Skill',url='/api/iqc/agent-assets/skills/{id}/versions/{versionNo}/rollback',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:skill:rollback' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCAE',LEFT(SHA2('iqc:skill:versions:view',256),15)),'查看Skill版本','iqc:skill:versions:view','iqc','/api/iqc/agent-assets/skills/{id}/versions','GET','独立端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:skill:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看Skill版本',url='/api/iqc/agent-assets/skills/{id}/versions',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:skill:versions:view' AND application='iqc-platform' AND product_code='iqc';

-- Copy only explicit grants to an active original capability, never infer grants from role names.
INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCAE',LEFT(SHA2(CONCAT(CHAR_LENGTH(granted.role_id),':',granted.role_id,':',CHAR_LENGTH(target.id),':',target.id),256),15)),
 granted.role_id,target.id,now(3),now(3),'system','system'
FROM (SELECT 'iqc:model:manage' AS old_code,'iqc:model:update' AS new_code
 UNION ALL SELECT 'iqc:model:manage' AS old_code,'iqc:model:enable' AS new_code
 UNION ALL SELECT 'iqc:model:manage' AS old_code,'iqc:model:disable' AS new_code
 UNION ALL SELECT 'iqc:skill:manage' AS old_code,'iqc:skill:update' AS new_code
 UNION ALL SELECT 'iqc:skill:manage' AS old_code,'iqc:skill:enable' AS new_code
 UNION ALL SELECT 'iqc:skill:manage' AS old_code,'iqc:skill:disable' AS new_code
 UNION ALL SELECT 'iqc:skill:manage' AS old_code,'iqc:skill:rollback' AS new_code
 UNION ALL SELECT 'iqc:skill:view' AS old_code,'iqc:skill:versions:view' AS new_code) mapping
JOIN base_org_resource original ON original.code=mapping.old_code
 AND original.application='iqc-platform' AND original.product_code='iqc' AND original.status='ACTIVE'
JOIN base_org_role_resource granted ON granted.resource_id=original.id
JOIN base_org_resource target ON target.code=mapping.new_code
 AND target.application='iqc-platform' AND target.product_code='iqc' AND target.status='ACTIVE'
LEFT JOIN base_org_role_resource existing ON existing.role_id=granted.role_id AND existing.resource_id=target.id
WHERE existing.id IS NULL;
