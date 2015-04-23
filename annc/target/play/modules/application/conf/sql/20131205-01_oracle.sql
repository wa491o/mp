update t_scc_app_detail set type_device = 3 where type_device is null;
ALTER TABLE t_scc_app_detail MODIFY(ID_CAT_APP  NUMBER(19));
