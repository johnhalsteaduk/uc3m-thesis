% 1. Euler equation
1/C = beta/C(+1)*(R(+1)+1-delta);
% 2. Labour supply
W/C = psi*N^eta;
% 3. Investment
I = K-(1-delta)*K(-1);
% 4. Resource constraint
Y = C+I;
% 5. Production function
Y = exp(a)*K(-1)^alpha*N^(1-alpha);
% 6. Factor prices
R = alpha*Y/K(-1);
W = (1-alpha)*Y/N;
% 7. Shocks: negative productivity shock. a = log(A).
a = rho*a(-1)-e;