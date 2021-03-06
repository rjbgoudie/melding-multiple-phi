library(tidyverse)

source("scripts/common/plot-settings.R")
source("scripts/common/mcmc-util.R")

sim_settings <- readRDS("rds/surv-example/simulation-settings-and-joint-data.rds")

# psi_2 first
point_est <- readRDS("rds/surv-example/point-est-psi-2-samples.rds")
point_est_1_meld_23 <- readRDS(
  "rds/surv-example/point-est-1-meld-23-psi-2-samples.rds"
)

point_est_3_meld_12 <- readRDS(
  "rds/surv-example/point-est-3-meld-12-psi-2-samples.rds"
)

par_names <- names(point_est[1, 1, ]) %>%
  grep("(lp__|surv_prob)", ., value = TRUE, invert = TRUE)

named_vec <- c(
  "theta_zero" = "theta[0]",
  'theta_one' = "theta[1]",
  "hazard_gamma" = "gamma",
  "alpha" = "alpha"
)

p_1 <- plot_worst_pars(point_est[, , par_names], named_vec)
p_2 <- plot_worst_pars(point_est_1_meld_23[, , par_names], named_vec)
p_3 <- plot_worst_pars(point_est_3_meld_12[, , par_names], named_vec)

ggsave_halfheight(
  filename = "plots/surv-example/point-est-diags.png",
  plot = p_1
)

ggsave_halfheight(
  filename = "plots/surv-example/point-est-1-meld-23-diags.png",
  plot = p_2
)

ggsave_halfheight(
  filename = "plots/surv-example/point-est-3-meld-12-diags.png",
  plot = p_3
)

# next phi_12
point_est_3_meld_12_phi_12_samples <- readRDS(
  "rds/surv-example/point-est-3-meld-12-phi-12-samples.rds"
)

p4 <- bayesplot::mcmc_trace(
  point_est_3_meld_12_phi_12_samples[
    , 
    , 
    sprintf("event_time[%d]", which(as.logical(sim_settings$event_indicator)))
  ])

ggsave_fullpage(
  filename = "plots/surv-example/point-est-3-meld-12-phi-12-event-only-diag.png",
  plot = p4
)

point_est_1_meld_23_phi_23_samples <- readRDS(
  "rds/surv-example/point-est-1-meld-23-phi-23-samples.rds"
)

p5 <- bayesplot::mcmc_trace(
  point_est_1_meld_23_phi_23_samples[
    , 
    , 
    c(
      sprintf("beta[%d,1]", which(as.logical(sim_settings$event_indicator))),
      sprintf("beta[%d,2]", which(as.logical(sim_settings$event_indicator)))
    )
  ])

ggsave_fullpage(
  filename = "plots/surv-example/point-est-1-meld-23-phi-23-event-only-diag.png",
  plot = p5
)
