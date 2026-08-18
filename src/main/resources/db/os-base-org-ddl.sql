SET NAMES utf8;

-- 用户组表
DROP TABLE IF EXISTS base_org_group;
CREATE TABLE base_org_group
(
    id           VARCHAR(20) PRIMARY KEY COMMENT 'id',
    parent_id    VARCHAR(20)  NOT NULL COMMENT '用户组父id',
    name         VARCHAR(200) COMMENT '用户组名称',
    description  VARCHAR(500) COMMENT '描述',
    deleted      VARCHAR(1)   NOT NULL DEFAULT 'N' COMMENT '是否已删除Y：已删除，N：未删除',
    created_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
    updated_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
    created_by   VARCHAR(100) NOT NULL COMMENT '创建人',
    updated_by   VARCHAR(100) NOT NULL COMMENT '更新人'
) COMMENT '用户组表';

-- 岗位表
DROP TABLE IF EXISTS base_org_position;
CREATE TABLE base_org_position
(
    id           VARCHAR(20) PRIMARY KEY COMMENT 'id',
    name         VARCHAR(200) COMMENT '岗位名称',
    description  VARCHAR(500) COMMENT '描述',
    deleted      VARCHAR(1)   NOT NULL DEFAULT 'N' COMMENT '是否已删除Y：已删除，N：未删除',
    created_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
    updated_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
    created_by   VARCHAR(100) NOT NULL COMMENT '创建人',
    updated_by   VARCHAR(100) NOT NULL COMMENT '更新人'
) COMMENT '岗位表';

-- 菜单表
DROP TABLE IF EXISTS base_org_menu;
CREATE TABLE base_org_menu
(
    id           VARCHAR(20) PRIMARY KEY COMMENT 'id',
    parent_id    VARCHAR(20)  NOT NULL COMMENT '父菜单id',
    type         VARCHAR(100) COMMENT '菜单类型',
    href         VARCHAR(200) COMMENT '菜单路径',
    icon         VARCHAR(200) COMMENT '菜单图标',
    name         VARCHAR(200) COMMENT '菜单名称',
    description  VARCHAR(500) COMMENT '描述',
    order_num    INTEGER COMMENT '创建时间',
    created_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
    updated_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
    created_by   VARCHAR(100) NOT NULL COMMENT '创建人',
    updated_by   VARCHAR(100) NOT NULL COMMENT '更新人'
) COMMENT '菜单表';


-- 用户和组关系表
DROP TABLE IF EXISTS base_org_user_group;
CREATE TABLE base_org_user_group
(
    id           VARCHAR(20) PRIMARY KEY COMMENT 'id',
    user_id      VARCHAR(20)  NOT NULL COMMENT '用户id',
    group_id     VARCHAR(20)  NOT NULL COMMENT '用户组id',
    created_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
    updated_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
    created_by   VARCHAR(100) NOT NULL COMMENT '创建人',
    updated_by   VARCHAR(100) NOT NULL COMMENT '更新人'
) COMMENT '用户和组关系表';


-- 用户和岗位系表
DROP TABLE IF EXISTS base_org_user_position;
CREATE TABLE base_org_user_position
(
    id           VARCHAR(20) PRIMARY KEY COMMENT 'id',
    user_id      VARCHAR(20)  NOT NULL COMMENT '用户id',
    position_id  VARCHAR(20)  NOT NULL COMMENT '角色id',
    created_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
    updated_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
    created_by   VARCHAR(100) NOT NULL COMMENT '创建人',
    updated_by   VARCHAR(100) NOT NULL COMMENT '更新人'
) COMMENT '用户和岗位关系表';


-- 角色和菜单关系表
DROP TABLE IF EXISTS base_org_role_menu;
CREATE TABLE base_org_role_menu
(
    id           VARCHAR(20) PRIMARY KEY COMMENT 'id',
    menu_id      VARCHAR(20)  NOT NULL COMMENT '菜单id',
    role_id      VARCHAR(20)  NOT NULL COMMENT '角色id',
    created_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
    updated_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
    created_by   VARCHAR(100) NOT NULL COMMENT '创建人',
    updated_by   VARCHAR(100) NOT NULL COMMENT '更新人'
) COMMENT '角色和菜单关系表';

--  用户表
DROP TABLE IF EXISTS base_org_user;
CREATE TABLE base_org_user
(
    id                      VARCHAR(20) PRIMARY KEY COMMENT '用户id',
    username                VARCHAR(100) NOT NULL COMMENT '用户名',
    password                VARCHAR(100) NOT NULL COMMENT '用户密码密文',
    name                    VARCHAR(200) COMMENT '用户姓名',
    mobile                  VARCHAR(20) COMMENT '用户手机',
    description             VARCHAR(500) COMMENT '简介',
    gender                  VARCHAR(20) COMMENT '性别',
    deleted                 VARCHAR(1)   NOT NULL DEFAULT 'N' COMMENT '是否已删除Y：已删除，N：未删除',
    enabled                 BOOLEAN COMMENT '是否有效用户',
    account_non_expired     BOOLEAN COMMENT '账号是否未过期',
    credentials_non_expired BOOLEAN COMMENT '密码是否未过期',
    account_non_locked      BOOLEAN COMMENT '是否未锁定',
    created_time            DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
    updated_time            DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
    created_by              VARCHAR(100) NOT NULL COMMENT '创建人',
    updated_by              VARCHAR(100) NOT NULL COMMENT '更新人'
) COMMENT '用户表';
CREATE UNIQUE INDEX ux_user_username
    ON base_org_user (username);
CREATE UNIQUE INDEX ux_user_mobile
    ON base_org_user (mobile);

