SET NAMES utf8mb4;

-- Business paging is a separate URL/method resource; keep legacy result permissions unchanged.
INSERT INTO base_org_resource
    (id, name, code, type, url, method, description, application, product_code, source, status,
     created_time, updated_time, created_by, updated_by)
VALUES
    ('900144', '查看业务会话结果', 'iqc:result:business:view', 'iqc', '/api/iqc/results/business', 'GET',
     '按当前会话业务结果分页查询', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE',
     now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    status = VALUES(status), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('IQCBR', LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id), ':', role.id, ':',
                                    CHAR_LENGTH(resource.id), ':', resource.id), 256), 15)),
       role.id, resource.id,
       now(3), now(3), 'system', 'system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing
       ON existing.role_id = role.id AND existing.resource_id = resource.id
WHERE resource.code = 'iqc:result:business:view'
  AND resource.application = 'iqc-platform' AND resource.product_code = 'iqc' AND resource.status = 'ACTIVE'
  AND role.code IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER', 'IQC_INSPECTOR', 'IQC_VIEWER')
  AND existing.id IS NULL;
