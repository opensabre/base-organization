package io.github.opensabre.organization;

import org.junit.jupiter.api.Test;
import org.h2.jdbcx.JdbcDataSource;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Timestamp;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

/** Checks JDBC timestamp mapping against the organization H2 test fixture. */
class AuditTimestampPrecisionTest {

    @Test
    void jdbcPreservesMillisecondsAndOnlyUpdateUpdatedTime() throws Exception {
        String id = "audit-time-test";
        Timestamp createdTime = Timestamp.valueOf("2020-08-18 12:34:56.789");
        try (Connection connection = newConnection()) {
            try (PreparedStatement insert = connection.prepareStatement("INSERT INTO base_org_group "
                    + "(id, parent_id, name, created_time, updated_time, created_by, updated_by) "
                    + "VALUES (?, ?, ?, ?, ?, ?, ?)")) {
                insert.setString(1, id);
                insert.setString(2, "0");
                insert.setString(3, "before-update");
                insert.setTimestamp(4, createdTime);
                insert.setTimestamp(5, createdTime);
                insert.setString(6, "test");
                insert.setString(7, "test");
                insert.executeUpdate();
            }
            try (PreparedStatement update = connection.prepareStatement(
                    "UPDATE base_org_group SET name = ? WHERE id = ?")) {
                update.setString(1, "after-update");
                update.setString(2, id);
                update.executeUpdate();
            }
            try (PreparedStatement select = connection.prepareStatement(
                    "SELECT created_time, updated_time FROM base_org_group WHERE id = ?")) {
                select.setString(1, id);
                try (ResultSet result = select.executeQuery()) {
                    assertTrue(result.next());
                    Timestamp storedCreatedTime = result.getTimestamp("created_time");
                    Timestamp storedUpdatedTime = result.getTimestamp("updated_time");
                    assertEquals(createdTime.getTime(), storedCreatedTime.getTime(),
                            "JDBC must read the stored millisecond value without truncation");
                    assertEquals(789, Math.floorMod(storedCreatedTime.getTime(), 1_000));
                    assertTrue(storedUpdatedTime.after(storedCreatedTime),
                            "database-managed updated_time must advance while created_time stays unchanged");
                }
            }
        }
    }

    private Connection newConnection() throws Exception {
        JdbcDataSource dataSource = new JdbcDataSource();
        dataSource.setURL("jdbc:h2:mem:audit_timestamp_" + UUID.randomUUID()
                + ";MODE=MySQL;INIT=RUNSCRIPT FROM 'classpath:db/organization-service-fixture.sql'");
        return dataSource.getConnection();
    }
}
