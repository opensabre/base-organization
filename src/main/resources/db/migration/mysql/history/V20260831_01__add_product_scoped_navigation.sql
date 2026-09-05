SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS base_org_product
(
    id                 VARCHAR(20) PRIMARY KEY,
    code               VARCHAR(64) NOT NULL,
    name               VARCHAR(200) NOT NULL,
    short_name         VARCHAR(100) NOT NULL,
    description        VARCHAR(500),
    logo_url           VARCHAR(500),
    collapsed_logo_url VARCHAR(500),
    favicon_url        VARCHAR(500),
    primary_color      VARCHAR(20),
    home_path          VARCHAR(200) NOT NULL,
    enabled            BOOLEAN NOT NULL DEFAULT TRUE,
    order_num          INTEGER NOT NULL DEFAULT 0,
    created_time       DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_time       DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    created_by         VARCHAR(100) NOT NULL,
    updated_by         VARCHAR(100) NOT NULL,
    UNIQUE KEY ux_product_code (code)
) COMMENT '产品配置表';

CREATE TABLE IF NOT EXISTS base_org_product_application
(
    id           VARCHAR(20) PRIMARY KEY,
    product_code VARCHAR(64) NOT NULL,
    application  VARCHAR(100) NOT NULL,
    created_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    updated_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3),
    created_by   VARCHAR(100) NOT NULL,
    updated_by   VARCHAR(100) NOT NULL,
    UNIQUE KEY ux_product_application (application)
) COMMENT '产品应用映射表';

INSERT INTO base_org_product
    (id, code, name, short_name, description, logo_url, collapsed_logo_url, favicon_url,
     primary_color, home_path, enabled, order_num, created_time, updated_time, created_by, updated_by)
