% =========================================================================
% MASTER PLOTTING SCRIPT: CRDC RESILIENCE COMPARISON (PART 2)
% =========================================================================
file_debt       = 'results_debt_adaptation.mat';
file_debt_resil = 'results_debt_resilience.mat';
file_crdc       = 'results_crdc_adaptation.mat';
file_crdc_resil = 'results_crdc_resilience.mat';

% Extended to capture the second shock
time_horizon = 40; 
years = 2010 + (1:time_horizon) - 1; 

% Load datasets
d_debt       = load(file_debt, 'oo_', 'M_');
d_debt_resil = load(file_debt_resil, 'oo_', 'M_');
d_crdc       = load(file_crdc, 'oo_', 'M_');
d_crdc_resil = load(file_crdc_resil, 'oo_', 'M_');

names = strtrim(cellstr(d_debt.M_.endo_names));

% Helper functions
get_sim = @(data, var) data.oo_.endo_simul(strcmp(names, var), 1:time_horizon);
get_ss  = @(data, var) data.oo_.steady_state(strcmp(names, var));
pct_dev = @(data, var) ((get_sim(data, var) - get_ss(data, var)) / get_ss(data, var)) * 100;
pct_gdp = @(data, var) (get_sim(data, var) ./ get_sim(data, 'Y')) * 100;
debt_gdp = @(data) (get_sim(data, 'q') .* get_sim(data, 'B') ./ get_sim(data, 'Y')) * 100;

figure('Name', 'CRDC Resilience vs Standard Policies', 'Position', [100, 100, 1400, 900]);

% 1. Public Debt (% of GDP)
subplot(3, 3, 1); hold on;
plot(years, debt_gdp(d_debt), 'k-', 'LineWidth', 1.5);
plot(years, debt_gdp(d_debt_resil), 'k:', 'LineWidth', 1.5);
plot(years, debt_gdp(d_crdc), 'b--', 'LineWidth', 1.5);
plot(years, debt_gdp(d_crdc_resil), 'g-.', 'LineWidth', 1.5);
title('Public Debt (% of GDP)');
legend('Standard Debt', 'Debt (Resilience)', 'CRDC (Standard)', 'CRDC (Resilience)', 'Location', 'best');
xlim([2010 2049]); grid on;

% 2. Aggregate Consumption (% \Delta from SS)
subplot(3, 3, 2); hold on;
plot(years, pct_dev(d_debt, 'C'), 'k-', 'LineWidth', 1.5);
plot(years, pct_dev(d_debt_resil, 'C'), 'k:', 'LineWidth', 1.5);
plot(years, pct_dev(d_crdc, 'C'), 'b--', 'LineWidth', 1.5);
plot(years, pct_dev(d_crdc_resil, 'C'), 'g-.', 'LineWidth', 1.5);
title('Aggregate Cons. (% \Delta from SS)');
xlim([2010 2049]); grid on;

% 3. Private Capital (% \Delta from SS)
subplot(3, 3, 3); hold on;
plot(years, pct_dev(d_debt, 'K'), 'k-', 'LineWidth', 1.5);
plot(years, pct_dev(d_debt_resil, 'K'), 'k:', 'LineWidth', 1.5);
plot(years, pct_dev(d_crdc, 'K'), 'b--', 'LineWidth', 1.5);
plot(years, pct_dev(d_crdc_resil, 'K'), 'g-.', 'LineWidth', 1.5);
title('Private Capital (% \Delta from SS)');
xlim([2010 2049]); grid on;

% 4. Private Investment (% of GDP)
subplot(3, 3, 4); hold on;
plot(years, pct_gdp(d_debt, 'I_k'), 'k-', 'LineWidth', 1.5);
plot(years, pct_gdp(d_debt_resil, 'I_k'), 'k:', 'LineWidth', 1.5);
plot(years, pct_gdp(d_crdc, 'I_k'), 'b--', 'LineWidth', 1.5);
plot(years, pct_gdp(d_crdc_resil, 'I_k'), 'g-.', 'LineWidth', 1.5);
title('Private Inv. (% of GDP)');
xlim([2010 2049]); grid on;

% 5. Standard Public Capital (% \Delta from SS)
subplot(3, 3, 5); hold on;
plot(years, pct_dev(d_debt, 'Z_i'), 'k-', 'LineWidth', 1.5);
plot(years, pct_dev(d_debt_resil, 'Z_i'), 'k:', 'LineWidth', 1.5);
plot(years, pct_dev(d_crdc, 'Z_i'), 'b--', 'LineWidth', 1.5);
plot(years, pct_dev(d_crdc_resil, 'Z_i'), 'g-.', 'LineWidth', 1.5);
title('Standard Pub. Capital (% \Delta from SS)');
xlim([2010 2049]); grid on;

% 6. Standard Public Investment (% of GDP)
subplot(3, 3, 6); hold on;
plot(years, pct_gdp(d_debt, 'I_zi'), 'k-', 'LineWidth', 1.5);
plot(years, pct_gdp(d_debt_resil, 'I_zi'), 'k:', 'LineWidth', 1.5);
plot(years, pct_gdp(d_crdc, 'I_zi'), 'b--', 'LineWidth', 1.5);
plot(years, pct_gdp(d_crdc_resil, 'I_zi'), 'g-.', 'LineWidth', 1.5);
title('Standard Pub. Inv. (% of GDP)');
xlim([2010 2049]); grid on;

% 7. Adaptation Capital (% \Delta from SS)
subplot(3, 3, 7); hold on;
plot(years, pct_dev(d_debt, 'Z_a'), 'k-', 'LineWidth', 1.5);
plot(years, pct_dev(d_debt_resil, 'Z_a'), 'k:', 'LineWidth', 1.5);
plot(years, pct_dev(d_crdc, 'Z_a'), 'b--', 'LineWidth', 1.5);
plot(years, pct_dev(d_crdc_resil, 'Z_a'), 'g-.', 'LineWidth', 1.5);
title('Adaptation Capital (% \Delta from SS)');
xlim([2010 2049]); grid on;

% 8. Adaptation Investment (% of GDP)
subplot(3, 3, 8); hold on;
plot(years, pct_gdp(d_debt, 'I_za'), 'k-', 'LineWidth', 1.5);
plot(years, pct_gdp(d_debt_resil, 'I_za'), 'k:', 'LineWidth', 1.5);
plot(years, pct_gdp(d_crdc, 'I_za'), 'b--', 'LineWidth', 1.5);
plot(years, pct_gdp(d_crdc_resil, 'I_za'), 'g-.', 'LineWidth', 1.5);
title('Adaptation Inv. (% of GDP)');
xlim([2010 2049]); grid on;

% 9. Marginal Benefits & Allocation (Dual Y-Axis)
subplot(3, 3, 9); hold on;
yyaxis left;
plot(years, get_sim(d_crdc_resil, 'MB_b'), 'r-', 'LineWidth', 1.5);
plot(years, get_sim(d_crdc_resil, 'MB_za'), 'b-', 'LineWidth', 1.5);
ylabel('Marginal Benefits');
ax = gca; ax.YColor = 'k';

yyaxis right;
% Calculate the allocation share directly from the simulated marginal benefits
inline_share = zeta .* (get_sim(d_crdc_resil, 'MB_za') ./ get_sim(d_crdc_resil, 'MB_b'));
plot(years, inline_share, 'k--', 'LineWidth', 1.5);
ylabel('Allocation Share');
ax = gca; ax.YColor = 'k';

title('Dynamic Allocation (Resilience)');
legend('MB_b', 'MB_{za}', 'Inline Share', 'Location', 'best');
xlim([2010 2049]); grid on;