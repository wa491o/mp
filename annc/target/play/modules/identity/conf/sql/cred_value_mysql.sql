ALTER TABLE `t_scc_credential`
MODIFY COLUMN `VALUE`  varchar(4000) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL AFTER `TYPE`;