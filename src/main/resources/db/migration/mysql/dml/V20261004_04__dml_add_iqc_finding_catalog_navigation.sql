-- Preserve the existing view-menu identity and role associations when promoting it to a page.
UPDATE base_org_menu SET type='MENU',href='/iqc/findings',name='事实语义目录',icon='book',order_num=36,
    updated_time=now(3),updated_by='system' WHERE id='900150' AND product_code='iqc';
UPDATE base_org_menu SET parent_id='900150',updated_time=now(3),updated_by='system'
    WHERE id IN ('900151','900152') AND product_code='iqc';
INSERT INTO base_org_menu
    (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
VALUES
    ('900171','iqc','900150','BUTTON',NULL,'eye','查看事实定义','{"perm":"iqc:finding:detail:view"}',10,now(3),now(3),'system','system'),
    ('900172','iqc','900150','BUTTON',NULL,'edit','更新事实草稿','{"perm":"iqc:finding:update"}',20,now(3),now(3),'system','system'),
    ('900173','iqc','900150','BUTTON',NULL,'settings','设置事实可用性','{"perm":"iqc:finding:availability"}',30,now(3),now(3),'system','system'),
    ('900174','iqc','900150','BUTTON',NULL,'history','查看事实版本历史','{"perm":"iqc:finding:versions:view"}',40,now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE product_code=VALUES(product_code),parent_id=VALUES(parent_id),type=VALUES(type),href=VALUES(href),icon=VALUES(icon),name=VALUES(name),description=VALUES(description),order_num=VALUES(order_num),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);
INSERT INTO base_org_role_menu (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCFN',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(menu.id),':',menu.id),256),15)),role.id,menu.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_menu menu
LEFT JOIN base_org_role_menu existing ON existing.role_id=role.id AND existing.menu_id=menu.id
WHERE menu.product_code='iqc' AND menu.id IN ('900171','900172','900173','900174') AND existing.id IS NULL
AND (role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER')
 OR (role.code IN ('IQC_INSPECTOR','IQC_VIEWER') AND menu.id IN ('900171','900174')));
