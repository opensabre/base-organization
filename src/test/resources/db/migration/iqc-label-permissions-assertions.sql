-- Assert both positive grants and negative role boundaries in an isolated MySQL database.
SELECT IF(
    (SELECT COUNT(*) FROM base_org_menu WHERE id BETWEEN '900121' AND '900128' AND product_code='iqc') = 8
    AND (SELECT COUNT(*) FROM base_org_menu WHERE parent_id='900121' AND type='MENU'
         AND href IN ('/iqc/labels/tree', '/iqc/labels/collections', '/iqc/labels/candidates')) = 3
    AND (SELECT COUNT(*) FROM base_org_menu WHERE id='900121' AND parent_id='900001' AND type='MENU') = 1
    AND (SELECT COUNT(*) FROM base_org_menu WHERE id BETWEEN '900125' AND '900128' AND type='BUTTON'
         AND parent_id IN ('900122', '900123', '900124')) = 4
    AND (SELECT COUNT(*) FROM base_org_resource WHERE code LIKE 'iqc:label%' AND status='ACTIVE'
         AND application='iqc-platform' AND product_code='iqc') = 7
    AND (SELECT COUNT(*) FROM base_org_role_menu WHERE menu_id BETWEEN '900121' AND '900128'
         AND role_id IN ('104', '105')) = 16
    AND (SELECT COUNT(*) FROM base_org_role_menu WHERE menu_id BETWEEN '900121' AND '900124'
         AND role_id IN ('106', '107')) = 8
    AND (SELECT COUNT(*) FROM base_org_role_menu WHERE menu_id BETWEEN '900125' AND '900128'
         AND role_id IN ('106', '107')) = 0
    AND (SELECT COUNT(*) FROM base_org_role_resource g JOIN base_org_resource r ON r.id=g.resource_id
         WHERE r.code LIKE 'iqc:label%' AND g.role_id IN ('104', '105')) = 14
    AND (SELECT COUNT(*) FROM base_org_role_resource g JOIN base_org_resource r ON r.id=g.resource_id
         WHERE r.code LIKE 'iqc:label%' AND g.role_id IN ('106', '107') AND r.code LIKE '%:view') = 6
    AND (SELECT COUNT(*) FROM base_org_role_resource g JOIN base_org_resource r ON r.id=g.resource_id
         WHERE r.code LIKE 'iqc:label%' AND g.role_id IN ('106', '107') AND r.code NOT LIKE '%:view') = 0
    AND (SELECT COUNT(*) FROM base_org_role_menu WHERE menu_id BETWEEN '900121' AND '900128'
         AND role_id NOT IN ('104', '105', '106', '107')) = 0
    AND (SELECT COUNT(*) FROM base_org_role_resource g JOIN base_org_resource r ON r.id=g.resource_id
         WHERE r.code LIKE 'iqc:label%' AND g.role_id NOT IN ('104', '105', '106', '107')) = 0,
    'PASS', 'FAIL: label hierarchy or role/resource boundaries');
