rspm::enable()
if (!require("desc")) install.packages(pkgs = "desc")
if (!require("remotes")) install.packages(pkgs = "remotes")
desc_df <- desc::desc_get_deps()
pkgs <- desc_df[desc_df$type != "Depends", "package"]

install.packages(pkgs = setdiff(pkgs, c("INLA", "cmdstanr", "plot2", "rjags")))
install.packages("INLA", repos = c(getOption("repos"), INLA = "https://inla.r-inla-download.org/R/stable"))
install.packages("cmdstanr", repos = c(getOption("repos"), STAN = "https://mc-stan.org/r-packages/"))
install.packages("plot2", repos = c(getOption("repos"), PLOT = "https://grantmcdermott.r-universe.dev"))
remotes::install_github(c("davidsjoberg/ggbump", "davidsjoberg/ggstream"))

# rjags and rstanarm can't be installed because Rocky Linux 9 doesn't have JAGS and Posit doesn't have rstanarm 
