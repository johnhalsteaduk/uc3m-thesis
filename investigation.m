% =========================================================================
% DIAGNOSTIC PLOT: FISCAL MECHANICS (HIGH RISK, FIX TAU SCENARIO)
% =========================================================================
horizon_diag = 35;
years_diag = 2015 + (1:horizon_diag) - 1;

% Load the scenario where taxes are fixed, meaning L absorbs the debt deviation
d_hr_debt = load('results_debt_hr_fix_tau.mat', 'oo_', 'M_');
d_hr_crdc = load('results_crdc_hr_fix_tau.mat', 'oo_', 'M_');

% Helper functions
get_sim = @(data, var) reshape(data.oo_.endo_simul(find(strcmp(strtrim(cellstr(data.M_.endo_names)), var), 1), 1:horizon_diag), 1, []);
abs_sim = @(data, var) get_sim(data, var); 

figure('Name', 'Fiscal Mechanics: High Risk (Transfers Absorb)', 'Position', [150, 150, 1200, 700]);

% 1. Standard Public Investment (I_zi)
subplot(2, 3, 1); hold on;
plot(years_diag, abs_sim(d_hr_debt, 'I_zi'), 'k-', 'LineWidth', 1.5);
plot(years_diag, abs_sim(d_hr_crdc, 'I_zi'), 'b--', 'LineWidth', 1.5);
title('Standard Infra Inv. I_{zi} (Absolute Level)');
grid on; xlim([2015 2049]);
legend('Standard Debt', 'CRDC', 'Location', 'best');

% 2. Adaptation Investment (I_za)
subplot(2, 3, 2); hold on;
plot(years_diag, abs_sim(d_hr_debt, 'I_za'), 'k-', 'LineWidth', 1.5);
plot(years_diag, abs_sim(d_hr_crdc, 'I_za'), 'b--', 'LineWidth', 1.5);
title('Adaptation Inv. I_{za} (Absolute Level)');
grid on; xlim([2015 2049]);

% 3. Lump-sum Transfers (L)
subplot(2, 3, 3); hold on;
plot(years_diag, abs_sim(d_hr_debt, 'L'), 'k-', 'LineWidth', 1.5);
plot(years_diag, abs_sim(d_hr_crdc, 'L'), 'b--', 'LineWidth', 1.5);
title('Transfers L (Absolute Level)');
grid on; xlim([2015 2049]);

% 4. Tax Revenue (T)
subplot(2, 3, 4); hold on;
plot(years_diag, abs_sim(d_hr_debt, 'T'), 'k-', 'LineWidth', 1.5);
plot(years_diag, abs_sim(d_hr_crdc, 'T'), 'b--', 'LineWidth', 1.5);
title('Tax Revenue T (Absolute Level)');
grid on; xlim([2015 2049]);

% 5. Standard Market Debt (B)
subplot(2, 3, 5); hold on;
plot(years_diag, abs_sim(d_hr_debt, 'B'), 'k-', 'LineWidth', 1.5);
plot(years_diag, abs_sim(d_hr_crdc, 'B'), 'b--', 'LineWidth', 1.5);
title('Market Debt B (Absolute Level)');
grid on; xlim([2015 2049]);