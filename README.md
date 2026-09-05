# base-organization

组织与权限服务，管理用户、组织、岗位、角色、菜单、产品和资源授权。

## 数据模型

- [表结构与 ER 图](docs/data-model.md)
- [完整建库脚本](src/main/resources/db/os-base-org-ddl.sql)
- 数据库增量变更位于 `src/main/resources/db/migration/mysql/`

## 项目文档

架构、开发路线和模块资料见 [docs/](docs/README.md)。

## 本地构建

```bash
mvn clean package
```

## 本地运行

```bash
mvn spring-boot:run
```
