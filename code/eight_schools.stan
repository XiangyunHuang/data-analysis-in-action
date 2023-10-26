data {
  int<lower=0> J; // 学校数目 
  array[J] real y; // 测试效果的预测值
  array[J] real <lower=0> sigma; // 测试效果的标准差 
}
parameters {
  real mu; 
  real<lower=0> tau;
  vector[J] eta;
}
transformed parameters {
  vector[J] theta;
  theta = mu + tau * eta;
}
model {
  target += normal_lpdf(mu | 0, 1e3); 
  target += cauchy_lpdf(tau | 0, 5);
  target += std_normal_lpdf(eta);
  target += normal_lpdf(y | theta, sigma);
}
