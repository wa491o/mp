update `T_SCC_USER` t0 set t0.ACCOUNT_ID = (select t1.`ID` from `T_SCC_ACCOUNT` t1 where t1.`USER_ID` = t0.`ID`) where t0.ACCOUNT_ID is null;

ALTER TABLE `t_scc_account`
MODIFY COLUMN `USER_ID`  bigint(20) NULL AFTER `STATUS`;