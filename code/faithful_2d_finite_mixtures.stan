data {
  int<lower=1> K;  // number of mixture components
  int<lower=1> N;  // number of observations
  int<lower=1> D;  // dimension of observations
  array[N] vector[D] y; // observations: a list of N vectors (each has D elements)
}
parameters {
  simplex[K] theta;       // mixing proportions
  array[K] ordered[D] mu; // locations of mixture components
                          // scales of mixture components
  array[K] cholesky_factor_corr[D] Lcorr; // cholesky factor (L_u matrix for R)
}
model {
  for(i in 1:K){
    mu[i] ~ normal(0,3); // prior for mu
    Lcorr[i] ~ lkj_corr_cholesky(2.0); // prior for cholesky factor of a correlation matrix
  }
  
  vector[K] log_theta = log(theta);  // cache log calculation
  
  for (n in 1:N) {
    vector[K] lps = log_theta;
    for (k in 1:K) {
      lps[k] += multi_normal_cholesky_lpdf(y[n] | mu[k], Lcorr[k]);
    }
    target += log_sum_exp(lps);
  }
}
