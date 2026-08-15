function [ys, params, check] = main_steadystate(ys, exo, M_, options_)
    % 0. Initialization
    check = 0; 
    params = M_.params; 
    param_names = strtrim(cellstr(M_.param_names));

    % Extract core shared parameters
    alpha = params(strcmp(param_names, 'alpha'));
    beta  = params(strcmp(param_names, 'beta'));
    delta = params(strcmp(param_names, 'delta'));
    eta   = params(strcmp(param_names, 'eta'));
    psi   = params(strcmp(param_names, 'psi'));

    R_ss = 1/beta - (1-delta);
    K_Y_ratio = alpha / R_ss;
    I_Y_ratio = delta * K_Y_ratio;

    if any(strcmp(param_names, 'D_ss'))
        % --- DEBT EXTENSION ---
        D_ss = params(strcmp(param_names, 'D_ss'));
        R_star = params(strcmp(param_names, 'R_star'));
        
        R_d_ss = R_star;
        
        X = K_Y_ratio^(alpha/(1 - alpha)); % output to labour ratio
        Omega = 1 - I_Y_ratio; 
        
        % Solve for N_ss handling the debt service
        N_fun = @(N) (1-alpha)*X - psi * (Omega * X * N - R_d_ss * D_ss) * N^eta;
        
        N_guess = ((1-alpha)/(psi*Omega))^(1/(1+eta));
        N_ss = fzero(N_fun, N_guess);
        
        Y_ss = X * N_ss;
        K_ss = K_Y_ratio * Y_ss;
        I_ss = I_Y_ratio * Y_ss;
        C_ss = Omega * Y_ss - R_d_ss * D_ss;
        W_ss = (1-alpha) * Y_ss / N_ss;
        
        endo_dict = dictionary(["Y", "K", "N", "C", "I", "R", "W", "D", "R_d"], ...
                               [Y_ss, K_ss, N_ss, C_ss, I_ss, R_ss, W_ss, D_ss, R_d_ss]);
    else
        % --- BASELINE RBC ---
        C_Y_ratio = 1 - I_Y_ratio;
    
        N_ss = ((1-alpha)/(psi*C_Y_ratio))^(1/(1+eta));
        Y_ss = (K_Y_ratio^(alpha/(1 - alpha)))*N_ss;
    
        K_ss = K_Y_ratio*Y_ss;
        I_ss = I_Y_ratio*Y_ss;
        C_ss = C_Y_ratio*Y_ss;
        W_ss = (1-alpha)*Y_ss/N_ss;
    
        % Initialize the final output variables with these baseline results
        endo_dict = dictionary(["Y", "K", "N", "C", "I", "R", "W"], ...
                             [Y_ss, K_ss, N_ss, C_ss, I_ss, R_ss, W_ss]);
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
            % set a = 0
            ys(i) = 0;
        end
    end
end