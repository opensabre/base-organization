SET NAMES utf8mb4;

-- 统一历史初始化菜单的文案，避免面包屑标题与当前菜单、页面术语不一致。
UPDATE base_org_menu
SET name = '系统管理',
    description = '用户，角色，菜单，部门等基础数据管理',
    updated_time = now(),
    updated_by = 'system'
WHERE id = 101
  AND href = '/admin';

UPDATE base_org_menu
SET name = '部门管理',
    description = '部门新增，修改，查看，删除',
    updated_time = now(),
    updated_by = 'system'
WHERE id = 105
  AND href = '/admin/groups';

UPDATE base_org_menu
SET name = '安全认证',
    description = '安全认证服务管理',
    updated_time = now(),
    updated_by = 'system'
WHERE id = 108
  AND href = '/auth';

UPDATE base_org_menu
SET name = '内部认证',
    updated_time = now(),
    updated_by = 'system'
WHERE id = 220
  AND href IN ('/auth/internal-token-keys', '/sysadmin/internal-token-keys');
