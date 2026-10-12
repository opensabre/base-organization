# 原始音频敏感权限

V20261012_02 在原资源与角色授权模型注册三个独立资源：上传音频POST /api/iqc/conversations/{id}/audio、查看信息GET同路径、读取字节GET /api/iqc/conversations/{id}/audio/content。一般会话/任务查看不替代音频权限。初始仅IQC_ADMIN及IQC_QUALITY_MANAGER获得授权，Inspector/Viewer不自动获得敏感权限；额外授权使用现有组织权限管理。接口还需同时校验原会话数据范围。

72226实际专用MySQL验证exit0：随机库原baseline、新DML完整执行两次，精确资源ID/方法/路径/ANNOTATION状态及仅两个角色、无重复授权通过，finally删除本测试库。日志/private/tmp/iqc-b-audio-permission-validation.log。布局检查通过。此证据不是完整Flyway新库/升级或HTTP鉴权验收；接口仍在开发，未部署。
