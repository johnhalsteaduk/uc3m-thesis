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
    psi_z    = params(strcmp(param_names, 'psi_z'));
    rho_z    = params(strcmp(param_names, 'rho_z'));
    xi       = params(strcmp(param_names, 'xi'));
    nu_a     = params(strcmp(param_names, 'nu_a'));
    tau_zi   = params(strcmp(param_names, 'tau_zi'));
    tau_za   = params(strcmp(param_names, 'tau_za'));
    v        = params(strcmp(param_names, 'v'));

    % 1. Core Macro Ratios
    R_ss = 1/beta - (1-delta_k);
    K_Y_ratio = alpha / R_ss;
    I_Y_ratio = delta_k * K_Y_ratio;
    
    Z_i_Y_ratio = tau_zi / delta_zi;
    Z_a_Y_ratio = tau_za / delta_za;
    
    % 2. Handle CES Aggregator limits mathematically
    if isinf(xi)
        Z_Y_ratio = rho_z * Z_i_Y_ratio + (1-rho_z) * nu_a * Z_a_Y_ratio;
    elseif xi == 1
        Z_Y_ratio = (Z_i_Y_ratio)^rho_z * (nu_a * Z_a_Y_ratio)^(1-rho_z);
    else
        Z_Y_ratio = (rho_z^(1/xi) * Z_i_Y_ratio^((xi-1)/xi) + ...
                    (1-rho_z)^(1/xi) * (nu_a*Z_a_Y_ratio)^((xi-1)/xi))^(xi/(xi-1));
    end
    
    % Output scale factor derived from production function exponent algebra
    X = (K_Y_ratio^alpha * Z_Y_ratio^psi_z)^(1/(1 - alpha - psi_z));
    
    % Common consumption resource share
    Omega_C = 1 - I_Y_ratio - tau_zi - tau_za;

    % 3. Model branching logic
    if any(strcmp(param_names, 'B_ss'))
        % --- DEBT EXTENSION ---
        B_ss = params(strcmp(param_names, 'B_ss'));
        R_star = params(strcmp(param_names, 'R_star'));
        R_b_ss = R_star;
        
        % Solve for N_ss handling the absolute debt service constraint
        N_fun = @(N) (1-alpha) * X * N^(psi_z/(1-alpha-psi_z)) - ...
                     psi * (Omega_C * X * N^((1-alpha)/(1-alpha-psi_z)) - R_b_ss * B_ss) * N^eta;
        
        N_guess = ((1-alpha)/(psi*Omega_C))^(1/(1+eta));
        N_ss = fzero(N_fun, N_guess);
        
        Y_ss = X * N_ss^((1-alpha)/(1-alpha-psi_z));
        C_ss = Omega_C * Y_ss - R_b_ss * B_ss;
    elseif any(strcmp(param_names, 'F_target'))
        % --- FUND EXTENSION ---
        F_target = params(strcmp(param_names, 'F_target'));
        R_star = params(strcmp(param_names, 'R_star'));
        
        % The fund generates passive interest (+), increasing steady state consumption
        N_fun = @(N) (1-alpha) * X * N^(psi_z/(1-alpha-psi_z)) - ...
                     psi * (Omega_C * X * N^((1-alpha)/(1-alpha-psi_z)) + R_star * F_target * X * N^((1-alpha)/(1-alpha-psi_z))) * N^eta;
        
        N_guess = ((1-alpha)/(psi*Omega_C))^(1/(1+eta));
        N_ss = fzero(N_fun, N_guess);
        Y_ss = X * N_ss^((1-alpha)/(1-alpha-psi_z));
        
        % Fund specific variables
        F_ss = F_target * Y_ss;
        I_f_ss = -R_star * F_ss; % Peacetime interest acts as revenue
        W_f_ss = 0;
        
        C_ss = Omega_C * Y_ss - I_f_ss; % Consumption increases by the interest earned
    else
        % --- BASELINE RBC ---
        N_ss = ((1-alpha)/(psi*Omega_C))^(1/(1+eta));
        Y_ss = X * N_ss^((1-alpha)/(1-alpha-psi_z));
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
    D_ss = 0;
    S_ss = 1;
    T_ss = I_zi_ss + I_za_ss;
    CRDC_ss = 0; 
    
    % 5. Map to dictionary based on active extension
    endo_names_in_model = strtrim(cellstr(M_.endo_names));
    
    if any(strcmp(endo_names_in_model, 'CRDC'))
        % --- CRDC ---
        endo_dict = dictionary(["Y", "K", "N", "C", "I_k", "R", "W", "D", "Z_i", "Z_a", "I_zi", "I_za", "S", "Z", "T", "B", "R_b", "CRDC"], ...
                               [Y_ss, K_ss, N_ss, C_ss, I_ss, R_ss, W_ss, D_ss, Z_i_ss, Z_a_ss, I_zi_ss, I_za_ss, S_ss, Z_ss, T_ss, B_ss, R_b_ss, CRDC_ss]);
    elseif any(strcmp(endo_names_in_model, 'B'))
        % --- DEBT ---
        endo_dict = dictionary(["Y", "K", "N", "C", "I_k", "R", "W", "D", "Z_i", "Z_a", "I_zi", "I_za", "S", "Z", "T", "B", "R_b"], ...
                               [Y_ss, K_ss, N_ss, C_ss, I_ss, R_ss, W_ss, D_ss, Z_i_ss, Z_a_ss, I_zi_ss, I_za_ss, S_ss, Z_ss, T_ss, B_ss, R_b_ss]);
    elseif any(strcmp(endo_names_in_model, 'F'))
        % --- FUND ---
        endo_dict = dictionary(["Y", "K", "N", "C", "I_k", "R", "W", "D", "Z_i", "Z_a", "I_zi", "I_za", "S", "Z", "T", "F", "I_f", "W_f"], ...
                               [Y_ss, K_ss, N_ss, C_ss, I_ss, R_ss, W_ss, D_ss, Z_i_ss, Z_a_ss, I_zi_ss, I_za_ss, S_ss, Z_ss, T_ss, F_ss, I_f_ss, W_f_ss]);
    else
        % --- BASELINE RBC ---
        endo_dict = dictionary(["Y", "K", "N", "C", "I_k", "R", "W", "D", "Z_i", "Z_a", "I_zi", "I_za", "S", "Z", "T"], ...
                               [Y_ss, K_ss, N_ss, C_ss, I_ss, R_ss, W_ss, D_ss, Z_i_ss, Z_a_ss, I_zi_ss, I_za_ss, S_ss, Z_ss, T_ss]);
    end

    dict_keys = keys(endo_dict);
    fprintf('\nNumber of steady state vars: %d\n', length(dict_keys));
    for i = 1:length(dict_keys)
        current_key = dict_keys(i);
        fprintf('%10s: %15.6f\n', current_key, endo_dict(current_key))
    end

    % --- ECONOMIC CHECKS & MAPPING ---
    if K_ss <= 0 || C_ss <= 0 || N_ss <= 0
        check = 1;
        return; 
    end
    
    % Assign values to endogenous variables for Dynare
    for i = 1:length(endo_names_in_model)
        endo_name = string(endo_names_in_model{i});
        if isKey(endo_dict, endo_name)
            ys(i) = endo_dict(endo_name);
        else
            ys(i) = 0; % Safety fallback
        end
    end
end