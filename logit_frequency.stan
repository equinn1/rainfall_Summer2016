//logistic regression for probability of measurable rain
//
data { 
  int<lower=1> N;                           //number of observations
  int<lower=1> Nsites;                      //number of sites
  int<lower=0,upper=1> measurable_rain[N];  //measurable rain or not
  int<lower=1,upper=Nsites> site[N];        //site
  vector[N] dseq;                           //day index
  int s[Nsites];                            //number of obs for each site
} 
parameters {
  real beta0[Nsites];                       //logistic intercept
  real beta1[Nsites];                       //logistic slope
} 
model {
  int pos;
  beta0 ~ normal(0,5);
  beta1 ~ normal(0,1);
  
  pos<-1;
  for(i in 1:Nsites){
     segment(measurable_rain, pos, s[i]) ~ bernoulli_logit(beta0[i]+beta1[i]*segment(dseq, pos, s[i]));
     pos<-pos+s[i];
  }
}
