#!/usr/bin/env python3
"""Check split-operation menu DML on isolated schemas of the dedicated local MySQL."""
import json
import runpy
import uuid
from pathlib import Path

shared = runpy.run_path(str(Path(__file__).with_name('test-iqc-endpoint-permissions.py')))
sql, quoted, short_id = (shared[key] for key in ('sql', 'quoted', 'short_id'))
MIGRATIONS, GROUPS, TARGETS = (shared[key] for key in ('MIGRATIONS', 'GROUPS', 'TARGETS'))
MENU = MIGRATIONS / 'dml/V20261028_08__dml_add_split_iqc_operation_buttons.sql'
PAIRS = [(parent, child) for parent, children in GROUPS.items() for child in children]
assert len(PAIRS) == 68
PERM = "JSON_UNQUOTE(JSON_EXTRACT(CASE WHEN JSON_VALID(description) THEN description ELSE '{}' END,'$.perm'))"


def insert(database, table, columns, values):
    sql('INSERT INTO ' + table + '(' + columns + ',created_by,updated_by) VALUES (' +
        ','.join(quoted(str(value)) for value in values + ['test', 'test']) + ')', database)


def menus(database):
    return sql('SELECT id,product_code,parent_id,type,IFNULL(href,"NULL"),IFNULL(description,"NULL"),name,order_num FROM base_org_menu ORDER BY id', database).splitlines()


def relations(database):
    return sql('SELECT id,role_id,menu_id FROM base_org_role_menu ORDER BY id', database).splitlines()


def validate(scenario):
    database = 'iqc_operation_menus_' + uuid.uuid4().hex
    sql('CREATE DATABASE ' + database + ' CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci')
    try:
        sql((MIGRATIONS / 'baseline/B20260831_02__baseline.sql').read_text(), database)
        for migration in sorted(MIGRATIONS.glob('dml/*.sql')):
            if migration.name < TARGETS[0].name:
                sql(migration.read_text(), database)
        codes = ','.join(quoted(code) for code in shared['CODES'])
        children = ','.join(quoted(child) for _, child in PAIRS)
        # Construct these capabilities independently of existing controlled role defaults.
        sql('DELETE rr FROM base_org_role_resource rr JOIN base_org_resource r ON r.id=rr.resource_id WHERE r.code IN (' + codes + ');'
            'DELETE FROM base_org_resource WHERE code IN (' + codes + ');'
            'DELETE rm FROM base_org_role_menu rm JOIN base_org_menu m ON m.id=rm.menu_id WHERE ' + PERM.replace('description', 'm.description') + ' IN (' + children + ');'
            'DELETE FROM base_org_menu WHERE ' + PERM + ' IN (' + children + ');', database)
        for parent in GROUPS:
            shared['insert_resource'](database, parent, 'ACTIVE')
        for _, child in PAIRS:
            shared['insert_resource'](database, child,
                'PENDING' if scenario == 'pending' else 'STALE' if scenario == 'stale' else 'ACTIVE',
                application='other-app' if scenario == 'foreign_application' else 'iqc-platform',
                product='other-product' if scenario == 'foreign_product' else 'iqc')
        for migration in TARGETS:
            sql(migration.read_text(), database)
        if scenario == 'missing_root':
            sql("DELETE FROM base_org_menu WHERE id='900001'", database)
        old_ids = {}
        for parent in GROUPS:
            identity = short_id('old-menu:' + parent)
            old_ids[parent] = identity
            insert(database, 'base_org_menu', 'id,product_code,parent_id,type,name,description',
                   [identity, 'iqc', '900001', 'BUTTON', 'Old', json.dumps({'perm': parent})])
        expected_new = set()
        for index, (parent, child) in enumerate(PAIRS):
            resource_id = short_id(child)
            target_id = short_id('existing-menu:' + child)
            if scenario in ('existing_iqc_menu', 'foreign_menu'):
                insert(database, 'base_org_menu', 'id,product_code,parent_id,type,name,description',
                       [target_id, 'iqc' if scenario == 'existing_iqc_menu' else 'other-product', '900001', 'BUTTON', 'Custom', json.dumps({'perm': child})])
            # Unique roles per capability prevent another parent's menu/grant from masking leakage.
            for kind in ('both', 'menu_only', 'api_only', 'parent_api_only'):
                role = short_id(str(index) + ':' + kind)
                if kind != 'api_only':
                    insert(database, 'base_org_role_menu', 'id,role_id,menu_id',
                           [short_id(role + ':old'), role, old_ids[parent]])
                if kind in ('both', 'api_only', 'parent_api_only'):
                    insert(database, 'base_org_role_resource', 'id,role_id,resource_id',
                           [short_id(role + ':api'), role, short_id(parent) if kind == 'parent_api_only' else resource_id])
                if kind == 'both' and scenario not in ('pending', 'stale', 'foreign_application', 'foreign_product', 'missing_root'):
                    expected_new.add((role, target_id if scenario == 'existing_iqc_menu' else 'IQCSB' + __import__('hashlib').sha256(child.encode()).hexdigest()[:15]))
        before_menus, before_relations = menus(database), relations(database)
        before_resources = shared['snapshot'](database)
        before_accounts = sql('SELECT (SELECT COUNT(*) FROM base_org_user),(SELECT COUNT(*) FROM base_org_user_role),(SELECT COUNT(*) FROM base_org_role)', database)
        first = None
        for iteration in range(2):
            sql(MENU.read_text(), database)
            current_menus, current_relations = menus(database), relations(database)
            assert set(before_menus) <= set(current_menus), (scenario, 'original menu mutated')
            assert set(before_relations) <= set(current_relations), (scenario, 'original relation mutated')
            assert shared['snapshot'](database) == before_resources, (scenario, 'API resources or grants mutated')
            assert sql('SELECT (SELECT COUNT(*) FROM base_org_user),(SELECT COUNT(*) FROM base_org_user_role),(SELECT COUNT(*) FROM base_org_role)', database) == before_accounts
            added = {tuple(line.split('\t')[1:]) for line in set(current_relations) - set(before_relations)}
            assert added == expected_new, (scenario, 'unexpected menu grants', added ^ expected_new)
            if first is not None:
                assert (current_menus, current_relations) == first, (scenario, 'not idempotent')
            first = current_menus, current_relations
        visible = sql("SELECT " + PERM + ",COUNT(*) FROM base_org_menu WHERE product_code='iqc' AND " + PERM + ' IN (' + children + ') GROUP BY ' + PERM, database)
        actual = dict(line.split('\t') for line in visible.splitlines())
        expected_codes = set() if scenario in ('foreign_application', 'foreign_product', 'missing_root') else {child for _, child in PAIRS}
        assert actual == dict.fromkeys(expected_codes, '1'), (scenario, 'missing or duplicate capability menus')
        print('PASS', scenario, '68 menu contracts, exact dual-gate role grants, preserved state, two DML passes', flush=True)
    finally:
        sql('DROP DATABASE ' + database)


for scenario in ('active', 'pending', 'stale', 'foreign_application', 'foreign_product', 'existing_iqc_menu', 'foreign_menu', 'missing_root'):
    validate(scenario)
print('PASS all 8 menu migration scenarios; no browser/Flyway/PDP claim', flush=True)
