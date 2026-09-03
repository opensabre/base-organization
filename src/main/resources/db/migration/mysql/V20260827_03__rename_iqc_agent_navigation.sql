SET NAMES utf8mb4;

UPDATE base_org_menu
SET name = '智能体管理', updated_time = now(3), updated_by = 'system'
WHERE href = '/iqc/agents' AND type = 'MENU' AND parent_id = '900001';

UPDATE base_org_menu
SET name = '智能体列表', updated_time = now(3), updated_by = 'system'
WHERE href = '/iqc/agents' AND type = 'MENU' AND parent_id = '900105';
