package io.github.opensabre.organization.dao;

import com.baomidou.mybatisplus.annotation.InterceptorIgnore;
import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import io.github.opensabre.organization.entity.po.Resource;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Insert;
import org.springframework.stereotype.Repository;

@Mapper
@Repository
@InterceptorIgnore(illegalSql = "1")
public interface ResourceMapper extends BaseMapper<Resource> {
    @Insert("""
            INSERT INTO base_org_resource
              (id, code, type, name, url, method, description, application, source, status, handler,
               first_seen_at, last_seen_at, missing_since, app_version,
               created_time, updated_time, created_by, updated_by)
            VALUES
              (#{id}, #{code}, #{type}, #{name}, #{url}, #{method}, #{description}, #{application},
               #{source}, #{status}, #{handler}, #{firstSeenAt}, #{lastSeenAt}, #{missingSince}, #{appVersion},
               #{createdTime}, #{updatedTime}, #{createdBy}, #{updatedBy})
            ON DUPLICATE KEY UPDATE
              type = VALUES(type), name = VALUES(name), url = VALUES(url), method = VALUES(method),
              description = VALUES(description), application = VALUES(application), source = VALUES(source),
              handler = VALUES(handler), last_seen_at = VALUES(last_seen_at), missing_since = VALUES(missing_since),
              app_version = VALUES(app_version), updated_time = VALUES(updated_time), updated_by = VALUES(updated_by)
            """)
    int upsertRegistration(Resource resource);
}
