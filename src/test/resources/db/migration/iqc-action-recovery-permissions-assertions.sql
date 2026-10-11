-- Dedicated manual recovery grant; viewers and generic ADMIN gain no operation authority.
SELECT IF(
    (SELECT COUNT(*) FROM base_org_resource WHERE code='iqc:action:recover'
      AND url='/api/iqc/conversation-results/{id}/actions/{actionExecutionId}/recover' AND method='POST'
      AND application='iqc-platform' AND product_code='iqc' AND status='ACTIVE') = 1
    AND (SELECT COUNT(*) FROM base_org_role_resource g
      JOIN base_org_resource r ON r.id=g.resource_id JOIN base_org_role role ON role.id=g.role_id
      WHERE r.code='iqc:action:recover' AND role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER')) = 2
    AND (SELECT COUNT(*) FROM base_org_role_resource g
      JOIN base_org_resource r ON r.id=g.resource_id JOIN base_org_role role ON role.id=g.role_id
      WHERE r.code='iqc:action:recover' AND role.code NOT IN ('IQC_ADMIN','IQC_QUALITY_MANAGER')) = 0
    AND (SELECT COUNT(*) FROM base_org_menu m JOIN base_org_menu task ON task.id='900019'
      WHERE m.id='900250' AND m.product_code='iqc' AND m.type='BUTTON' AND m.parent_id=task.parent_id
      AND JSON_UNQUOTE(JSON_EXTRACT(m.description,'$.perm'))='iqc:action:recover') = 1
    AND (SELECT COUNT(*) FROM base_org_role_menu g JOIN base_org_role role ON role.id=g.role_id
      WHERE g.menu_id='900250' AND role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER')) = 2
    AND (SELECT COUNT(*) FROM base_org_role_menu g JOIN base_org_role role ON role.id=g.role_id
      WHERE g.menu_id='900250' AND role.code NOT IN ('IQC_ADMIN','IQC_QUALITY_MANAGER')) = 0,
    'PASS', 'FAIL: manual blocked action recovery resource, button and role boundaries');
