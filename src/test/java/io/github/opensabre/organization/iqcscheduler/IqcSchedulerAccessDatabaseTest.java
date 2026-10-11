package io.github.opensabre.organization.iqcscheduler;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.aop.support.AopUtils;

import static org.assertj.core.api.Assertions.assertThat;

/** Actual mapper queries and transaction proxy; isolated fixture IDs, no outer test transaction. */
@SpringBootTest
class IqcSchedulerAccessDatabaseTest {
    @Autowired IqcSchedulerAccessService access;
    @Autowired JdbcTemplate jdbc;

    @BeforeEach void seed() {
        clean();
        jdbc.update("INSERT INTO base_org_user (id,username,password,enabled,account_non_expired,credentials_non_expired,account_non_locked,created_by,updated_by) VALUES ('iqc-db-user','iqc-db-user','unused',true,true,true,true,'test','test')");
        jdbc.update("INSERT INTO base_org_role (id,code,created_by,updated_by) VALUES ('iqc-db-role','IQC_QUALITY_MANAGER','test','test')");
        jdbc.update("INSERT INTO base_org_user_role (id,user_id,role_id,created_by,updated_by) VALUES ('iqc-db-ur','iqc-db-user','iqc-db-role','test','test')");
        jdbc.update("INSERT INTO base_org_resource (id,code,type,name,url,method,application,product_code,status,created_by,updated_by) VALUES ('iqc-db-resource','iqc:action:recover','API','recover','/test','POST','iqc-platform','iqc','ACTIVE','test','test')");
        jdbc.update("INSERT INTO base_org_role_resource (id,role_id,resource_id,created_by,updated_by) VALUES ('iqc-db-rr','iqc-db-role','iqc-db-resource','test','test')");
    }

    @AfterEach void clean() {
        jdbc.update("DELETE FROM base_org_role_resource WHERE id='iqc-db-rr'");
        jdbc.update("DELETE FROM base_org_user_role WHERE id='iqc-db-ur'");
        jdbc.update("DELETE FROM base_org_resource WHERE id='iqc-db-resource'");
        jdbc.update("DELETE FROM base_org_role WHERE id='iqc-db-role'");
        jdbc.update("DELETE FROM base_org_user WHERE id='iqc-db-user'");
    }

    @Test void revocationIsVisibleOnNextProjection() {
        assertThat(AopUtils.isAopProxy(access)).isTrue();
        var initial=access.resolve("iqc-db-user");
        assertThat(initial.accountValid()).isTrue();
        assertThat(initial.username()).isEqualTo("iqc-db-user");
        assertThat(initial.roles()).containsExactly("IQC_QUALITY_MANAGER");
        assertThat(initial.resourceCodes()).containsExactly("iqc:action:recover");
        jdbc.update("DELETE FROM base_org_role_resource WHERE id='iqc-db-rr'");
        assertThat(access.resolve("iqc-db-user").resourceCodes()).isEmpty();
        jdbc.update("DELETE FROM base_org_user_role WHERE id='iqc-db-ur'");
        assertThat(access.resolve("iqc-db-user").roles()).isEmpty();
    }

    @Test void inactiveOrForeignResourcesAreExcluded() {
        for (String[] change:new String[][]{{"status","MISSING"},{"application","base-organization"},{"product_code","COMMON"}}) {
            jdbc.update("UPDATE base_org_resource SET status='ACTIVE',application='iqc-platform',product_code='iqc' WHERE id='iqc-db-resource'");
            assertThat(access.resolve("iqc-db-user").resourceCodes()).containsExactly("iqc:action:recover");
            jdbc.update("UPDATE base_org_resource SET "+change[0]+"=? WHERE id='iqc-db-resource'",change[1]);
            assertThat(access.resolve("iqc-db-user").resourceCodes()).isEmpty();
        }
    }

    @Test void invalidOrDeletedAccountReturnsNoGrants() {
        for (String column:new String[]{"enabled","account_non_expired","credentials_non_expired","account_non_locked"}) {
            jdbc.update("UPDATE base_org_user SET enabled=true,account_non_expired=true,credentials_non_expired=true,account_non_locked=true WHERE id='iqc-db-user'");
            jdbc.update("UPDATE base_org_user SET "+column+"=false WHERE id='iqc-db-user'");
            var denied=access.resolve("iqc-db-user");
            assertThat(denied.accountValid()).isFalse();
            assertThat(denied.roles()).isEmpty();
            assertThat(denied.resourceCodes()).isEmpty();
        }
        jdbc.update("UPDATE base_org_user SET enabled=true,account_non_expired=true,credentials_non_expired=true,account_non_locked=true,deleted='Y' WHERE id='iqc-db-user'");
        assertThat(access.resolve("iqc-db-user").accountValid()).isFalse();
    }
}
