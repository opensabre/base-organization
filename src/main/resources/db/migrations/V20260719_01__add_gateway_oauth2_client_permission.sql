-- 网关 OAuth2/OIDC 认证方式由 sysadmin 显式发布到 Nacos，独立于授权服务 Client 管理权限。
INSERT INTO base_org_resource (id, name, code, type, url, method, description,
                           created_time, updated_time, created_by, updated_by)
VALUES (323, '发布网关 OAuth2 认证方式', 'gateway:oauth2-client:update', 'gateway',
        '/gateway/routes/oauth2-clients', 'PUT', '更新并发布网关 OAuth2/OIDC 登录认证方式',
        now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE name = VALUES(name), code = VALUES(code),
    url = VALUES(url), method = VALUES(method), description = VALUES(description),
    updated_time = now(), updated_by = 'system';

INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num, created_time, updated_time, created_by, updated_by)
VALUES (159, 120, 'BUTTON', '', '', '发布 OAuth2 认证方式', '{"perm":"gateway:oauth2-client:update"}',
        4, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE description = VALUES(description), name = VALUES(name), order_num = VALUES(order_num),
    updated_time = now(), updated_by = 'system';

INSERT INTO base_org_role_resource (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
VALUES (520, 101, 323, now(), now(), 'system', 'system'),
       (521, 103, 323, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_menu (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
VALUES (101159, 101, 159, now(), now(), 'system', 'system'),
       (103159, 103, 159, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
