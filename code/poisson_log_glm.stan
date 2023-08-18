data {
  int<lower=1> k;
  int<lower=0> n;
  matrix[n, k] X;
  array[n] int<lower=0> y;
  vector[n] log_offset;
}
parameters {
  vector[k] beta;
  real alpha;
}
model {
  target += std_normal_lpdf(beta);
  target += std_normal_lpdf(alpha);
  target += poisson_log_glm_lpmf(y | X, alpha + log_offset, beta);
}
generated quantities {
  vector[n] log_lik; // pointwise log-likelihood for LOO
  vector[n] y_rep;   // replications from posterior predictive dist
  for (i in 1 : n) {
    real y_hat_i = alpha + X[i] * beta + log_offset[i];
    log_lik[i] = poisson_log_lpmf(y[i] | y_hat_i);
    y_rep[i] = poisson_log_rng(y_hat_i);
  }
}
