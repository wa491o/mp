ALTER TABLE `t_scc_announcement_detail`
MODIFY COLUMN `URL_SOURCE`  varchar(2000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL AFTER `SOURCE`;