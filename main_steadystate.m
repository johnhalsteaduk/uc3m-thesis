function [ys, params, check] = main_steadystate(ys, ~, M_, ~)
    % Initialization
    check = 0; 
    params = M_.params; 
    param_names = strtrim(cellstr(M_.param_names));
    
    % Extract core shared parameters
    alpha    = params(strcmp(param_names, 'alpha'));
    delta_k  = params(strcmp(param_names, 'delta_k'));
    delta_zi = params(strcmp(param_names, 'delta_zi'));
    delta_za = params(strcmp(param_names, 'delta_za'));
    eta      = params(strcmp(param_names, 'eta'));
    psi      = params(strcmp(param_names, 'psi'));
    psi_z    = params(strcmp(param_names, 'psi_z'));
    nu_a     = params(strcmp(param_names, 'nu_a'));
    tau_zi   = params(strcmp(param_names, 'tau_zi'));
    tau_za   = params(strcmp(param_names, 'tau_za'));
    tau_c_target = params(strcmp(param_names, 'tau_c_target'));
    S_target     = params(strcmp(param_names, 'S_target'));
    B_Y_ratio = params(strcmp(param_names, 'B_Y_ratio'));
    R_star   = params(strcmp(param_names, 'R_star'));
    lambda_c = params(strcmp(param_names, 'lambda_c'));
    delta_b  = params(strcmp(param_names, 'delta_b'));

    R_k_ss = 1 + R_star - (1-delta_k);
    K_Y_ratio = alpha / R_k_ss;
    I_Y_ratio = delta_k * K_Y_ratio;
    
    S_ss = S_target;
    Z_i_Y_ratio = (S_ss * tau_zi) / delta_zi;
    Z_a_Y_ratio = (S_ss * tau_za) / delta_za;
    Z_Y_ratio = Z_i_Y_ratio + nu_a * Z_a_Y_ratio;
    
    % Output scale factor derived from production function exponent algebra
    X = (K_Y_ratio^alpha * Z_Y_ratio^psi_z)^(1/(1 - alpha - psi_z));

    % Common consumption resource share
    Omega_C = 1 - I_Y_ratio - tau_zi - tau_za - R_star * B_Y_ratio;
    
    tau_c_ss = tau_c_target;
    N_ss = ((1-alpha) / (psi * (1+tau_c_ss) * Omega_C))^(1/(1+eta));
    Y_ss = X * N_ss^((1-alpha)/(1-alpha-psi_z));
    C_ss = Omega_C * Y_ss;
    T_ss = tau_c_ss * C_ss;
    Q_ss     = 1 / (R_star + delta_b);
    B_ss = B_Y_ratio * Y_ss / Q_ss;
    R_b_ss = R_star;
   
    K_ss = K_Y_ratio * Y_ss;
    I_ss = I_Y_ratio * Y_ss;
    I_zi_ss = tau_zi * Y_ss;
    I_za_ss = tau_za * Y_ss;
    Z_i_ss = (S_target * I_zi_ss) / delta_zi;
    Z_a_ss = (S_target * I_za_ss) / delta_za;
    Z_ss = Z_Y_ratio * Y_ss;
    W_ss = (1-alpha) * Y_ss / N_ss;
    L_ss = T_ss - (tau_zi + tau_za)*Y_ss - B_ss + Q_ss * delta_b * B_ss;

    C_c_ss = (W_ss * N_ss + L_ss) / (1 + tau_c_ss);
    C_r_ss = (C_ss - lambda_c * C_c_ss) / (1 - lambda_c);
    
    D_ss = 0;
    D_r_ss = 0;
    F_ss = 0;
    
    % Map to dictionary based on active extension
    endo_names_in_model = strtrim(cellstr(M_.endo_names));
    
    endo_dict = dictionary(["Y", "K", "N", "C", "C_r", "C_c", "I_k", "R_k", "W", "D", ...
                            "D_r", "Z_i", "Z_a", "I_zi", "I_za", "S", "Z", "T", "B", ...
                            "tau_c", "R_b", "Q", "F", "L"], ...
                           [Y_ss, K_ss, N_ss, C_ss, C_r_ss, C_c_ss, I_ss, R_k_ss, W_ss, D_ss, ...
                            D_r_ss, Z_i_ss, Z_a_ss, I_zi_ss, I_za_ss, S_ss, Z_ss, T_ss, B_ss, ...
                            tau_c_ss, R_b_ss, Q_ss, F_ss, L_ss]);

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