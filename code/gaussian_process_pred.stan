functions {
  vector gp_pred_rng(array[] vector x2,
                     vector y1,
                     array[] vector x1,
                     real sigma,
                     real phi,
                     real tau,
                     real delta) {
    int N1 = rows(y1);
    int N2 = size(x2);
    vector[N2] f2;
    {
      matrix[N1, N1] L_K;
      vector[N1] K_div_y1;
      matrix[N1, N2] k_x1_x2;
      matrix[N1, N2] v_pred;
      vector[N2] f2_mu;
      matrix[N2, N2] cov_f2;
      matrix[N2, N2] diag_delta;
      matrix[N1, N1] K;
      K = gp_exponential_cov(x1, sigma, phi);
      for (n in 1:N1) {
        K[n, n] = K[n, n] + square(tau);
      }
      L_K = cholesky_decompose(K);
      K_div_y1 = mdivide_left_tri_low(L_K, y1);
      K_div_y1 = mdivide_right_tri_low(K_div_y1', L_K)';
      k_x1_x2 = gp_exponential_cov(x1, x2, sigma, phi);
      f2_mu = (k_x1_x2' * K_div_y1);
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
  vector[N1] y1;
  int<lower=1> N2;
  array[N2] vector[D] x2;
}
transformed data {
  real delta = 1e-9;
}
parameters {
  real beta;
  real<lower=0> phi;
  real<lower=0> sigma;
  real<lower=0> tau;
}
transformed parameters {
  vector[N1] mu = rep_vector(beta, N1);
}
model {
  matrix[N1, N1] L_K;
  {
    matrix[N1, N1] K = gp_exponential_cov(x1, sigma, phi);
    real sq_tau = square(tau);

    // diagonal elements
    for (n1 in 1:N1) {
      K[n1, n1] = K[n1, n1] + sq_tau;
    }

    L_K = cholesky_decompose(K);
  }

  beta ~ std_normal();
  phi ~ std_normal();
  sigma ~ inv_gamma(5, 5);
  tau ~ std_normal();

  y1 ~ multi_normal_cholesky(mu, L_K);
}
generated quantities {
  vector[N2] f2;
  vector[N2] ypred;

  f2 = gp_pred_rng(x2, y1, x1, sigma, phi, tau, delta);
  for (n2 in 1:N2) {
    ypred[n2] = normal_rng(f2[n2], tau);
  }
}
