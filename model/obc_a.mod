var k a logit_delta q c r pi mc disp psi spread inv Y H b D mv nu kappa
    E_rate D_rate;

@#for lag in [1:7]
var prodR@{lag} lagD@{lag} SZ@{lag};
@#endfor

var Xjr lambdaX;

varexo epsA;

parameters varrho alp zzeta betta deltaSS sigma_c gy rhodelta rhoA
rho_psi Ass Phi sigmaB xiB Theta kappaSS logit_deltaSS epsilon kappa_GK gam
sigma_a sigma_psi sigma_delta deltabar logit_deltabar
chi sigma_h psi_h epsilonC epsilonH gam_jr theta_jr C_bar H_bar 
nubar kappa_new lambdaB_bar SZ7_bar SZ6_bar SZ5_bar SZ4_bar SZ3_bar 
SZ2_bar SZ1_bar MD1_bar MD2_bar MD3_bar MD4_bar MD5_bar MD6_bar MD7_bar;

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
sigmaB=0.975;
xiB=0.003;
epsilon = -2;
kappa_GK = 13;
gam=1e-8;
kappaSS=.05;
gy = 0;

Theta=0.669734151867773;
Phi=2;
sigma_a = 0.0060626464427887;
sigma_psi = 0;
sigma_delta = .9;

logit_deltaSS = logit_deltabar;
deltaSS = 1/(1+exp(-logit_deltaSS));

nubar = 400;
kappa_new = .1;

lambdaB_bar = gam*(1-(1-gam)*(1-Theta));
SZ7_bar = lambdaB_bar;
SZ6_bar = lambdaB_bar + (1-gam)*SZ7_bar*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lambdaB_bar );
SZ5_bar = lambdaB_bar + (1-gam)*SZ6_bar*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lambdaB_bar );
SZ4_bar = lambdaB_bar + (1-gam)*SZ5_bar*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lambdaB_bar );
SZ3_bar = lambdaB_bar + (1-gam)*SZ4_bar*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lambdaB_bar );
SZ2_bar = lambdaB_bar + (1-gam)*SZ3_bar*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lambdaB_bar );
SZ1_bar = lambdaB_bar + (1-gam)*SZ2_bar*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lambdaB_bar );
@#for lag in [1:7]
MD@{lag}_bar = SZ@{lag}_bar*(1 / betta)^@{lag}*( (1-gam)*(1-Theta) )/( (1-(1-gam)*(1-Theta)) - lambdaB_bar );
@#endfor

H_bar = csolve_H_obc;
C_bar = ( 1 - deltaSS * alp/( ( 1/((1-gam)*betta*( ( 1 - gam*(1-( (1-gam)*betta*MD1_bar/(1+(1-gam)*betta*MD1_bar) ))*(1-(1-gam)*(1-Theta)) )/(1-gam) )) )-1+deltaSS ) ) * ( Ass * H_bar )*(alp/(1 / ( 1 - gam ) / betta - ( 1 -  deltaSS ) / ( 1 - gam ) + gam * ( betta * Theta * ( 1 - deltaSS ) )))^( alp / ( 1 - alp ) );

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
Y = C+I;
# lead_Y = lead_C+lead_I;
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

# lag_R = exp( r(-1) );
# lead_R = exp( r(+1) );
# SG = 0;
# lead_SG = 0;
# MV = exp( mv );
# lead_MV = exp( mv(+1) );
# lead_kappa = kappa(+1);
# lead_Xi = (1-gam)*lead_Lambda*lead_MV*(1-kappa)/(1-lead_kappa);
# lambdaB = (1-(1-gam)*(1-Theta))*(1-kappa)*(MV-1)/(MV-(1-kappa)*(1-(1-gam)*(1-Theta)));
# lead_lambdaB = (1-(1-gam)*(1-Theta))*(1-lead_kappa)*(lead_MV-1)/(lead_MV-(1-lead_kappa)*(1-(1-gam)*(1-Theta)));

