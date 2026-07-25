USE os_base_organization;
SET NAMES utf8mb4;

-- 使用 UTF-8 十六进制字节写入名称，避免部署终端或客户端字符集造成二次转码。
UPDATE base_org_menu
SET name = CONVERT(0xE58685E983A8546F6B656EE7AEA1E79086 USING utf8mb4),
    updated_time = now(),
    updated_by = 'system'
WHERE id = 220;

UPDATE base_org_menu
SET name = CONVERT(0xE8BDAEE68DA2E58685E983A8546F6B656EE5AF86E992A5 USING utf8mb4),
    updated_time = now(),
    updated_by = 'system'
WHERE id = 221;

UPDATE base_org_menu
SET name = CONVERT(0xE98080E5BDB970726576696F7573E5AF86E992A5 USING utf8mb4),
    updated_time = now(),
    updated_by = 'system'
WHERE id = 222;
