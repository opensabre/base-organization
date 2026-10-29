# 灰度分配预览资源草案

V20261019_01，资源/按钮900265，code iqc:pipeline:rollout:preview，真实POST /api/iqc/pipelines/{id}/rollout-preview。按钮归现有流水线菜单900160，默认仅IQC_ADMIN/IQC_QUALITY_MANAGER，不授系统ADMIN/质检员/查看者。沿原resource/menu和SHA2自然键去重规范，不新建ACL。

接口刷新当前独立资源后校验原流水线scope、已发布版本与单变量；输出只有分配及比较摘要，不返回Prompt、请求键、账号ID或原配置，不额外要求敏感正文权限。Audit无正文/id目标、no-store/nosniff、30/60限流。仅预览，不保存策略、不创建任务、不改变路由。

仅静态核对版本/ID/URL/方法/权限码，未执行SQL；新库/升级/重复执行、已注册ID保留、真实角色和切面待验收。当前资源迁移尚未生效，不以本草案声明灰度发布完成。