@#for lag in [1:7]
# MD@{lag} = SZ@{lag}*prodR@{lag}*( (1-gam)*(1-Theta) )/( (1-(1-gam)*(1-Theta)) - lambdaB );
# mD@{lag} = ( MD@{lag} + (1-gam)*(1-Theta)*prodR@{lag} )/( 1 - (1-gam)*(1-Theta) );
@#endfor
# mV = MV / ( 1 - (1-gam)*(1-Theta) ) - (1-kappa);
# summ_times_D = mD1*lagD1 + mD2*lagD2 + mD3*lagD3 + mD4*lagD4 + mD5*lagD5 + mD6*lagD6 + mD7*lagD7;
# sumM_times_D = MD1*lagD1 + MD2*lagD2 + MD3*lagD3 + MD4*lagD4 + MD5*lagD5 + MD6*lagD6 + MD7*lagD7;
# sumprodR_times_D = prodR1*lagD1 + prodR2*lagD2 + prodR3*lagD3 + prodR4*lagD4 + prodR5*lagD5 + prodR6*lagD6 + prodR7*lagD7;
# lead_MD1 = SZ1(+1)*prodR1(+1)*( (1-gam)*(1-Theta) )/( (1-(1-gam)*(1-Theta)) - lead_lambdaB );
# B = exp( b );
# lag_B = exp( b(-1) );
# Vhat = ( RK*lag_S/Pi - (lag_R-SG)*lag_B/Pi )/(1-kappa);
# V = MV*Vhat + sumM_times_D;
# E = ( D + S - B )/(1-kappa) - Vhat;
# lambdaD = kappa - (1-gam)*(1-kappa)*(lead_Lambda/lead_Pi)*lead_MD1;
# N = S - B;

prodR1 = lag_R;
prodR2 = lag_R*prodR1(-1);
prodR3 = lag_R*prodR2(-1);
prodR4 = lag_R*prodR3(-1);
prodR5 = lag_R*prodR4(-1);
prodR6 = lag_R*prodR5(-1);
prodR7 = lag_R*prodR6(-1);
lagD1 = D(-1)/Pi;
lagD2 = lagD1(-1)/Pi;
lagD3 = lagD2(-1)/Pi;
lagD4 = lagD3(-1)/Pi;
lagD5 = lagD4(-1)/Pi;
lagD6 = lagD5(-1)/Pi;
lagD7 = lagD6(-1)/Pi;
SZ1 = lambdaB + (1-gam)*SZ2(+1)*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lead_lambdaB );
SZ2 = lambdaB + (1-gam)*SZ3(+1)*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lead_lambdaB );
SZ3 = lambdaB + (1-gam)*SZ4(+1)*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lead_lambdaB );
SZ4 = lambdaB + (1-gam)*SZ5(+1)*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lead_lambdaB );
SZ5 = lambdaB + (1-gam)*SZ6(+1)*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lead_lambdaB );
SZ6 = lambdaB + (1-gam)*SZ7(+1)*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lead_lambdaB );
SZ7 = lambdaB;

kappa = kappa_new*( 1 - exp(-nu*E/V ) );
D_rate = D/N;
E_rate = E/N;

(1-gam)*(lead_Lambda/lead_Pi)*( lead_MV/MV )*(R - lead_SG)*(1-kappa)/(1-kappa(+1)) + (MV-1) / ( MV - (1-kappa)*(1-(1-gam)*(1-Theta)) ) = 1;
1 = lead_Xi*lead_RK/lead_Pi;

0 = min( D , lambdaD );
0 = min( mV*Vhat + summ_times_D - B , lambdaB);

pi = 0;
disp = 0;
mc = 0;
nu = nubar;

spread = lead_RK - R;

I*(1-Phi*(1-I/lag_I)^2) = K - (1-delta)*psi*lag_K;
1=Q*(1-Phi*(I/lag_I-1)^2 - (I/lag_I)*2*Phi*(I/lag_I-1))+lead_Lambda*2*Phi*(lead_I/I-1)*(lead_I/I)^2*lead_Q;

