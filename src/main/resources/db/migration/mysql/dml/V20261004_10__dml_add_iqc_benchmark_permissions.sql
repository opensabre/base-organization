-- Evaluation and Benchmark reuse existing task execution endpoints and product-scoped navigation.
INSERT INTO base_org_resource
 (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
 ('900198','创建单变量对照评测','iqc:benchmark:create','iqc','/api/iqc/evaluation/benchmarks','POST','创建冻结数据集与单变量目标对照任务','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900199','查看对照评测关联','iqc:benchmark:view','iqc','/api/iqc/evaluation/benchmarks/{baselineTaskId}','GET','查看基线与候选任务关联','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900200','查看对照评测报告','iqc:benchmark:report:view','iqc','/api/iqc/evaluation/benchmarks/{baselineTaskId}/report','GET','查看基线与候选评测指标差异','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE name=VALUES(name),type=VALUES(type),description=VALUES(description),application=VALUES(application),product_code=VALUES(product_code),source=VALUES(source),status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
SELECT '900197','iqc',dataset.parent_id,'MENU','/iqc/evaluation/tasks','file','评测任务与对照','{"perm":"iqc:evaluation:report:view"}',39,now(3),now(3),'system','system'
FROM base_org_menu dataset WHERE dataset.id='900185' AND dataset.product_code='iqc'
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),href=VALUES(href),icon=VALUES(icon),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

UPDATE base_org_menu SET parent_id='900197',updated_time=now(3),updated_by='system'
WHERE product_code='iqc' AND id IN ('900193','900194','900195','900196');

INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
VALUES
 ('900198','iqc','900197','BUTTON',NULL,'file','创建对照评测','{"perm":"iqc:benchmark:create"}',144,now(3),now(3),'system','system'),
 ('900199','iqc','900197','BUTTON',NULL,'file','查看对照关联','{"perm":"iqc:benchmark:view"}',145,now(3),now(3),'system','system'),
 ('900200','iqc','900197','BUTTON',NULL,'file','查看对照报告','{"perm":"iqc:benchmark:report:view"}',146,now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),href=VALUES(href),icon=VALUES(icon),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCBR',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE'
 AND resource.code IN ('iqc:benchmark:create','iqc:benchmark:view','iqc:benchmark:report:view')
 AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER') OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND resource.code<>'iqc:benchmark:create'));

INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCBM',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.id IN ('900197','900198','900199','900200') AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER') OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND menu.id<>'900198'));
