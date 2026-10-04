#!/usr/bin/env bash
set -euo pipefail

# Never run against a shared or production database. CI requires a labelled disposable container;
# local mode requires a loopback-only MySQL server under the dedicated /private/tmp test directory.
# The reusable base-k8s job separately verifies full Flyway ordering and schema history.
test_mode="${MYSQL_TEST_MODE:-docker}"
if [[ "$test_mode" == docker ]]; then
  test_container="${MYSQL_TEST_CONTAINER:?Identify the isolated CI MySQL container}"
  [[ "$(docker inspect "$test_container" --format '{{index .Config.Labels "opensabre.test"}}')" == iqc-label-permissions ]] || {
    echo 'Refusing to test an unlabelled MySQL container.' >&2; exit 1;
  }
  mysql_test() {
    docker exec -i "$test_container" sh -c \
      'exec mysql --default-character-set=utf8mb4 -N -B -uroot -p"$MYSQL_ROOT_PASSWORD" "$@"' sh "$@"
  }
elif [[ "$test_mode" == local-socket ]]; then
  : "${MYSQL_TEST_ALLOWED_DATADIR:?Specify the isolated local MySQL datadir}"
  : "${MYSQL_TEST_SOCKET:?Specify the isolated local MySQL socket}"
  : "${MYSQL_TEST_PORT:?Specify the isolated local MySQL port}"
  [[ "$MYSQL_TEST_ALLOWED_DATADIR" =~ ^/private/tmp/iqc-mysql-validation\.[[:alnum:]_-]+/?$ ]] || {
    echo 'Refusing a MySQL datadir outside /private/tmp/iqc-mysql-validation.*.' >&2; exit 1;
  }
  [[ "$MYSQL_TEST_SOCKET" == "${MYSQL_TEST_ALLOWED_DATADIR%/}/mysql.sock" ]] || {
    echo 'Refusing a MySQL socket outside the isolated datadir.' >&2; exit 1;
  }
  [[ "$MYSQL_TEST_PORT" =~ ^[0-9]{5}$ ]] && (( MYSQL_TEST_PORT >= 30000 && MYSQL_TEST_PORT <= 49999 )) || {
    echo 'Refusing a non-test MySQL port.' >&2; exit 1;
  }
  mysql=(mysql --protocol=socket --socket="$MYSQL_TEST_SOCKET" -uroot --default-character-set=utf8mb4 -N -B)
  actual_identity="$("${mysql[@]}" -e 'SELECT CONCAT(@@datadir, "|", @@port, "|", @@bind_address)')"
  expected_identity="${MYSQL_TEST_ALLOWED_DATADIR%/}/|${MYSQL_TEST_PORT}|127.0.0.1"
  [[ "$actual_identity" == "$expected_identity" ]] || {
    echo "Refusing unexpected local MySQL server: $actual_identity" >&2; exit 1;
  }
  mysql_test() { "${mysql[@]}" "$@"; }
else
  echo "Unsupported MYSQL_TEST_MODE: $test_mode" >&2
  exit 1
fi

repository_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
migration_root="$repository_root/src/main/resources/db/migration/mysql"
new_migration="$migration_root/dml/V20260915_01__dml_add_iqc_label_navigation_and_permissions.sql"
scheme_migration="$migration_root/dml/V20260917_01__dml_add_iqc_scheme_permissions.sql"
review_migration="$migration_root/dml/V20260927_01__dml_add_iqc_label_review_resources.sql"
business_result_migration="$migration_root/dml/V20260928_01__dml_add_iqc_business_result_resource.sql"
test_database_prefix="iqc_label_permissions_$$"
cleanup() {
  for scenario in fresh upgrade; do
    mysql_test -e "DROP DATABASE IF EXISTS ${test_database_prefix}_${scenario}" >/dev/null 2>&1 || true
  done
}
trap cleanup EXIT

for scenario in fresh upgrade; do
  test_database="${test_database_prefix}_${scenario}"
  mysql_test -e "CREATE DATABASE $test_database CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
  mysql_test "$test_database" < "$migration_root/baseline/B20260831_02__baseline.sql"
  while IFS= read -r migration; do
    [[ "$migration" == "$new_migration" || "$migration" == "$scheme_migration" || "$migration" == "$review_migration" || "$migration" == "$business_result_migration" ]] && continue
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
INSERT INTO base_org_resource
    (id, code, type, name, url, method, application, product_code, source, status, created_by, updated_by)
