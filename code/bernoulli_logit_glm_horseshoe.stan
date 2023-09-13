data {
  int<lower=1> k;
  int<lower=0> n;
  matrix[n, k] X;
  array[n] int<lower=0, upper=1> y;
}
parameters {
  vector[k] beta_tilde;
  real alpha;
  real<lower=0> tau;
  vector<lower=0>[k] lambda;
}
transformed parameters {
  vector[k] beta = beta_tilde .* lambda * tau;
}
model {
  target += normal_lpdf(beta_tilde | 0, lambda);
  target += normal_lpdf(alpha | 0, lambda);
  target += cauchy_lpdf(tau | 0, 1);
  target += cauchy_lpdf(lambda | 0, 1);
  target += bernoulli_logit_glm_lpmf(y | X, alpha, beta);
}
generated quantities {
  vector[n] log_lik;
  for (i in 1 : n) {
    log_lik[i] = bernoulli_logit_lpmf(y[i] | alpha + X[i] * beta);
  }
}
