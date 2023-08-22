data {
  int<lower=1> N;
  int<lower=1> D;
  array[N] vector[D] X;
  array[N] int<lower = 0> y;
  vector[N] offsets;
}
transformed data {
  real delta = 1e-12;
  vector[N] log_offsets = log(offsets);
}
parameters {
  real beta;
  real<lower=0> sigma;
  real<lower=0> phi;
  vector[N] lambda;
}
transformed parameters {
  vector[N] mu = rep_vector(beta, N);
  matrix[N, N] K = gp_exponential_cov(X, sigma, phi) + diag_matrix(rep_vector(delta, N));
  matrix[N, N] L_K = cholesky_decompose(K);
}
model {
  beta ~ std_normal();
  sigma ~ inv_gamma(5, 5);
  phi ~ std_normal();
  
  lambda ~ multi_normal_cholesky(mu, L_K);
  y ~ poisson_log(log_offsets + lambda);
}
