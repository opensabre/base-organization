SET NAMES utf8mb4;

-- IQC 岗位账号沿用 iqc-admin 的默认密码；首次登录后应立即修改。
UPDATE base_org_user target
JOIN base_org_user source ON source.username = 'iqc-admin'
SET target.password = source.password,
    target.updated_time = now(3),
    target.updated_by = 'system'
WHERE target.username IN ('iqc-quality-manager', 'iqc-inspector', 'iqc-viewer');
