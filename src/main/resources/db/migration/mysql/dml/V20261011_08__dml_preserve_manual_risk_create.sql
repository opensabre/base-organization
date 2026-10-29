-- Preserve the actual background operation independently of HTTP mapping snapshots.
-- Retains IDs and role relationships seeded by V20261011_03.
UPDATE base_org_resource
SET source='MANUAL',status='ACTIVE',updated_time=now(3),updated_by='system'
WHERE code='iqc:risk:create' AND application='iqc-platform' AND product_code='iqc'
  AND method='BACKGROUND' AND url='/internal/iqc/risk-events/create';
