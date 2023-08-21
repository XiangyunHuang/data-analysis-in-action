data {
  int<lower=1> N; // number of observations
  int<lower=1> K; // dimension of observations
  array[N] vector[K] y; // observations: a list of N vectors (each has K elements)
}
parameters {
  vector[K] mu;
  cholesky_factor_corr[K] Lcorr; // cholesky factor (L_u matrix for R)
  vector<lower=0>[K] sigma;
}
transformed parameters {
  corr_matrix[K] R; // correlation matrix
  cov_matrix[K] Sigma; // VCV matrix
  R = multiply_lower_tri_self_transpose(Lcorr); // R = Lcorr * Lcorr'
  Sigma = quad_form_diag(R, sigma); // quad_form_diag: diag_matrix(sig) * R * diag_matrix(sig)
}
model {
  sigma ~ cauchy(0, 5); // prior for sigma
  Lcorr ~ lkj_corr_cholesky(2.0); // prior for cholesky factor of a correlation matrix
  y ~ multi_normal(mu, Sigma);
}
