% =========================================================================
% MASTER PLOTTING SCRIPT: CRDC HIGH RISK COMPARISON
% =========================================================================
file_debt_norm = 'results_debt_normal.mat';
file_crdc_norm = 'results_crdc_normal.mat';
file_debt_hr   = 'results_debt_high_risk.mat';
file_crdc_hr   = 'results_crdc_high_risk.mat';

time_horizon = 35; 
years = 2015 + (1:time_horizon) - 1; 

% Load datasets
d_dn  = load(file_debt_norm, 'oo_', 'M_');
d_cn  = load(file_crdc_norm, 'oo_', 'M_');
d_dhr = load(file_debt_hr, 'oo_', 'M_');
d_chr = load(file_crdc_hr, 'oo_', 'M_');

names = strtrim(cellstr(d_dn.M_.endo_names));

% Helper functions
get_sim = @(data, var) data.oo_.endo_simul(strcmp(names, var), 1:time_horizon);
get_ss  = @(data, var) data.oo_.steady_state(strcmp(names, var));
pct_dev = @(data, var) ((get_sim(data, var) - get_ss(data, var)) / get_ss(data, var)) * 100;

% Total debt helper (Standard Bonds + CRDC Obligations - Updated to uppercase Q)
debt_gdp = @(data) ((get_sim(data, 'Q') .* get_sim(data, 'B') + get_sim(data, 'F')) ./ get_sim(data, 'Y')) * 100;

figure('Name', 'CRDC vs Debt: High Risk Scenario', 'Position', [100, 100, 1200, 700]);

% --- NORMAL CONDITIONS ---
% 1. Total Debt (Normal)
subplot(2, 3, 1); hold on;
plot(years, debt_gdp(d_dn), 'k-', 'LineWidth', 1.5);
plot(years, debt_gdp(d_cn), 'b--', 'LineWidth', 1.5);
title('Total Debt (% GDP): Normal');
legend('Standard Debt', 'CRDC', 'Location', 'best');
xlim([2015 2049]); grid on;

% --- HIGH RISK CONDITIONS ---
% 2. Total Debt (High Risk)
subplot(2, 3, 2); hold on;
plot(years, debt_gdp(d_dhr), 'k-', 'LineWidth', 1.5);
plot(years, debt_gdp(d_chr), 'b--', 'LineWidth', 1.5);
title('Total Debt (% GDP): High Risk');
xlim([2015 2049]); grid on;

% 3. Consumption Tax Rate (High Risk)
subplot(2, 3, 3); hold on;
plot(years, get_sim(d_dhr, 'tau_c') * 100, 'k-', 'LineWidth', 1.5);
plot(years, get_sim(d_chr, 'tau_c') * 100, 'b--', 'LineWidth', 1.5);
title('Consumption Tax Rate (%)');
xlim([2015 2049]); grid on;

% 4. Risk Premium (High Risk)
subplot(2, 3, 4); hold on;
plot(years, get_sim(d_dhr, 'R_b') * 100, 'k-', 'LineWidth', 1.5);
plot(years, get_sim(d_chr, 'R_b') * 100, 'b--', 'LineWidth', 1.5);
title('Risk Premium (%)');
xlim([2015 2049]); grid on;

% 5. Ricardian Consumption (High Risk)
subplot(2, 3, 5); hold on;
plot(years, pct_dev(d_dhr, 'C_r'), 'k-', 'LineWidth', 1.5);
plot(years, pct_dev(d_chr, 'C_r'), 'b--', 'LineWidth', 1.5);
title('Ricardian Cons. (% \Delta SS)');
xlim([2015 2049]); grid on;

% 6. Constrained Consumption (High Risk)
subplot(2, 3, 6); hold on;
plot(years, pct_dev(d_dhr, 'C_c'), 'k-', 'LineWidth', 1.5);
plot(years, pct_dev(d_chr, 'C_c'), 'b--', 'LineWidth', 1.5);
title('Constrained Cons. (% \Delta SS)');
xlim([2015 2049]); grid on;