lead_Lambda*R/lead_Pi=1;
log(Y) = (1-alp)*((a) + log(H)) + alp*( k(-1) + log(psi)) - disp;

UH/lambdaC = - W;

a-log(Ass) = rhoA*(a(-1)-log(Ass))+sigma_a*epsA;
logit_delta = logit_deltabar;
psi = 1;

end;

steady_state_model;
    mc = 0;
    disp = 0;
    pi = 0;
    psi = 1;
    logit_delta = logit_deltaSS;
    nu = nubar;
    q = 0;
    R_ = 1 / betta;
    r = log( R_ );
    a = log( Ass );
    lambdaD_ = 0;
    lambdaB_ = gam*(1-(1-gam)*(1-Theta));
    SZ7 = lambdaB_;
    SZ6 = lambdaB_ + (1-gam)*SZ7*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lambdaB_ );
    SZ5 = lambdaB_ + (1-gam)*SZ6*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lambdaB_ );
    SZ4 = lambdaB_ + (1-gam)*SZ5*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lambdaB_ );
    SZ3 = lambdaB_ + (1-gam)*SZ4*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lambdaB_ );
    SZ2 = lambdaB_ + (1-gam)*SZ3*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lambdaB_ );
    SZ1 = lambdaB_ + (1-gam)*SZ2*(1-(1-gam)*(1-Theta))/( (1-(1-gam)*(1-Theta))-lambdaB_ );
    @#for lag in [1:7]
    prodR@{lag} = R_^@{lag};
    MD@{lag}_ = SZ@{lag}*R_^@{lag}*( (1-gam)*(1-Theta) )/( (1-(1-gam)*(1-Theta)) - lambdaB_ );
    mD@{lag}_ = ( MD@{lag}_ + (1-gam)*(1-Theta)*R_^@{lag} )/( 1 - (1-gam)*(1-Theta) );
    @#endfor
    kappa = (1-gam)*betta*MD1_/(1+(1-gam)*betta*MD1_);
    MV_ = ( 1 - gam*(1-kappa)*(1-(1-gam)*(1-Theta)) )/(1-gam);
    mv = log( MV_ );
    mV_ = MV_ / ( 1 - (1-gam)*(1-Theta) ) - (1-kappa);
    RK_ = 1/((1-gam)*betta*MV_);
    Z_ = RK_-1+deltaSS;
    K_over_Y = alp/Z_;
    I_over_Y = deltaSS * K_over_Y;
    C_over_Y = 1 - I_over_Y;
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
    sum_mD = mD1_ + mD2_ + mD3_ + mD4_ + mD5_ + mD6_ + mD7_;
    sum_MD = MD1_ + MD2_ + MD3_ + MD4_ + MD5_ + MD6_ + MD7_;
    AUXBD = sum_mD/(1+mV_*R_/(1-kappa));
    AUXBS = (mV_*RK_/(1-kappa))/(1+mV_*R_/(1-kappa));
    AUXED = (1/nubar)*( log( 1 - kappa/kappa_new ) )*( ((MV_*R_/(1-kappa))/(1+mV_*R_/(1-kappa)))*sum_mD - sum_MD );
    AUXES = (1/nubar)*( log( 1 - kappa/kappa_new ) )*((MV_*RK_/(1-kappa))/(1+mV_*R_/(1-kappa)));
    D = K_*(RK_ - 1 - (R_-1)*AUXBS - (1-kappa)*AUXES)/(1-(1-kappa)*AUXED + (R_-1)*AUXBD);
    E_ = AUXED*D - AUXES*K_;
    B_ = AUXBD*D + AUXBS*K_;
    b = log( B_ );
    @#for lag in [1:7]
    lagD@{lag} = D;
    @#endfor
    spread = RK_ - R_;

    Y = Y_;
    E_rate = E_/(K_-B_);
    D_rate = D/(K_-B_);
end;


steady;
check;

shocks;
    var epsA = 1; 
end;

stoch_simul( nograph , replic = 256, order = 3, irf = 60, periods = 0 , irf_shocks = ( epsA ) );
