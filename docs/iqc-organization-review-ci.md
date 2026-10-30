# 组织服务协作PR的原CI触发范围

基于PR57固定 `9d3b9c7`，仅将原 docker_publish.yml 的 pull_request base 分支从main扩为main及review/iqc-*，让以IQC父功能分支为目标的小PR执行原完整验证。

保留原Maven Verify及Redis、标签权限隔离MySQL脚本、base-k8s隔离Flyway、依赖/needs/权限/超时/并发策略。framework只读checkout/install版本不变，未修改框架源码。push仍main及v*，镜像仍仅push事件，PR不发布镜像。

Ruby YAML解析、仅单行workflow差异与git diff检查通过。本轮不本地重复应用测试或主动dispatch；新正式PR的自动同头run/job终态在PR正文/协作记录另记，不能借PR57本地16项作为远端完整结果。生产和测试源码相对9d3b9c7逐字一致，不远端合并、推main或部署。
