% =========================================================================
% MASTER PLOTTING SCRIPT (PART 1: MARTO REPLICATION)
% =========================================================================
file_no_accel   = 'results_baseline_no_accel.mat';
file_base_accel = 'results_baseline_accel.mat'; 
file_tax_accel  = 'results_tax_only_accel.mat'; 
file_debt_accel = 'results_debt_only_accel.mat'; 
file_adapt      = 'results_baseline_accel_adaptation.mat'; 

time_horizon = 35; % 5 years pre-shock + 30 years post-shock
years = 2015 + (1:time_horizon) - 1; 

%% --- HELPER FUNCTIONS & DATA LOADING ---
d_no    = load(file_no_accel, 'oo_', 'M_');
d_base  = load(file_base_accel, 'oo_', 'M_');
d_tax   = load(file_tax_accel, 'oo_', 'M_');
d_debt  = load(file_debt_accel, 'oo_', 'M_');
d_adapt = load(file_adapt, 'oo_', 'M_');

names = strtrim(cellstr(d_no.M_.endo_names));
get_sim = @(data, var) data.oo_.endo_simul(strcmp(names, var), 1:time_horizon);
get_ss  = @(data, var) data.oo_.steady_state(strcmp(names, var));
pct_dev = @(data, var) ((get_sim(data, var) - get_ss(data, var)) / get_ss(data, var)) * 100;

% Total debt helper (Updated to include F and Q to prevent breaks on CRDC data)
debt_gdp = @(data) ((get_sim(data, 'Q') .* get_sim(data, 'B') + get_sim(data, 'F')) ./ get_sim(data, 'Y')) * 100;

p_names = strtrim(cellstr(d_no.M_.param_names));
get_p = @(p) d_no.M_.params(strcmp(p_names, p));

% Extract updated TFP parameter
omega_tfp = get_p('omega_tfp'); 
pi_val = get_p('pi'); 

%% --- FIGURE 1: SHOCK TRANSMISSION (Marto Fig 2) ---
figure('Name', 'Marto Fig 2: Shock Transmission', 'Position', [100, 100, 1000, 600]);

subplot(2, 3, 1); hold on;
plot(years, pct_dev(d_no, 'Z_i'), 'r-.', 'LineWidth', 1.5);
plot(years, pct_dev(d_base, 'Z_i'), 'b-', 'LineWidth', 1.5);
title('Public Capital (% \Delta from SS)'); 
legend('Without Accel', 'With Accel', 'Location', 'best');
xlim([2015 2040]); grid on;

subplot(2, 3, 2); hold on;
plot(years, pct_dev(d_no, 'K'), 'r-.', 'LineWidth', 1.5);
plot(years, pct_dev(d_base, 'K'), 'b-', 'LineWidth', 1.5);
title('Private Capital (% \Delta from SS)');
xlim([2015 2040]); grid on;

% Total Factor Productivity (TFP) using updated omega_tfp
Z_a_sim_no = get_sim(d_no, 'Z_a'); 
Z_a_lag_no = [get_ss(d_no, 'Z_a'), Z_a_sim_no(1:end-1)];
Z_a_sim_base = get_sim(d_base, 'Z_a'); 
Z_a_lag_base = [get_ss(d_base, 'Z_a'), Z_a_sim_base(1:end-1)];

calc_tfp_no = (1 - get_sim(d_no,'D') ./ (1 + pi_val*Z_a_lag_no)).^omega_tfp;
calc_tfp_base = (1 - get_sim(d_base,'D') ./ (1 + pi_val*Z_a_lag_base)).^omega_tfp;

subplot(2, 3, 3); hold on;
plot(years, (calc_tfp_no - 1) * 100, 'r-.', 'LineWidth', 1.5);
plot(years, (calc_tfp_base - 1) * 100, 'b-', 'LineWidth', 1.5);
title('Total Factor Productivity (% \Delta from SS)');
xlim([2015 2040]); grid on;

subplot(2, 3, 4); hold on;
plot(years, (get_sim(d_no, 'I_zi') ./ get_sim(d_no, 'Y')) * 100, 'r-.', 'LineWidth', 1.5);
plot(years, (get_sim(d_base, 'I_zi') ./ get_sim(d_base, 'Y')) * 100, 'b-', 'LineWidth', 1.5);
title('Public Investment (% of GDP)');
xlim([2015 2040]); grid on;

