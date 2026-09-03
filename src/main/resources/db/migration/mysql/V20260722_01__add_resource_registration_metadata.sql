SET NAMES utf8mb4;

ALTER TABLE base_org_resource
    ADD COLUMN application VARCHAR(100) NOT NULL DEFAULT 'legacy' COMMENT '来源应用' AFTER description,
    ADD COLUMN source VARCHAR(20) NOT NULL DEFAULT 'MANUAL' COMMENT '资源来源' AFTER application,
    ADD COLUMN status VARCHAR(20) NOT NULL DEFAULT 'ACTIVE' COMMENT '注册状态' AFTER source,
    ADD COLUMN handler VARCHAR(300) NULL COMMENT '处理器方法' AFTER status,
    ADD COLUMN first_seen_at DATETIME NULL COMMENT '首次发现时间' AFTER handler,
    ADD COLUMN last_seen_at DATETIME NULL COMMENT '最后发现时间' AFTER first_seen_at,
    ADD COLUMN missing_since DATETIME NULL COMMENT '首次缺失时间' AFTER last_seen_at,
    ADD COLUMN app_version VARCHAR(100) NULL COMMENT '应用版本' AFTER missing_since;

CREATE INDEX ix_resource_endpoint ON base_org_resource (application, method, url);