--  角色表
DROP TABLE IF EXISTS base_org_role;
CREATE TABLE base_org_role
(
    id           VARCHAR(20) PRIMARY KEY COMMENT '角色id',
    code         VARCHAR(100) NOT NULL COMMENT '角色code',
    name         VARCHAR(200) COMMENT '角色名称',
    description  VARCHAR(500) COMMENT '简介',
    created_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
    updated_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
    created_by   VARCHAR(100) NOT NULL COMMENT '创建人',
    updated_by   VARCHAR(100) NOT NULL COMMENT '更新人'
) COMMENT '角色表';

-- 资源表
DROP TABLE IF EXISTS base_org_resource;
CREATE TABLE base_org_resource
(
    id           VARCHAR(20) PRIMARY KEY COMMENT '资源id',
    code         VARCHAR(100) NOT NULL COMMENT '资源code',
    type         VARCHAR(100) NOT NULL COMMENT '资源类型',
    name         VARCHAR(200) NOT NULL COMMENT '资源名称',
    url          VARCHAR(200) NOT NULL COMMENT '资源url',
    method       VARCHAR(20)  NOT NULL COMMENT '资源方法',
    description  VARCHAR(500) COMMENT '简介',
    application  VARCHAR(100) NOT NULL DEFAULT 'legacy' COMMENT '来源应用',
    source       VARCHAR(20)  NOT NULL DEFAULT 'MANUAL' COMMENT '资源来源',
    status       VARCHAR(20)  NOT NULL DEFAULT 'ACTIVE' COMMENT '注册状态',
    handler      VARCHAR(300) COMMENT '处理器方法',
    first_seen_at DATETIME COMMENT '首次发现时间',
    last_seen_at DATETIME COMMENT '最后发现时间',
    missing_since DATETIME COMMENT '首次缺失时间',
    app_version  VARCHAR(100) COMMENT '应用版本',
    created_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
    updated_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
    created_by   VARCHAR(100) NOT NULL COMMENT '创建人',
    updated_by   VARCHAR(100) NOT NULL COMMENT '更新人'
) COMMENT '资源表';
CREATE UNIQUE INDEX ux_resource_code
    ON base_org_resource (code);
CREATE INDEX ix_resource_endpoint
    ON base_org_resource (application, method, url);

-- 用户和角色关系表
DROP TABLE IF EXISTS base_org_user_role;
CREATE TABLE base_org_user_role
(
    id           VARCHAR(20) PRIMARY KEY COMMENT '关系id',
    user_id      VARCHAR(20)  NOT NULL COMMENT '用户id',
    role_id      VARCHAR(20)  NOT NULL COMMENT '角色id',
    created_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
    updated_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
    created_by   VARCHAR(100) NOT NULL COMMENT '创建人',
    updated_by   VARCHAR(100) NOT NULL COMMENT '更新人'
) COMMENT '用户和角色关系表';

-- 角色和资源关系表
DROP TABLE IF EXISTS base_org_role_resource;
CREATE TABLE base_org_role_resource
(
    id           VARCHAR(20) PRIMARY KEY COMMENT '关系id',
    resource_id  VARCHAR(20)  NOT NULL COMMENT '角色id',
    role_id      VARCHAR(20)  NOT NULL COMMENT '资源id',
    created_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) COMMENT '创建时间',
    updated_time DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3) ON UPDATE CURRENT_TIMESTAMP(3) COMMENT '更新时间',
    created_by   VARCHAR(100) NOT NULL COMMENT '创建人',
    updated_by   VARCHAR(100) NOT NULL COMMENT '更新人'
) COMMENT '角色和资源关系表';

-- DML准备初始化数据

-- 用户
INSERT INTO base_org_user (id, username, password, deleted, enabled, account_non_expired, credentials_non_expired, account_non_locked, name, mobile, gender, created_time, updated_time, created_by, updated_by)
VALUES
(101, 'admin', '$2a$10$vYA9wKn/hVGOtwQw2eHiceeIGNBdfLYpDmbzHgBSVmOfHXPH4iYdS', 'N', true, true, true, true,
 '超级管理员', '', 'M', now(3), now(3), 'system', 'system'),
(102, 'zhoutaoo', '$2a$10$vYA9wKn/hVGOtwQw2eHiceeIGNBdfLYpDmbzHgBSVmOfHXPH4iYdS', 'N', true, true, true, true,
 '周涛', 15619841000, 'M', now(3), now(3), 'system', 'system');
-- 角色
INSERT INTO base_org_role (id, code, name, description, created_time, updated_time, created_by, updated_by)
VALUES (101, 'ADMIN', '超级管理员', '公司IT总负责人', now(3), now(3), 'system', 'system'),
       (102, 'FIN', '财务', '财务', now(3), now(3), 'system', 'system'),
       (103, 'IT', 'IT', 'IT角色', now(3), now(3), 'system', 'system');
