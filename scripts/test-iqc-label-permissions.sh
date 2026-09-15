#!/usr/bin/env bash
set -euo pipefail

# Never run against a shared or production database; CI supplies a labelled disposable container.
# The reusable base-k8s job separately verifies full Flyway ordering and schema history.
test_container="${MYSQL_TEST_CONTAINER:?Identify the isolated CI MySQL container}"
[[ "$(docker inspect "$test_container" --format '{{index .Config.Labels "opensabre.test"}}')" == iqc-label-permissions ]] || {
  echo 'Refusing to test an unlabelled MySQL container.' >&2; exit 1;
}
repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
migration_root="$repository_root/src/main/resources/db/migration/mysql"
new_migration="$migration_root/dml/V20260915_01__dml_add_iqc_label_navigation_and_permissions.sql"

mysql_test() {
  docker exec -i "$test_container" sh -c \
    'exec mysql --default-character-set=utf8mb4 -N -B -uroot -p"$MYSQL_ROOT_PASSWORD" "$@"' sh "$@"
}

for scenario in fresh upgrade; do
  test_database="iqc_label_permissions_${scenario}_test"
  mysql_test -e "CREATE DATABASE $test_database CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
  mysql_test "$test_database" < "$migration_root/baseline/B20260831_02__baseline.sql"
  while IFS= read -r migration; do
    [[ "$migration" == "$new_migration" ]] && continue
    mysql_test "$test_database" < "$migration"
  done < <(find "$migration_root/dml" -name '*.sql' -print | sort)

  if [[ "$scenario" == upgrade ]]; then
    # Synthetic registration with generated IDs and a different endpoint, never copied from production.
    mysql_test "$test_database" <<'SQL'
INSERT INTO base_org_resource
    (id, code, type, name, url, method, application, product_code, source, status, created_by, updated_by)
VALUES
    ('2100000000000000001', 'iqc:label:view', 'iqc', 'test', '/api/iqc/labels/{id}', 'GET', 'iqc-platform', 'iqc', 'ANNOTATION', 'PENDING', 'test', 'test'),
    ('2100000000000000002', 'iqc:label:manage', 'iqc', 'test', '/api/iqc/labels/{id}/bindings', 'PUT', 'iqc-platform', 'iqc', 'ANNOTATION', 'PENDING', 'test', 'test'),
    ('2100000000000000003', 'iqc:label:approve', 'iqc', 'test', '/api/iqc/labels/{id}/publish', 'POST', 'iqc-platform', 'iqc', 'ANNOTATION', 'PENDING', 'test', 'test'),
    ('2100000000000000004', 'iqc:label-collection:view', 'iqc', 'test', '/api/iqc/label-collections', 'GET', 'iqc-platform', 'iqc', 'ANNOTATION', 'PENDING', 'test', 'test'),
    ('2100000000000000005', 'iqc:label-collection:manage', 'iqc', 'test', '/api/iqc/label-collections', 'POST', 'iqc-platform', 'iqc', 'ANNOTATION', 'PENDING', 'test', 'test'),
    ('2100000000000000006', 'iqc:label-candidate:view', 'iqc', 'test', '/api/iqc/label-candidates', 'GET', 'iqc-platform', 'iqc', 'ANNOTATION', 'PENDING', 'test', 'test'),
    ('2100000000000000007', 'iqc:label-candidate:review', 'iqc', 'test', '/api/iqc/label-candidates/{id}/merge', 'POST', 'iqc-platform', 'iqc', 'ANNOTATION', 'PENDING', 'test', 'test');
SQL
  fi
  runtime_counts="$(mysql_test "$test_database" -e 'SELECT (SELECT COUNT(*) FROM base_org_user), (SELECT COUNT(*) FROM base_org_user_role);')"
  for iteration in 1 2; do
    mysql_test "$test_database" < "$new_migration"
    [[ "$(mysql_test "$test_database" < "$repository_root/src/test/resources/db/migration/iqc-label-permissions-assertions.sql")" == PASS ]]
    [[ "$(mysql_test "$test_database" -e 'SELECT (SELECT COUNT(*) FROM base_org_user), (SELECT COUNT(*) FROM base_org_user_role);')" == "$runtime_counts" ]]
  done
  if [[ "$scenario" == upgrade ]]; then
    [[ "$(mysql_test "$test_database" -e "SELECT COUNT(*) FROM base_org_resource WHERE code LIKE 'iqc:label%' AND id LIKE '210000000000000000%';")" == 7 ]]
    [[ "$(mysql_test "$test_database" -e "SELECT CONCAT(url, ' ', method) FROM base_org_resource WHERE code='iqc:label:manage';")" == '/api/iqc/labels/{id}/bindings PUT' ]]
  fi
  echo "PASS $scenario: hierarchy, active resources, four-role boundaries, unchanged users, repeat run"
done
