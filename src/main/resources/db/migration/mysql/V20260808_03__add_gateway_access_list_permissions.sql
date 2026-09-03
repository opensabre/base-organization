SET NAMES utf8mb4;

-- 流量治理和全局规则改为单页 Tab；原子菜单保留为隐藏兼容路由。
UPDATE base_org_menu
SET description = '{"routeName":"GatewayTraffic","component":"system/gateway/traffic/index","visible":1}',
    updated_time = now(),
    updated_by = 'system'
WHERE id = 202;

UPDATE base_org_menu
SET parent_id = 160,
    description = CONCAT(
      '{"routeName":"',
      CASE id
        WHEN 217 THEN 'GatewayRateLimits'
        WHEN 218 THEN 'GatewayCircuitBreakers'
        ELSE 'GatewayFallbacks'
      END,
      '","component":"system/gateway/traffic/index","visible":0}'
    ),
    order_num = CASE id WHEN 217 THEN 41 WHEN 218 THEN 42 ELSE 43 END,
    updated_time = now(),
    updated_by = 'system'
WHERE id IN (217, 218, 219);

UPDATE base_org_menu
SET description = '{"routeName":"GatewayGlobalRules","component":"system/gateway/global/index","visible":1}',
    updated_time = now(),
    updated_by = 'system'
WHERE id = 162;

UPDATE base_org_menu
SET parent_id = 160,
    description = CONCAT(
      '{"routeName":"',
      CASE id WHEN 205 THEN 'GatewayGlobalFilters' ELSE 'GatewayCors' END,
      '","component":"system/gateway/global/index","visible":0}'
    ),
    order_num = CASE id WHEN 205 THEN 61 ELSE 62 END,
    updated_time = now(),
    updated_by = 'system'
WHERE id IN (205, 206);
