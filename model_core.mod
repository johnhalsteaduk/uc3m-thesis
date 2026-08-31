% 1. Euler equation
(1/(C_r*(1+tau_c)))*(1 + v*(I_k/K(-1) - delta_k)) = 1/(1+R_b)*(1/(C_r(+1)*(1+tau_c(+1))))*(R_k(+1) + 1 - delta_k - (v/2)*(I_k(+1)/K - delta_k)^2 + v*(I_k(+1)/K - delta_k)*(K(+1)/K));  

% 2. Labour supply
W/(C*(1+tau_c)) = psi*N^eta;

% 3. Private Investment
I_k = K - ((1 - D/(1 + pi*Z_a(-1))) - delta_k)*K(-1);

% 4. Production function 
Y = (1 - D/(1 + pi*Z_a(-1)))^omega_tfp * K(-1)^alpha * N^(1-alpha) * Z(-1)^psi_z;

% 5. Capital rental rate
R_k = alpha*Y/K(-1);

% 6. Real wage
W = (1 - alpha)*Y/N;

% 7. Natural disaster shock
D = rho_d*D(-1) + e_d;

% 8. Natural disaster shock to interest rate
D_r = rho_dr*D_r(-1) + e_d;

% 9. Standard public capital evolution
Z_i = ((1 - D/(1 + pi*Z_a(-1))) - delta_zi)*Z_i(-1) + S*I_zi;

% 10. Adaptation public capital evolution
Z_a = ((1 - D/(1 + pi*Z_a(-1))) - delta_za)*Z_a(-1) + S*I_za;

% 11. Effective public capital (assume perfect substitutes)
Z = Z_i + nu_a*Z_a;

% 12. Public investment efficiency
S = steady_state(S) - omega_s*D;

% 13. Tax revenue
T = tau_c*C;

% 14. Household Budget Constraint
C*(1+tau_c) + I_k = Y + L;

% 15. Standard public investment rule (Asymmetric with momentum)
@#if ACCEL_RECON == 1
    I_zi = tau_zi * Y + phi_z * (steady_state(Z_i) - Z_i(-1));
@#else
    I_zi = tau_zi * Y;
@#endif

% 16. Adaptation public investment rule
I_za = tau_za * Y;

% 17. Non-Ricardian Budget Constraint
C_c*(1+tau_c) = W*N + L;

% 18. Aggregate Consumption
C = (1 - lambda_c)*C_r + lambda_c*C_c;

% 19. Risk premium
@#if FIX_R == 1
    R_b = R_star;
@#else
    R_b = (1 + omega_r*D_r) * (R_star + nu_g*exp(eta_g*((Q*B+F)/steady_state(Y) - B_Y_ratio)) - 1);
@#endif

% 20. Long-Duration Bond Pricing Equation
Q = (1 + (1 - delta_b)*Q(+1)) / (1 + R_b);

% 21. Government Budget Constraint
Q*(B - (1 - delta_b)*B(-1)) = B(-1) + I_zi + I_za + L - T - e_crdc*steady_state(B) + (1-e_crdc)*delta_b*F(-1);

% 22. Fiscal Rules (Outputs exactly 2 equations)
@#if FIX_B == 1
    B = B(-1);
    
    % If B is fixed, fix ONE of the following to leave the other as the budget residual
    @#if FIX_TAU_C == 1
        tau_c = steady_state(tau_c);
    @#elseif FIX_L == 1
        L = steady_state(L);
    @#endif

@#else
    % If B is not fixed, it becomes the residual, so we must provide rules for both tau_c and L
    @#if FIX_TAU_C == 1
        tau_c = steady_state(tau_c);
    @#else
        tau_c = steady_state(tau_c) + phi_c * ((Q*B+F)/steady_state(Y) - B_Y_ratio);
    @#endif

    @#if FIX_L == 1
        L = steady_state(L);
    @#else
        L = steady_state(L) - phi_l * ((Q*B+F)/steady_state(Y) - B_Y_ratio);
    @#endif
@#endif

% 23. CRDC Deferred Obligations Stock
F = e_crdc*steady_state(B) + (1 + R_star - (1-e_crdc)*delta_b)*F(-1);