VALUES
    ('prod-common', 'COMMON', '公共能力', '公共', '所有产品可复用的菜单和资源', NULL, NULL, NULL,
     '#315EFB', '/', TRUE, 0, now(3), now(3), 'system', 'system'),
    ('prod-opensabre', 'opensabre-admin', 'OpenSabre 开发平台', 'OpenSabre', 'OpenSabre 系统与开发管理控制台',
     '/favicon.ico', '/favicon.ico', '/favicon.ico', '#409EFF', '/dashboard', TRUE, 10, now(3), now(3), 'system', 'system'),
    ('prod-iqc', 'iqc', '智能质检平台', '睿检', '基于规则与智能体的会话质量分析平台',
     NULL, NULL, NULL, '#315EFB', '/dashboard', TRUE, 20, now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE
    name = VALUES(name), short_name = VALUES(short_name), description = VALUES(description),
    home_path = VALUES(home_path), enabled = VALUES(enabled), order_num = VALUES(order_num),
    updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

INSERT INTO base_org_product_application
    (id, product_code, application, created_time, updated_time, created_by, updated_by)
VALUES
    ('pa-authorization', 'COMMON', 'base-authorization', now(3), now(3), 'system', 'system'),
    ('pa-organization', 'opensabre-admin', 'base-organization', now(3), now(3), 'system', 'system'),
    ('pa-sysadmin', 'opensabre-admin', 'base-sysadmin', now(3), now(3), 'system', 'system'),
    ('pa-gateway', 'opensabre-admin', 'base-gateway', now(3), now(3), 'system', 'system'),
    ('pa-gateway-admin', 'opensabre-admin', 'base-gateway-admin', now(3), now(3), 'system', 'system'),
    ('pa-iqc', 'iqc', 'iqc-platform', now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE product_code = VALUES(product_code), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);

ALTER TABLE base_org_menu
    ADD COLUMN product_code VARCHAR(64) NOT NULL DEFAULT 'opensabre-admin' COMMENT '归属产品编码，COMMON 表示公共菜单' AFTER id;
UPDATE base_org_menu SET product_code = 'iqc'
WHERE id BETWEEN 900000 AND 999999 OR href = '/iqc' OR href LIKE '/iqc/%';
CREATE INDEX ix_menu_product ON base_org_menu (product_code);

ALTER TABLE base_org_resource
    ADD COLUMN product_code VARCHAR(64) NOT NULL DEFAULT 'opensabre-admin' COMMENT '归属产品编码，COMMON 表示公共资源' AFTER application;
UPDATE base_org_resource SET product_code = 'iqc' WHERE application = 'iqc-platform';
UPDATE base_org_resource SET product_code = 'COMMON' WHERE application = 'base-authorization';
UPDATE base_org_resource SET product_code = 'COMMON'
WHERE application = 'base-organization'
  AND url IN ('/user/current', '/menu/current', '/products/{code}/profile');
CREATE INDEX ix_resource_product ON base_org_resource (product_code);

-- 公共个人中心作为公共菜单能力示例；是否显示仍取决于角色授权。
INSERT INTO base_org_menu
    (id, product_code, parent_id, type, href, icon, name, description, order_num,
     created_time, updated_time, created_by, updated_by)
VALUES
    ('980001', 'COMMON', '-1', 'MENU', '/profile', 'user', '个人中心', NULL, 990,
     now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE product_code = VALUES(product_code), href = VALUES(href), updated_time = VALUES(updated_time);

INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('98', LPAD(role.id, 18, '0')), role.id, '980001', now(3), now(3), 'system', 'system'
FROM base_org_role role
WHERE NOT EXISTS (SELECT 1 FROM base_org_role_menu existing
                  WHERE existing.role_id = role.id AND existing.menu_id = '980001');

-- 产品配置及菜单初始化是登录后的基础能力；管理写操作只授权平台管理员。
INSERT INTO base_org_resource
    (id, code, type, name, url, method, description, application, product_code, source, status,
     created_time, updated_time, created_by, updated_by)
VALUES
    ('880001', 'product_profile:view', 'product', '查看产品品牌', '/products/{code}/profile', 'GET',
     '加载当前产品名称、Logo 与主题', 'base-organization', 'COMMON', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('880002', 'product_menu:view', 'menu', '查看当前产品菜单', '/menu/current', 'GET',
     '加载当前用户在当前产品中的授权菜单', 'base-organization', 'COMMON', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('880003', 'product_manager:view', 'product', '查看产品', '/products', 'GET',
     '查询产品配置', 'base-organization', 'opensabre-admin', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('880004', 'product_manager:add', 'product', '新增产品', '/products', 'POST',
     '新增产品配置', 'base-organization', 'opensabre-admin', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system'),
    ('880005', 'product_manager:edit', 'product', '修改产品', '/products/{code}', 'PUT',
     '修改产品配置', 'base-organization', 'opensabre-admin', 'ANNOTATION', 'ACTIVE', now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE name = VALUES(name), url = VALUES(url), method = VALUES(method),
    product_code = VALUES(product_code), source = VALUES(source), status = VALUES(status), updated_time = VALUES(updated_time);

INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('87', LPAD(role.id, 8, '0'), RIGHT(resource.id, 10)), role.id, resource.id,
       now(3), now(3), 'system', 'system'
FROM base_org_role role
JOIN base_org_resource resource ON resource.id IN ('880001', '880002')
WHERE NOT EXISTS (SELECT 1 FROM base_org_role_resource existing
                  WHERE existing.role_id = role.id AND existing.resource_id = resource.id);

INSERT INTO base_org_role_resource
    (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
SELECT CONCAT('86', LPAD(resource.id, 18, '0')), '101', resource.id,
       now(3), now(3), 'system', 'system'
FROM base_org_resource resource
WHERE resource.id IN ('880003', '880004', '880005')
  AND NOT EXISTS (SELECT 1 FROM base_org_role_resource existing
                  WHERE existing.role_id = '101' AND existing.resource_id = resource.id);

INSERT INTO base_org_menu
    (id, product_code, parent_id, type, href, icon, name, description, order_num,
     created_time, updated_time, created_by, updated_by)
VALUES
    ('280', 'opensabre-admin', '101', 'MENU', '/admin/product', 'application', '产品管理',
     '{"routeName":"ProductManagement","component":"system/product/index","visible":1,"perm":"product_manager:view"}',
     85, now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE product_code = VALUES(product_code), parent_id = VALUES(parent_id), href = VALUES(href),
    name = VALUES(name), description = VALUES(description), order_num = VALUES(order_num), updated_time = VALUES(updated_time);

INSERT INTO base_org_role_menu
    (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
VALUES ('280101', '101', '280', now(3), now(3), 'system', 'system')
ON DUPLICATE KEY UPDATE updated_time = VALUES(updated_time), updated_by = VALUES(updated_by);
