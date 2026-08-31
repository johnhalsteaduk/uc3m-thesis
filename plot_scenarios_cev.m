% =========================================================================
% CEV SENSITIVITY ANALYSIS: CRDC vs DEBT ACROSS OMEGA_R
% =========================================================================
omega_vals = [0.0, 0.5, 1.0, 1.5, 2.0, 2.5, 3.0];
cev_results = zeros(length(omega_vals), 1);
time_horizon = 100; % Use a long horizon to capture the full welfare integral

% --- Dynamic Shock Generator Setup ---
shock_magnitude = 0.25;
crdc_profile = [1, 1]; 
ed_periods = 1;
ed_values  = shock_magnitude;
crdc_periods = 1 + (1:length(crdc_profile));
crdc_values  = crdc_profile;

% Convert arrays to comma-separated strings for safe Dynare parsing
str_periods = strjoin(arrayfun(@num2str, crdc_periods, 'UniformOutput', false), ', ');
str_values  = strjoin(arrayfun(@num2str, crdc_values, 'UniformOutput', false), ', ');

for i = 1:length(omega_vals)
    current_omega = omega_vals(i);
    
    % 1. Dynamically inject the current omega_r into the .mod file
    fid = fopen('omega_setting.mod', 'w');
    fprintf(fid, 'omega_r = %f;\n', current_omega);
    fclose(fid);
    
    % --- 2. Run Standard Debt Scenario ---
    fid = fopen('flags.mod', 'w');
    fprintf(fid, '@#define ACCEL_RECON  = 1\n');
    fprintf(fid, '@#define DEBT_ONLY    = 0\n'); 
    fprintf(fid, '@#define TAX_ONLY     = 0\n');
    fprintf(fid, '@#define CRDC         = 0\n'); 
    fprintf(fid, '@#define ADAPTATION   = 0\n'); 
    fprintf(fid, '@#define HIGH_RISK    = 0\n'); 
    fclose(fid);
    
    % Write shocks.mod (No CRDC)
    fid = fopen('shocks.mod', 'w');
    fprintf(fid, 'shocks;\n');
    fprintf(fid, '    var e_d;\n');
    fprintf(fid, '    periods %d;\n', ed_periods);
    fprintf(fid, '    values %f;\n', ed_values);
    fprintf(fid, 'end;\n');
    fclose(fid);
    
    evalc('dynare main.mod noclearall nostrict'); 
    C_debt = oo_.endo_simul(strcmp(cellstr(M_.endo_names), 'C'), 1:time_horizon);
    
    % Extract R_star to calculate the base social discount factor (beta)
    R_star = M_.params(strcmp(cellstr(M_.param_names), 'R_star'));
    beta_val = 1 / (1 + R_star);
    
    % --- 3. Run CRDC Scenario ---
    fid = fopen('flags.mod', 'w');
    fprintf(fid, '@#define ACCEL_RECON  = 1\n');
    fprintf(fid, '@#define DEBT_ONLY    = 0\n');
    fprintf(fid, '@#define TAX_ONLY     = 0\n');
    fprintf(fid, '@#define CRDC         = 1\n'); 
    fprintf(fid, '@#define ADAPTATION   = 0\n'); 
    fprintf(fid, '@#define HIGH_RISK    = 0\n'); 
    fclose(fid);
    
    % Write shocks.mod (With CRDC active - using safe comma-separated strings)
    fid = fopen('shocks.mod', 'w');
    fprintf(fid, 'shocks;\n');
    fprintf(fid, '    var e_d;\n');
    fprintf(fid, '    periods %d;\n', ed_periods);
    fprintf(fid, '    values %f;\n', ed_values);
    fprintf(fid, '    var e_crdc;\n');
    fprintf(fid, '    periods %s;\n', str_periods);
    fprintf(fid, '    values %s;\n', str_values);
    fprintf(fid, 'end;\n');
    fclose(fid);
    
    evalc('dynare main.mod noclearall nostrict');
    C_crdc = oo_.endo_simul(strcmp(cellstr(M_.endo_names), 'C'), 1:time_horizon);
    
    % --- 4. Compute CEV (Log Utility) ---
    % Discount vector: [beta^0, beta^1, beta^2, ... ]
    discount_vector = beta_val .^ (0:(time_horizon-1));
    
    % Welfare = Sum( beta^t * log(C_t) )
    W_debt = sum(discount_vector .* log(C_debt));
    W_crdc = sum(discount_vector .* log(C_crdc));
    
    % Finite horizon CEV formula for Log Utility
    sum_beta = (1 - beta_val^time_horizon) / (1 - beta_val);
    cev_results(i) = (exp((W_crdc - W_debt) / sum_beta) - 1) * 100;
end

% =========================================================================
% PLOT THE CEV CURVE
% =========================================================================
figure('Name', 'Welfare Gains of CRDC', 'Position', [200, 200, 700, 450]);
plot(omega_vals, cev_results, 'b-o', 'LineWidth', 2, 'MarkerSize', 7, 'MarkerFaceColor', 'b');
title('CRDC Welfare Gain (CEV) across Risk Premium Sensitivities');
xlabel('Disaster Risk Premium Sensitivity (\omega_r)');
ylabel('Consumption Equivalent Variation (%)');
grid on;

% Add a baseline zero-line for reference
yline(0, 'k--', 'LineWidth', 1);