VALUES
    ('2100000000000000011', 'iqc:scheme:manage', 'iqc', 'test', '/api/iqc/schemes/{id}', 'PUT', 'iqc-platform', 'iqc', 'ANNOTATION', 'PENDING', 'test', 'test'),
    ('2100000000000000012', 'iqc:scheme:publish', 'iqc', 'test', '/api/iqc/schemes/{id}/publish', 'POST', 'iqc-platform', 'iqc', 'ANNOTATION', 'PENDING', 'test', 'test'),
    ('2100000000000000013', 'iqc:scheme:use', 'iqc', 'test', '/api/iqc/schemes/{id}/versions/{versionNo}/tasks', 'POST', 'iqc-platform', 'iqc', 'ANNOTATION', 'PENDING', 'test', 'test');
INSERT INTO base_org_resource
    (id, code, type, name, url, method, application, product_code, source, status, created_by, updated_by)
VALUES
    ('2100000000000000021', 'iqc:review:label:create', 'iqc', 'test', '/api/iqc/quality-operations/label-results/{labelResultId}/reviews', 'POST', 'iqc-platform', 'iqc', 'ANNOTATION', 'PENDING', 'test', 'test'),
    ('2100000000000000022', 'iqc:review:label:history', 'iqc', 'test', '/api/iqc/quality-operations/label-results/{labelResultId}/reviews', 'GET', 'iqc-platform', 'iqc', 'ANNOTATION', 'PENDING', 'test', 'test'),
    ('2100000000000000023', 'iqc:review:label:queue', 'iqc', 'test', '/api/iqc/quality-operations/label-reviews', 'GET', 'iqc-platform', 'iqc', 'ANNOTATION', 'PENDING', 'test', 'test'),
    ('2100000000000000024', 'iqc:review:label:decide', 'iqc', 'test', '/api/iqc/quality-operations/label-reviews/{reviewId}/decision', 'POST', 'iqc-platform', 'iqc', 'ANNOTATION', 'PENDING', 'test', 'test');
INSERT INTO base_org_resource
    (id, code, type, name, url, method, application, product_code, source, status, created_by, updated_by)
VALUES
    ('2100000000000000031', 'iqc:result:business:view', 'iqc', 'test', '/api/iqc/results/business', 'GET', 'iqc-platform', 'iqc', 'ANNOTATION', 'PENDING', 'test', 'test');
SQL
  fi
  runtime_counts="$(mysql_test "$test_database" -e 'SELECT (SELECT COUNT(*) FROM base_org_user), (SELECT COUNT(*) FROM base_org_user_role);')"
  for iteration in 1 2; do
    mysql_test "$test_database" < "$new_migration"
    mysql_test "$test_database" < "$scheme_migration"
    mysql_test "$test_database" < "$review_migration"
    mysql_test "$test_database" < "$business_result_migration"
    [[ "$(mysql_test "$test_database" < "$repository_root/src/test/resources/db/migration/iqc-label-permissions-assertions.sql")" == PASS ]]
    [[ "$(mysql_test "$test_database" < "$repository_root/src/test/resources/db/migration/iqc-scheme-permissions-assertions.sql")" == PASS ]]
    [[ "$(mysql_test "$test_database" < "$repository_root/src/test/resources/db/migration/iqc-label-review-permissions-assertions.sql")" == PASS ]]
    [[ "$(mysql_test "$test_database" < "$repository_root/src/test/resources/db/migration/iqc-business-result-permissions-assertions.sql")" == PASS ]]
    [[ "$(mysql_test "$test_database" -e 'SELECT (SELECT COUNT(*) FROM base_org_user), (SELECT COUNT(*) FROM base_org_user_role);')" == "$runtime_counts" ]]
  done
  if [[ "$scenario" == upgrade ]]; then
    [[ "$(mysql_test "$test_database" -e "SELECT COUNT(*) FROM base_org_resource WHERE code LIKE 'iqc:label%' AND id LIKE '210000000000000000%';")" == 7 ]]
    [[ "$(mysql_test "$test_database" -e "SELECT CONCAT(url, ' ', method) FROM base_org_resource WHERE code='iqc:label:manage';")" == '/api/iqc/labels/{id}/bindings PUT' ]]
    [[ "$(mysql_test "$test_database" -e "SELECT COUNT(*) FROM base_org_resource WHERE code LIKE 'iqc:scheme:%' AND id LIKE '210000000000000001%';")" == 3 ]]
    [[ "$(mysql_test "$test_database" -e "SELECT CONCAT(url, ' ', method) FROM base_org_resource WHERE code='iqc:scheme:manage';")" == '/api/iqc/schemes/{id} PUT' ]]
    [[ "$(mysql_test "$test_database" -e "SELECT COUNT(*) FROM base_org_resource WHERE code LIKE 'iqc:review:label:%' AND id LIKE '210000000000000002%';")" == 4 ]]
    [[ "$(mysql_test "$test_database" -e "SELECT id FROM base_org_resource WHERE code='iqc:result:business:view';")" == 2100000000000000031 ]]
  fi
  echo "PASS $scenario: label/scheme/review/business-result resources, four-role boundaries, unchanged users, repeat run"
done
