#!/usr/bin/env python3
"""Validate fixed IQC endpoint migrations only on a dedicated local MySQL server."""
import hashlib
import os
from pathlib import Path
import re
import subprocess
import uuid

ROOT = Path(__file__).resolve().parents[1]
MIGRATIONS = ROOT / 'src/main/resources/db/migration/mysql'
GROUPS = {
    'iqc:model:manage': ['iqc:model:update', 'iqc:model:enable', 'iqc:model:disable'],
    'iqc:skill:manage': ['iqc:skill:update', 'iqc:skill:enable', 'iqc:skill:disable', 'iqc:skill:rollback'],
    'iqc:skill:view': ['iqc:skill:versions:view'],
    'iqc:task:view': ['iqc:task:detail:view', 'iqc:task:executions:view'],
    'iqc:task:execute': ['iqc:task:resume', 'iqc:task:pause', 'iqc:task:priority'],
    'iqc:result:view': ['iqc:result:detail:view', 'iqc:result:summary:view', 'iqc:result:labels:view',
                        'iqc:result:label-insights:view', 'iqc:result:conversation:view',
                        'iqc:result:hierarchy:view', 'iqc:result:conversation-history:view', 'iqc:result:feedback:view'],
    'iqc:result:export': ['iqc:result:labels:export'],
    'iqc:conversation:view': ['iqc:conversation:detail:view', 'iqc:conversation:api-stats:view'],
    'iqc:conversation:upload': ['iqc:conversation:batch-upload', 'iqc:conversation:zip-upload',
                                'iqc:conversation:ingest', 'iqc:conversation:batch-ingest'],
    'iqc:mcp:manage': ['iqc:mcp:update', 'iqc:mcp:enable', 'iqc:mcp:disable'],
    'iqc:scheme:manage': ['iqc:scheme:versions:view'],
    'iqc:dashboard:view': ['iqc:bootstrap:view'],
    'iqc:label:view': ['iqc:label:detail:view'],
    'iqc:label:manage': ['iqc:label:category:create', 'iqc:label:group:create', 'iqc:label:category:update',
                         'iqc:label:group:update', 'iqc:label:update', 'iqc:label:values:update',
                         'iqc:label:bindings:update', 'iqc:label:disable', 'iqc:label:group:disable', 'iqc:label:category:disable'],
    'iqc:label-collection:view': ['iqc:label-collection:detail:view'],
    'iqc:label-collection:manage': ['iqc:label-collection:update', 'iqc:label-collection:members:update',
                                  'iqc:label-collection:publish', 'iqc:label-collection:disable'],
    'iqc:label-candidate:view': ['iqc:label-candidate:similarities:view'],
    'iqc:label-candidate:review': ['iqc:label-candidate:reject', 'iqc:label-candidate:merge'],
    'iqc:agent:view': ['iqc:agent:versions:view', 'iqc:agent:versions:compare', 'iqc:agent:version:effect:view'],
    'iqc:agent:approve': ['iqc:agent:reject'],
    'iqc:rule:view': ['iqc:rule:versions:view', 'iqc:rule-set:view', 'iqc:rule-set:versions:view'],
    'iqc:rule:manage': ['iqc:rule:submit', 'iqc:rule:version:manage', 'iqc:rule-set:manage',
                        'iqc:rule-set:version:manage', 'iqc:rule-set:submit', 'iqc:template:materialize'],
    'iqc:rule:approve': ['iqc:rule:reject', 'iqc:rule-set:approve', 'iqc:rule-set:reject'],
}
CODES = list(GROUPS) + [child for children in GROUPS.values() for child in children]
TARGETS = sorted(MIGRATIONS.glob('dml/V20261028_0[1234567]__*.sql'))
assert len(TARGETS) == 7
CONTRACT = {fields[0]: fields[1:] for fields in (line.split('\t') for line in
    (ROOT / 'src/test/resources/db/migration/iqc-endpoint-permission-contract.tsv').read_text().splitlines())}
