% 1. Euler equation
(1/C)*(1 + v*(I_k/K(-1) - delta_k)) = beta*(1/C(+1))*(R(+1) + 1 - delta_k - (v/2)*(I_k(+1)/K - delta_k)^2 + v*(I_k(+1)/K - delta_k)*(K(+1)/K));
    
% 2. Labour supply
W/C = psi*N^eta;

% 3. Private Investment
I_k = K - (1 - delta_k - omega_k*D/(1 + kappa*Z_a(-1)))*K(-1);

% 4. Resource constraint
@#if CRDC == 1
    B = (1 + R_b(-1)*(1 - CRDC))*B(-1) + C + I_k + I_zi + I_za - Y;
@#elseif DEBT == 1
    B = (1 + R_b(-1))*B(-1) + C + I_k + I_zi + I_za - Y;
@#elseif FUND == 1
    Y + W_f = C + I_k + I_zi + I_za + I_f;
@#else
    Y = C + I_k + I_zi + I_za;
@#endif

% 5. Production function 
Y = exp(-(1-omega_k*alpha-omega_z*psi_z)*D/(1+kappa*Z_a(-1)))*K(-1)^alpha * N^(1-alpha) * Z(-1)^psi_z;

% 6. Capital rental rate
R = alpha*Y/K(-1);

% 7. Real wage
W = (1 - alpha)*Y/N;

% 8. Natural disaster shock
D = rho_d*D(-1) + e_d;

% 9. Standard public capital evolution
Z_i = (1 - delta_zi - omega_z*D/(1 + kappa*Z_a(-1)))*Z_i(-1) + S*I_zi;

% 10. Adaptation public capital evolution
Z_a = (1 - delta_za - omega_z*D/(1 + kappa*Z_a(-1)))*Z_a(-1) + S*I_za;

% 11. Effective public capital (CES Aggregator)
Z = (rho_z^(1/xi) * Z_i^((xi-1)/xi) + (1-rho_z)^(1/xi) * (nu_a*Z_a)^((xi-1)/xi))^(xi/(xi-1));

% 12. Public investment efficiency
S = 1 - omega_s*D;

% 13. Government Budget Constraint (Lump-sum tax)
T = I_zi + I_za;

% 14. Standard public investment rule
I_zi = tau_zi * Y;

% 15. Adaptation public investment rule
I_za = tau_za * Y;

@#if DEBT == 1 || CRDC == 1
    % 16. Risk premium
    R_b = R_star + eta_g*(B - B_ss);
@#endif

@#if CRDC == 1
    @#define crdc_lags = 4
    
    % 17. Bond Euler equation
    1/C = beta/C(+1)*(R_b(+1)*(1 - CRDC(+1)) + 1);
    
    % 18. CRDC MA(1) tracker function
    CRDC = e_d
    @#for i in 1:crdc_lags
        + e_d(-@{i})
    @#endfor
    ;
@#elseif DEBT == 1
    % 17. Bond Euler equation
    1/C = beta/C(+1)*(R_b(+1) + 1);
@#endif

@#if FUND == 1
    % 19. Contingency fund accumulation
    F = (1 + R_star)*F(-1) + I_f - W_f;
    
    % 20. Fund replenishment rule (targets a % of GDP and offsets peacetime interest)
    I_f = tau_f*(F_target * Y - F(-1)) - R_star*F(-1);
    
    % 21. Disaster withdrawal rule 
    W_f = omega_f * D * F(-1);
@#endif