subplot(2, 3, 5); hold on;
plot(years, get_sim(d_base, 'S'), 'b-.', 'LineWidth', 1.5);
plot(years, get_sim(d_base, 'R_b') * 100, 'r-', 'LineWidth', 1.5);
title('Efficiency & Real Interest Rate');
legend('Public investment efficiency', 'Real interest rate (%)', 'Location', 'best', 'FontSize', 7);
xlim([2015 2040]); grid on;

%% --- FIGURE 2: POLICY COMPARISON (Marto Fig 3) ---
figure('Name', 'Marto Fig 3: Recovery Policies', 'Position', [120, 120, 1000, 600]);

subplot(2, 6, [2 3]); hold on;
plot(years, get_sim(d_debt, 'tau_c') * 100, 'k-', 'LineWidth', 1.5);
plot(years, get_sim(d_tax, 'tau_c') * 100, 'r*-', 'LineWidth', 1.5);
title('Consumption Tax Rate (%)'); 
legend('Debt-financed', 'Tax-financed', 'Location', 'best');
xlim([2015 2040]); grid on;

subplot(2, 6, [4 5]); hold on;
plot(years, debt_gdp(d_debt), 'k-', 'LineWidth', 1.5);
plot(years, debt_gdp(d_tax), 'r*-', 'LineWidth', 1.5);
title('Total Public Debt (% of GDP)');
xlim([2015 2040]); grid on;

subplot(2, 3, 4); hold on;
plot(years, pct_dev(d_debt, 'C'), 'k-', 'LineWidth', 1.5);
plot(years, pct_dev(d_tax, 'C'), 'r*-', 'LineWidth', 1.5);
title('Private Consumption (% \Delta from SS)');
xlim([2015 2040]); grid on;

subplot(2, 3, 5); hold on;
plot(years, pct_dev(d_debt, 'I_k'), 'k-', 'LineWidth', 1.5);
plot(years, pct_dev(d_tax, 'I_k'), 'r*-', 'LineWidth', 1.5);
title('Private Investment (% \Delta from SS)');
xlim([2015 2040]); grid on;

% Updated to include F and Q for consistency
calc_cad = @(data) ([0, diff(get_sim(data, 'Q') .* get_sim(data, 'B') + get_sim(data, 'F'))] ./ get_sim(data, 'Y')) * 100;

subplot(2, 3, 6); hold on;
plot(years, calc_cad(d_debt), 'k-', 'LineWidth', 1.5);
plot(years, calc_cad(d_tax), 'r*-', 'LineWidth', 1.5);
title('Current Account Deficit (% of GDP)');
xlim([2015 2040]); grid on;

%% --- FIGURE 3: ADAPTATION VS NO ADAPTATION (Marto Fig 4) ---
figure('Name', 'Marto Fig 4: Capital and TFP with vs. without Adaptation', 'Position', [140, 140, 1000, 300]);

Z_a_sim_adapt = get_sim(d_adapt, 'Z_a');
Z_a_lag_adapt = [get_ss(d_adapt, 'Z_a'), Z_a_sim_adapt(1:end-1)];
calc_tfp_adapt = (1 - get_sim(d_adapt,'D') ./ (1 + pi_val*Z_a_lag_adapt)).^omega_tfp;

subplot(1, 3, 1); hold on;
plot(years, pct_dev(d_base, 'Z_i'), 'b-', 'LineWidth', 1.5);
plot(years, pct_dev(d_adapt, 'Z_i'), 'r*-', 'LineWidth', 1.5);
title('Effective Public Capital (% \Delta from SS)');
legend('Without Adaptation', 'With Adaptation', 'Location', 'best');
xlim([2015 2040]); grid on;

subplot(1, 3, 2); hold on;
plot(years, pct_dev(d_base, 'K'), 'b-', 'LineWidth', 1.5);
plot(years, pct_dev(d_adapt, 'K'), 'r*-', 'LineWidth', 1.5);
title('Private Capital (% \Delta from SS)');
xlim([2015 2040]); grid on;

subplot(1, 3, 3); hold on;
plot(years, (calc_tfp_base - 1) * 100, 'b-', 'LineWidth', 1.5);
plot(years, (calc_tfp_adapt - 1) * 100, 'r*-', 'LineWidth', 1.5);
title('Total Factor Productivity (% \Delta from SS)');
xlim([2015 2040]); grid on;