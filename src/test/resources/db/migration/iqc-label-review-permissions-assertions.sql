-- Run only in the labelled disposable IQC permission-regression database.
SELECT IF(
    (SELECT COUNT(*) FROM base_org_resource WHERE code LIKE 'iqc:review:label:%'
         AND application='iqc-platform' AND product_code='iqc' AND status='ACTIVE') = 4
    AND (SELECT COUNT(*) FROM base_org_resource WHERE code='iqc:review:label:create'
         AND url='/api/iqc/quality-operations/label-results/{labelResultId}/reviews' AND method='POST') = 1
    AND (SELECT COUNT(*) FROM base_org_resource WHERE code='iqc:review:label:history'
         AND url='/api/iqc/quality-operations/label-results/{labelResultId}/reviews' AND method='GET') = 1
    AND (SELECT COUNT(*) FROM base_org_resource WHERE code='iqc:review:label:queue'
         AND url='/api/iqc/quality-operations/label-reviews' AND method='GET') = 1
    AND (SELECT COUNT(*) FROM base_org_resource WHERE code='iqc:review:label:decide'
         AND url='/api/iqc/quality-operations/label-reviews/{reviewId}/decision' AND method='POST') = 1
    AND (SELECT COUNT(*) FROM base_org_role_resource grant_row
         JOIN base_org_resource resource ON resource.id=grant_row.resource_id
         JOIN base_org_role role ON role.id=grant_row.role_id
         WHERE resource.code LIKE 'iqc:review:label:%'
           AND role.code IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER')) = 8
    AND (SELECT COUNT(*) FROM base_org_role_resource grant_row
         JOIN base_org_resource resource ON resource.id=grant_row.resource_id
         JOIN base_org_role role ON role.id=grant_row.role_id
         WHERE resource.code IN ('iqc:review:label:history', 'iqc:review:label:queue')
           AND role.code IN ('IQC_INSPECTOR', 'IQC_VIEWER')) = 4
    AND (SELECT COUNT(*) FROM base_org_role_resource grant_row
         JOIN base_org_resource resource ON resource.id=grant_row.resource_id
         JOIN base_org_role role ON role.id=grant_row.role_id
         WHERE resource.code IN ('iqc:review:label:create', 'iqc:review:label:decide')
           AND role.code IN ('IQC_INSPECTOR', 'IQC_VIEWER')) = 0
    AND (SELECT COUNT(*) FROM base_org_role_resource grant_row
         JOIN base_org_resource resource ON resource.id=grant_row.resource_id
         JOIN base_org_role role ON role.id=grant_row.role_id
         WHERE resource.code LIKE 'iqc:review:label:%'
           AND role.code NOT IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER', 'IQC_INSPECTOR', 'IQC_VIEWER')) = 0,
    'PASS', 'FAIL: label-review resource and role boundaries');
