SET NAMES utf8mb4;

-- iqc-admin 已由既有部署创建并绑定 IQC_ADMIN；这里只补齐三个岗位账号。
-- 初始密码仅用于首次登录，交付后应立即修改。
INSERT INTO base_org_user
    (id, username, password, deleted, enabled, account_non_expired, credentials_non_expired,
     account_non_locked, name, mobile, gender, created_time, updated_time, created_by, updated_by)
VALUES
    ('2073374148729507842', 'iqc-quality-manager', '$2a$10$vYA9wKn/hVGOtwQw2eHiceeIGNBdfLYpDmbzHgBSVmOfHXPH4iYdS', 'N', true, true, true, true,
     'IQC 质量主管', NULL, NULL, now(3), now(3), 'system', 'system'),
    ('2073374148729507843', 'iqc-inspector', '$2a$10$vYA9wKn/hVGOtwQw2eHiceeIGNBdfLYpDmbzHgBSVmOfHXPH4iYdS', 'N', true, true, true, true,
     'IQC 质检员', NULL, NULL, now(3), now(3), 'system', 'system'),
    ('2073374148729507844', 'iqc-viewer', '$2a$10$vYA9wKn/hVGOtwQw2eHiceeIGNBdfLYpDmbzHgBSVmOfHXPH4iYdS', 'N', true, true, true, true,
     'IQC 查看者', NULL, NULL, now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    name = VALUES(name), enabled = VALUES(enabled), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_user_role
    (id, user_id, role_id, created_time, updated_time, created_by, updated_by)
VALUES
    ('2080908010682101763', '2073374148729507842', '105', now(3), now(3), 'system', 'system'),
    ('2080908010682101764', '2073374148729507843', '106', now(3), now(3), 'system', 'system'),
    ('2080908010682101765', '2073374148729507844', '107', now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
