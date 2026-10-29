SET NAMES utf8mb4;
-- Apply before matching IQC registration; preserve IDs/states and explicit active grants.
-- Missing originals remain PENDING; no role/account/sensitive grants are inferred.

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCAH',LEFT(SHA2('iqc:mcp:manage',256),15)),'创建MCP','iqc:mcp:manage','iqc','/api/iqc/agent-assets/mcps','POST','独立资产历史状态端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='创建MCP',url='/api/iqc/agent-assets/mcps',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:mcp:manage' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCAH',LEFT(SHA2('iqc:scheme:manage',256),15)),'查看方案草稿','iqc:scheme:manage','iqc','/api/iqc/schemes','GET','独立资产历史状态端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看方案草稿',url='/api/iqc/schemes',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:scheme:manage' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCAH',LEFT(SHA2('iqc:dashboard:view',256),15)),'查看质检总览','iqc:dashboard:view','iqc','/api/iqc/dashboard','GET','独立资产历史状态端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看质检总览',url='/api/iqc/dashboard',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:dashboard:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCAH',LEFT(SHA2('iqc:mcp:update',256),15)),'更新MCP','iqc:mcp:update','iqc','/api/iqc/agent-assets/mcps/{id}','PUT','独立资产历史状态端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:mcp:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='更新MCP',url='/api/iqc/agent-assets/mcps/{id}',method='PUT',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:mcp:update' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCAH',LEFT(SHA2('iqc:mcp:enable',256),15)),'启用MCP','iqc:mcp:enable','iqc','/api/iqc/agent-assets/mcps/{id}/enable','POST','独立资产历史状态端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:mcp:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='启用MCP',url='/api/iqc/agent-assets/mcps/{id}/enable',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:mcp:enable' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCAH',LEFT(SHA2('iqc:mcp:disable',256),15)),'停用MCP','iqc:mcp:disable','iqc','/api/iqc/agent-assets/mcps/{id}/disable','POST','独立资产历史状态端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:mcp:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='停用MCP',url='/api/iqc/agent-assets/mcps/{id}/disable',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:mcp:disable' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCAH',LEFT(SHA2('iqc:scheme:versions:view',256),15)),'查看专家方案历史','iqc:scheme:versions:view','iqc','/api/iqc/schemes/{id}/versions','GET','独立资产历史状态端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:scheme:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看专家方案历史',url='/api/iqc/schemes/{id}/versions',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:scheme:versions:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCAH',LEFT(SHA2('iqc:bootstrap:view',256),15)),'查看平台基础状态','iqc:bootstrap:view','iqc','/api/iqc/bootstrap','GET','独立资产历史状态端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:dashboard:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看平台基础状态',url='/api/iqc/bootstrap',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:bootstrap:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCAH',LEFT(SHA2(CONCAT(CHAR_LENGTH(granted.role_id),':',granted.role_id,':',CHAR_LENGTH(target.id),':',target.id),256),15)),granted.role_id,target.id,now(3),now(3),'system','system'
FROM (SELECT 'iqc:mcp:manage' AS old_code,'iqc:mcp:update' AS new_code
 UNION ALL SELECT 'iqc:mcp:manage' AS old_code,'iqc:mcp:enable' AS new_code
 UNION ALL SELECT 'iqc:mcp:manage' AS old_code,'iqc:mcp:disable' AS new_code
 UNION ALL SELECT 'iqc:scheme:manage' AS old_code,'iqc:scheme:versions:view' AS new_code
 UNION ALL SELECT 'iqc:dashboard:view' AS old_code,'iqc:bootstrap:view' AS new_code) mapping
JOIN base_org_resource original ON original.code=mapping.old_code AND original.application='iqc-platform' AND original.product_code='iqc' AND original.status='ACTIVE'
JOIN base_org_role_resource granted ON granted.resource_id=original.id
JOIN base_org_resource target ON target.code=mapping.new_code AND target.application='iqc-platform' AND target.product_code='iqc' AND target.status='ACTIVE'
LEFT JOIN base_org_role_resource existing ON existing.role_id=granted.role_id AND existing.resource_id=target.id
WHERE existing.id IS NULL;
