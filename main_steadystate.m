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

    % =====================================================================
    % STEP 1: ANALYTICAL BASELINE RBC
    % =====================================================================
    R_ss = 1/beta - (1-delta);

    K_Y_ratio = alpha / R_ss;
    I_Y_ratio = delta * K_Y_ratio;
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

    dict_keys = keys(endo_dict);
    fprintf('Number of steady state vars: %d\n', length(dict_keys));
    for i = 1:length(dict_keys)
        current_key = dict_keys(i);
        fprintf('%10s: %15.6f\n', current_key, endo_dict(current_key))
    end

    % =====================================================================
    % STEP 2: THE NUMERICAL EXTENSION (If MARTO is active)
    % =====================================================================
    if any(strcmp(param_names, 'tau'))
        % Extract Marto parameters
        tau  = params(strcmp(param_names, 'tau'));
        xi   = params(strcmp(param_names, 'xi'));
        S    = params(strcmp(param_names, 'S'));
        D_Z  = params(strcmp(param_names, 'D_Z'));
        D_S  = params(strcmp(param_names, 'D_S'));

        C_Y_ratio   = (1-I_Y_ratio)/(1+tau);
        I_Z_Y_ratio = tau*C_Y_ratio;
        Z_Y_ratio   = S*(1-D_S)/(delta+D_Z)*I_Z_Y_ratio;

        N_ss = ((1-alpha)/(psi*C_Y_ratio))^(1/(1+eta));
        Y_ss = ((K_Y_ratio^alpha)*(Z_Y_ratio^xi)*(N_ss^(1-alpha)))^(1/(1-alpha-xi));

        K_ss   = K_Y_ratio*Y_ss;
        I_ss   = I_Y_ratio*Y_ss;
        C_ss   = C_Y_ratio*Y_ss;
        W_ss   = (1-alpha)*Y_ss/N_ss;
        I_Z_ss = I_Z_Y_ratio*Y_ss;
        Z_ss   = Z_Y_ratio*Y_ss;

        % Initialize the final output variables with these baseline results
        endo_dict = dictionary(["Y", "K", "N", "C", "I", "R", "W", "I_Z", "Z"], ...
                             [Y_ss, K_ss, N_ss, C_ss, I_ss, R_ss, W_ss, I_Z_ss, Z_ss]);
    
        % Print var names and values
        dict_keys = keys(endo_dict);
        fprintf('Number of steady state vars: %d\n', length(dict_keys));
        for i = 1:length(dict_keys)
            current_key = dict_keys(i);
            fprintf('%10s: %15.6f\n', current_key, endo_dict(current_key))
        end
    end

    % =====================================================================
    % STEP 3: ECONOMIC CHECKS & MAPPING
    % =====================================================================
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