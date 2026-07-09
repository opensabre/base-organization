package io.github.opensabre.organization.rest;

import io.github.opensabre.governance.audit.annotations.Audit;
import io.github.opensabre.governance.audit.annotations.OperationType;
import io.github.opensabre.organization.entity.form.GroupForm;
import io.github.opensabre.organization.entity.form.PositionForm;
import io.github.opensabre.organization.entity.form.RoleForm;
import org.junit.jupiter.api.Test;

import java.lang.reflect.Method;
import java.util.Set;

import static org.assertj.core.api.Assertions.assertThat;

class AuditAnnotationTest {

    @Test
    void roleChangeOperationsShouldBeAudited() throws NoSuchMethodException {
        assertAudit(RoleController.class.getMethod("add", RoleForm.class),
                OperationType.CREATE, "新增角色", "ROLE", "#roleForm.name");
        assertAudit(RoleController.class.getMethod("delete", String.class),
                OperationType.DELETE, "删除角色", "ROLE", "#id");
        assertAudit(RoleController.class.getMethod("update", String.class, RoleForm.class),
                OperationType.UPDATE, "修改角色信息", "ROLE", "#id");
        assertAudit(RoleController.class.getMethod("updateRoleMenus", String.class, Set.class),
                OperationType.UPDATE, "分配角色菜单", "ROLE", "#id");
        assertAudit(RoleController.class.getMethod("updateRoleResources", String.class, Set.class),
                OperationType.UPDATE, "分配角色资源", "ROLE", "#id");
    }

    @Test
    void groupChangeOperationsShouldBeAudited() throws NoSuchMethodException {
        assertAudit(GroupController.class.getMethod("add", GroupForm.class),
                OperationType.CREATE, "新增组织", "GROUP", "#groupForm.name");
        assertAudit(GroupController.class.getMethod("delete", String.class),
                OperationType.DELETE, "删除组织", "GROUP", "#id");
        assertAudit(GroupController.class.getMethod("update", String.class, GroupForm.class),
                OperationType.UPDATE, "修改组织信息", "GROUP", "#id");
    }

    @Test
    void positionChangeOperationsShouldBeAudited() throws NoSuchMethodException {
        assertAudit(PositionController.class.getMethod("add", PositionForm.class),
                OperationType.CREATE, "新增岗位", "POSITION", "#positionForm.name");
        assertAudit(PositionController.class.getMethod("delete", String.class),
                OperationType.DELETE, "删除岗位", "POSITION", "#id");
        assertAudit(PositionController.class.getMethod("update", String.class, PositionForm.class),
                OperationType.UPDATE, "修改岗位信息", "POSITION", "#id");
    }

    private static void assertAudit(Method method, OperationType operationType, String description, String module, String key) {
        Audit audit = method.getAnnotation(Audit.class);

        assertThat(audit).isNotNull();
        assertThat(audit.operationType()).isEqualTo(operationType);
        assertThat(audit.description()).isEqualTo(description);
        assertThat(audit.module()).isEqualTo(module);
        assertThat(audit.response()).isTrue();
        assertThat(audit.key()).isEqualTo(key);
    }
}
