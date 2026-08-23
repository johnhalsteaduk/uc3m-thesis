% 1. Euler equation
(1/(C_r*(1+tau_c)))*(1 + v*(I_k/K(-1) - delta_k)) = beta*(1/(C_r(+1)*(1+tau_c(+1))))*(R(+1) + 1 - delta_k - (v/2)*(I_k(+1)/K - delta_k)^2 + v*(I_k(+1)/K - delta_k)*(K(+1)/K));  

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

% 8. Sovereign Risk Penalty
D_r = rho_d * D_r(-1) + omega_r * e_d;

% 9. Standard public capital evolution
Z_i = (1 - delta_zi - omega_z*D/(1 + kappa*Z_a(-1)))*Z_i(-1) + S*I_zi;

% 10. Adaptation public capital evolution
Z_a = (1 - delta_za - omega_z*D/(1 + kappa*Z_a(-1)))*Z_a(-1) + S*I_za;

% 11. Effective public capital (CES Aggregator)
Z = (rho_z^(1/xi) * Z_i^((xi-1)/xi) + (1-rho_z)^(1/xi) * (nu_a*Z_a)^((xi-1)/xi))^(xi/(xi-1));

% 12. Public investment efficiency
S = S_ss - omega_s*D;

% 13. Tax revenue
T = tau_c*C;

% 14. Household Budget Constraint
C*(1+tau_c) + I_k = Y + L_ss;

@#if ACCEL_RECON == 1
    % 15. Accelerated standard public investment rule
    I_zi = tau_zi * Y + phi_z * (Z_i_ss - Z_i);
@#else
    % 15. Baseline standard public investment rule
    I_zi = tau_zi * Y;
@#endif

% 16. Adaptation public investment rule
I_za = tau_za * Y;

% 17. Non-Ricardian Budget Constraint
C_c*(1+tau_c) = W*N + L_ss;

% 18. Aggregate Consumption
C = (1 - lambda_c)*C_r + lambda_c*C_c;

% 19. Risk premium
R_b = (1 + D_r) * (R_star + eta_g*(B/Y - B_Y_ratio));

@#if DEBT == 1
    % 20. Government Budget Constraint
    B = (1 + R_b(-1))*B(-1) + I_zi + I_za + L_ss - T;

    % 21. Fiscal Rule for Consumption Tax (Locked Flat)
    tau_c = tau_c_ss;
@#elseif  CRDC == 1
    % 20. Government Budget Constraint
    B = (1 + R_b(-1) - CRDC*(R_b(-1) - R_star))*B(-1) + I_zi + I_za + L_ss - T;

    % 21. Fiscal Rule for Consumption Tax (Locked Flat)
    tau_c = tau_c_ss;
@#elseif FUND == 1
    % 20. Government Budget Constraint
    B = (1 + R_star)*B(-1) + I_zi + I_za + I_f + L_ss - T - W_f;
    
    % 21. Debt Rule (No new borrowing)
    B = B(-1);

    % 22. Contingency fund accumulation
    F = (1 + R_star)*F(-1) + I_f - W_f;
    
    % 23. Fund replenishment rule
    I_f = tau_f*(F_target * Y - F(-1)) - R_star*F(-1);
    
    % 24. Disaster withdrawal rule 
    W_f = omega_f * D * F(-1);
@#else
    % 20. Government Budget Constraint
    B = (1 + R_star)*B(-1) + I_zi + I_za + L_ss - T;

    % 21. Debt Rule (No new borrowing)
    B = B(-1);
@#endif