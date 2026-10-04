-- The published-policy selector already consumes detail/version permissions from the menu contract.
INSERT INTO base_org_menu
    (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
VALUES
    ('900175','iqc','900001','BUTTON',NULL,'eye','查看流水线定义','{"perm":"iqc:pipeline:detail:view"}',110,now(3),now(3),'system','system'),
    ('900176','iqc','900001','BUTTON',NULL,'history','查看流水线版本','{"perm":"iqc:pipeline:versions:view"}',111,now(3),now(3),'system','system'),
    ('900177','iqc','900001','BUTTON',NULL,'edit','更新流水线草稿','{"perm":"iqc:pipeline:update"}',112,now(3),now(3),'system','system'),
    ('900178','iqc','900001','BUTTON',NULL,'settings','设置流水线可用性','{"perm":"iqc:pipeline:availability"}',113,now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),href=VALUES(href),icon=VALUES(icon),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);
INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPN',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.id IN ('900175','900176','900177','900178') AND existing.id IS NULL
AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER')
 OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND menu.id IN ('900175','900176')));