-- 资源
INSERT INTO base_org_resource (id, name, code, type, url, method, description, created_time, updated_time, created_by, updated_by)
VALUES (101, '新增用户', 'user_manager:btn_add', 'user', '/user', 'POST', '新增用户功能', now(3), now(3), 'system', 'system'),
       (102, '编辑用户', 'user_manager:btn_edit', 'user', '/user/{id}', 'PUT', '编辑用户功能', now(3), now(3), 'system', 'system'),
       (103, '删除用户', 'user_manager:btn_del', 'user', '/user/{id}', 'DELETE', '根据用户id删除用户', now(3), now(3), 'system', 'system'),
       (104, '查看用户', 'user_manager:view', 'user', '/user/{id}', 'GET', '根据用户id获取用户', now(3), now(3), 'system', 'system'),
       (105, '搜索用户', 'user_manager:query', 'user', '/user/conditions', 'POST', '根据条件查询用户', now(3), now(3), 'system', 'system'),
       (106, '获取用户', 'user_manager:get', 'user', '/user', 'GET', '根据唯一标识获取用户', now(3), now(3), 'system', 'system'),
       (201, '新增角色', 'role_manager:btn_add', 'role', '/role', 'POST', '新增角色功能', now(3), now(3), 'system', 'system'),
       (202, '编辑角色', 'role_manager:btn_edit', 'role', '/role/{id}', 'PUT', '编辑角色功能', now(3), now(3), 'system', 'system'),
       (203, '删除角色', 'role_manager:btn_del', 'role', '/role/{id}', 'DELETE', '根据id删除角色', now(3), now(3), 'system', 'system'),
       (204, '查看角色', 'role_manager:view', 'role', '/role/{id}', 'GET', '根据id获取角色', now(3), now(3), 'system', 'system'),
       (205, '根据用户id查询角色', 'role_manager:user', 'role', '/role/user/{userId}', 'GET', '根据用户id获取用户所拥有的角色集', now(3), now(3), 'system', 'system'),
       (206, '获取所有角色', 'role_manager:all', 'role', '/role/all', 'GET', '获取所有角色', now(3), now(3), 'system', 'system'),
       (207, '搜索角色', 'role_manager:query', 'role', '/role/conditions', 'POST', '根据条件查询角色', now(3), now(3), 'system', 'system'),
       (301, '根据父id查询组', 'group_manager:parent', 'group', '/group/parent/{id}', 'GET', '根据父id查询用户组', now(3), now(3), 'system', 'system'),
       (302, '查看用户组', 'group_manager:get', 'group', '/group/{id}', 'GET', '根据id查询用户组', now(3), now(3), 'system', 'system'),
       (303, '搜索用户组', 'group_manager:query', 'group', '/group/conditions', 'POST', '根据条件查询用户组信息', now(3), now(3), 'system', 'system'),
       (304, '删除用户组', 'group_manager:del', 'group', '/group/{id}', 'DELETE', '根据用户id删除用户组', now(3), now(3), 'system', 'system'),
       (305, '编辑用户组', 'group_manager:edit', 'group', '/group/{id}', 'PUT', '修改用户组', now(3), now(3), 'system', 'system'),
       (306, '新增用户组', 'group_manager:add', 'group', '/group', 'POST', '新增用户组', now(3), now(3), 'system', 'system'),
       (307, '新增网关路由', 'gateway_manager:add', 'gateway', '/gateway/routes', 'POST', '新增网关路由', now(3), now(3), 'system', 'system'),
       (308, '修改网关路由', 'gateway_manager:edit', 'gateway', '/gateway/routes/{id}', 'PUT', '修改网关路由', now(3), now(3), 'system', 'system'),
       (309, '删除网关路由', 'gateway_manager:adel', 'gateway', '/gateway/routes/{id}', 'DELETE', '删除网关路由', now(3), now(3), 'system', 'system'),
       (310, '查看网关路由', 'gateway_manager:view', 'gateway', '/gateway/routes/{id}', 'GET', '查看网关路由', now(3), now(3), 'system', 'system'),
       (311, '搜索网关路由', 'gateway_manager:query', 'gateway', '/gateway/routes/conditions', 'POST', '搜索网关路由', now(3), now(3), 'system', 'system'),
       (312, '全局加载路由', 'gateway_manager:overload', 'gateway', '/gateway/routes/overload', 'POST', '全局加载路由', now(3), now(3), 'system', 'system'),
       (313, '新增网关路由', 'resource_manager:add', 'resource', '/resource', 'POST', '新增资源路由', now(3), now(3), 'system', 'system'),
       (314, '修改网关路由', 'resource_manager:edit', 'resource', '/resource/{id}', 'PUT', '修改资源', now(3), now(3), 'system', 'system'),
       (315, '删除网关路由', 'resource_manager:adel', 'resource', '/resource/{id}', 'DELETE', '删除资源', now(3), now(3), 'system', 'system'),
       (316, '查看网关路由', 'resource_manager:view', 'resource', '/resource/{id}', 'GET', '查看资源', now(3), now(3), 'system', 'system'),
       (317, '搜索网关路由', 'resource_manager:query', 'resource', '/resource/conditions', 'POST', '搜索资源', now(3), now(3), 'system', 'system'),
       (318, '全局加载路由', 'resource_manager:all', 'resource', '/resource/all', 'GET', '查询全部资源', now(3), now(3), 'system', 'system'),
       (322, '获取当前登录用户', 'user_manager:current', 'user', '/user/current', 'GET', '获取当前认证用户信息', now(3), now(3), 'system', 'system'),
       (323, '发布网关 OAuth2 认证方式', 'gateway:oauth2-client:update', 'gateway', '/gateway/routes/oauth2-clients', 'PUT', '更新并发布网关 OAuth2/OIDC 登录认证方式', now(3), now(3), 'system', 'system'),
       (330, '查询OAuth2授权记录', 'auth:authorization:query', 'authorization', '/api/auth/authorizations/conditions', 'POST', '分页查询OAuth2服务端授权记录', now(3), now(3), 'system', 'system'),
       (331, '查看OAuth2授权记录', 'auth:authorization:view', 'authorization', '/api/auth/authorizations/{id}', 'GET', '查看OAuth2服务端授权详情', now(3), now(3), 'system', 'system'),
       (332, '终止OAuth2服务端授权', 'auth:authorization:revoke', 'authorization', '/api/auth/authorizations/{id}', 'DELETE', '删除服务端授权并阻止Refresh Token继续使用', now(3), now(3), 'system', 'system'),
       (333, '清理已失效OAuth2授权记录', 'auth:authorization:cleanup', 'authorization', '/api/auth/authorizations/expired/cleanup', 'DELETE', '删除所有Token、授权码和设备码均已过期的服务端授权记录', now(3), now(3), 'system', 'system'),
       (334, '查询客户端授权记录', 'auth:consent:query', 'authorization', '/api/auth/authorization-consents/conditions', 'POST', '分页查询用户授予OAuth2客户端的权限记录', now(3), now(3), 'system', 'system'),
       (335, '查看客户端授权记录', 'auth:consent:view', 'authorization', '/api/auth/authorization-consents', 'GET', '查看用户授予OAuth2客户端的权限详情', now(3), now(3), 'system', 'system'),
       (336, '删除客户端授权记录', 'auth:consent:remove', 'authorization', '/api/auth/authorization-consents', 'DELETE', '删除客户端授权同意，用户下次授权时需要重新同意', now(3), now(3), 'system', 'system'),
       (337, '查询网关黑白名单', 'gateway:access-list:read', 'gateway', '/api/gateway-admin/policies', 'GET', '查询网关 IP 黑白名单策略', now(3), now(3), 'system', 'system'),
       (338, '修改网关黑白名单', 'gateway:access-list:update', 'gateway', '/api/gateway-admin/policies', 'PUT', '保存网关 IP 黑白名单策略草稿', now(3), now(3), 'system', 'system'),
       (339, '发布网关黑白名单', 'gateway:access-list:publish', 'gateway', '/api/gateway-admin/releases', 'POST', '校验并发布网关配置版本', now(3), now(3), 'system', 'system'),
       (340, '查询网关全局规则', 'gateway:global-rule:read', 'gateway', '/api/gateway-admin/policies', 'GET', '查询网关全局安全响应头和跨域规则', now(3), now(3), 'system', 'system'),
       (341, '修改网关全局过滤器', 'gateway:global-rule:update', 'gateway', '/api/gateway-admin/policies', 'PUT', '保存网关 default-filters 草稿', now(3), now(3), 'system', 'system'),
       (342, '修改网关跨域规则', 'gateway:cors:update', 'gateway', '/api/gateway-admin/policies', 'PUT', '保存网关全局跨域规则草稿', now(3), now(3), 'system', 'system'),
       (343, '发布网关全局规则', 'gateway:global-rule:publish', 'gateway', '/api/gateway-admin/releases', 'POST', '预检并发布网关全局规则', now(3), now(3), 'system', 'system');

