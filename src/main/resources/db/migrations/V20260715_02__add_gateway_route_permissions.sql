USE os_base_organization;
SET NAMES utf8mb4;

-- 网关路由直接发布到 Nacos，发布权限必须与只读菜单权限分离。
INSERT INTO base_org_resource (id, name, code, type, url, method, description, created_time, updated_time, created_by, updated_by)
VALUES (319, '新增并发布网关路由', 'gateway:route:create', 'gateway', '/gateway/routes', 'POST', '新增并发布网关路由', now(), now(), 'system', 'system'),
       (320, '修改并发布网关路由', 'gateway:route:update', 'gateway', '/gateway/routes/{routeId}', 'PUT', '修改并发布网关路由', now(), now(), 'system', 'system'),
       (321, '删除并发布网关路由', 'gateway:route:delete', 'gateway', '/gateway/routes/{routeId}', 'DELETE', '删除并发布网关路由', now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE name = VALUES(name), type = VALUES(type), url = VALUES(url), method = VALUES(method),
                        description = VALUES(description), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_role_resource (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
VALUES (511, 101, 319, now(), now(), 'system', 'system'),
       (512, 101, 320, now(), now(), 'system', 'system'),
       (513, 101, 321, now(), now(), 'system', 'system'),
       (514, 103, 319, now(), now(), 'system', 'system'),
       (515, 103, 320, now(), now(), 'system', 'system'),
       (516, 103, 321, now(), now(), 'system', 'system')
ON DUPLICATE KEY UPDATE role_id = VALUES(role_id), resource_id = VALUES(resource_id),
                        updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
