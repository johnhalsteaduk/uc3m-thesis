% =========================================================================
% POST-PROCESSING SCRIPT: LOG-UTILITY CEV (Ricardian, Non-Ricardian, Total)
% =========================================================================
time_horizon = 25; 

% Load standard datasets
d_base  = load('results_debt_accel_adaptation.mat', 'oo_', 'M_');
d_crdc  = load('results_crdc_accel_adaptation.mat', 'oo_', 'M_');
d_tax   = load('results_crdc_accel_adaptation_tax_cut.mat', 'oo_', 'M_');
d_trans = load('results_crdc_accel_adaptation_transfer.mat', 'oo_', 'M_');

% Load relief fund datasets
d_crdc_relief  = load('results_crdc_accel_adaptation_relief.mat', 'oo_', 'M_');
d_tax_relief   = load('results_crdc_accel_adaptation_tax_cut_relief.mat', 'oo_', 'M_');
d_trans_relief = load('results_crdc_accel_adaptation_transfer_relief.mat', 'oo_', 'M_');

% Extract parameters directly from Dynare's compiled memory
param_names = cellstr(d_base.M_.param_names);
beta        = d_base.M_.params(strcmp(param_names, 'beta'));
lambda_c    = d_base.M_.params(strcmp(param_names, 'lambda_c'));

names = strtrim(cellstr(d_base.M_.endo_names));
get_path = @(data, var) data.oo_.endo_simul(strcmp(names, var), 1:time_horizon);

% Utility function matching your Euler equation (log utility over consumption)
calc_lifetime_utility = @(C_path) sum((beta.^(0:time_horizon-1)) .* log(C_path));

scenarios = {d_crdc, d_tax, d_trans};
scenarios_relief = {d_crdc_relief, d_tax_relief, d_trans_relief};

scenario_names = {'CRDC (Standard)', 'CRDC (Tax Cut)', 'CRDC (Transfer)'};
scenario_names_relief = {'Smoothed CRDC', 'Smoothed Tax Cut', 'Smoothed Transfer'};

cev_r = zeros(1, 3); cev_c = zeros(1, 3); cev_total = zeros(1, 3);
cev_r_relief = zeros(1, 3); cev_c_relief = zeros(1, 3); cev_total_relief = zeros(1, 3);

% Baseline utilities
U_base_r = calc_lifetime_utility(get_path(d_base, 'C_r'));
U_base_c = calc_lifetime_utility(get_path(d_base, 'C_c'));

for i = 1:3
    % Standard Scenarios CEV
    U_alt_r = calc_lifetime_utility(get_path(scenarios{i}, 'C_r'));
    cev_r(i) = (exp((1 - beta) * (U_alt_r - U_base_r)) - 1) * 100;
    
    U_alt_c = calc_lifetime_utility(get_path(scenarios{i}, 'C_c'));
    cev_c(i) = (exp((1 - beta) * (U_alt_c - U_base_c)) - 1) * 100;
    
    cev_total(i) = lambda_c * cev_c(i) + (1 - lambda_c) * cev_r(i);
    
    % Relief Fund (Smoothed) Scenarios CEV
    U_alt_r_relief = calc_lifetime_utility(get_path(scenarios_relief{i}, 'C_r'));
    cev_r_relief(i) = (exp((1 - beta) * (U_alt_r_relief - U_base_r)) - 1) * 100;
    
    U_alt_c_relief = calc_lifetime_utility(get_path(scenarios_relief{i}, 'C_c'));
    cev_c_relief(i) = (exp((1 - beta) * (U_alt_c_relief - U_base_c)) - 1) * 100;
    
    cev_total_relief(i) = lambda_c * cev_c_relief(i) + (1 - lambda_c) * cev_r_relief(i);
end

%% --- PLOTTING ---
figure('Name', 'Consumption Equivalent Variation (CEV)', 'Position', [100, 100, 1200, 800]);

% Establish a universal y-axis scale so the raw vs smoothed impact is visually directly comparable
y_min = min([cev_r, cev_c, cev_total, cev_r_relief, cev_c_relief, cev_total_relief, 0]) * 1.2;
y_max = max([cev_r, cev_c, cev_total, cev_r_relief, cev_c_relief, cev_total_relief, 0]) * 1.2;

% --- TOP ROW: Standard Shock ---
% 1. Ricardian Households
subplot(2, 3, 1);
bar(categorical(scenario_names, scenario_names), cev_r, 'FaceColor', [0.2 0.5 0.7]);
ylabel('CEV (% permanent consumption change)');
title('Ricardian Households (Standard)');
grid on; ylim([y_min, y_max]);

% 2. Non-Ricardian Households
subplot(2, 3, 2);
bar(categorical(scenario_names, scenario_names), cev_c, 'FaceColor', [0.8 0.4 0.2]);
title('Non-Ricardian Households (Standard)');
grid on; ylim([y_min, y_max]);

% 3. Total (Population-Weighted) Welfare
subplot(2, 3, 3);
bar(categorical(scenario_names, scenario_names), cev_total, 'FaceColor', [0.3 0.6 0.4]);
title('Total Population-Weighted CEV (Standard)');
grid on; ylim([y_min, y_max]);

% --- BOTTOM ROW: Smoothed Relief Fund ---
% 4. Ricardian Households (Smoothed)
subplot(2, 3, 4);
bar(categorical(scenario_names_relief, scenario_names_relief), cev_r_relief, 'FaceColor', [0.2 0.5 0.7]);
ylabel('CEV (% permanent consumption change)');
title('Ricardian Households (Smoothed)');
grid on; ylim([y_min, y_max]);

% 5. Non-Ricardian Households (Smoothed)
subplot(2, 3, 5);
bar(categorical(scenario_names_relief, scenario_names_relief), cev_c_relief, 'FaceColor', [0.8 0.4 0.2]);
title('Non-Ricardian Households (Smoothed)');
grid on; ylim([y_min, y_max]);

% 6. Total (Population-Weighted) Welfare (Smoothed)
subplot(2, 3, 6);
bar(categorical(scenario_names_relief, scenario_names_relief), cev_total_relief, 'FaceColor', [0.3 0.6 0.4]);
title('Total Population-Weighted CEV (Smoothed)');
grid on; ylim([y_min, y_max]);