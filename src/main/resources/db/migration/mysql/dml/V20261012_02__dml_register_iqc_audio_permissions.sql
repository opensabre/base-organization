-- Sensitive audio operations are independent from task/conversation read permissions.
INSERT INTO base_org_resource
 (id,name,code,type,url,method,description,application,product_code,source,status,created_time,updated_time,created_by,updated_by)
VALUES
 ('900258','上传原始音频','iqc:audio:upload','iqc','/api/iqc/conversations/{id}/audio','POST','绑定经过实际媒体校验的原始音频','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900259','查看音频信息','iqc:audio:view','iqc','/api/iqc/conversations/{id}/audio','GET','查看授权会话的音频元数据','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system'),
 ('900260','读取原始音频','iqc:audio:read','iqc','/api/iqc/conversations/{id}/audio/content','GET','敏感原始音频读取及Range播放','iqc-platform','iqc','ANNOTATION','ACTIVE',now(3),now(3),'system','system')
ON DUPLICATE KEY UPDATE name=VALUES(name),type=VALUES(type),description=VALUES(description),application=VALUES(application),product_code=VALUES(product_code),source=VALUES(source),status=VALUES(status),updated_time=VALUES(updated_time),updated_by=VALUES(updated_by);

INSERT INTO base_org_role_resource (id,role_id,resource_id,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCPR',LEFT(SHA2(CONCAT(CHAR_LENGTH(role.id),':',role.id,':',CHAR_LENGTH(resource.id),':',resource.id),256),15)),role.id,resource.id,now(3),now(3),'system','system'
FROM base_org_role role CROSS JOIN base_org_resource resource
LEFT JOIN base_org_role_resource existing ON existing.role_id=role.id AND existing.resource_id=resource.id
WHERE resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE'
 AND resource.code IN ('iqc:audio:upload','iqc:audio:view','iqc:audio:read') AND existing.id IS NULL
 AND role.code IN ('IQC_ADMIN','IQC_QUALITY_MANAGER');
