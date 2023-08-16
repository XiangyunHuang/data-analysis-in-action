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
  vector[n] log_lik;
  for (i in 1 : n) {
    log_lik[i] = poisson_log_lpmf(y[i] | alpha + X[i] * beta + log_offset[i]);
  }
}