-- 用户关系授权
INSERT INTO base_org_user_role (id, user_id, role_id, created_time, updated_time, created_by, updated_by)
VALUES (101, 101, 101, now(3), now(3), 'system', 'system'),
       (102, 102, 101, now(3), now(3), 'system', 'system'),
       (103, 102, 103, now(3), now(3), 'system', 'system');
-- 角色与资源关系表
INSERT INTO base_org_role_resource (id, role_id, resource_id, created_time, updated_time, created_by, updated_by)
VALUES (101, 101, 101, now(3), now(3), 'system', 'system'),
       (102, 101, 102, now(3), now(3), 'system', 'system'),
       (103, 101, 103, now(3), now(3), 'system', 'system'),
       (104, 101, 104, now(3), now(3), 'system', 'system'),
       (105, 101, 105, now(3), now(3), 'system', 'system'),
       (106, 101, 106, now(3), now(3), 'system', 'system'),
       (201, 101, 201, now(3), now(3), 'system', 'system'),
       (202, 101, 202, now(3), now(3), 'system', 'system'),
       (203, 101, 203, now(3), now(3), 'system', 'system'),
       (204, 101, 204, now(3), now(3), 'system', 'system'),
       (205, 101, 205, now(3), now(3), 'system', 'system'),
       (206, 101, 206, now(3), now(3), 'system', 'system'),
       (207, 101, 207, now(3), now(3), 'system', 'system'),
       (208, 101, 301, now(3), now(3), 'system', 'system'),
       (209, 101, 302, now(3), now(3), 'system', 'system'),
       (210, 101, 303, now(3), now(3), 'system', 'system'),
       (211, 101, 304, now(3), now(3), 'system', 'system'),
       (212, 101, 305, now(3), now(3), 'system', 'system'),
       (213, 101, 306, now(3), now(3), 'system', 'system'),
       (401, 101, 307, now(3), now(3), 'system', 'system'),
       (402, 101, 308, now(3), now(3), 'system', 'system'),
       (403, 101, 309, now(3), now(3), 'system', 'system'),
       (404, 101, 310, now(3), now(3), 'system', 'system'),
       (405, 101, 311, now(3), now(3), 'system', 'system'),
       (406, 101, 312, now(3), now(3), 'system', 'system'),
       (501, 101, 313, now(3), now(3), 'system', 'system'),
       (502, 101, 314, now(3), now(3), 'system', 'system'),
       (503, 101, 315, now(3), now(3), 'system', 'system'),
       (504, 101, 316, now(3), now(3), 'system', 'system'),
       (505, 101, 317, now(3), now(3), 'system', 'system'),
       (506, 101, 318, now(3), now(3), 'system', 'system'),
       (517, 101, 322, now(3), now(3), 'system', 'system'),
       (518, 102, 322, now(3), now(3), 'system', 'system'),
       (519, 103, 322, now(3), now(3), 'system', 'system'),
       (520, 101, 323, now(3), now(3), 'system', 'system'),
       (521, 103, 323, now(3), now(3), 'system', 'system'),
       (522, 101, 330, now(3), now(3), 'system', 'system'),
       (523, 101, 331, now(3), now(3), 'system', 'system'),
       (524, 101, 332, now(3), now(3), 'system', 'system'),
       (525, 103, 330, now(3), now(3), 'system', 'system'),
       (526, 103, 331, now(3), now(3), 'system', 'system'),
       (527, 103, 332, now(3), now(3), 'system', 'system'),
       (528, 101, 333, now(3), now(3), 'system', 'system'),
       (529, 103, 333, now(3), now(3), 'system', 'system'),
       (530, 101, 334, now(3), now(3), 'system', 'system'),
       (531, 101, 335, now(3), now(3), 'system', 'system'),
       (532, 101, 336, now(3), now(3), 'system', 'system'),
       (533, 103, 334, now(3), now(3), 'system', 'system'),
       (534, 103, 335, now(3), now(3), 'system', 'system'),
       (535, 103, 336, now(3), now(3), 'system', 'system'),
       (536, 101, 337, now(3), now(3), 'system', 'system'),
       (537, 101, 338, now(3), now(3), 'system', 'system'),
       (538, 101, 339, now(3), now(3), 'system', 'system'),
       (539, 103, 337, now(3), now(3), 'system', 'system'),
       (540, 103, 338, now(3), now(3), 'system', 'system'),
       (541, 103, 339, now(3), now(3), 'system', 'system'),
       (542, 101, 340, now(3), now(3), 'system', 'system'),
       (543, 101, 341, now(3), now(3), 'system', 'system'),
       (544, 101, 342, now(3), now(3), 'system', 'system'),
       (545, 101, 343, now(3), now(3), 'system', 'system'),
       (546, 103, 340, now(3), now(3), 'system', 'system'),
       (547, 103, 341, now(3), now(3), 'system', 'system'),
       (548, 103, 342, now(3), now(3), 'system', 'system'),
       (549, 103, 343, now(3), now(3), 'system', 'system');

