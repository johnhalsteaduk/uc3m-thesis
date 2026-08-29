% =========================================================================
% MASTER PLOTTING SCRIPT: CRDC FRICTIONS COMPARISON
% =========================================================================
file_debt_norm = 'results_debt_normal.mat';
file_crdc_norm = 'results_crdc_normal.mat';
file_debt_adj  = 'results_debt_adj_cost.mat';
file_crdc_adj  = 'results_crdc_adj_cost.mat';
file_debt_exp  = 'results_debt_exp_risk.mat';
file_crdc_exp  = 'results_crdc_exp_risk.mat';

time_horizon = 40; 
years = 2010 + (1:time_horizon) - 1; 

% Load datasets
d_dn = load(file_debt_norm, 'oo_', 'M_');
d_cn = load(file_crdc_norm, 'oo_', 'M_');
d_da = load(file_debt_adj, 'oo_', 'M_');
d_ca = load(file_crdc_adj, 'oo_', 'M_');
d_de = load(file_debt_exp, 'oo_', 'M_');
d_ce = load(file_crdc_exp, 'oo_', 'M_');

names = strtrim(cellstr(d_dn.M_.endo_names));

% Helper functions
get_sim = @(data, var) data.oo_.endo_simul(strcmp(names, var), 1:time_horizon);
debt_gdp = @(data) (get_sim(data, 'q') .* get_sim(data, 'B') ./ get_sim(data, 'Y')) * 100;
rb_pct = @(data) get_sim(data, 'R_b') * 100;

figure('Name', 'CRDC vs Debt: Frictions Comparison', 'Position', [100, 100, 1200, 700]);

% --- ROW 1: PUBLIC DEBT (% OF GDP) ---
% 1. Normal Conditions
subplot(2, 3, 1); hold on;
plot(years, debt_gdp(d_dn), 'k-', 'LineWidth', 1.5);
plot(years, debt_gdp(d_cn), 'b--', 'LineWidth', 1.5);
title('Debt (% GDP): Normal');
legend('Standard Debt', 'CRDC', 'Location', 'best');
xlim([2010 2049]); grid on;

% 2. Adjustment Costs (Negotiation Lags)
subplot(2, 3, 2); hold on;
plot(years, debt_gdp(d_da), 'k-', 'LineWidth', 1.5);
plot(years, debt_gdp(d_ca), 'b--', 'LineWidth', 1.5);
title('Debt (% GDP): Adj Costs');
xlim([2010 2049]); grid on;

% 3. Exponential Risk (Sudden Stops)
subplot(2, 3, 3); hold on;
plot(years, debt_gdp(d_de), 'k-', 'LineWidth', 1.5);
plot(years, debt_gdp(d_ce), 'b--', 'LineWidth', 1.5);
title('Debt (% GDP): Exp Risk');
xlim([2010 2049]); grid on;

% --- ROW 2: RISK PREMIUM (R_b) ---
% 4. Normal Conditions
subplot(2, 3, 4); hold on;
plot(years, rb_pct(d_dn), 'k-', 'LineWidth', 1.5);
plot(years, rb_pct(d_cn), 'b--', 'LineWidth', 1.5);
title('Risk Premium (%): Normal');
xlim([2010 2049]); grid on;

% 5. Adjustment Costs (Negotiation Lags)
subplot(2, 3, 5); hold on;
plot(years, rb_pct(d_da), 'k-', 'LineWidth', 1.5);
plot(years, rb_pct(d_ca), 'b--', 'LineWidth', 1.5);
title('Risk Premium (%): Adj Costs');
xlim([2010 2049]); grid on;

% 6. Exponential Risk (Sudden Stops)
subplot(2, 3, 6); hold on;
plot(years, rb_pct(d_de), 'k-', 'LineWidth', 1.5);
plot(years, rb_pct(d_ce), 'b--', 'LineWidth', 1.5);
title('Risk Premium (%): Exp Risk');
xlim([2010 2049]); grid on;