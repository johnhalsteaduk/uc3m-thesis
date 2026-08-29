% 1. Euler equation
(1/(C_r*(1+tau_c)))*(1 + v*(I_k/K(-1) - delta_k)) = beta*(1/(C_r(+1)*(1+tau_c(+1))))*(R(+1) + 1 - delta_k - (v/2)*(I_k(+1)/K - delta_k)^2 + v*(I_k(+1)/K - delta_k)*(K(+1)/K));  

% 2. Labour supply
W/(C*(1+tau_c)) = psi*N^eta;

% 3. Private Investment
I_k = K - ((1 - D/(1 + pi*Z_a(-1))^nu_D)^omega_k - delta_k)*K(-1);

% 4. Production function 
Y = (1 - D/(1 + pi*Z_a(-1))^nu_D)^(1 - omega_k*alpha - omega_z*psi_z) * K(-1)^alpha * N^(1-alpha) * Z(-1)^psi_z;

% 5. Capital rental rate
R = alpha*Y/K(-1);

% 6. Real wage
W = (1 - alpha)*Y/N;

% 7. Natural disaster shock
D = rho_d*D(-1) + e_d;

% 9. Standard public capital evolution
Z_i = ((1 - D/(1 + pi*Z_a(-1))^nu_D)^omega_z - delta_zi)*Z_i(-1) + S*I_zi;

% 10. Adaptation public capital evolution
Z_a = ((1 - D/(1 + pi*Z_a(-1))^nu_D)^omega_z - delta_za)*Z_a(-1) + S*I_za;

% 11. Effective public capital (assume perfect substitutes)
Z = Z_i + nu_a*Z_a;

% 12. Public investment efficiency
S = S_ss - omega_s*D;

% 13. Tax revenue
T = tau_c*C;

% 14. Household Budget Constraint
C*(1+tau_c) + I_k = Y + L_ss;

% 15. Standard public investment rule
@#if ACCEL_RECON == 1
    I_zi = tau_zi * Y + phi_z * (Z_i_ss - Z_i(-1));
@#else
    I_zi = tau_zi * Y;
@#endif

% 15b. Marginal Benefits
MB_b = R_b + (1 + omega_r*D) * eta_g * (q*B(-1)/Y);
MB_za = (D * pi * nu_D) / (1 + pi * Z_a(-1))^(nu_D + 1);

% 16. Adaptation public investment rule
@#if RESILIENCE == 1
    I_za = tau_za * Y + zeta * (MB_za / MB_b)*e_crdc * B_ss;
@#else
    I_za = tau_za * Y;
@#endif

% 17. Non-Ricardian Budget Constraint
C_c*(1+tau_c) = W*N + L_ss;

% 18. Aggregate Consumption
C = (1 - lambda_c)*C_r + lambda_c*C_c;

% 19. Risk premium (now based on market value of debt: q*B)
R_b = (1 + omega_r*D) * (R_star + eta_g*(q*B/Y - B_Y_ratio));

% 20. Long-Duration Bond Pricing Equation
q = (1 + (1 - delta_b)*q(+1)) / (1 + R_b);

% 21. Government Budget Constraint
@#if CRDC == 1
    q*(B - (1 - delta_b)*B(-1)) = B(-1) + I_zi + I_za + L_ss - T - G_ss - e_crdc*B_ss + (1 - e_crdc)*(1 + R_star)*F(-1);
@#else
    q*(B - (1 - delta_b)*B(-1)) = B(-1) + I_zi + I_za + L_ss - T - G_ss;
@#endif

% 22. Fiscal Rule (Taxes react to total debt: standard bonds + capitalized CRDC stock)
@#if DEBT_ONLY == 1
    tau_c = tau_c_ss;
@#elseif TAX_ONLY == 1
    B = B(-1);
@#else
    tau_c = tau_c_ss + phi_c * ((q*B+F)/Y - B_Y_ratio);
@#endif

% 23. CRDC Deferred Obligations Stock
@#if CRDC == 1
    F = e_crdc*B_ss + (1 - (1 - e_crdc))*(1 + R_star)*F(-1);
@#else
    F = 0;
@#endif