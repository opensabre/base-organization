SET NAMES utf8mb4;

-- 一条资源只对应一个 URL/方法。前端沿用 iqc:review:* 按钮权限，网关使用独立资源码。
INSERT INTO base_org_resource
    (id, name, code, type, url, method, description, application, product_code, source, status,
     created_time, updated_time, created_by, updated_by)
VALUES
    ('900140', '发起标签值复核', 'iqc:review:label:create', 'iqc', '/api/iqc/quality-operations/label-results/{labelResultId}/reviews', 'POST', '为冻结标签值发起复核', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900141', '查看标签值复核历史', 'iqc:review:label:history', 'iqc', '/api/iqc/quality-operations/label-results/{labelResultId}/reviews', 'GET', '查看标签值复核轮次', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900142', '查看标签值复核待办', 'iqc:review:label:queue', 'iqc', '/api/iqc/quality-operations/label-reviews', 'GET', '按任务范围查询标签复核轮次', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('900143', '处理标签值复核', 'iqc:review:label:decide', 'iqc', '/api/iqc/quality-operations/label-reviews/{reviewId}/decision', 'POST', '修正或退回标签值复核', 'iqc-platform', 'iqc', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    status = VALUES(status), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

-- 质量主管与 IQC 管理员沿用原复核创建/裁决能力；质检员、查看者仅可查询。
INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('IQCLR', LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id), ':', role.id, ':',
                                    CHAR_LENGTH(resource.id), ':', resource.id), 256), 15)),
       role.id, resource.id,
       now(3), now(3), 'system', 'system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing
       ON existing.role_id = role.id AND existing.resource_id = resource.id
WHERE resource.code IN ('iqc:review:label:create', 'iqc:review:label:history',
                        'iqc:review:label:queue', 'iqc:review:label:decide')
  AND resource.application = 'iqc-platform' AND resource.product_code = 'iqc' AND resource.status = 'ACTIVE'
  AND (role.code IN ('IQC_ADMIN', 'IQC_QUALITY_MANAGER')
       OR (role.code IN ('IQC_INSPECTOR', 'IQC_VIEWER')
           AND resource.code IN ('iqc:review:label:history', 'iqc:review:label:queue')))
  AND existing.id IS NULL;
