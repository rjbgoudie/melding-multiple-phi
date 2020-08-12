library(tibble)
library(dplyr)

source("scripts/common/logger-setup.R")

sim_settings <- readRDS("rds/surv-example/submodel-one-simulation-settings.rds")

# TODO: censoring time / censoring in general?
# will this lead to truncated distributions?
# Possibly too hard

flog.info("surv-submodel-one: simulating data", name = base_filename)

simulated_data <- with(sim_settings, 
  bind_rows(lapply(1 : n_patients, function(patient_id) {
    beta_one_true <- rnorm(n = 1, mean = 1, sd = 0.1)
    beta_two_true <- rnorm(
      n = 1,
      mean = ifelse(event_indicator[patient_id], -1, 0),
      sd = ifelse(event_indicator[patient_id], 0.2, 0.1)
    )
    obs_times <- sort(runif(
      n = n_obs_per_patient[patient_id]
    ))
    true_values <- beta_one_true + beta_two_true * obs_times
    obs_values <- abs(
      true_values + 
      rnorm(n = n_obs_per_patient[patient_id], mean = 0, sd = sigma_noise)
    )
    res <- tibble(
      patient_id = patient_id,
      time = obs_times,
      measurement = obs_values,
      event_indicator = event_indicator[patient_id]
    )
  }))
)

flog.info(
  "surv-submodel-one: saving simulated data to disk",
  name = base_filename
)

saveRDS(
  object = simulated_data,
  file = "rds/surv-example/submodel-one-simulated-data.rds"
)