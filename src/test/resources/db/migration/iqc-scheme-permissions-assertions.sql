-- Reuses the existing isolated permission regression job; never executed against a shared database.
SELECT IF(
    (SELECT COUNT(*) FROM base_org_menu WHERE id IN ('900131', '900132', '900133') AND product_code='iqc') = 3
    AND (SELECT COUNT(*) FROM base_org_menu WHERE id='900131' AND type='MENU' AND href='/iqc/schemes') = 1
    AND (SELECT COUNT(*) FROM base_org_menu WHERE id='900133' AND parent_id='900107' AND type='BUTTON') = 1
    AND (SELECT COUNT(*) FROM base_org_resource WHERE code LIKE 'iqc:scheme:%' AND status='ACTIVE'
         AND application='iqc-platform' AND product_code='iqc') = 9
    AND (SELECT COUNT(*) FROM base_org_role_menu g JOIN base_org_role role ON role.id=g.role_id
         WHERE g.menu_id IN ('900131', '900132', '900133') AND role.code IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER')) = 6
    AND (SELECT COUNT(*) FROM base_org_role_menu g JOIN base_org_role role ON role.id=g.role_id
         WHERE g.menu_id='900133' AND role.code='IQC_INSPECTOR') = 1
    AND (SELECT COUNT(*) FROM base_org_role_menu g JOIN base_org_role role ON role.id=g.role_id
         WHERE g.menu_id IN ('900131', '900132') AND role.code='IQC_INSPECTOR') = 0
    AND (SELECT COUNT(*) FROM base_org_role_resource g JOIN base_org_resource r ON r.id=g.resource_id
         JOIN base_org_role role ON role.id=g.role_id
         WHERE r.code LIKE 'iqc:scheme:%' AND role.code IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER')) = 18
    AND (SELECT COUNT(*) FROM base_org_role_resource g JOIN base_org_resource r ON r.id=g.resource_id
         JOIN base_org_role role ON role.id=g.role_id WHERE r.code='iqc:scheme:use' AND role.code='IQC_INSPECTOR') = 1
    AND (SELECT COUNT(*) FROM base_org_role_resource g JOIN base_org_resource r ON r.id=g.resource_id
         JOIN base_org_role role ON role.id=g.role_id
         WHERE r.code LIKE 'iqc:scheme:%' AND r.code NOT IN ('iqc:scheme:use', 'iqc:scheme:view') AND role.code='IQC_INSPECTOR') = 0
    AND (SELECT COUNT(*) FROM base_org_role_resource g JOIN base_org_resource r ON r.id=g.resource_id
         JOIN base_org_role role ON role.id=g.role_id WHERE r.code='iqc:scheme:view' AND role.code IN ('IQC_INSPECTOR', 'IQC_VIEWER')) = 2
    AND (SELECT COUNT(*) FROM base_org_role_resource g JOIN base_org_resource r ON r.id=g.resource_id
         JOIN base_org_role role ON role.id=g.role_id WHERE r.code LIKE 'iqc:scheme:%' AND r.code <> 'iqc:scheme:view' AND role.code='IQC_VIEWER') = 0
    AND (SELECT COUNT(*) FROM base_org_role_resource g JOIN base_org_resource r ON r.id=g.resource_id
         JOIN base_org_role role ON role.id=g.role_id WHERE r.code LIKE 'iqc:scheme:%'
         AND role.code NOT IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER', 'IQC_INSPECTOR', 'IQC_VIEWER')) = 0
    AND (SELECT COUNT(*) FROM base_org_role_menu g JOIN base_org_role role ON role.id=g.role_id
         WHERE g.menu_id IN ('900131', '900132', '900133')
         AND role.code NOT IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER', 'IQC_INSPECTOR')) = 0,
    'PASS', 'FAIL: scheme expert/use permission boundaries');
