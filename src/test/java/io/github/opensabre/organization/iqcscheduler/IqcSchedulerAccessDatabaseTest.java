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
@SpringBootTest(properties = {
    "opensabre.security.internal-token.enabled=true",
    "opensabre.security.internal-token.required=true",
    "opensabre.security.internal-token.active-key-id=iqc-test",
    "opensabre.security.internal-token.active-key=MDEyMzQ1Njc4OWFiY2RlZjAxMjM0NTY3ODlhYmNkZWY=",
    "opensabre.security.internal-token.allowed-issuers=iqc-platform",
    "opensabre.governance.error-catalog.enabled=false",
    "opensabre.governance.dictionary.registration-enabled=false"
})
class IqcSchedulerAccessDatabaseTest {
    @org.springframework.test.context.bean.override.mockito.MockitoBean
    io.github.opensabre.security.config.InternalTokenConfigurationRefresher remoteRefresh;
    @Autowired IqcSchedulerAccessService access;
    @Autowired JdbcTemplate jdbc;
    @Autowired org.springframework.web.context.WebApplicationContext web;
    @Autowired org.springframework.security.web.FilterChainProxy security;
    @Autowired io.github.opensabre.security.token.InternalTokenService signing;
    @Autowired io.github.opensabre.security.context.InternalTokenUserContext tokens;

    @BeforeEach void seed() {
        clean();
        jdbc.update("INSERT INTO base_org_user (id,username,password,enabled,account_non_expired,credentials_non_expired,account_non_locked,created_by,updated_by) VALUES ('iqc-db-user','iqc-db-user','unused',true,true,true,true,'test','test')");
        jdbc.update("INSERT INTO base_org_role (id,code,created_by,updated_by) VALUES ('iqc-db-role','IQC_QUALITY_MANAGER','test','test')");
        jdbc.update("INSERT INTO base_org_user_role (id,user_id,role_id,created_by,updated_by) VALUES ('iqc-db-ur','iqc-db-user','iqc-db-role','test','test')");
        jdbc.update("INSERT INTO base_org_resource (id,code,type,name,url,method,application,product_code,status,created_by,updated_by) VALUES ('iqc-db-resource','iqc:action:recover','API','recover','/test','POST','iqc-platform','iqc','ACTIVE','test','test')");
        jdbc.update("INSERT INTO base_org_role_resource (id,role_id,resource_id,created_by,updated_by) VALUES ('iqc-db-rr','iqc-db-role','iqc-db-resource','test','test')");
    }

    @AfterEach void clean() {
        jdbc.update("DELETE FROM base_org_user_group WHERE user_id='iqc-db-user'");
        jdbc.update("DELETE FROM base_org_group WHERE id IN ('iqc-db-group-a','iqc-db-group-b')");
        jdbc.update("DELETE FROM base_org_role_resource WHERE id='iqc-db-rr'");
        jdbc.update("DELETE FROM base_org_user_role WHERE id='iqc-db-ur'");
        jdbc.update("DELETE FROM base_org_resource WHERE id='iqc-db-resource'");
        jdbc.update("DELETE FROM base_org_role WHERE id='iqc-db-role'");
        jdbc.update("DELETE FROM base_org_user WHERE id='iqc-db-user'");
    }

