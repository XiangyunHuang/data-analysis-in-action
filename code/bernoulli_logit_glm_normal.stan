data {
  int<lower=1> k;
  int<lower=0> n;
  matrix[n, k] X;
  array[n] int<lower=0, upper=1> y;
}
parameters {
  vector[k] beta;
  real alpha;
}
model {
  target += normal_lpdf(beta | 0, 1000);
  target += normal_lpdf(alpha | 0, 1000);
  target += bernoulli_logit_glm_lpmf(y | X, alpha, beta);
}
generated quantities {
  vector[n] log_lik;
  for (i in 1 : n) {
    log_lik[i] = bernoulli_logit_lpmf(y[i] | alpha + X[i] * beta);
  }
}
