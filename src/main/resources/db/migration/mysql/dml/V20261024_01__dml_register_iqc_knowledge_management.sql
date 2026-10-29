-- Knowledge corpora reuse existing role resources and organization/sensitive controls. No new identities or broad ADMIN grant.
INSERT INTO base_org_resource
 (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
 ('900280','查看知识库目录','iqc:knowledge:view','iqc','/api/iqc/knowledge-bases','GET','沿既有组织范围与敏感读取投影，不因写权限返回正文','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900281','查看知识库详情','iqc:knowledge:detail:view','iqc','/api/iqc/knowledge-bases/{id}','GET','沿既有组织范围与敏感读取投影，不因写权限返回正文','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900282','创建知识库','iqc:knowledge:create','iqc','/api/iqc/knowledge-bases','POST','沿既有组织范围与敏感读取投影，不因写权限返回正文','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900283','修订知识库','iqc:knowledge:update','iqc','/api/iqc/knowledge-bases/{id}','PUT','沿既有组织范围与敏感读取投影，不因写权限返回正文','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900284','启停知识库','iqc:knowledge:availability','iqc','/api/iqc/knowledge-bases/{id}/availability','POST','沿既有组织范围与敏感读取投影，不因写权限返回正文','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900285','查看知识库发布历史','iqc:knowledge:versions:view','iqc','/api/iqc/knowledge-bases/{id}/versions','GET','沿既有组织范围与敏感读取投影，不因写权限返回正文','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900286','发布知识库版本','iqc:knowledge:publish','iqc','/api/iqc/knowledge-bases/{id}/publish','POST','沿既有组织范围与敏感读取投影，不因写权限返回正文','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900287','查看精确知识库版本','iqc:knowledge:version:view','iqc','/api/iqc/knowledge-bases/{id}/versions/{versionNo}','GET','沿既有组织范围与敏感读取投影，不因写权限返回正文','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900288','恢复知识库历史为草稿','iqc:knowledge:restore','iqc','/api/iqc/knowledge-bases/{id}/versions/{versionNo}/restore','POST','沿既有组织范围与敏感读取投影，不因写权限返回正文','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE name=VALUES(name),type=VALUES(type),description=VALUES(description),application=VALUES(application),product_code=VALUES(product_code),source=VALUES(source),status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

-- Place the page alongside the established Pipeline menu, retaining the installed IQC parent.
INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
SELECT '900280','iqc',pipeline_menu.parent_id,'MENU','/knowledge-bases','file','知识库','{"perm":"iqc:knowledge:view"}',280,now(3),now(3),'system','system'
FROM base_org_menu pipeline_menu WHERE pipeline_menu.id='900160' AND pipeline_menu.product_code='iqc'
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),href=VALUES(href),icon=VALUES(icon),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
VALUES
 ('900281','iqc','900280','BUTTON',NULL,'file','查看知识库详情','{"perm":"iqc:knowledge:detail:view"}',281,now(3),now(3),'system','system'),
 ('900282','iqc','900280','BUTTON',NULL,'file','创建知识库','{"perm":"iqc:knowledge:create"}',282,now(3),now(3),'system','system'),
 ('900283','iqc','900280','BUTTON',NULL,'file','修订知识库','{"perm":"iqc:knowledge:update"}',283,now(3),now(3),'system','system'),
 ('900284','iqc','900280','BUTTON',NULL,'file','启停知识库','{"perm":"iqc:knowledge:availability"}',284,now(3),now(3),'system','system'),
 ('900285','iqc','900280','BUTTON',NULL,'file','查看知识库发布历史','{"perm":"iqc:knowledge:versions:view"}',285,now(3),now(3),'system','system'),
 ('900286','iqc','900280','BUTTON',NULL,'file','发布知识库版本','{"perm":"iqc:knowledge:publish"}',286,now(3),now(3),'system','system'),
 ('900287','iqc','900280','BUTTON',NULL,'file','查看精确知识库版本','{"perm":"iqc:knowledge:version:view"}',287,now(3),now(3),'system','system'),
 ('900288','iqc','900280','BUTTON',NULL,'file','恢复知识库历史为草稿','{"perm":"iqc:knowledge:restore"}',288,now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPR',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE' AND resource.code IN ('iqc:knowledge:view','iqc:knowledge:detail:view','iqc:knowledge:create','iqc:knowledge:update','iqc:knowledge:availability','iqc:knowledge:versions:view','iqc:knowledge:publish','iqc:knowledge:version:view','iqc:knowledge:restore') AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER') OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND resource.code IN ('iqc:knowledge:view','iqc:knowledge:detail:view','iqc:knowledge:versions:view','iqc:knowledge:version:view')));

INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPM',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.id IN ('900280','900281','900282','900283','900284','900285','900286','900287','900288') AND existing.id IS NULL
 AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER') OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND menu.id IN ('900280','900281','900285','900287')));
