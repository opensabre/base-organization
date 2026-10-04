-- Retain the dataset permission identity and role grants for the delivered dataset page.
UPDATE base_org_menu SET type='MENU',href='/iqc/evaluation/datasets',name='评测数据集',order_num=38,
    updated_time=now(3),updated_by='system' WHERE id='900185' AND product_code='iqc';
UPDATE base_org_menu SET parent_id='900185',updated_time=now(3),updated_by='system'
    WHERE product_code='iqc' AND id IN ('900186','900187','900188','900189','900190','900191','900192');
-- Gold annotation/review remains in the existing quality operations sample page.
