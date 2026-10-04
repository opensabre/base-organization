-- Reuse organization resources and BUTTON permissions; no UI route is delivered yet.
-- Preserve registered resource IDs/endpoints and activate existing PENDING resources by unique code.
INSERT INTO base_org_resource
    (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
    ('900180','查看金标草稿','iqc:gold:view','iqc','/api/iqc/quality-operations/samples/{sampleId}/gold','GET','查看金标草稿','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
    ('900181','标注金标样本','iqc:gold:annotate','iqc','/api/iqc/quality-operations/samples/{sampleId}/gold','PUT','标注金标样本','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
    ('900182','审核金标样本','iqc:gold:review','iqc','/api/iqc/quality-operations/samples/{sampleId}/gold/reviews','POST','审核金标样本','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
    ('900183','查看金标审核历史','iqc:gold:versions:view','iqc','/api/iqc/quality-operations/samples/{sampleId}/gold/versions','GET','查看金标审核历史','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
    ('900184','查看金标版本快照','iqc:gold:version:view','iqc','/api/iqc/quality-operations/samples/{sampleId}/gold/versions/{versionNo}','GET','查看金标版本快照','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
    ('900185','查看评测数据集','iqc:dataset:view','iqc','/api/iqc/evaluation/datasets','GET','查看评测数据集','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
    ('900186','查看评测数据集草稿','iqc:dataset:detail:view','iqc','/api/iqc/evaluation/datasets/{id}','GET','查看评测数据集草稿','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
    ('900187','创建评测数据集','iqc:dataset:manage','iqc','/api/iqc/evaluation/datasets','POST','创建评测数据集','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
    ('900188','更新评测数据集','iqc:dataset:update','iqc','/api/iqc/evaluation/datasets/{id}','PUT','更新评测数据集','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
    ('900189','冻结评测数据集版本','iqc:dataset:freeze','iqc','/api/iqc/evaluation/datasets/{id}/freeze','POST','冻结评测数据集版本','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
    ('900190','设置评测数据集可用性','iqc:dataset:availability','iqc','/api/iqc/evaluation/datasets/{id}/availability','POST','设置评测数据集可用性','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
    ('900191','查看数据集版本历史','iqc:dataset:versions:view','iqc','/api/iqc/evaluation/datasets/{id}/versions','GET','查看数据集版本历史','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
    ('900192','查看数据集冻结快照','iqc:dataset:version:view','iqc','/api/iqc/evaluation/datasets/{id}/versions/{versionNo}','GET','查看数据集冻结快照','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);
INSERT INTO base_org_menu
    (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
VALUES
    ('900180','iqc','900001','BUTTON',NULL,'file','查看金标草稿','{"perm":"iqc:gold:view"}',114,now(3),now(3),'system','system'),
    ('900181','iqc','900001','BUTTON',NULL,'file','标注金标样本','{"perm":"iqc:gold:annotate"}',115,now(3),now(3),'system','system'),
    ('900182','iqc','900001','BUTTON',NULL,'file','审核金标样本','{"perm":"iqc:gold:review"}',116,now(3),now(3),'system','system'),
    ('900183','iqc','900001','BUTTON',NULL,'file','查看金标审核历史','{"perm":"iqc:gold:versions:view"}',117,now(3),now(3),'system','system'),
    ('900184','iqc','900001','BUTTON',NULL,'file','查看金标版本快照','{"perm":"iqc:gold:version:view"}',118,now(3),now(3),'system','system'),
    ('900185','iqc','900001','BUTTON',NULL,'file','查看评测数据集','{"perm":"iqc:dataset:view"}',119,now(3),now(3),'system','system'),
    ('900186','iqc','900001','BUTTON',NULL,'file','查看评测数据集草稿','{"perm":"iqc:dataset:detail:view"}',120,now(3),now(3),'system','system'),
    ('900187','iqc','900001','BUTTON',NULL,'file','创建评测数据集','{"perm":"iqc:dataset:manage"}',121,now(3),now(3),'system','system'),
    ('900188','iqc','900001','BUTTON',NULL,'file','更新评测数据集','{"perm":"iqc:dataset:update"}',122,now(3),now(3),'system','system'),
    ('900189','iqc','900001','BUTTON',NULL,'file','冻结评测数据集版本','{"perm":"iqc:dataset:freeze"}',123,now(3),now(3),'system','system'),
    ('900190','iqc','900001','BUTTON',NULL,'file','设置评测数据集可用性','{"perm":"iqc:dataset:availability"}',124,now(3),now(3),'system','system'),
    ('900191','iqc','900001','BUTTON',NULL,'file','查看数据集版本历史','{"perm":"iqc:dataset:versions:view"}',125,now(3),now(3),'system','system'),
    ('900192','iqc','900001','BUTTON',NULL,'file','查看数据集冻结快照','{"perm":"iqc:dataset:version:view"}',126,now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),href=VALUES(href),icon=VALUES(icon),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);
INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCGR',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE'
AND resource.code IN ('iqc:gold:view','iqc:gold:annotate','iqc:gold:review','iqc:gold:versions:view','iqc:gold:version:view','iqc:dataset:view','iqc:dataset:detail:view','iqc:dataset:manage','iqc:dataset:update','iqc:dataset:freeze','iqc:dataset:availability','iqc:dataset:versions:view','iqc:dataset:version:view') AND existing.id IS NULL
AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER')
 OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND resource.code IN ('iqc:gold:view','iqc:gold:versions:view','iqc:gold:version:view','iqc:dataset:view','iqc:dataset:detail:view','iqc:dataset:versions:view','iqc:dataset:version:view'))
 OR (role.code='IQC_INSPECTOR' AND resource.code='iqc:gold:annotate'));
INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCGB',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.id IN ('900180','900181','900182','900183','900184','900185','900186','900187','900188','900189','900190','900191','900192') AND existing.id IS NULL
AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER')
 OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND menu.id IN ('900180','900183','900184','900185','900186','900191','900192'))
 OR (role.code='IQC_INSPECTOR' AND menu.id='900181'));
