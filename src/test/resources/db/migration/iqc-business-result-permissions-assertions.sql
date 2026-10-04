-- Run only in the labelled disposable IQC permission-regression database.
SELECT IF(
    (SELECT COUNT(*) FROM base_org_resource WHERE code='iqc:result:business:view'
         AND url='/api/iqc/results/business' AND method='GET'
         AND application='iqc-platform' AND product_code='iqc' AND status='ACTIVE') = 1
    AND (SELECT COUNT(*) FROM base_org_role_resource grant_row
         JOIN base_org_resource resource ON resource.id=grant_row.resource_id
         JOIN base_org_role role ON role.id=grant_row.role_id
         WHERE resource.code='iqc:result:business:view'
           AND role.code IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER', 'IQC_INSPECTOR', 'IQC_VIEWER')) = 4
    AND (SELECT COUNT(*) FROM base_org_role_resource grant_row
         JOIN base_org_resource resource ON resource.id=grant_row.resource_id
         JOIN base_org_role role ON role.id=grant_row.role_id
         WHERE resource.code='iqc:result:business:view'
           AND role.code NOT IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER', 'IQC_INSPECTOR', 'IQC_VIEWER')) = 0,
    'PASS', 'FAIL: business-result resource and role boundaries');
