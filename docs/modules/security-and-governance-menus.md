# 0.7 安全与治理菜单权限

## 错误码目录

菜单 ID 186，路由 `/sysadmin/error-catalog`，位于“研发管理”。页面只读，默认授予系统管理员与开发管理员。

## OAuth2 Token 管理

客户端与授权记录合并到客户端管理入口。API 资源：

| 权限码 | 方法与路径 | 说明 |
| --- | --- | --- |
| `auth:authorization:query` | `POST /api/auth/authorizations/conditions` | 分页查询 |
| `auth:authorization:view` | `GET /api/auth/authorizations/{id}` | 查看详情 |
| `auth:authorization:revoke` | `DELETE /api/auth/authorizations/{id}` | 终止服务端授权 |
| `auth:authorization:cleanup` | `DELETE /api/auth/authorizations/expired/cleanup` | 清理全部凭据均过期的记录 |

终止授权不会提前使已签发的自包含 JWT Access Token 失效，它仍有效至过期。

## 内部认证

菜单 ID 220，路由 `/auth/internal-token-keys`。按钮权限：

- `sysadmin:internal-token-key:rotate`：轮换内部 Token 密钥。
- `sysadmin:internal-token-key:retire`：退役 previous 密钥。

迁移顺序以 `V20260726_01` 至 `V20260727_01` 为准；所有菜单变更都必须与初始化 DDL 保持一致。
