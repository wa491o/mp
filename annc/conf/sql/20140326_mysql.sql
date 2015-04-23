ALTER TABLE `t_scc_announcement_user_sub`
CHANGE COLUMN `UID` `USER_ID`  bigint(20) NULL DEFAULT NULL AFTER `id`;