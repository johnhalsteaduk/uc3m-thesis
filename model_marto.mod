% 1. Euler equation
1/C = beta/C(+1)*(R(+1)+1-delta);
% 2. Labour supply
W/C = psi*N^eta;
% 3. Investment
I = K-(1-delta)*K(-1);
% 4. Resource constraint
Y = C+I+I_Z;
% 5. Add public capital to production function
Y = exp(a)*K(-1)^alpha*N^(1-alpha)*Z(-1)^xi;
% 6. Public capital
Z = (1-delta-D_Z)*Z(-1)+(1-D_S)*S*I_Z;
% 7. Public capital investment
I_Z = tau*C; % TODO massive oversimplification to make the model work
% Invest tau % of consumption in public capital
% 8. Factor prices
R = alpha*Y/K(-1);
W = (1-alpha)*Y/N;
% 9. Shocks: negative productivity shock. a = log(A).
a = rho*a(-1)-e;