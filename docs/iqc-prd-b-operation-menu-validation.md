# 拆分操作菜单迁移独立验证（2026-10-29）

组织基线6ceba0f，仅merge固定06dcb02为020f24f，生产SQL不修改。新增`scripts/test-iqc-operation-menus.py`，复用独立七迁移契约的23父/68子映射与专用MySQL保护。原脚本加main guard供复用，并将前置DML明确截止第一目标迁移之前，避免菜单08被提前执行混入七迁移证据。

## 实际执行

原73385 terminal0，`/tmp/iqc-b-operation-menu-validation-20261029.log.exit=0`。使用既有专用MySQL8 loopback34307和随机隔离schema，先重跑七份接口迁移十场景（每份两遍），再跑菜单08八场景（两遍），全部通过。每schema finally删除，实例由启动器trap关闭；不触及共享库，不读生产凭据。

八场景为新资源ACTIVE/PENDING/STALE、异application、异product、复用已有IQC菜单、已有同码异产品菜单、IQC根菜单缺失。每场景均以独立固定映射检查68项；每项构造四类合成角色关系：旧菜单+新API、只有旧菜单、只有新API、旧菜单+旧父级API。只有旧菜单和ACTIVE新API同时满足时，新增对应可见性；旧父级API本身不替代新API。

逐遍检查新增角色菜单关系集合精确相等、原菜单完整字段与原关系ID保留、全部API资源/授权快照不变、用户/用户角色/角色计数不变；两遍菜单字段/关系/ID完全一致。按新能力精确检查同产品菜单数量为1，跨application/product及缺根不新增目标菜单；IQC既有菜单复用其原ID，异产品同码菜单不阻止IQC创建。SQL实际写入20字符ID，无长度截断失败。

## 复现与边界

先启动专用本机实例并设置与原脚本相同的`MYSQL_TEST_ALLOWED_DATADIR`、`MYSQL_TEST_SOCKET`、`MYSQL_TEST_PORT`、`MYSQL_TEST_BINARY`，顺序执行`python3 scripts/test-iqc-endpoint-permissions.py`和`python3 scripts/test-iqc-operation-menus.py`。启动器必须在退出时关闭自己的专用实例。

角色ID为合成fixture，不代表真实用户/岗位；本批证明直接MySQL DML与幂等/精确关系，不证明完整Flyway新库升级、菜单树Controller、实际浏览器、真实登录/PDP/网关。已有目标关系不会被此一次性迁移当成持续撤权同步；未据此宣称运行时撤权验收。原七迁移报告与组织H2当前授权报告各自保留边界，不能拼接冒称端到端。全部适用I1–I7仍继续，输入仅处理后会话。
