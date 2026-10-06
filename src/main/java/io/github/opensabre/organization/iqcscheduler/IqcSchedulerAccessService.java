package io.github.opensabre.organization.iqcscheduler;

import com.baomidou.mybatisplus.core.toolkit.Wrappers;
import io.github.opensabre.organization.dao.*;
import io.github.opensabre.organization.entity.po.*;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Isolation;
import org.springframework.transaction.annotation.Transactional;
import java.time.Instant;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.Objects;
import java.util.stream.Collectors;

/** Fresh projection of existing organization rows, independent of cached interactive role/resource queries. */
@Service @RequiredArgsConstructor
public class IqcSchedulerAccessService {
    public record Access(String schemaVersion,String userId,String username,boolean accountValid,String groupId,
                         Set<String> roles,Set<String> resourceCodes,Instant checkedAt) { }
    private final UserMapper users;
    private final UserRoleMapper userRoles;
    private final RoleMapper roles;
    private final RoleResourceMapper roleResources;
    private final ResourceMapper resources;
    private final UserGroupMapper userGroups;
    private final GroupMapper groups;

    @Transactional(readOnly=true,isolation=Isolation.REPEATABLE_READ)
    public Access resolve(String userId) {
        if(userId==null || !userId.matches("[A-Za-z0-9:_-]{1,64}"))throw new IllegalArgumentException("invalid user ID");
        Instant checkedAt=Instant.now(); // Reject slow projections using read-start time rather than a fresh end-time stamp.
        var user=users.selectOne(Wrappers.<User>lambdaQuery().eq(User::getId,userId)
                .select(User::getId,User::getUsername,User::getEnabled,User::getAccountNonExpired,
                        User::getCredentialsNonExpired,User::getAccountNonLocked));
        if(user==null || !Boolean.TRUE.equals(user.getEnabled()) || !Boolean.TRUE.equals(user.getAccountNonExpired())
                || !Boolean.TRUE.equals(user.getCredentialsNonExpired()) || !Boolean.TRUE.equals(user.getAccountNonLocked())
                || user.getUsername()==null || user.getUsername().isBlank())
            return new Access("iqc-scheduler-access-v1",userId,null,false,null,Set.of(),Set.of(),checkedAt);
        var assignments=userRoles.selectList(Wrappers.<UserRole>lambdaQuery().eq(UserRole::getUserId,userId).last("LIMIT 129"));
        if(assignments.size()>128)throw new IllegalStateException("scheduler user role projection exceeds limit");
        var roleIds=assignments.stream().map(UserRole::getRoleId).filter(Objects::nonNull).collect(Collectors.toSet());
        var assigned=roleIds.isEmpty()?List.<Role>of():roles.selectList(Wrappers.<Role>lambdaQuery().in(Role::getId,roleIds));
        var effectiveRoleIds=assigned.stream().map(Role::getId).collect(Collectors.toSet());
        var relations=effectiveRoleIds.isEmpty()?List.<RoleResource>of():roleResources.selectList(Wrappers.<RoleResource>lambdaQuery()
                .in(RoleResource::getRoleId,effectiveRoleIds).last("LIMIT 10001"));
        if(relations.size()>10000)throw new IllegalStateException("scheduler resource projection exceeds limit");
        var resourceIds=relations.stream().map(RoleResource::getResourceId).filter(Objects::nonNull).collect(Collectors.toSet());
        var active=resourceIds.isEmpty()?List.<Resource>of():resources.selectList(Wrappers.<Resource>lambdaQuery()
                .in(Resource::getId,resourceIds).eq(Resource::getApplication,"iqc-platform")
                .eq(Resource::getProductCode,"iqc").eq(Resource::getStatus,"ACTIVE"));
        var memberships=userGroups.selectList(Wrappers.<UserGroup>lambdaQuery().eq(UserGroup::getUserId,userId).last("LIMIT 33"));
        String groupId=null;
        if(memberships.size()<=32) {
            var ids=memberships.stream().map(UserGroup::getGroupId).filter(Objects::nonNull).collect(Collectors.toSet());
            var existing=ids.isEmpty()?List.<Group>of():groups.selectList(Wrappers.<Group>lambdaQuery().in(Group::getId,ids));
            if(existing.size()==1)groupId=existing.getFirst().getId();
        }
        var roleCodes=assigned.stream().map(Role::getCode).filter(Objects::nonNull).collect(Collectors.toCollection(TreeSet::new));
        var codes=active.stream().map(Resource::getCode).filter(Objects::nonNull).collect(Collectors.toCollection(TreeSet::new));
        return new Access("iqc-scheduler-access-v1",userId,user.getUsername(),true,groupId,Set.copyOf(roleCodes),Set.copyOf(codes),checkedAt);
    }
}
