# 灰度任务创建资源草案

V20261019_03 为真实 POST /api/iqc/pipelines/{id}/rollout/tasks 注册 iqc:pipeline:rollout:task:create，资源/按钮900269，父菜单沿用900160。默认IQC_ADMIN、IQC_QUALITY_MANAGER、IQC_INSPECTOR，与原已发布流水线任务创建角色一致；不授IQC_VIEWER或系统ADMIN。

服务端同时刷新新资源及原iqc:pipeline:task:create，不允许通过新入口绕过旧创建授权。创建/重放仍校验原资产与任务范围；只返回已有安全任务回执，原文与冻结证据不外泄。审计无请求/响应正文，声明20次/60秒限流，no-store/nosniff。只创建任务，不自动开始执行；执行沿用原iqc:task:execute。

复用原组织资源/按钮与20字符SHA2自然键去重。仅静态检查，未执行SQL；新库/升级/已注册ID保留/重复执行、真实角色/网关/审计限流切面仍待验收。
