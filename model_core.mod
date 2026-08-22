% 1. Euler equation
(1/(C*(1+tau_c)))*(1 + v*(I_k/K(-1) - delta_k)) = beta*(1/(C(+1)*(1+tau_c(+1))))*(R(+1) + 1 - delta_k - (v/2)*(I_k(+1)/K - delta_k)^2 + v*(I_k(+1)/K - delta_k)*(K(+1)/K));  

% 2. Labour supply
W/(C*(1+tau_c)) = psi*N^eta;

% 3. Private Investment
I_k = K - (1 - delta_k - omega_k*D/(1 + kappa*Z_a(-1)))*K(-1);

% 4. Production function 
Y = exp(-(1-omega_k*alpha-omega_z*psi_z)*D/(1+kappa*Z_a(-1)))*K(-1)^alpha * N^(1-alpha) * Z(-1)^psi_z;

% 5. Capital rental rate
R = alpha*Y/K(-1);

% 6. Real wage
W = (1 - alpha)*Y/N;

% 7. Natural disaster shock
D = rho_d*D(-1) + e_d;

% 8. Standard public capital evolution
Z_i = (1 - delta_zi - omega_z*D/(1 + kappa*Z_a(-1)))*Z_i(-1) + S*I_zi;

% 9. Adaptation public capital evolution
Z_a = (1 - delta_za - omega_z*D/(1 + kappa*Z_a(-1)))*Z_a(-1) + S*I_za;

% 10. Effective public capital (CES Aggregator)
Z = (rho_z^(1/xi) * Z_i^((xi-1)/xi) + (1-rho_z)^(1/xi) * (nu_a*Z_a)^((xi-1)/xi))^(xi/(xi-1));

% 11. Public investment efficiency
S = S_ss - omega_s*D;

% 12. Tax revenue
T = tau_c*C;

% 13. Standard public investment rule
I_zi = tau_zi * Y;

% 14. Adaptation public investment rule
I_za = tau_za * Y;

% 15. Constant Lump-sum Transfers
L = L_ss;

@#if DEBT == 1 || CRDC == 1
    % 16. Government Budget Constraint
    B = (1 + R_b(-1)*(1 - CRDC))*B(-1) + I_zi + I_za + L - T;

    % 17. Resource constraint (Physical goods only)
    Y = C + I_k + I_zi + I_za;

    % 18. Fiscal Rule for Consumption Tax (Locked Flat)
    tau_c = tau_c_ss; 
    
    % 19. Risk premium
    R_b = R_star + eta_g*(B - B_ss);
  
    @#if CRDC == 1
        @#define crdc_lags = 4
        % 20. CRDC MA(1) tracker function
        CRDC = e_d
        @#for i in 1:crdc_lags
            + e_d(-@{i})
        @#endfor
        ;
    @#else
        % 20. CRDC inactive
        CRDC = 0;
    @#endif

@#elseif FUND == 1
    % 16. Government Budget Constraint
    T + W_f = I_zi + I_za + I_f + L; 

    % 17. Resource constraint
    Y = C + I_k + I_zi + I_za;
    
    % 18. Contingency fund accumulation
    F = (1 + R_star)*F(-1) + I_f - W_f;
    
    % 19. Fund replenishment rule
    I_f = tau_f*(F_target * Y - F(-1)) - R_star*F(-1);
    
    % 20. Disaster withdrawal rule 
    W_f = omega_f * D * F(-1);

@#else
    % 16. Government Budget Constraint
    T = I_zi + I_za + L; 

    % 17. Resource constraint
    Y = C + I_k + I_zi + I_za;
@#endif