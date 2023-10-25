data {
  int<lower=0> N;
  int<lower=0> T;
  vector[T] x;
  matrix[N,T] y;
  real xbar;
}
parameters {
  vector[N] alpha;
  vector[N] beta;

  real alpha_c;
  real beta_c;          // beta.c in original bugs model

  real<lower=0> tausq_c;
  real<lower=0> tausq_alpha;
  real<lower=0> tausq_beta;
}
transformed parameters {
  real<lower=0> tau_c;       // sigma in original bugs model
  real<lower=0> tau_alpha;
  real<lower=0> tau_beta;

  tau_c = sqrt(tausq_c);
  tau_alpha = sqrt(tausq_alpha);
  tau_beta = sqrt(tausq_beta);
}
model {
  alpha_c ~ normal(0, 100);
  beta_c ~ normal(0, 100);
  tausq_c ~ inv_gamma(0.001, 0.001);
  tausq_alpha ~ inv_gamma(0.001, 0.001);
  tausq_beta ~ inv_gamma(0.001, 0.001);
  alpha ~ normal(alpha_c, tau_alpha); // vectorized
  beta ~ normal(beta_c, tau_beta);  // vectorized
  for (n in 1:N)
    for (t in 1:T)
      y[n,t] ~ normal(alpha[n] + beta[n] * (x[t] - xbar), tau_c);
}
generated quantities {
  real alpha0;
  alpha0 = alpha_c - xbar * beta_c;
}
