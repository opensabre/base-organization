-- Reuse task execution permissions; these resources only create/query frozen evaluation artifacts.
INSERT INTO base_org_resource
 (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
 ('900193','创建冻结数据集评测任务','iqc:evaluation:task:create','iqc','/api/iqc/evaluation/tasks','POST','创建精确数据集评测任务','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900194','查看评测样本结果','iqc:evaluation:results:view','iqc','/api/iqc/evaluation/tasks/{taskId}/results','GET','查看评测样本结果摘要','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900195','查看评测样本轨迹','iqc:evaluation:result:view','iqc','/api/iqc/evaluation/tasks/{taskId}/results/{resultId}','GET','查看评测机器输出轨迹','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900196','查看固定数据集评测报告','iqc:evaluation:report:view','iqc','/api/iqc/evaluation/tasks/{taskId}/report','GET','查看完整金标分母的评测报告','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE name=VALUES(name),type=VALUES(type),description=VALUES(description),application=VALUES(application),product_code=VALUES(product_code),source=VALUES(source),status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
VALUES
 ('900193','iqc','900185','BUTTON',NULL,'file','创建评测任务','{"perm":"iqc:evaluation:task:create"}',140,now(3),now(3),'system','system'),
 ('900194','iqc','900185','BUTTON',NULL,'file','查看评测结果','{"perm":"iqc:evaluation:results:view"}',141,now(3),now(3),'system','system'),
 ('900195','iqc','900185','BUTTON',NULL,'file','查看评测轨迹','{"perm":"iqc:evaluation:result:view"}',142,now(3),now(3),'system','system'),
 ('900196','iqc','900185','BUTTON',NULL,'file','查看评测报告','{"perm":"iqc:evaluation:report:view"}',143,now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),href=VALUES(href),icon=VALUES(icon),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCER',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE'
 AND resource.code IN ('iqc:evaluation:task:create','iqc:evaluation:results:view','iqc:evaluation:result:view','iqc:evaluation:report:view')
 AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER') OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND resource.code<>'iqc:evaluation:task:create'));

INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCEB',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.id IN ('900193','900194','900195','900196') AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER') OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND menu.id<>'900193'));
