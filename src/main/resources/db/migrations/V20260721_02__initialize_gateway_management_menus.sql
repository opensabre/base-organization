USE os_base_organization;
SET NAMES utf8mb4;

-- 初始化网关控制面的完整信息架构。未实现的功能先指向统一规划页，后续迭代替换组件即可。
INSERT INTO base_org_menu (id, parent_id, type, href, icon, name, description, order_num,
                           created_time, updated_time, created_by, updated_by)
VALUES
 (200,160,'MENU','/gateway/dashboard','homepage','网关总览','{"routeName":"GatewayDashboard","component":"system/gateway/planned/index","visible":1}',10,now(),now(),'system','system'),
 (201,160,'MENU','/gateway/services','cluster','服务管理','{"routeName":"GatewayServices","component":"system/gateway/planned/index","visible":1}',20,now(),now(),'system','system'),
 (202,160,'MENU','/gateway/traffic','timer','流量治理','{"routeName":"GatewayTraffic","visible":1}',40,now(),now(),'system','system'),
 (217,202,'MENU','/gateway/traffic/rate-limits','timer','限流规则','{"routeName":"GatewayRateLimits","component":"system/gateway/planned/index","visible":1}',10,now(),now(),'system','system'),
 (218,202,'MENU','/gateway/traffic/circuit-breakers','switch','熔断规则','{"routeName":"GatewayCircuitBreakers","component":"system/gateway/planned/index","visible":1}',20,now(),now(),'system','system'),
 (219,202,'MENU','/gateway/traffic/fallbacks','warning','降级策略','{"routeName":"GatewayFallbacks","component":"system/gateway/planned/index","visible":1}',30,now(),now(),'system','system'),
 (203,161,'MENU','/gateway/security/authentication','lock','认证配置','{"routeName":"GatewayAuthentication","component":"system/gateway/authentication/index","visible":1}',10,now(),now(),'system','system'),
 (204,161,'MENU','/gateway/security/access-lists','list','黑白名单','{"routeName":"GatewayAccessLists","component":"system/gateway/planned/index","visible":1}',20,now(),now(),'system','system'),
 (205,162,'MENU','/gateway/global/filters','filter','全局过滤器','{"routeName":"GatewayGlobalFilters","component":"system/gateway/policy/index","visible":1}',10,now(),now(),'system','system'),
 (206,162,'MENU','/gateway/global/cors','connection','跨域规则','{"routeName":"GatewayCors","component":"system/gateway/planned/index","visible":1}',20,now(),now(),'system','system'),
 (207,160,'MENU','/gateway/releases','upload','发布中心','{"routeName":"GatewayReleases","visible":1}',70,now(),now(),'system','system'),
 (208,207,'MENU','/gateway/releases/drafts','edit','配置草稿','{"routeName":"GatewayReleaseDrafts","component":"system/gateway/planned/index","visible":1}',10,now(),now(),'system','system'),
 (209,207,'MENU','/gateway/releases/history','document','发布记录','{"routeName":"GatewayReleaseHistory","component":"system/gateway/planned/index","visible":1}',20,now(),now(),'system','system'),
 (210,207,'MENU','/gateway/releases/versions','refresh','版本回滚','{"routeName":"GatewayReleaseVersions","component":"system/gateway/planned/index","visible":1}',30,now(),now(),'system','system'),
 (211,160,'MENU','/gateway/monitoring','trend-charts','监控中心','{"routeName":"GatewayMonitoring","visible":1}',80,now(),now(),'system','system'),
 (212,211,'MENU','/gateway/monitoring/instances','monitor','网关实例','{"routeName":"GatewayInstances","component":"system/gateway/planned/index","visible":1}',10,now(),now(),'system','system'),
 (213,211,'MENU','/gateway/monitoring/traffic','data-line','流量监控','{"routeName":"GatewayTrafficMonitoring","component":"system/gateway/planned/index","visible":1}',20,now(),now(),'system','system'),
 (214,211,'MENU','/gateway/monitoring/routes','histogram','路由监控','{"routeName":"GatewayRouteMonitoring","component":"system/gateway/planned/index","visible":1}',30,now(),now(),'system','system'),
 (215,211,'MENU','/gateway/monitoring/alerts','bell','告警记录','{"routeName":"GatewayAlerts","component":"system/gateway/planned/index","visible":1}',40,now(),now(),'system','system'),
 (216,160,'MENU','/gateway/settings','setting','系统设置','{"routeName":"GatewaySettings","component":"system/gateway/planned/index","visible":1}',90,now(),now(),'system','system')
ON DUPLICATE KEY UPDATE parent_id=VALUES(parent_id), type=VALUES(type), href=VALUES(href), icon=VALUES(icon),
 name=VALUES(name), description=VALUES(description), order_num=VALUES(order_num),
 updated_time=now(), updated_by='system';

-- 保留既有菜单和按钮 ID，整理为新的目录层级。
UPDATE base_org_menu SET name='网关路由', updated_time=now(), updated_by='system' WHERE id=160;
UPDATE base_org_menu SET parent_id=160, href='/gateway/routes', name='路由管理', order_num=30,
 description='{"routeName":"GatewayRouteManagement","component":"system/gateway/route/index","visible":1}',
 updated_time=now(), updated_by='system' WHERE id=120;
UPDATE base_org_menu SET parent_id=160, type='MENU', href='/gateway/security', icon='lock', name='安全管理',
 description='{"routeName":"GatewaySecurity","visible":1}', order_num=50, updated_time=now(), updated_by='system' WHERE id=161;
UPDATE base_org_menu SET parent_id=160, type='MENU', href='/gateway/global', icon='setting', name='全局规则',
 description='{"routeName":"GatewayGlobalRules","visible":1}', order_num=60, updated_time=now(), updated_by='system' WHERE id=162;
UPDATE base_org_menu SET parent_id=203, name='发布 OAuth2 认证方式', order_num=1, updated_time=now(), updated_by='system' WHERE id=159;
UPDATE base_org_menu SET parent_id=205, name='发布网关全局过滤器', order_num=1, updated_time=now(), updated_by='system' WHERE id=164;

-- 当前沿用既有管理员角色范围；业务角色后续按最小权限单独授权。
INSERT INTO base_org_role_menu (id, role_id, menu_id, created_time, updated_time, created_by, updated_by)
SELECT 100000 + CAST(r.id AS UNSIGNED) * 1000 + m.id, r.id, m.id, now(), now(), 'system', 'system'
FROM base_org_menu m JOIN base_org_role r ON r.id IN (101, 103)
WHERE m.id IN (120,159,160,161,162,164,200,201,202,203,204,205,206,207,208,209,210,211,212,213,214,215,216,217,218,219)
ON DUPLICATE KEY UPDATE updated_time=VALUES(updated_time), updated_by=VALUES(updated_by);
