% 1. Euler equation
1/C = beta/C(+1)*(R(+1)+1-delta);
% 2. Labour supply
W/C = psi*N^eta;
% 3. Investment
I = K-(1-delta-omega_k*ND)*K(-1);
% 4. Resource constraint
Y = C+I;
% 5. Production function
Y = exp(-omega_a*ND)*K(-1)^alpha*N^(1-alpha);
% 6. Capital rental rate
R = alpha*Y/K(-1);
% 7. Real wage
W = (1-alpha)*Y/N;
% 8. Natural disaster shock
ND = rho_nd*ND(-1)+e;