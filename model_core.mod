% 1. Euler equation
@#if DEBT == 1 || CRDC == 1
    (1/C)*(1 + phi*(I_k/K(-1) - delta_k)) = beta*(1/C(+1))*(R(+1) + 1 - delta_k + phi*(I_k(+1)/K - delta_k));
@#else
    1/C = beta/C(+1)*(R(+1) + 1 - delta_k);
@#endif
    
% 2. Labour supply
W/C = psi*N^eta;

% 3. Private Investment
I_k = K - (1 - delta_k - omega_k*ND/((1 + pi_d*Z_a(-1))^nu_d))*K(-1);

% 4. Resource constraint
@#if DEBT == 1
    D = (1 + R_d(-1))*D(-1) + C + I_k + I_zi + I_za - Y;
@#elseif CRDC == 1
    D = (1 + R_d(-1)*(1 - CRDC))*D(-1) + C + I_k + I_zi + I_za - Y;
@#else
    Y = C + I_k + I_zi + I_za;
@#endif

% 5. Production function 
Y = exp(-omega_a*ND/((1 + pi_d*Z_a(-1))^nu_d)) * K(-1)^alpha * N^(1-alpha) * Z(-1)^xi;

% 6. Capital rental rate
R = alpha*Y/K(-1);

% 7. Real wage
W = (1 - alpha)*Y/N;

% 8. Natural disaster shock
ND = rho_nd*ND(-1) + e_nd;

% 9. Standard public capital evolution
Z_i = (1 - delta_zi - omega_z*ND/((1 + pi_d*Z_a(-1))^nu_d))*Z_i(-1) + S*I_zi;

% 10. Adaptation public capital evolution
Z_a = (1 - delta_za - omega_z*ND/((1 + pi_d*Z_a(-1))^nu_d))*Z_a(-1) + S*I_za;

% 11. Effective public capital (CES Aggregator)
Z = (rho_z^(1/xi_ces) * Z_i^((xi_ces-1)/xi_ces) + (1-rho_z)^(1/xi_ces) * (nu_a*Z_a)^((xi_ces-1)/xi_ces))^(xi_ces/(xi_ces-1));

% 12. Public investment efficiency
S = 1 - omega_s*ND;

% 13. Government Budget Constraint (Lump-sum tax)
T = I_zi + I_za;

% 14. Standard public investment rule
I_zi = tau_zi * Y;

% 15. Adaptation public investment rule
I_za = tau_za * Y;

@#if DEBT == 1 || CRDC == 1
    % 16. Risk premium
    R_d = R_star + nu*(D - D_ss);
@#endif

@#if DEBT == 1
    % 17. Bond Euler equation
    1/C = beta/C(+1)*(R_d(+1) + 1);
@#elseif CRDC == 1
    @#define crdc_lags = 4
    
    % 17. Bond Euler equation
    1/C = beta/C(+1)*(R_d(+1)*(1 - CRDC(+1)) + 1);
    
    % 18. CRDC MA(1) tracker function
    CRDC = e_nd
    @#for i in 1:crdc_lags
        + e_nd(-@{i})
    @#endfor
    ;
@#endif