assert set(CONTRACT) == set(CODES)
validation_dir = os.environ['MYSQL_TEST_ALLOWED_DATADIR'].rstrip('/')
assert re.fullmatch(r'/private/tmp/iqc-mysql-validation\.[A-Za-z0-9_-]+', validation_dir)
socket = os.environ['MYSQL_TEST_SOCKET']
port = os.environ['MYSQL_TEST_PORT']
assert socket == validation_dir + '/mysql.sock'
assert port.isdigit() and 30000 <= int(port) <= 49999
MYSQL = [os.environ.get('MYSQL_TEST_BINARY', 'mysql'), '--protocol=socket', '--socket=' + socket,
         '-uroot', '--default-character-set=utf8mb4', '-N', '-B']


def sql(body, database=None):
    result = subprocess.run(MYSQL + ([database] if database else []), input=body,
                            text=True, capture_output=True, check=True)
    return result.stdout.strip()


assert sql('SELECT CONCAT(@@datadir,"|",@@port,"|",@@bind_address)') == validation_dir + '/|' + port + '|127.0.0.1'


def quoted(value):
    return "'" + value.replace("'", "''") + "'"


def short_id(value):
    return hashlib.sha256(value.encode()).hexdigest()[:20]


def snapshot(database):
    # Exact identities/state/grants; timestamps are expected to advance on rerun.
    return sql('SELECT id,code,status,application,product_code,url,method FROM base_org_resource ORDER BY id;', database), sql(
        'SELECT id,role_id,resource_id FROM base_org_role_resource ORDER BY id;', database)


def runtime(database):
    # No password/token values are read or printed.
    return sql('SELECT (SELECT COUNT(*) FROM base_org_user),(SELECT COUNT(*) FROM base_org_user_role),'
               '(SELECT COUNT(*) FROM base_org_role),(SELECT COUNT(*) FROM base_org_menu),'
               '(SELECT COUNT(*) FROM base_org_role_menu);', database)


def insert_resource(database, code, status, application='iqc-platform', product='iqc', identity=None):
    identity = identity or short_id(code)
    sql('INSERT INTO base_org_resource(id,code,type,name,url,method,application,product_code,source,status,created_by,updated_by) VALUES (' +
        ','.join(map(quoted, [identity, code, 'iqc', 'fixture', '/fixture', 'GET', application, product, 'ANNOTATION', status, 'test', 'test'])) + ');', database)
    return identity