    @Test void productionSecurityChainProjectsSignedUserAndRejectsInvalidTokens() throws Exception {
        var mvc=org.springframework.test.web.servlet.setup.MockMvcBuilders.webAppContextSetup(web)
                .addFilters(security).build();
        String path="/internal/iqc/scheduler-access/current/iqc-db-user";
        String header=io.github.opensabre.security.token.InternalTokenConstants.HEADER;
        var request=new io.github.opensabre.security.token.InternalTokenRequest(
                "iqc-platform","iqc-db-user","iqc-db-user","base-organization",
                java.util.List.of(),java.util.List.of(),2,null,null,java.util.Map.of());
        String signed=signing.issue(request);
        mvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get(path))
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.status().isUnauthorized());
        mvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get(path).header(header,signed+"tampered"))
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.status().isUnauthorized());
        var accepted=mvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get(path).header(header,signed))
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.status().isOk()).andReturn();
        assertThat(accepted.getResponse().getContentAsString()).contains("iqc-db-user","iqc:action:recover");
        assertThat(tokens.currentClaims()).isNull();
        jdbc.update("DELETE FROM base_org_role_resource WHERE id='iqc-db-rr'");
        var revoked=mvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get(path).header(header,signed))
                .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.status().isOk()).andReturn();
        assertThat(revoked.getResponse().getContentAsString()).doesNotContain("iqc:action:recover");
        assertThat(tokens.currentClaims()).isNull();
    }

    /** Exercise the production security/filter/controller/mapper chain for every split endpoint code. */
    @Test void allSplitEndpointGrantsReflectStatusAndRelationRevocationThroughSignedCurrentHttp() throws Exception {
        var mvc=org.springframework.test.web.servlet.setup.MockMvcBuilders.webAppContextSetup(web).addFilters(security).build();
        String path="/internal/iqc/scheduler-access/current/iqc-db-user";
        String signed=signing.issue(new io.github.opensabre.security.token.InternalTokenRequest(
            "iqc-platform","iqc-db-user","iqc-db-user","base-organization",java.util.List.of(),java.util.List.of(),2,null,null,java.util.Map.of()));
        java.util.List<String> lines;
        try(var input=getClass().getResourceAsStream("/db/migration/iqc-endpoint-permission-contract.tsv")){
            assertThat(input).isNotNull();
            lines=new String(input.readAllBytes(),java.nio.charset.StandardCharsets.UTF_8).lines().toList();
        }
        assertThat(lines).hasSize(70);
        var json=new tools.jackson.databind.ObjectMapper();
        for(String line:lines){
            String[] fields=line.split("\\t");String code=fields[0];
            jdbc.update("UPDATE base_org_resource SET code=?,method=?,url=?,status='ACTIVE' WHERE id='iqc-db-resource'",code,fields[1],fields[2]);
            var active=currentGrantCodes(mvc,path,signed,json);assertThat(active).containsExactly(code);
            jdbc.update("UPDATE base_org_resource SET status='PENDING' WHERE id='iqc-db-resource'");
            assertThat(currentGrantCodes(mvc,path,signed,json)).isEmpty();
            jdbc.update("UPDATE base_org_resource SET status='ACTIVE' WHERE id='iqc-db-resource'");
            jdbc.update("DELETE FROM base_org_role_resource WHERE id='iqc-db-rr'");
            assertThat(currentGrantCodes(mvc,path,signed,json)).isEmpty();
            jdbc.update("INSERT INTO base_org_role_resource(id,role_id,resource_id,created_by,updated_by) VALUES ('iqc-db-rr','iqc-db-role','iqc-db-resource','test','test')");
            assertThat(tokens.currentClaims()).isNull();
        }
    }

    private java.util.List<String> currentGrantCodes(org.springframework.test.web.servlet.MockMvc mvc,String path,
            String signed,tools.jackson.databind.ObjectMapper json) throws Exception {
        var response=mvc.perform(org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get(path)
            .header(io.github.opensabre.security.token.InternalTokenConstants.HEADER,signed))
            .andExpect(org.springframework.test.web.servlet.result.MockMvcResultMatchers.status().isOk()).andReturn();
        var root=json.readTree(response.getResponse().getContentAsString());
        var grants=root.has("data")?root.path("data").path("resourceCodes"):root.path("resourceCodes");
        assertThat(grants.isArray()).isTrue();
        var values=new java.util.ArrayList<String>();grants.forEach(value->values.add(value.asText()));return values;
    }

    /** Ambiguous or revoked group membership must never yield a guessed data-scope group. */
    @Test void groupProjectionTracksMembershipRevocationAmbiguityAndDeletedGroups() {
        assertThat(access.resolve("iqc-db-user").groupId()).isNull();
        for(String id:java.util.List.of("iqc-db-group-a","iqc-db-group-b"))
            jdbc.update("INSERT INTO base_org_group(id,parent_id,name,created_by,updated_by) VALUES (?,'0','Fixture','test','test')",id);
        jdbc.update("INSERT INTO base_org_user_group(id,user_id,group_id,created_by,updated_by) VALUES ('iqc-db-ug-a','iqc-db-user','iqc-db-group-a','test','test')");
        assertThat(access.resolve("iqc-db-user").groupId()).isEqualTo("iqc-db-group-a");
        jdbc.update("INSERT INTO base_org_user_group(id,user_id,group_id,created_by,updated_by) VALUES ('iqc-db-ug-b','iqc-db-user','iqc-db-group-b','test','test')");
        assertThat(access.resolve("iqc-db-user").groupId()).isNull();
        jdbc.update("UPDATE base_org_group SET deleted='Y' WHERE id='iqc-db-group-b'");
        assertThat(access.resolve("iqc-db-user").groupId()).isEqualTo("iqc-db-group-a");
        jdbc.update("DELETE FROM base_org_user_group WHERE id='iqc-db-ug-a'");
        assertThat(access.resolve("iqc-db-user").groupId()).isNull();
        jdbc.update("UPDATE base_org_group SET deleted='N' WHERE id='iqc-db-group-b'");
        var moved=access.resolve("iqc-db-user");
        assertThat(moved.groupId()).isEqualTo("iqc-db-group-b");
        assertThat(moved.accountValid()).isTrue();assertThat(moved.resourceCodes()).containsExactly("iqc:action:recover");
    }

    @Test void excessiveMembershipRowsFailClosedEvenWhenTheyPointToOneExistingGroup() {
        jdbc.update("INSERT INTO base_org_group(id,parent_id,name,created_by,updated_by) VALUES ('iqc-db-group-a','0','Fixture','test','test')");
        for(int i=0;i<33;i++){
            jdbc.update("INSERT INTO base_org_user_group(id,user_id,group_id,created_by,updated_by) VALUES (?,'iqc-db-user','iqc-db-group-a','test','test')","iqc-db-ug-"+i);
            if(i==31)assertThat(access.resolve("iqc-db-user").groupId()).isEqualTo("iqc-db-group-a");
        }
        var overflow=access.resolve("iqc-db-user");assertThat(overflow.groupId()).isNull();
        assertThat(overflow.accountValid()).isTrue();assertThat(overflow.resourceCodes()).containsExactly("iqc:action:recover");
        jdbc.update("DELETE FROM base_org_user_group WHERE id='iqc-db-ug-32'");
        assertThat(access.resolve("iqc-db-user").groupId()).isEqualTo("iqc-db-group-a");
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
