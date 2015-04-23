update t_scc_account set pwd_back = REVERSIBLE_PWD where pwd_back is null;

ALTER TABLE `t_scc_account`
DROP COLUMN `REVERSIBLE_PWD`;