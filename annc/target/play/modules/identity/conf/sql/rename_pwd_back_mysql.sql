update t_scc_account set pwd_back = REVERSIBLE_PWD where pwd_back is null;

ALTER TABLE "T_SCC_ACCOUNT" DROP("REVERSIBLE_PWD");