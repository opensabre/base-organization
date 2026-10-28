SET NAMES utf8mb4;
-- Complete the existing menu-carried UI permission contract for split endpoint capabilities.
-- Reuse any existing IQC menu with the same permission; retain original menus and IDs.
-- Button-only entries under the existing IQC root create no page or parallel role model.
INSERT INTO base_org_menu
 (id,product_code,parent_id,type,href,icon,name,description,order_num,created_time,updated_time,created_by,updated_by)
SELECT CONCAT('IQCSB',LEFT(SHA2(resource.code,256),15)),'iqc',root.id,'BUTTON',NULL,'lock',resource.name,
 JSON_OBJECT('perm',resource.code),800,now(3),now(3),'system','system'
FROM (SELECT 'iqc:model:manage' AS old_code,'iqc:model:update' AS new_code
 UNION ALL SELECT 'iqc:model:manage' AS old_code,'iqc:model:enable' AS new_code
 UNION ALL SELECT 'iqc:model:manage' AS old_code,'iqc:model:disable' AS new_code
 UNION ALL SELECT 'iqc:skill:manage' AS old_code,'iqc:skill:update' AS new_code
 UNION ALL SELECT 'iqc:skill:manage' AS old_code,'iqc:skill:enable' AS new_code
 UNION ALL SELECT 'iqc:skill:manage' AS old_code,'iqc:skill:disable' AS new_code
 UNION ALL SELECT 'iqc:skill:manage' AS old_code,'iqc:skill:rollback' AS new_code
 UNION ALL SELECT 'iqc:skill:view' AS old_code,'iqc:skill:versions:view' AS new_code
 UNION ALL SELECT 'iqc:task:view' AS old_code,'iqc:task:detail:view' AS new_code
 UNION ALL SELECT 'iqc:task:view' AS old_code,'iqc:task:executions:view' AS new_code
 UNION ALL SELECT 'iqc:task:execute' AS old_code,'iqc:task:resume' AS new_code
 UNION ALL SELECT 'iqc:task:execute' AS old_code,'iqc:task:pause' AS new_code
 UNION ALL SELECT 'iqc:task:execute' AS old_code,'iqc:task:priority' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:detail:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:summary:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:labels:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:label-insights:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:conversation:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:hierarchy:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:conversation-history:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:feedback:view' AS new_code
 UNION ALL SELECT 'iqc:result:export' AS old_code,'iqc:result:labels:export' AS new_code
 UNION ALL SELECT 'iqc:conversation:view' AS old_code,'iqc:conversation:detail:view' AS new_code
 UNION ALL SELECT 'iqc:conversation:view' AS old_code,'iqc:conversation:api-stats:view' AS new_code
 UNION ALL SELECT 'iqc:conversation:upload' AS old_code,'iqc:conversation:batch-upload' AS new_code
 UNION ALL SELECT 'iqc:conversation:upload' AS old_code,'iqc:conversation:zip-upload' AS new_code
 UNION ALL SELECT 'iqc:conversation:upload' AS old_code,'iqc:conversation:ingest' AS new_code
 UNION ALL SELECT 'iqc:conversation:upload' AS old_code,'iqc:conversation:batch-ingest' AS new_code
 UNION ALL SELECT 'iqc:mcp:manage' AS old_code,'iqc:mcp:update' AS new_code
 UNION ALL SELECT 'iqc:mcp:manage' AS old_code,'iqc:mcp:enable' AS new_code
 UNION ALL SELECT 'iqc:mcp:manage' AS old_code,'iqc:mcp:disable' AS new_code
 UNION ALL SELECT 'iqc:scheme:manage' AS old_code,'iqc:scheme:versions:view' AS new_code
 UNION ALL SELECT 'iqc:dashboard:view' AS old_code,'iqc:bootstrap:view' AS new_code
 UNION ALL SELECT 'iqc:label:view' AS old_code,'iqc:label:detail:view' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:category:create' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:group:create' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:category:update' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:group:update' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:update' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:values:update' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:bindings:update' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:disable' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:group:disable' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:category:disable' AS new_code
 UNION ALL SELECT 'iqc:label-collection:view' AS old_code,'iqc:label-collection:detail:view' AS new_code
 UNION ALL SELECT 'iqc:label-collection:manage' AS old_code,'iqc:label-collection:update' AS new_code
 UNION ALL SELECT 'iqc:label-collection:manage' AS old_code,'iqc:label-collection:members:update' AS new_code
 UNION ALL SELECT 'iqc:label-collection:manage' AS old_code,'iqc:label-collection:publish' AS new_code
 UNION ALL SELECT 'iqc:label-collection:manage' AS old_code,'iqc:label-collection:disable' AS new_code
 UNION ALL SELECT 'iqc:label-candidate:view' AS old_code,'iqc:label-candidate:similarities:view' AS new_code
 UNION ALL SELECT 'iqc:label-candidate:review' AS old_code,'iqc:label-candidate:reject' AS new_code
 UNION ALL SELECT 'iqc:label-candidate:review' AS old_code,'iqc:label-candidate:merge' AS new_code
 UNION ALL SELECT 'iqc:agent:approve' AS old_code,'iqc:agent:reject' AS new_code
 UNION ALL SELECT 'iqc:agent:view' AS old_code,'iqc:agent:versions:view' AS new_code
 UNION ALL SELECT 'iqc:agent:view' AS old_code,'iqc:agent:versions:compare' AS new_code
 UNION ALL SELECT 'iqc:agent:view' AS old_code,'iqc:agent:version:effect:view' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:rule:submit' AS new_code
 UNION ALL SELECT 'iqc:rule:approve' AS old_code,'iqc:rule:reject' AS new_code
 UNION ALL SELECT 'iqc:rule:view' AS old_code,'iqc:rule:versions:view' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:rule:version:manage' AS new_code
 UNION ALL SELECT 'iqc:rule:view' AS old_code,'iqc:rule-set:view' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:rule-set:manage' AS new_code
 UNION ALL SELECT 'iqc:rule:view' AS old_code,'iqc:rule-set:versions:view' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:rule-set:version:manage' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:rule-set:submit' AS new_code
 UNION ALL SELECT 'iqc:rule:approve' AS old_code,'iqc:rule-set:approve' AS new_code
 UNION ALL SELECT 'iqc:rule:approve' AS old_code,'iqc:rule-set:reject' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:template:materialize' AS new_code) mapping
JOIN base_org_resource resource ON resource.code=mapping.new_code
 AND resource.application='iqc-platform' AND resource.product_code='iqc'
JOIN base_org_menu root ON root.id='900001' AND root.product_code='iqc'
WHERE NOT EXISTS (SELECT 1 FROM base_org_menu existing
 WHERE existing.product_code='iqc' AND JSON_UNQUOTE(JSON_EXTRACT(CASE WHEN JSON_VALID(existing.description) THEN existing.description ELSE '{}' END,'$.perm'))=resource.code)
ON DUPLICATE KEY UPDATE id=base_org_menu.id;

-- Preserve prior UI visibility AND require an explicit ACTIVE new API grant.
-- API-only roles without the old menu gain no new UI visibility. No default role grants.
INSERT INTO base_org_role_menu
 (id,role_id,menu_id,created_time,updated_time,created_by,updated_by)
SELECT DISTINCT CONCAT('IQCSM',LEFT(SHA2(CONCAT(CHAR_LENGTH(original.role_id),':',original.role_id,':',CHAR_LENGTH(target.id),':',target.id),256),15)),
 original.role_id,target.id,now(3),now(3),'system','system'
FROM (SELECT 'iqc:model:manage' AS old_code,'iqc:model:update' AS new_code
 UNION ALL SELECT 'iqc:model:manage' AS old_code,'iqc:model:enable' AS new_code
 UNION ALL SELECT 'iqc:model:manage' AS old_code,'iqc:model:disable' AS new_code
 UNION ALL SELECT 'iqc:skill:manage' AS old_code,'iqc:skill:update' AS new_code
 UNION ALL SELECT 'iqc:skill:manage' AS old_code,'iqc:skill:enable' AS new_code
 UNION ALL SELECT 'iqc:skill:manage' AS old_code,'iqc:skill:disable' AS new_code
 UNION ALL SELECT 'iqc:skill:manage' AS old_code,'iqc:skill:rollback' AS new_code
 UNION ALL SELECT 'iqc:skill:view' AS old_code,'iqc:skill:versions:view' AS new_code
 UNION ALL SELECT 'iqc:task:view' AS old_code,'iqc:task:detail:view' AS new_code
 UNION ALL SELECT 'iqc:task:view' AS old_code,'iqc:task:executions:view' AS new_code
 UNION ALL SELECT 'iqc:task:execute' AS old_code,'iqc:task:resume' AS new_code
 UNION ALL SELECT 'iqc:task:execute' AS old_code,'iqc:task:pause' AS new_code
 UNION ALL SELECT 'iqc:task:execute' AS old_code,'iqc:task:priority' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:detail:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:summary:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:labels:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:label-insights:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:conversation:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:hierarchy:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:conversation-history:view' AS new_code
 UNION ALL SELECT 'iqc:result:view' AS old_code,'iqc:result:feedback:view' AS new_code
 UNION ALL SELECT 'iqc:result:export' AS old_code,'iqc:result:labels:export' AS new_code
 UNION ALL SELECT 'iqc:conversation:view' AS old_code,'iqc:conversation:detail:view' AS new_code
 UNION ALL SELECT 'iqc:conversation:view' AS old_code,'iqc:conversation:api-stats:view' AS new_code
 UNION ALL SELECT 'iqc:conversation:upload' AS old_code,'iqc:conversation:batch-upload' AS new_code
 UNION ALL SELECT 'iqc:conversation:upload' AS old_code,'iqc:conversation:zip-upload' AS new_code
 UNION ALL SELECT 'iqc:conversation:upload' AS old_code,'iqc:conversation:ingest' AS new_code
 UNION ALL SELECT 'iqc:conversation:upload' AS old_code,'iqc:conversation:batch-ingest' AS new_code
 UNION ALL SELECT 'iqc:mcp:manage' AS old_code,'iqc:mcp:update' AS new_code
 UNION ALL SELECT 'iqc:mcp:manage' AS old_code,'iqc:mcp:enable' AS new_code
 UNION ALL SELECT 'iqc:mcp:manage' AS old_code,'iqc:mcp:disable' AS new_code
 UNION ALL SELECT 'iqc:scheme:manage' AS old_code,'iqc:scheme:versions:view' AS new_code
 UNION ALL SELECT 'iqc:dashboard:view' AS old_code,'iqc:bootstrap:view' AS new_code
 UNION ALL SELECT 'iqc:label:view' AS old_code,'iqc:label:detail:view' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:category:create' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:group:create' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:category:update' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:group:update' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:update' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:values:update' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:bindings:update' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:disable' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:group:disable' AS new_code
 UNION ALL SELECT 'iqc:label:manage' AS old_code,'iqc:label:category:disable' AS new_code
 UNION ALL SELECT 'iqc:label-collection:view' AS old_code,'iqc:label-collection:detail:view' AS new_code
 UNION ALL SELECT 'iqc:label-collection:manage' AS old_code,'iqc:label-collection:update' AS new_code
 UNION ALL SELECT 'iqc:label-collection:manage' AS old_code,'iqc:label-collection:members:update' AS new_code
 UNION ALL SELECT 'iqc:label-collection:manage' AS old_code,'iqc:label-collection:publish' AS new_code
 UNION ALL SELECT 'iqc:label-collection:manage' AS old_code,'iqc:label-collection:disable' AS new_code
 UNION ALL SELECT 'iqc:label-candidate:view' AS old_code,'iqc:label-candidate:similarities:view' AS new_code
 UNION ALL SELECT 'iqc:label-candidate:review' AS old_code,'iqc:label-candidate:reject' AS new_code
 UNION ALL SELECT 'iqc:label-candidate:review' AS old_code,'iqc:label-candidate:merge' AS new_code
 UNION ALL SELECT 'iqc:agent:approve' AS old_code,'iqc:agent:reject' AS new_code
 UNION ALL SELECT 'iqc:agent:view' AS old_code,'iqc:agent:versions:view' AS new_code
 UNION ALL SELECT 'iqc:agent:view' AS old_code,'iqc:agent:versions:compare' AS new_code
 UNION ALL SELECT 'iqc:agent:view' AS old_code,'iqc:agent:version:effect:view' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:rule:submit' AS new_code
 UNION ALL SELECT 'iqc:rule:approve' AS old_code,'iqc:rule:reject' AS new_code
 UNION ALL SELECT 'iqc:rule:view' AS old_code,'iqc:rule:versions:view' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:rule:version:manage' AS new_code
 UNION ALL SELECT 'iqc:rule:view' AS old_code,'iqc:rule-set:view' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:rule-set:manage' AS new_code
 UNION ALL SELECT 'iqc:rule:view' AS old_code,'iqc:rule-set:versions:view' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:rule-set:version:manage' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:rule-set:submit' AS new_code
 UNION ALL SELECT 'iqc:rule:approve' AS old_code,'iqc:rule-set:approve' AS new_code
 UNION ALL SELECT 'iqc:rule:approve' AS old_code,'iqc:rule-set:reject' AS new_code
 UNION ALL SELECT 'iqc:rule:manage' AS old_code,'iqc:template:materialize' AS new_code) mapping
JOIN base_org_menu old_menu ON old_menu.product_code='iqc' AND JSON_UNQUOTE(JSON_EXTRACT(CASE WHEN JSON_VALID(old_menu.description) THEN old_menu.description ELSE '{}' END,'$.perm'))=mapping.old_code
JOIN base_org_role_menu original ON original.menu_id=old_menu.id
JOIN base_org_resource resource ON resource.code=mapping.new_code
 AND resource.application='iqc-platform' AND resource.product_code='iqc' AND resource.status='ACTIVE'
JOIN base_org_role_resource allowed ON allowed.role_id=original.role_id AND allowed.resource_id=resource.id
JOIN base_org_menu target ON target.product_code='iqc' AND JSON_UNQUOTE(JSON_EXTRACT(CASE WHEN JSON_VALID(target.description) THEN target.description ELSE '{}' END,'$.perm'))=mapping.new_code
LEFT JOIN base_org_role_menu existing ON existing.role_id=original.role_id AND existing.menu_id=target.id
WHERE existing.id IS NULL;
