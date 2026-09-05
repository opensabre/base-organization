-- admin 用户仅额外绑定 IQC 专用角色，IQC 权限仍不进入 ADMIN 角色。
INSERT INTO base_org_user_role
    (id, user_id, role_id, created_time, updated_time, created_by, updated_by)
VALUES
    (105, 101, 104, now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
