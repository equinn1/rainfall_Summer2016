data { 
  int<lower=1> Nsites;          //number of sites
  int<lower=1> N;               //number of observations
  real<lower=0> y[N];           //rainfall amount
  int <lower=1, upper=Nsites>  site[N];
} 
parameters {
  real<lower=0,upper=1> theta[Nsites];  //probability of measurable rain
  real<lower=0> alpha[Nsites];          //shape parameter for rainfall amount gamma
  real<lower=0> beta[Nsites];           //scale parameter for rainfall amount gamma
} 
model {
  theta ~ beta(1,1);            //uniform prior for theta
  alpha ~ normal(0,5);          //half-normal prior for alpha
  beta ~ normal(0,5);           //half-normal prior for beta
  
  for (i in 1:N){
    int j;
    j = site[i];
    if(y[i] < 0.0001) {       //no measurable rain
      target+=log(1-theta[j]);
    }
    else {                    //measurable rainfall
      target+=log(theta[j])+gamma_lpdf(y[i] | alpha[j],beta[j]);
    }
  }
}
generated quantities{
  int z;
  real y_rep[Nsites];
  for (j in 1:Nsites){
    z = bernoulli_rng(theta[j]);
    if(z==0){
      y_rep[j] = 0.0;
    }
    if(z==1){
      y_rep[j] = gamma_rng(alpha[j],beta[j]);
    }
  }

}