data {
  int<lower=1> N;
  int<lower=1> D;
  array[N] vector[D] X;
  vector[N] mu;
  real<lower=0> sigma;
  real<lower=0> phi;
}
transformed data {
  real delta = 1e-9;
  matrix[N, N] L;
  matrix[N, N] K = gp_exponential_cov(X, sigma, phi) + diag_matrix(rep_vector(delta, N));
  L = cholesky_decompose(K);
}
parameters {
  vector[N] eta;
}
model {
  eta ~ std_normal();
}
generated quantities {
  vector[N] y;
  y = mu + L * eta;
}