def validate(scenario, parent_status='ACTIVE', child_status=None, application='iqc-platform', product='iqc'):
    database = 'iqc_endpoint_permissions_' + uuid.uuid4().hex
    sql('CREATE DATABASE ' + database + ' CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;')
    try:
        sql((MIGRATIONS / 'baseline/B20260831_02__baseline.sql').read_text(), database)
        # Same pre-migration data sequence as the existing organization SQL validator.
        for migration in sorted(MIGRATIONS.glob('dml/*.sql')):
            if migration not in TARGETS:
                sql(migration.read_text(), database)
        in_codes = ','.join(map(quoted, CODES))
        sql('DELETE rr FROM base_org_role_resource rr JOIN base_org_resource r ON r.id=rr.resource_id WHERE r.code IN (' + in_codes + ');'
            'DELETE FROM base_org_resource WHERE code IN (' + in_codes + ');', database)
        parents = {}
        for index, (code, children) in enumerate(GROUPS.items()):
            if scenario == 'fresh':
                continue
            identity = str(88000000000000000000 + index)
            parents[code] = insert_resource(database, code, parent_status, application, product, identity)
            role = str(77000000000000000000 + index)
            sql('INSERT INTO base_org_role_resource(id,role_id,resource_id,created_by,updated_by) VALUES (' +
                ','.join(map(quoted, [short_id(role + identity), role, identity, 'test', 'test'])) + ');', database)
            if child_status:
                for child in children:
                    insert_resource(database, child, child_status)
        approve_before = sql("SELECT id,code,status,url,method FROM base_org_resource WHERE code='iqc:label:approve'", database)
        approve_grants_before = sql("SELECT rr.id,rr.role_id,rr.resource_id FROM base_org_role_resource rr JOIN base_org_resource r ON r.id=rr.resource_id WHERE r.code='iqc:label:approve' ORDER BY rr.id", database)
        before_runtime = runtime(database)
        first = None
        for iteration in range(2):
            for migration in TARGETS:
                sql(migration.read_text(), database)
            assert sql("SELECT id,code,status,url,method FROM base_org_resource WHERE code='iqc:label:approve'", database) == approve_before
            assert sql("SELECT rr.id,rr.role_id,rr.resource_id FROM base_org_role_resource rr JOIN base_org_resource r ON r.id=rr.resource_id WHERE r.code='iqc:label:approve' ORDER BY rr.id", database) == approve_grants_before
            assert runtime(database) == before_runtime, (scenario, 'runtime counts changed')
            current = snapshot(database)
            if first is not None:
                assert current == first, (scenario, 'non-idempotent identities/state/grants')
            first = current
        rows = {row.split('\t')[1]: row.split('\t') for row in sql(
            'SELECT id,code,status,application,product_code,method,url FROM base_org_resource WHERE code IN (' + in_codes + ')', database).splitlines()}
        for code, row in rows.items():
            if row[3:5] == ['iqc-platform', 'iqc']:
                assert row[5:7] == CONTRACT[code], (scenario, code, 'endpoint drift', row[5:7])
            else:
                assert row[5:7] == ['GET', '/fixture'], (scenario, 'foreign endpoint mutated')
        grants = sql('SELECT rr.role_id,r.code FROM base_org_role_resource rr JOIN base_org_resource r ON r.id=rr.resource_id WHERE r.code IN (' + in_codes + ') ORDER BY rr.role_id,r.code;', database)
        grant_set = {tuple(row.split('\t')) for row in grants.splitlines()}
        inherited = application == 'iqc-platform' and product == 'iqc'
        expected = set()
        for index, (code, children) in enumerate(GROUPS.items()):
            role = str(77000000000000000000 + index)
            if scenario != 'fresh':
                assert rows[code][0] == parents[code] and rows[code][2] == parent_status
                expected.add((role, code))
            for child in children:
                if not inherited and not child_status:
                    assert child not in rows
                    continue
                status = child_status or ('PENDING' if scenario == 'fresh' else parent_status)
                assert rows[child][2] == status
                if child_status:
                    assert rows[child][0] == short_id(child)
                if scenario != 'fresh' and inherited and parent_status == status == 'ACTIVE':
                    expected.add((role, child))
        assert grant_set == expected, (scenario, 'unexpected role grants', grant_set ^ expected)
        # Verify effective active relation disappears when explicitly revoked; do not replay DML after revocation.
        if scenario == 'active':
            child = GROUPS['iqc:model:manage'][0]
            sql('DELETE rr FROM base_org_role_resource rr JOIN base_org_resource r ON r.id=rr.resource_id WHERE r.code=' + quoted(child), database)
            assert sql('SELECT COUNT(*) FROM base_org_role_resource rr JOIN base_org_resource r ON r.id=rr.resource_id WHERE r.status=\'ACTIVE\' AND r.code=' + quoted(child), database) == '0'
        print('PASS', scenario, 'exact grants, preserved IDs/states, two DML passes, unchanged runtime counts', flush=True)
    finally:
        sql('DROP DATABASE ' + database)


for scenario, status, child_status, application, product in [
    ('fresh', 'PENDING', None, 'iqc-platform', 'iqc'),
    ('active', 'ACTIVE', None, 'iqc-platform', 'iqc'),
    ('pending', 'PENDING', None, 'iqc-platform', 'iqc'),
    ('stale', 'STALE', None, 'iqc-platform', 'iqc'),
    ('existing_pending', 'ACTIVE', 'PENDING', 'iqc-platform', 'iqc'),
    ('existing_active', 'PENDING', 'ACTIVE', 'iqc-platform', 'iqc'),
    ('existing_active_parent_active', 'ACTIVE', 'ACTIVE', 'iqc-platform', 'iqc'),
    ('existing_stale', 'ACTIVE', 'STALE', 'iqc-platform', 'iqc'),
    ('foreign_application', 'ACTIVE', None, 'other-app', 'iqc'),
    ('foreign_product', 'ACTIVE', None, 'iqc-platform', 'other-product'),
]:
    validate(scenario, status, child_status, application, product)
print('PASS all 10 endpoint permission migration scenarios; no Flyway/PDP/HTTP claim')
