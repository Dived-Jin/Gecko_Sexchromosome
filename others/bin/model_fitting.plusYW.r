library(lme4)
library(effects)
args = commandArgs(T)

inFile = args[1]
outFile = args[2]

expr_df = read.table(inFile, h=F)
colnames(expr_df) = c('Y', 'geneID', 'chrID', 'indID', 'chrType', 'AZS', 'geneLength', 'chrLength')

expr_df$Y = log2(expr_df$Y)
expr_df$chrLength_z = scale(expr_df$chrLength)

m_expr <- lmer(
  Y ~ AZS +
    chrLength_z +
    (1 | indID) +
    (1 | chrID/geneID),
  offset = log(geneLength),
  data = expr_df
)

#summary(m_expr)
eff_AZS <- effect(
  term = "AZS",
  mod = m_expr
)
AZS_est <- as.data.frame(eff_AZS)
#AZS_est

theta_hat <- setNames(AZS_est$fit, AZS_est$AZS)
#theta_hat

ratio_fun <- function(theta) {
  c(
    XZ_OP_hom_AAhom = theta["XZ_noPair_hom"] / theta["A_hom"],   # homogametic XZOP vs homogametic autosomes, control
    XZ_OP_het_AAhet = theta["XZ_noPair_het"] / theta["A_het"],   # heterogametic XZOP vs heterogametic autosomes, DC_XZOP
    XZ_OP_hom_XZ_OP_het  = theta["XZ_noPair_hom"] / theta["XZ_noPair_het"],    # homogametic vs heterogametic Z, DB_XZOP
    XZ_GP_hom_AAhom = theta["XZ_withPair_hom"] / theta["A_hom"],   # homogametic XZGP vs homogametic autosomes, control
    XZ_GP_het_AAhet = theta["XZ_withPair_het"] / theta["A_het"],   # heterogametic XZGP vs heterogametic autosomes, DC_XZGP
    XZ_GP_hom_XZ_GP_het  = theta["XZ_withPair_hom"] / theta["XZ_withPair_het"],    # homogametic vs heterogametic Z, DB_XZGP
    AAhom_AAhet = theta["A_hom"] / theta["A_het"]  # homogametic vs heterogametic autosomes, control
  )
}

ratio_hat <- ratio_fun(theta_hat)
#ratio_hat
#log2(ratio_hat)

boot_fun <- function(fit) {
  eff <- effect("AZS", fit)
  est <- as.data.frame(eff)
  theta <- setNames(est$fit, est$AZS)
  ratio_fun(theta)
}

set.seed(123)
boot_res <- bootMer(
  x        = m_expr,
  FUN      = boot_fun,
  nsim     = 100,
  type     = "parametric",
  use.u    = TRUE
)

boot_CI <- apply(
  boot_res$t,
  2,
  quantile,
  probs = c(0.025, 0.975),
  na.rm = TRUE
)
#boot_CI

ratio_table <- data.frame(
  Ratio = names(ratio_hat),
  Estimate = ratio_hat,
  CI_lower = boot_CI[1, ],
  CI_upper = boot_CI[2, ]
)

write.table(ratio_table, outFile, quote=F, row.names=F, sep="\t")
