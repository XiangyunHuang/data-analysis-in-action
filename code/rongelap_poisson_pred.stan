functions {
  vector gp_pred_rng(array[] vector x2,
                     vector lambda,
                     array[] vector x1,
                     real beta,
                     real sigma,
                     real phi,
                     real delta) {
    int N1 = rows(lambda);
    int N2 = size(x2);
    vector[N2] f2;
    {
      matrix[N1, N1] L_K;
      vector[N1] K_div_lambda;
      matrix[N1, N2] k_x1_x2;
      matrix[N1, N2] v_pred;
      vector[N2] f2_mu;
      matrix[N2, N2] cov_f2;
      matrix[N2, N2] diag_delta;
      matrix[N1, N1] K;
      K = gp_exponential_cov(x1, sigma, phi);
      L_K = cholesky_decompose(K);
      K_div_lambda = mdivide_left_tri_low(L_K, lambda - beta);
      K_div_lambda = mdivide_right_tri_low(K_div_lambda', L_K)';
      k_x1_x2 = gp_exponential_cov(x1, x2, sigma, phi);
      f2_mu = beta + (k_x1_x2' * K_div_lambda);
      v_pred = mdivide_left_tri_low(L_K, k_x1_x2);
      cov_f2 = gp_exponential_cov(x2, sigma, phi) - v_pred' * v_pred;
      diag_delta = diag_matrix(rep_vector(delta, N2));

      f2 = multi_normal_rng(f2_mu, cov_f2 + diag_delta);
    }
    return f2;
  }
}
data {
  int<lower=1> D;
  int<lower=1> N1;
  array[N1] vector[D] x1;
  array[N1] int<lower = 0> y1;
  vector[N1] offsets1;
  int<lower=1> N2;
  array[N2] vector[D] x2;
  vector[N2] offsets2;
}
transformed data {
  real delta = 1e-12;
  vector[N1] log_offsets1 = log(offsets1);
  vector[N2] log_offsets2 = log(offsets2);
  
  int<lower=1> N = N1 + N2;
  array[N] vector[D] x;
  
  for (n1 in 1:N1) {
    x[n1] = x1[n1];
  }
  for (n2 in 1:N2) {
    x[N1 + n2] = x2[n2];
  }
}
parameters {
  real beta;
  real<lower=0> sigma;
  real<lower=0> phi;
  vector[N1] lambda1;
}
transformed parameters {
  vector[N1] mu = rep_vector(beta, N1);
}
model {
  matrix[N1, N1] L_K;
  {
    matrix[N1, N1] K = gp_exponential_cov(x1, sigma, phi) + diag_matrix(rep_vector(delta, N1));
    L_K = cholesky_decompose(K);
  }

  beta ~ std_normal();
  sigma ~ inv_gamma(5, 5);
  phi ~ std_normal();
  
  lambda1 ~ multi_normal_cholesky(mu, L_K);
  y1 ~ poisson_log(log_offsets1 + lambda1);
}
generated quantities {
  vector[N1] yhat;     // Posterior predictions for each location
  vector[N1] log_lik;  // Log likelihood for each location
  vector[N1] RR1 = log_offsets1 + lambda1;
  
  for(n in 1:N1) {
    log_lik[n] = poisson_log_lpmf(y1[n] | RR1[n]);
    yhat[n] = poisson_log_rng(RR1[n]);
  }
  
  vector[N2] ypred; 
  vector[N2] lambda2 = gp_pred_rng(x2, lambda1, x1, beta, sigma, phi, delta);
  vector[N2] RR2 = log_offsets2 + lambda2;
  
  for(n in 1:N2) {
    ypred[n] = poisson_log_rng(RR2[n]);
  }
}
