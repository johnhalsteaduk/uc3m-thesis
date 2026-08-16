function [ys, params, check] = main_steadystate(ys, exo, M_, options_)
    % 0. Initialization
    check = 0; 
    params = M_.params; 
    param_names = strtrim(cellstr(M_.param_names));
    
    % Extract core shared parameters
    alpha    = params(strcmp(param_names, 'alpha'));
    beta     = params(strcmp(param_names, 'beta'));
    delta_k  = params(strcmp(param_names, 'delta_k'));
    delta_zi = params(strcmp(param_names, 'delta_zi'));
    delta_za = params(strcmp(param_names, 'delta_za'));
    eta      = params(strcmp(param_names, 'eta'));
    psi      = params(strcmp(param_names, 'psi'));
    xi       = params(strcmp(param_names, 'xi'));
    rho_z    = params(strcmp(param_names, 'rho_z'));
    xi_ces   = params(strcmp(param_names, 'xi_ces'));
    nu_a     = params(strcmp(param_names, 'nu_a'));
    tau_zi   = params(strcmp(param_names, 'tau_zi'));
    tau_za   = params(strcmp(param_names, 'tau_za'));

    % 1. Core Macro Ratios
    R_ss = 1/beta - (1-delta_k);
    K_Y_ratio = alpha / R_ss;
    I_Y_ratio = delta_k * K_Y_ratio;
    
    Z_i_Y_ratio = tau_zi / delta_zi;
    Z_a_Y_ratio = tau_za / delta_za;
    
    % 2. Handle CES Aggregator limits mathematically
    if isinf(xi_ces)
        Z_Y_ratio = rho_z * Z_i_Y_ratio + (1-rho_z) * nu_a * Z_a_Y_ratio;
    elseif xi_ces == 1
        Z_Y_ratio = (Z_i_Y_ratio)^rho_z * (nu_a * Z_a_Y_ratio)^(1-rho_z);
    else
        Z_Y_ratio = (rho_z^(1/xi_ces) * Z_i_Y_ratio^((xi_ces-1)/xi_ces) + ...
                    (1-rho_z)^(1/xi_ces) * (nu_a*Z_a_Y_ratio)^((xi_ces-1)/xi_ces))^(xi_ces/(xi_ces-1));
    end
    
    % Output scale factor derived from production function exponent algebra
    X = (K_Y_ratio^alpha * Z_Y_ratio^xi)^(1/(1 - alpha - xi));
    
    % Common consumption resource share
    Omega_C = 1 - I_Y_ratio - tau_zi - tau_za;

    % 3. Model branching logic
    if any(strcmp(param_names, 'D_ss'))
        % --- DEBT EXTENSION ---
        D_ss = params(strcmp(param_names, 'D_ss'));
        R_star = params(strcmp(param_names, 'R_star'));
        R_d_ss = R_star;
        
        % Solve for N_ss handling the absolute debt service constraint
        N_fun = @(N) (1-alpha) * X * N^(xi/(1-alpha-xi)) - ...
                     psi * (Omega_C * X * N^((1-alpha)/(1-alpha-xi)) - R_d_ss * D_ss) * N^eta;
        
        N_guess = ((1-alpha)/(psi*Omega_C))^(1/(1+eta));
        N_ss = fzero(N_fun, N_guess);
        
        Y_ss = X * N_ss^((1-alpha)/(1-alpha-xi));
        C_ss = Omega_C * Y_ss - R_d_ss * D_ss;
    else
        % --- BASELINE RBC ---
        N_ss = ((1-alpha)/(psi*Omega_C))^(1/(1+eta));
        Y_ss = X * N_ss^((1-alpha)/(1-alpha-xi));
        C_ss = Omega_C * Y_ss;
    end

    % 4. Calculate Final Levels
    K_ss = K_Y_ratio * Y_ss;
    I_ss = I_Y_ratio * Y_ss;
    I_zi_ss = tau_zi * Y_ss;
    I_za_ss = tau_za * Y_ss;
    Z_i_ss = Z_i_Y_ratio * Y_ss;
    Z_a_ss = Z_a_Y_ratio * Y_ss;
    Z_ss = Z_Y_ratio * Y_ss;
    W_ss = (1-alpha) * Y_ss / N_ss;
    
    % Exogenous and structural steady states
    ND_ss = 0;
    S_ss = 1;
    A_ss = 1;
    T_ss = I_zi_ss + I_za_ss;

    % 5. Map to dictionary based on active extension
    if any(strcmp(param_names, 'D_ss'))
        endo_dict = dictionary(["Y", "K", "N", "C", "I_k", "R", "W", "ND", "Z_i", "Z_a", "I_zi", "I_za", "S", "Z", "A", "T", "D", "R_d"], ...
                               [Y_ss, K_ss, N_ss, C_ss, I_ss, R_ss, W_ss, ND_ss, Z_i_ss, Z_a_ss, I_zi_ss, I_za_ss, S_ss, Z_ss, A_ss, T_ss, D_ss, R_d_ss]);
    else
        endo_dict = dictionary(["Y", "K", "N", "C", "I_k", "R", "W", "ND", "Z_i", "Z_a", "I_zi", "I_za", "S", "Z", "A", "T"], ...
                               [Y_ss, K_ss, N_ss, C_ss, I_ss, R_ss, W_ss, ND_ss, Z_i_ss, Z_a_ss, I_zi_ss, I_za_ss, S_ss, Z_ss, A_ss, T_ss]);
    end

    dict_keys = keys(endo_dict);
    fprintf('Number of steady state vars: %d\n', length(dict_keys));
    for i = 1:length(dict_keys)
        current_key = dict_keys(i);
        fprintf('%10s: %15.6f\n', current_key, endo_dict(current_key))
    end

    % --- ECONOMIC CHECKS & MAPPING ---
    if K_ss <= 0 || C_ss <= 0 || N_ss <= 0
        check = 1;
        return; 
    end
    
    endo_names = strtrim(cellstr(M_.endo_names));
    
    % Assign values to endogenous variables
    for i = 1:length(endo_names)
        endo_name = string(endo_names{i});
        if isKey(endo_dict, endo_name)
            ys(i) = endo_dict(endo_name);
        else
            ys(i) = 0;
        end
    end
end