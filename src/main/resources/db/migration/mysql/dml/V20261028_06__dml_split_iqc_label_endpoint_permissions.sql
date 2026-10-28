SET NAMES utf8mb4;
-- Apply before matching IQC registration. Preserve IDs/states and explicit active grants.
-- Existing label:approve is intentionally untouched: manage never implies label publication.
-- No role/account/sensitive/all-data grants; missing originals remain PENDING.

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCLE',LEFT(SHA2('iqc:label:view',256),15)),'查看标签树','iqc:label:view','iqc','/api/iqc/labels/tree','GET','独立标签端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看标签树',url='/api/iqc/labels/tree',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCLE',LEFT(SHA2('iqc:label:manage',256),15)),'创建标签','iqc:label:manage','iqc','/api/iqc/labels','POST','独立标签端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='创建标签',url='/api/iqc/labels',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label:manage' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCLE',LEFT(SHA2('iqc:label-collection:view',256),15)),'查看标签集合','iqc:label-collection:view','iqc','/api/iqc/label-collections','GET','独立标签端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看标签集合',url='/api/iqc/label-collections',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label-collection:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCLE',LEFT(SHA2('iqc:label-collection:manage',256),15)),'创建标签集合','iqc:label-collection:manage','iqc','/api/iqc/label-collections','POST','独立标签端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='创建标签集合',url='/api/iqc/label-collections',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label-collection:manage' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCLE',LEFT(SHA2('iqc:label-candidate:view',256),15)),'查看候选标签','iqc:label-candidate:view','iqc','/api/iqc/label-candidates','GET','独立标签端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看候选标签',url='/api/iqc/label-candidates',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label-candidate:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES (CONCAT('IQCLE',LEFT(SHA2('iqc:label-candidate:review',256),15)),'批准候选标签','iqc:label-candidate:review','iqc','/api/iqc/label-candidates/{id}/approve','POST','独立标签端点授权','iqc-platform','iqc','ANNOTATION','PENDING',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='批准候选标签',url='/api/iqc/label-candidates/{id}/approve',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label-candidate:review' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label:detail:view',256),15)),'查看标签详情','iqc:label:detail:view','iqc','/api/iqc/labels/{id}','GET','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看标签详情',url='/api/iqc/labels/{id}',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label:detail:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label:category:create',256),15)),'创建一级标签','iqc:label:category:create','iqc','/api/iqc/labels/categories','POST','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='创建一级标签',url='/api/iqc/labels/categories',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label:category:create' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label:group:create',256),15)),'创建标签群组','iqc:label:group:create','iqc','/api/iqc/labels/groups','POST','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='创建标签群组',url='/api/iqc/labels/groups',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label:group:create' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label:category:update',256),15)),'修订一级标签','iqc:label:category:update','iqc','/api/iqc/labels/categories/{id}','PUT','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='修订一级标签',url='/api/iqc/labels/categories/{id}',method='PUT',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label:category:update' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label:group:update',256),15)),'修订标签群组','iqc:label:group:update','iqc','/api/iqc/labels/groups/{id}','PUT','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='修订标签群组',url='/api/iqc/labels/groups/{id}',method='PUT',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label:group:update' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label:update',256),15)),'修订标签','iqc:label:update','iqc','/api/iqc/labels/{id}','PUT','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='修订标签',url='/api/iqc/labels/{id}',method='PUT',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label:update' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label:values:update',256),15)),'配置标签值','iqc:label:values:update','iqc','/api/iqc/labels/{id}/values','PUT','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='配置标签值',url='/api/iqc/labels/{id}/values',method='PUT',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label:values:update' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label:bindings:update',256),15)),'配置标签绑定','iqc:label:bindings:update','iqc','/api/iqc/labels/{id}/bindings','PUT','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='配置标签绑定',url='/api/iqc/labels/{id}/bindings',method='PUT',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label:bindings:update' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label:disable',256),15)),'停用标签','iqc:label:disable','iqc','/api/iqc/labels/{id}/disable','POST','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='停用标签',url='/api/iqc/labels/{id}/disable',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label:disable' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label:group:disable',256),15)),'停用标签群组','iqc:label:group:disable','iqc','/api/iqc/labels/groups/{id}/disable','POST','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='停用标签群组',url='/api/iqc/labels/groups/{id}/disable',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label:group:disable' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label:category:disable',256),15)),'停用一级标签','iqc:label:category:disable','iqc','/api/iqc/labels/categories/{id}/disable','POST','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='停用一级标签',url='/api/iqc/labels/categories/{id}/disable',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label:category:disable' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label-collection:detail:view',256),15)),'查看标签集合详情','iqc:label-collection:detail:view','iqc','/api/iqc/label-collections/{id}','GET','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label-collection:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看标签集合详情',url='/api/iqc/label-collections/{id}',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label-collection:detail:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label-collection:update',256),15)),'修订标签集合','iqc:label-collection:update','iqc','/api/iqc/label-collections/{id}','PUT','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label-collection:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='修订标签集合',url='/api/iqc/label-collections/{id}',method='PUT',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label-collection:update' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label-collection:members:update',256),15)),'配置标签集合成员','iqc:label-collection:members:update','iqc','/api/iqc/label-collections/{id}/members','PUT','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label-collection:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='配置标签集合成员',url='/api/iqc/label-collections/{id}/members',method='PUT',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label-collection:members:update' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label-collection:publish',256),15)),'发布标签集合','iqc:label-collection:publish','iqc','/api/iqc/label-collections/{id}/publish','POST','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label-collection:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='发布标签集合',url='/api/iqc/label-collections/{id}/publish',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label-collection:publish' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label-collection:disable',256),15)),'停用标签集合','iqc:label-collection:disable','iqc','/api/iqc/label-collections/{id}/disable','POST','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label-collection:manage' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='停用标签集合',url='/api/iqc/label-collections/{id}/disable',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label-collection:disable' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label-candidate:similarities:view',256),15)),'查看候选相似标签','iqc:label-candidate:similarities:view','iqc','/api/iqc/label-candidates/{id}/similarities','GET','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label-candidate:view' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='查看候选相似标签',url='/api/iqc/label-candidates/{id}/similarities',method='GET',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label-candidate:similarities:view' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label-candidate:reject',256),15)),'拒绝候选标签','iqc:label-candidate:reject','iqc','/api/iqc/label-candidates/{id}/reject','POST','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label-candidate:review' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='拒绝候选标签',url='/api/iqc/label-candidates/{id}/reject',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label-candidate:reject' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_resource (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2('iqc:label-candidate:merge',256),15)),'合并候选标签','iqc:label-candidate:merge','iqc','/api/iqc/label-candidates/{id}/merge','POST','独立标签端点授权','iqc-platform','iqc','ANNOTATION',parent.status,now(3),now(3),'system','system'
FROM base_org_resource parent WHERE parent.code='iqc:label-candidate:review' AND parent.application='iqc-platform' AND parent.product_code='iqc'
ON DUPLICATE KEY UPDATE id=base_org_resource.id;

