data {
  int<lower=1> N;
  int<lower=1> D;
  array[N] vector[D] x;
  vector[N] y;
}
transformed data {
  real delta = 1e-9;
  vector[N] mu = rep_vector(0, N);
}
parameters {
  real<lower=0> phi;
  real<lower=0> sigma;
}
model {
  matrix[N, N] L_K;
  {
    matrix[N, N] K = gp_exponential_cov(x, sigma, phi) + diag_matrix(rep_vector(delta, N));
    L_K = cholesky_decompose(K);
  }
  
  phi ~ std_normal();
  sigma ~ std_normal();

  y ~ multi_normal_cholesky(mu, L_K);
}
