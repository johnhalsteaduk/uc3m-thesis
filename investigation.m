% =========================================================================
% DIAGNOSTIC PLOTTING SCRIPT: CRDC MECHANICS (HIGH RISK SCENARIO)
% =========================================================================
file_debt_hr = 'results_debt_high_risk.mat';
file_crdc_hr = 'results_crdc_high_risk.mat';

time_horizon = 35; 
years = 2015 + (1:time_horizon) - 1; 

% Load datasets
d_dhr = load(file_debt_hr, 'oo_', 'M_');
d_chr = load(file_crdc_hr, 'oo_', 'M_');

names = strtrim(cellstr(d_dhr.M_.endo_names));
get_sim = @(data, var) data.oo_.endo_simul(strcmp(names, var), 1:time_horizon);

figure('Name', 'CRDC Diagnostic: Internal Mechanics', 'Position', [150, 150, 1200, 700]);

% 1. Deferred Obligations (F)
subplot(2, 3, 1); hold on;
plot(years, get_sim(d_dhr, 'F'), 'k-', 'LineWidth', 1.5);
plot(years, get_sim(d_chr, 'F'), 'b--', 'LineWidth', 1.5);
title('Deferred Obligations (F)');
legend('Standard Debt', 'CRDC', 'Location', 'best');
xlim([2015 2049]); grid on;

% 2. Market Value of Standard Bonds (Q*B)
subplot(2, 3, 2); hold on;
plot(years, get_sim(d_dhr, 'Q') .* get_sim(d_dhr, 'B'), 'k-', 'LineWidth', 1.5);
plot(years, get_sim(d_chr, 'Q') .* get_sim(d_chr, 'B'), 'b--', 'LineWidth', 1.5);
title('Market Value of Bonds (Q*B)');
xlim([2015 2049]); grid on;

% 3. Disaster Shock (D)
subplot(2, 3, 3); hold on;
plot(years, get_sim(d_dhr, 'D'), 'k-', 'LineWidth', 1.5);
plot(years, get_sim(d_chr, 'D'), 'b--', 'LineWidth', 1.5);
title('Persistent Damage (D)');
xlim([2015 2049]); grid on;

% 4. Sovereign Risk Premium (R_b)
subplot(2, 3, 4); hold on;
plot(years, get_sim(d_dhr, 'R_b') * 100, 'k-', 'LineWidth', 1.5);
plot(years, get_sim(d_chr, 'R_b') * 100, 'b--', 'LineWidth', 1.5);
title('Sovereign Rate / R_b (%)');
xlim([2015 2049]); grid on;

% 5. Consumption Tax Rate (tau_c)
subplot(2, 3, 5); hold on;
plot(years, get_sim(d_dhr, 'tau_c') * 100, 'k-', 'LineWidth', 1.5);
plot(years, get_sim(d_chr, 'tau_c') * 100, 'b--', 'LineWidth', 1.5);
title('Consumption Tax (%)');
xlim([2015 2049]); grid on;

% 6. Bond Price (Q)
subplot(2, 3, 6); hold on;
plot(years, get_sim(d_dhr, 'Q'), 'k-', 'LineWidth', 1.5);
plot(years, get_sim(d_chr, 'Q'), 'b--', 'LineWidth', 1.5);
title('Bond Price (Q)');
xlim([2015 2049]); grid on;