-- 岗位
INSERT INTO base_org_position (id, name, description, created_time, updated_time, created_by, updated_by)
VALUES (101, '首席执行官', '公司CEO，负责公司整体运转', now(3), now(3), 'system', 'system'),
       (102, '首席运营官', '公司COO，负责公司整体运营', now(3), now(3), 'system', 'system'),
       (103, '首席技术官', '公司CTO，负责公司整体运营', now(3), now(3), 'system', 'system');
-- 用户组
INSERT INTO base_org_group (id, parent_id, name, description, created_time, updated_time, created_by, updated_by)
VALUES (101, -1, '总公司', '总公司', now(3), now(3), 'system', 'system'),
       (102, 101, '上海分公司', '上海分公司', now(3), now(3), 'system', 'system'),
       (103, 102, '研发部门', '负责产品研发', now(3), now(3), 'system', 'system'),
       (104, 102, '产品部门', '负责产品设计', now(3), now(3), 'system', 'system'),
       (105, 102, '运营部门', '负责公司产品运营', now(3), now(3), 'system', 'system'),
       (106, 102, '销售部门', '负责公司产品销售', now(3), now(3), 'system', 'system'),
       (107, 101, '北京分公司', '北京分公司', now(3), now(3), 'system', 'system');
-- 菜单
INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num, created_time, updated_time, created_by, updated_by)
VALUES (101, -1, 'MENU', '/admin', 'setting', '基础管理', '用户，角色，菜单，组织等基础数据管理', 0, now(3), now(3), 'system', 'system'),
       (102, 101, 'MENU', '/admin/users', 'user', '用户管理', '用户新增，修改，查看，删除', 10, now(3), now(3), 'system', 'system'),
       (103, 101, 'MENU', '/admin/menus', 'menu', '菜单管理', '菜单新增，修改，删除', 20, now(3), now(3), 'system', 'system'),
       (104, 101, 'MENU', '/admin/roles', 'role', '角色管理', '角色新增，修改，删除和菜单授权', 30, now(3), now(3), 'system', 'system'),
       (105, 101, 'MENU', '/admin/groups', 'tree', '组织管理', '组织新增，修改，查看，删除', 40, now(3), now(3), 'system', 'system'),
       (106, 101, 'MENU', '/admin/resources', 'api', '资源管理', '功能资源新增，修改，查看，删除', 50, now(3), now(3), 'system', 'system'),
       (107, 101, 'MENU', '/admin/positions', 'project', '岗位管理', '岗位新增，修改，查看，删除', 60, now(3), now(3), 'system', 'system'),
       (108, -1, 'MENU', '/auth', 'client', '安全认证', '安全认证服务管理', 70, now(3), now(3), 'system', 'system'),
       (109, -1, 'MENU', '/sysadmin', 'document', '系统管理', '审计与系统运维管理', 80, now(3), now(3), 'system', 'system'),
       (110, 108, 'MENU', '/auth/client', 'client', '客户端管理', '{"routeName":"OAuthClientManagement","component":"auth/client-management/index","visible":1}', 10, now(3), now(3), 'system', 'system'),
       (111, 109, 'MENU', '/sysadmin/audit-log', 'document', '审计日志', '审计日志查询，清理', 10, now(3), now(3), 'system', 'system'),
       (112, 109, 'MENU', '/sysadmin/dicts', 'dict', '字典管理', '{"routeName":"Dict","component":"system/dict/index","visible":1}', 20, now(3), now(3), 'system', 'system'),
       (113, 109, 'MENU', '/sysadmin/dict-items', 'dict', '字典项', '{"routeName":"DictItem","component":"system/dict/dict-item","visible":0}', 30, now(3), now(3), 'system', 'system'),
       (114, 109, 'MENU', '/sysadmin/captcha-scenes', 'captcha', '验证码管理', '{"routeName":"CaptchaScenes","component":"sysadmin/captcha-scenes/index","visible":1}', 40, now(3), now(3), 'system', 'system'),
       (115, 109, 'MENU', '/sysadmin/notification', 'bell', '通知管理', '{"routeName":"NotificationAdmin","component":"sysadmin/notification/index","visible":1}', 50, now(3), now(3), 'system', 'system'),
       (119, 109, 'MENU', '/sysadmin/ratelimit-scenes', 'timer', '限次场景', '{"routeName":"RateLimitScenes","component":"sysadmin/ratelimit-scenes/index","visible":1}', 55, now(3), now(3), 'system', 'system'),
       (126, 109, 'MENU', '/sysadmin/usage-management', 'collection-tag', '计次管理', '{"routeName":"UsageManagement","component":"sysadmin/usage-management/index","visible":1}', 68, now(3), now(3), 'system', 'system'),
       (160, -1, 'MENU', '/gateway', 'api', '网关路由', '{"routeName":"Gateway","visible":1}', 85, now(3), now(3), 'system', 'system'),
       (200,160,'MENU','/gateway/dashboard','homepage','网关总览','{"routeName":"GatewayDashboard","component":"system/gateway/planned/index","visible":1}',10,now(3),now(3),'system','system'),
       (201,117,'MENU','/gateway/services','cluster','服务管理','{"routeName":"GatewayServices","component":"system/gateway/services/index","visible":1}',30,now(3),now(3),'system','system'),
       (120,160,'MENU','/gateway/api-routes','api','路由管理','{"routeName":"GatewayApiRoutes","component":"system/gateway/api-routes/index","visible":1}',30,now(3),now(3),'system','system'),
       (202,160,'MENU','/gateway/traffic','timer','流量治理','{"routeName":"GatewayTraffic","component":"system/gateway/traffic/index","visible":1}',40,now(3),now(3),'system','system'),
       (217,160,'MENU','/gateway/traffic/rate-limits','timer','限流规则','{"routeName":"GatewayRateLimits","component":"system/gateway/traffic/index","visible":0}',41,now(3),now(3),'system','system'),
       (218,160,'MENU','/gateway/traffic/circuit-breakers','switch','熔断规则','{"routeName":"GatewayCircuitBreakers","component":"system/gateway/traffic/index","visible":0}',42,now(3),now(3),'system','system'),
       (219,160,'MENU','/gateway/traffic/fallbacks','warning','降级策略','{"routeName":"GatewayFallbacks","component":"system/gateway/traffic/index","visible":0}',43,now(3),now(3),'system','system'),
       (161,160,'MENU','/gateway/security','lock','安全管理','{"routeName":"GatewaySecurity","component":"system/gateway/security/index","visible":1}',50,now(3),now(3),'system','system'),
       (203,160,'MENU','/gateway/security/authentication','lock','认证配置','{"routeName":"GatewayAuthentication","component":"system/gateway/security/index","visible":0}',51,now(3),now(3),'system','system'),
       (204,160,'MENU','/gateway/security/access-lists','list','黑白名单','{"routeName":"GatewayAccessLists","component":"system/gateway/security/index","visible":0}',52,now(3),now(3),'system','system'),
       (162,160,'MENU','/gateway/global','setting','全局规则','{"routeName":"GatewayGlobalRules","component":"system/gateway/global/index","visible":1}',60,now(3),now(3),'system','system'),
       (205,160,'MENU','/gateway/global/filters','filter','全局过滤器','{"routeName":"GatewayGlobalFilters","component":"system/gateway/global/index","visible":0}',61,now(3),now(3),'system','system'),
       (206,160,'MENU','/gateway/global/cors','connection','跨域规则','{"routeName":"GatewayCors","component":"system/gateway/global/index","visible":0}',62,now(3),now(3),'system','system'),
       (207,160,'MENU','/gateway/releases','upload','发布中心','{"routeName":"GatewayReleases","visible":1}',70,now(3),now(3),'system','system'),
       (208,207,'MENU','/gateway/releases/drafts','edit','配置草稿','{"routeName":"GatewayReleaseDrafts","component":"system/gateway/planned/index","visible":1}',10,now(3),now(3),'system','system'),
       (209,207,'MENU','/gateway/releases/history','document','发布记录','{"routeName":"GatewayReleaseHistory","component":"system/gateway/planned/index","visible":1}',20,now(3),now(3),'system','system'),
       (210,207,'MENU','/gateway/releases/versions','refresh','版本回滚','{"routeName":"GatewayReleaseVersions","component":"system/gateway/planned/index","visible":1}',30,now(3),now(3),'system','system'),
       (211,160,'MENU','/gateway/monitoring','trend-charts','监控中心','{"routeName":"GatewayMonitoring","visible":1}',80,now(3),now(3),'system','system'),
       (212,211,'MENU','/gateway/monitoring/instances','monitor','网关实例','{"routeName":"GatewayInstances","component":"system/gateway/planned/index","visible":1}',10,now(3),now(3),'system','system'),
       (213,211,'MENU','/gateway/monitoring/traffic','data-line','流量监控','{"routeName":"GatewayTrafficMonitoring","component":"system/gateway/planned/index","visible":1}',20,now(3),now(3),'system','system'),
       (214,211,'MENU','/gateway/monitoring/routes','histogram','路由监控','{"routeName":"GatewayRouteMonitoring","component":"system/gateway/planned/index","visible":1}',30,now(3),now(3),'system','system'),
       (215,211,'MENU','/gateway/monitoring/alerts','bell','告警记录','{"routeName":"GatewayAlerts","component":"system/gateway/planned/index","visible":1}',40,now(3),now(3),'system','system'),
       (216,160,'MENU','/gateway/settings','setting','系统设置','{"routeName":"GatewaySettings","component":"system/gateway/planned/index","visible":1}',90,now(3),now(3),'system','system'),
       (121, 109, 'MENU', '/sysadmin/internal-messages', 'bell', '站内信管理', '{"routeName":"InternalMessage","component":"system/notice/index","visible":1}', 65, now(3), now(3), 'system', 'system'),
       (116, 108, 'MENU', '/auth/online-user', 'el-icon-User', '在线用户', '{"routeName":"OnlineUser","component":"security/online-user/index","visible":1}', 20, now(3), now(3), 'system', 'system'),
       (220, 108, 'MENU', '/auth/internal-token-keys', 'key', '内部认证', '{"routeName":"InternalTokenKeys","component":"sysadmin/internal-token-keys/index","visible":1}', 30, now(3), now(3), 'system', 'system'),
       (117, -1, 'MENU', '/development', 'code', '研发管理', '研发工具与接口文档', 90, now(3), now(3), 'system', 'system'),
       (118, 117, 'MENU', '/development/api-docs', 'document', 'API文档', '{"iframeUrl":"/doc.html","visible":1}', 10, now(3), now(3), 'system', 'system'),
       (186, 117, 'MENU', '/sysadmin/error-catalog', 'warning', '错误码目录', '{"routeName":"ErrorCatalog","component":"sysadmin/error-catalog/index","visible":1}', 20, now(3), now(3), 'system', 'system');

