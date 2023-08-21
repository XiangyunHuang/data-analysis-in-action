data {
  int<lower=1> N;
  int<lower=1> D;
  vector[D] mu;
  matrix[D, D] Sigma;
}
transformed data {
  matrix[D, D] L_K = cholesky_decompose(Sigma);
}
parameters {
}
model {
}
generated quantities {
  array[N] vector[D] yhat;
  for (n in 1:N){
    yhat[n] = multi_normal_cholesky_rng(mu, L_K); 
  }
}
