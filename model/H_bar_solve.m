function F = H_bar_solve(K_over_Y,H_bar)
global M_
 
NumberOfParameters = M_.param_nbr; 
for i = 1:NumberOfParameters   
  paramname = deblank(M_.param_names(i,:)); 
  if strcmp(paramname , 'H_bar')
      continue
  end
  eval([ paramname ' = M_.params(' int2str(i) ');']);
end

C_over_Y = ( 1 - gy - deltaSS * K_over_Y );
H = H_bar;
Y = ( H_bar ) * K_over_Y ^ ( alp / ( 1 - alp ) );
C = C_over_Y*Y;
Xjr = C;
W = (1-alp) * K_over_Y ^ ( alp / ( 1 - alp ) );

UH = - (C - varrho*H^theta_jr*Xjr)^(-sigma_c) * theta_jr*varrho*Xjr*H^(theta_jr-1);
UC = (C - varrho*H^theta_jr*Xjr)^(-sigma_c);
UX =  - (C - varrho*H^theta_jr*Xjr)^(-sigma_c) * varrho * H^(theta_jr);
lambdaX = UX / ( 1 - betta*( (1-gam_jr) ) );
lambdaC = UC + lambdaX*gam_jr;

F = UH+W*lambdaC;