INSERT INTO base_org_user_group (id, user_id, group_id, created_time, updated_time, created_by, updated_by)
VALUES (101, 101, 101, now(3), now(3), 'system', 'system'),
       (102, 102, 101, now(3), now(3), 'system', 'system');
INSERT INTO base_org_user_position (id, user_id, position_id, created_time, updated_time, created_by, updated_by)
VALUES (101, 101, 103, now(3), now(3), 'system', 'system'),
       (102, 102, 103, now(3), now(3), 'system', 'system');
-- 角色关系表
INSERT INTO base_org_role_menu (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
VALUES (101, 101, 101, now(3), now(3), 'system', 'system'),
       (102, 101, 102, now(3), now(3), 'system', 'system'),
       (103, 101, 103, now(3), now(3), 'system', 'system'),
       (104, 101, 104, now(3), now(3), 'system', 'system'),
       (105, 101, 105, now(3), now(3), 'system', 'system'),
       (106, 102, 101, now(3), now(3), 'system', 'system'),
       (107, 102, 102, now(3), now(3), 'system', 'system'),
       (108, 103, 101, now(3), now(3), 'system', 'system'),
       (109, 103, 102, now(3), now(3), 'system', 'system'),
       (110, 103, 103, now(3), now(3), 'system', 'system'),
       (111, 103, 104, now(3), now(3), 'system', 'system'),
       (112, 103, 105, now(3), now(3), 'system', 'system'),
       (113, 101, 106, now(3), now(3), 'system', 'system'),
       (114, 101, 107, now(3), now(3), 'system', 'system'),
       (115, 103, 106, now(3), now(3), 'system', 'system'),
       (116, 103, 107, now(3), now(3), 'system', 'system'),
       (117, 101, 108, now(3), now(3), 'system', 'system'),
       (118, 101, 109, now(3), now(3), 'system', 'system'),
       (119, 101, 110, now(3), now(3), 'system', 'system'),
       (120, 101, 111, now(3), now(3), 'system', 'system'),
       (121, 103, 108, now(3), now(3), 'system', 'system'),
       (122, 103, 109, now(3), now(3), 'system', 'system'),
       (123, 103, 110, now(3), now(3), 'system', 'system'),
       (124, 103, 111, now(3), now(3), 'system', 'system'),
       (125, 101, 112, now(3), now(3), 'system', 'system'),
       (126, 101, 113, now(3), now(3), 'system', 'system'),
       (127, 103, 112, now(3), now(3), 'system', 'system'),
       (128, 103, 113, now(3), now(3), 'system', 'system'),
       (129, 101, 114, now(3), now(3), 'system', 'system'),
       (130, 101, 115, now(3), now(3), 'system', 'system'),
       (131, 103, 114, now(3), now(3), 'system', 'system'),
       (132, 103, 115, now(3), now(3), 'system', 'system'),
       (133, 101, 116, now(3), now(3), 'system', 'system'),
       (134, 103, 116, now(3), now(3), 'system', 'system'),
       (135, 101, 117, now(3), now(3), 'system', 'system'),
       (136, 101, 118, now(3), now(3), 'system', 'system'),
       (137, 103, 117, now(3), now(3), 'system', 'system'),
       (138, 103, 118, now(3), now(3), 'system', 'system'),
       (139, 101, 119, now(3), now(3), 'system', 'system'),
       (140, 103, 119, now(3), now(3), 'system', 'system'),
       (141, 101, 120, now(3), now(3), 'system', 'system'),
       (146, 103, 120, now(3), now(3), 'system', 'system'),
       (147, 101, 121, now(3), now(3), 'system', 'system'),
       (148, 103, 121, now(3), now(3), 'system', 'system'),
       (160, 101, 126, now(3), now(3), 'system', 'system'),
       (161, 103, 126, now(3), now(3), 'system', 'system'),
       (186, 101, 186, now(3), now(3), 'system', 'system'),
       (187, 103, 186, now(3), now(3), 'system', 'system');

-- 按钮菜单控制管理台可见性；API 授权数据仍由 base_org_resource 维护。
INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num, created_time, updated_time, created_by, updated_by)
VALUES (122, 109, 'MENU', '/sysadmin/configs', 'setting', '系统配置', '{"routeName":"Config","component":"system/config/index","visible":1}', 70, now(3), now(3), 'system', 'system'),
       (123, 101, 'MENU', '/admin/tenants', 'tenant', '租户管理', '{"routeName":"Tenant","component":"system/tenant/index","visible":1}', 70, now(3), now(3), 'system', 'system'),
       (130,102,'BUTTON','','','新增用户','{"perm":"sys:user:create"}',1,now(3),now(3),'system','system'), (131,102,'BUTTON','','','修改用户','{"perm":"sys:user:update"}',2,now(3),now(3),'system','system'), (132,102,'BUTTON','','','删除用户','{"perm":"sys:user:delete"}',3,now(3),now(3),'system','system'),
       (133,102,'BUTTON','','','导入用户','{"perm":"sys:user:import"}',4,now(3),now(3),'system','system'), (134,102,'BUTTON','','','导出用户','{"perm":"sys:user:export"}',5,now(3),now(3),'system','system'), (135,102,'BUTTON','','','重置用户密码','{"perm":"sys:user:reset-password"}',6,now(3),now(3),'system','system'),
       (136,103,'BUTTON','','','新增菜单','{"perm":"sys:menu:create"}',1,now(3),now(3),'system','system'), (137,103,'BUTTON','','','修改菜单','{"perm":"sys:menu:update"}',2,now(3),now(3),'system','system'), (138,103,'BUTTON','','','删除菜单','{"perm":"sys:menu:delete"}',3,now(3),now(3),'system','system'),
       (139,104,'BUTTON','','','分配角色权限','{"perm":"sys:role:assign"}',1,now(3),now(3),'system','system'), (140,105,'BUTTON','','','新增组织','{"perm":"sys:dept:create"}',1,now(3),now(3),'system','system'), (141,105,'BUTTON','','','修改组织','{"perm":"sys:dept:update"}',2,now(3),now(3),'system','system'), (142,105,'BUTTON','','','删除组织','{"perm":"sys:dept:delete"}',3,now(3),now(3),'system','system'),
       (143,116,'BUTTON','','','强制下线','{"perm":"security:online-user:kickout"}',1,now(3),now(3),'system','system'), (144,120,'BUTTON','','','新增网关路由','{"perm":"gateway:route:create"}',1,now(3),now(3),'system','system'), (145,120,'BUTTON','','','修改网关路由','{"perm":"gateway:route:update"}',2,now(3),now(3),'system','system'), (146,120,'BUTTON','','','删除网关路由','{"perm":"gateway:route:delete"}',3,now(3),now(3),'system','system'),
       (147,121,'BUTTON','','','创建站内信','{"perm":"sys:internal-message:create"}',1,now(3),now(3),'system','system'), (148,121,'BUTTON','','','修改站内信','{"perm":"sys:internal-message:update"}',2,now(3),now(3),'system','system'), (149,121,'BUTTON','','','删除站内信','{"perm":"sys:internal-message:delete"}',3,now(3),now(3),'system','system'), (150,121,'BUTTON','','','发布站内信','{"perm":"sys:internal-message:publish"}',4,now(3),now(3),'system','system'), (151,121,'BUTTON','','','撤回站内信','{"perm":"sys:internal-message:revoke"}',5,now(3),now(3),'system','system'),
       (152,122,'BUTTON','','','新增系统配置','{"perm":"sys:config:create"}',1,now(3),now(3),'system','system'), (153,122,'BUTTON','','','修改系统配置','{"perm":"sys:config:update"}',2,now(3),now(3),'system','system'), (154,122,'BUTTON','','','删除系统配置','{"perm":"sys:config:delete"}',3,now(3),now(3),'system','system'), (155,122,'BUTTON','','','刷新系统配置缓存','{"perm":"sys:config:refresh"}',4,now(3),now(3),'system','system'),
       (156,123,'BUTTON','','','新增租户','{"perm":"sys:tenant:create"}',1,now(3),now(3),'system','system'), (157,123,'BUTTON','','','修改租户','{"perm":"sys:tenant:update"}',2,now(3),now(3),'system','system'), (158,123,'BUTTON','','','删除租户','{"perm":"sys:tenant:delete"}',3,now(3),now(3),'system','system'), (159,203,'BUTTON','','','发布 OAuth2 认证方式','{"perm":"gateway:oauth2-client:update"}',1,now(3),now(3),'system','system'), (164,205,'BUTTON','','','修改全局过滤器','{"perm":"gateway:global-rule:update"}',1,now(3),now(3),'system','system'),
       (221,220,'BUTTON','','','轮换内部 Token 密钥','{"perm":"sysadmin:internal-token-key:rotate"}',1,now(3),now(3),'system','system'), (222,220,'BUTTON','','','退役 previous 密钥','{"perm":"sysadmin:internal-token-key:retire"}',2,now(3),now(3),'system','system'), (231,110,'BUTTON','','','终止 OAuth2 服务端授权','{"perm":"auth:authorization:revoke"}',1,now(3),now(3),'system','system'), (232,110,'BUTTON','','','清理已失效 Token','{"perm":"auth:authorization:cleanup"}',2,now(3),now(3),'system','system'), (233,110,'BUTTON','','','删除客户端授权记录','{"perm":"auth:consent:remove"}',3,now(3),now(3),'system','system'),
       (234,204,'BUTTON','','','修改黑白名单','{"perm":"gateway:access-list:update"}',1,now(3),now(3),'system','system'),
       (235,204,'BUTTON','','','发布黑白名单','{"perm":"gateway:access-list:publish"}',2,now(3),now(3),'system','system'),
       (236,205,'BUTTON','','','发布全局规则','{"perm":"gateway:global-rule:publish"}',2,now(3),now(3),'system','system'),
       (237,206,'BUTTON','','','修改跨域规则','{"perm":"gateway:cors:update"}',1,now(3),now(3),'system','system'),
       (238,206,'BUTTON','','','发布跨域规则','{"perm":"gateway:global-rule:publish"}',2,now(3),now(3),'system','system');

INSERT INTO base_org_role_menu (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT 100000 + r.id * 1000 + m.id, r.id, m.id, now(3), now(3), 'system', 'system'
FROM base_org_menu m JOIN base_org_role r ON r.id IN (101, 103)
WHERE m.id IN (120,160,161,162,164,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219)
ON DUPLICATE KEY UPDATE updated_time=VALUES(updated_time), updated_by=VALUES(updated_by);

INSERT INTO base_org_role_menu (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT 100000 + r.id * 1000 + m.id, r.id, m.id, now(3), now(3), 'system', 'system'
FROM base_org_menu m JOIN base_org_role r ON r.id IN (101, 103)
WHERE m.id IN (122, 123, 220, 221, 222, 231, 232, 233, 234, 235, 236, 237, 238)
   OR m.id BETWEEN 130 AND 159;