UPDATE base_org_resource SET name='合并候选标签',url='/api/iqc/label-candidates/{id}/merge',method='POST',source='ANNOTATION',updated_time=now(3),updated_by='system'
WHERE code='iqc:label-candidate:merge' AND application='iqc-platform' AND product_code='iqc';

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCLE',LEFT(SHA2(CONCAT(CHAR_LENGTH(granted.role_id),':',granted.role_id,':',CHAR_LENGTH(target.id),':',target.id),256),15)),granted.role_id,target.id,now(3),now(3),'system','system'
FROM (SELECT 'iqc:label:view' AS old_code,'iqc:label:detail:view' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:category:create' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:group:create' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:category:update' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:group:update' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:update' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:values:update' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:bindings:update' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:disable' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:group:disable' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:category:disable' AS new_code
 UNION ALL SELECT 'iqc:label-collection:view' AS old_code,'iqc:label-collection:detail:view' AS new_code
 UNION ALL SELECT 'iqc:label-collection:manage' AS old_code,'iqc:label-collection:update' AS new_code
 UNION ALL SELECT 'iqc:label-collection:manage' AS old_code,'iqc:label-collection:members:update' AS new_code
 UNION ALL SELECT 'iqc:label-collection:manage' AS old_code,'iqc:label-collection:publish' AS new_code
 UNION ALL SELECT 'iqc:label-collection:manage' AS old_code,'iqc:label-collection:disable' AS new_code
 UNION ALL SELECT 'iqc:label-candidate:view' AS old_code,'iqc:label-candidate:similarities:view' AS new_code
 UNION ALL SELECT 'iqc:label-candidate:review' AS old_code,'iqc:label-candidate:reject' AS new_code
 UNION ALL SELECT 'iqc:label-candidate:review' AS old_code,'iqc:label-candidate:merge' AS new_code) mapping
JOIN base_org_resource original ON original.code=mapping.old_code AND original.application='iqc-platform' AND original.product_code='iqc' AND original.status='ACTIVE'
JOIN base_org_role_resource granted ON granted.resource_id=original.id
JOIN base_org_resource target ON target.code=mapping.new_code AND target.application='iqc-platform' AND target.product_code='iqc' AND target.status='ACTIVE'
LEFT JOIN base_org_role_resource existing ON existing.role_id=granted.role_id AND existing.resource_id=target.id
WHERE existing.id IS NULL;
