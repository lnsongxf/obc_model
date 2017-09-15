var k a logit_delta q c r pi mc disp psi spread inv Y H Xjr lambdaX;

varexo epsA eps_psi;

parameters varrho alp zzeta betta deltaSS sigma_c rhodelta rhoA
rho_psi Ass Phi sigmaB xiB Theta kappaSS logit_deltaSS epsilon kappa_GK gam
sigma_a sigma_psi sigma_delta deltabar logit_deltabar
chi sigma_h psi_h epsilonC epsilonH gam_jr theta_jr gy C_bar H_bar;

varrho=2.6;
alp=0.3;
zzeta=7.0;
betta=0.995;
deltabar=0.025;
logit_deltabar = log(deltabar/(1-deltabar));
sigma_c=2;
gam_jr = 0.001;
theta_jr = 1.4;
sigma_h=2.37;
psi_h=1;
chi = .7;
epsilonC = 0;
epsilonH = 0;
Ass=1;
rhoA=.95;
rhodelta=.85;
rho_psi = 0;
gy = 0;

sigmaB=0.975;
xiB=0.003;
epsilon = -2;
kappa_GK = 13;
gam=1e-8;
kappaSS=.05;

Theta=0;
Phi=2;
sigma_a = 0.0060626464427887;
sigma_psi = 0.00001;
sigma_delta = .9;

logit_deltaSS = logit_deltabar;
deltaSS = 1/(1+exp(-logit_deltaSS));

H_bar = csolve_H_rbc;
C_bar = (  (1 - deltaSS * alp/(1 / betta - ( 1 -  deltaSS ))) ) * ( ( Ass * H_bar ) * (alp/(1 / betta - ( 1 -  deltaSS ))) ^ ( alp / ( 1 - alp ) ) );

model;


# delta = 1/(1+exp(-logit_delta));
# lead_delta = 1/(1+exp(-logit_delta(+1)));
# lag_delta = 1/(1+exp(-logit_delta(-1)));
# K = exp( k );
# lead_K = exp( k(+1) );
# lag_K = exp( k(-1) );
# A = exp( a );
# lag_C = exp( c(-1) );
# C = exp( c );
# lead_C = exp( c(+1) );
# I = exp( inv );
# lag_I = exp( inv(-1) );
# lead_I = exp( inv(+1) );
# Q = exp( q );
# lead_Q = exp( q(+1) );
# lag_Q = exp( q(-1) );
# Pi = exp( pi );
# lead_Pi = exp( pi(+1) );
# Disp = exp( disp );
# MC = exp( mc );
# lead_MC = exp( mc(+1) );
Y = (C+I)/(1-gy);
# lead_Y = (lead_C+lead_I)/(1-gy);
# YW = Y*exp(disp);
# lead_YW = lead_Y*exp(disp(+1));
# Z = MC*alp*YW/(psi*lag_K);
# lead_Z = lead_MC*alp*lead_YW/(psi(+1)*K);
# lead_H = H(+1);
# UH = - (C - varrho*H^theta_jr*Xjr)^(-sigma_c) * theta_jr*varrho*Xjr*H^(theta_jr-1);
# UX =  - (C - varrho*H^theta_jr*Xjr)^(-sigma_c) * varrho * H^(theta_jr);
# UC = (C - varrho*H^theta_jr*Xjr)^(-sigma_c);
# lead_UC = (lead_C - varrho*lead_H^theta_jr*Xjr(+1))^(-sigma_c);
%   # lambdaC = UC + lambdaX*gam_jr*C^(gam_jr-1);
%   # lead_lambdaC = lead_UC + lambdaX(+1)*gam_jr*lead_C^(gam_jr-1);
# lambdaC = UC + lambdaX*gam_jr*Xjr/C;
# lead_lambdaC = lead_UC + lambdaX(+1)*gam_jr*Xjr(+1)/lead_C;
Xjr = C^gam_jr * Xjr(-1)^(1-gam_jr);
lambdaX = UX + betta * (1-gam_jr) * lambdaX(+1) * Xjr(+1) / Xjr;
# lead_Lambda = betta*lead_lambdaC/lambdaC;
# W = MC*(1-alp)*YW/H;
# R = exp( r );
# S = Q*K;
# lag_S = lag_Q*lag_K;
# RK = Pi*psi*(Z + (1-delta)*Q)/lag_Q;
# lead_RK = lead_Pi*psi(+1)*(lead_Z + (1-lead_delta)*lead_Q)/Q;
# Y_alt = (A*H)^(1-alp)*(psi*lag_K)^alp / Disp;
# E = 0;
# B = K*Q;
# N = 0;
# D = 0;
# D_rate = 0;
# E_rate = 0;
# kappa = 0;

lead_Lambda*R = lead_Lambda*lead_RK;

pi = 0;
disp = 0;
mc = 0;

spread = lead_RK - R;

I*(1-Phi*(1-I/lag_I)^2) = K - (1-delta)*psi*lag_K;
1=Q*(1-Phi*(I/lag_I-1)^2 - (I/lag_I)*2*Phi*(I/lag_I-1))+lead_Lambda*2*Phi*(lead_I/I-1)*(lead_I/I)^2*lead_Q;

lead_Lambda*R/lead_Pi=1;
log(Y) = (1-alp)*((a) + log(H)) + alp*( k(-1) + log(psi)) - disp;

UH/lambdaC = - W;

a-log(Ass) = rhoA*(a(-1)-log(Ass))+sigma_a*epsA;
psi = ( exp(sigma_psi*eps_psi) )*(psi(-1))^(rho_psi);
logit_delta = logit_deltabar;

end;

steady_state_model;
    mc = 0;
    disp = 0;
    psi = 1;
    q = 0;
    R_ = 1 / betta;
    RK_ = R_;
    r = log( R_ );
    Z_ = 1 / betta - ( 1 -  deltaSS ) ;
    a = log( Ass );
    K_over_Y = alp/Z_;
    I_over_Y = deltaSS * K_over_Y;
    C_over_Y = 1 - gy - I_over_Y;
    Y_over_H = Ass * K_over_Y ^ ( alp / ( 1 - alp ) );
    W_ = (1-alp)*Y_over_H;
    H = H_bar;
    H_ = H;
    Y_ = ( Ass * H_ ) * K_over_Y ^ ( alp / ( 1 - alp ) );
    K_ = K_over_Y * Y_;
    k = log( K_ );
    inv = log(deltaSS) + k;
    C_ = C_over_Y * Y_;
    c = log( C_ );
    Xjr = C_;
    UX_ =  - (C_ - varrho*H^theta_jr*Xjr)^(-sigma_c) * varrho * H^(theta_jr);
    lambdaX = UX_ / ( 1 - betta*( (1-gam_jr) ) );
    logit_delta = logit_deltaSS;
    B_ = K_;
    r_PLUS_b = log( R_ * B_ );

    spread = 0;
    Y = Y_;
end;

steady;
check;

shocks;
    var epsA = 1;  
    var eps_psi = 1; 
end;

stoch_simul( nograph , replic = 256, order = 3, irf = 60, periods = 0 , irf_shocks = ( eps_psi ) );
