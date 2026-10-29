-- Retain the existing menu identity and grants when exposing the delivered configuration page.
UPDATE base_org_menu SET type='MENU',href='/iqc/pipelines',name='检测流水线',icon='settings',order_num=37,
    updated_time=now(3),updated_by='system' WHERE id='900160' AND product_code='iqc';
UPDATE base_org_menu SET parent_id='900160',updated_time=now(3),updated_by='system'
    WHERE product_code='iqc' AND id IN ('900161','900162','900163','900164','900175','900176','900177','900178');
