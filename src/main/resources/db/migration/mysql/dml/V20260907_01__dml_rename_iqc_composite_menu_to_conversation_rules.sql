-- The former "composite rule" is a single-message structured rule and now lives in the rule library.
-- Reuse its menu identity for the dedicated DLS conversation-rule workspace so existing role grants remain valid.
UPDATE base_org_menu
SET path = '/iqc/rules/conversation',
    name = '会话规则',
    description = '{"perm":"iqc:rule:view"}',
    updated_time = CURRENT_TIMESTAMP(3),
    updated_by = 'system'
WHERE id = 900115
  AND product_code = 'iqc';
