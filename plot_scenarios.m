% =========================================================================
% MASTER PLOTTING SCRIPT (PART 1: MARTO REPLICATION)
% =========================================================================
file_no_accel   = 'results_baseline_no_accel.mat';
file_tax_accel  = 'results_baseline_accel.mat'; 
file_debt_accel = 'results_debt_only_accel.mat'; 
file_adapt      = 'results_baseline_accel_adaptation.mat'; 
time_horizon = 25; 

%% --- HELPER FUNCTIONS & DATA LOADING ---
d_no    = load(file_no_accel, 'oo_', 'M_');
d_ac    = load(file_tax_accel, 'oo_', 'M_');
d_debt  = load(file_debt_accel, 'oo_', 'M_');
d_adapt = load(file_adapt, 'oo_', 'M_');
names = strtrim(cellstr(d_no.M_.endo_names));

get_sim = @(data, var) data.oo_.endo_simul(strcmp(names, var), 1:time_horizon);
get_ss  = @(data, var) data.oo_.steady_state(strcmp(names, var));
pct_dev = @(data, var) ((get_sim(data, var) - get_ss(data, var)) / get_ss(data, var)) * 100;

p_names = strtrim(cellstr(d_no.M_.param_names));
get_p = @(p) d_no.M_.params(strcmp(p_names, p));
w_k = get_p('omega_k'); alpha = get_p('alpha'); w_z = get_p('omega_z');
psi_z = get_p('psi_z'); kappa = get_p('kappa');

%% --- FIGURE 1: SHOCK TRANSMISSION (Marto Fig 2) ---
figure('Name', 'Marto Fig 2: Shock Transmission', 'Position', [100, 100, 1000, 600]);
subplot(2, 3, 1); hold on;
plot(1:time_horizon, pct_dev(d_no, 'Z'), 'r-.', 'LineWidth', 1.5);
plot(1:time_horizon, pct_dev(d_ac, 'Z'), 'b-', 'LineWidth', 1.5);
title('Public Capital (% \Delta from SS)'); legend('Without Accel', 'With Accel', 'Location', 'best');

subplot(2, 3, 2); hold on;
plot(1:time_horizon, pct_dev(d_no, 'K'), 'r-.', 'LineWidth', 1.5);
plot(1:time_horizon, pct_dev(d_ac, 'K'), 'b-', 'LineWidth', 1.5);
title('Private Capital (% \Delta from SS)');

% Total Factor Productivity (TFP)
Z_a_sim_no = get_sim(d_no, 'Z_a');
Z_a_lag_no = [get_ss(d_no, 'Z_a'), Z_a_sim_no(1:end-1)];
Z_a_sim_ac = get_sim(d_ac, 'Z_a');
Z_a_lag_ac = [get_ss(d_ac, 'Z_a'), Z_a_sim_ac(1:end-1)];
calc_tfp_no = exp(-(1-w_k*alpha-w_z*psi_z)*get_sim(d_no,'D') ./ (1+kappa*Z_a_lag_no));
calc_tfp_ac = exp(-(1-w_k*alpha-w_z*psi_z)*get_sim(d_ac,'D') ./ (1+kappa*Z_a_lag_ac));
tfp_no = (calc_tfp_no - 1) * 100; 
tfp_ac = (calc_tfp_ac - 1) * 100;

subplot(2, 3, 3); hold on;
plot(1:time_horizon, tfp_no, 'r-.', 'LineWidth', 1.5);
plot(1:time_horizon, tfp_ac, 'b-', 'LineWidth', 1.5);
title('Total Factor Productivity (% \Delta from SS)');

subplot(2, 3, 4); hold on;
plot(1:time_horizon, (get_sim(d_no, 'I_zi') ./ get_sim(d_no, 'Y')) * 100, 'r-.', 'LineWidth', 1.5);
plot(1:time_horizon, (get_sim(d_ac, 'I_zi') ./ get_sim(d_ac, 'Y')) * 100, 'b-', 'LineWidth', 1.5);
title('Public Investment (% of GDP)');

subplot(2, 3, 5); hold on;
plot(1:time_horizon, get_sim(d_ac, 'S'), 'b-.', 'LineWidth', 1.5);
plot(1:time_horizon, get_sim(d_ac, 'R_b') * 100, 'r-', 'LineWidth', 1.5);
title('Efficiency & Real Interest Rate');
legend('Public investment efficiency', 'Real interest rate (%)', 'Location', 'best', 'FontSize', 7);

%% --- FIGURE 2: POLICY COMPARISON (Marto Fig 3) ---
figure('Name', 'Marto Fig 3: Recovery Policies', 'Position', [120, 120, 1000, 600]);
subplot(2, 6, [2 3]); hold on;
plot(1:time_horizon, get_sim(d_debt, 'tau_c') * 100, 'k-', 'LineWidth', 1.5);
plot(1:time_horizon, get_sim(d_ac, 'tau_c') * 100, 'r*-', 'LineWidth', 1.5);
title('Consumption Tax Rate (%)'); 
legend('Debt-financed', 'Tax-financed', 'Location', 'best');

subplot(2, 6, [4 5]); hold on;
plot(1:time_horizon, (get_sim(d_debt, 'B') ./ get_sim(d_debt, 'Y')) * 100, 'k-', 'LineWidth', 1.5);
plot(1:time_horizon, (get_sim(d_ac, 'B') ./ get_sim(d_ac, 'Y')) * 100, 'r*-', 'LineWidth', 1.5);
title('Total Public Debt (% of GDP)');

subplot(2, 3, 4); hold on;
plot(1:time_horizon, pct_dev(d_debt, 'C'), 'k-', 'LineWidth', 1.5);
plot(1:time_horizon, pct_dev(d_ac, 'C'), 'r*-', 'LineWidth', 1.5);
title('Private Consumption (% \Delta from SS)');

subplot(2, 3, 5); hold on;
plot(1:time_horizon, pct_dev(d_debt, 'I_k'), 'k-', 'LineWidth', 1.5);
plot(1:time_horizon, pct_dev(d_ac, 'I_k'), 'r*-', 'LineWidth', 1.5);
title('Private Investment (% \Delta from SS)');

calc_cad = @(d) ([0, diff(get_sim(d, 'B'))] ./ get_sim(d, 'Y')) * 100;
subplot(2, 3, 6); hold on;
plot(1:time_horizon, calc_cad(d_debt), 'k-', 'LineWidth', 1.5);
plot(1:time_horizon, calc_cad(d_ac), 'r*-', 'LineWidth', 1.5);
title('Current Account Deficit (% of GDP)');

%% --- FIGURE 3: ADAPTATION VS NO ADAPTATION (Marto Fig 4) ---
figure('Name', 'Marto Fig 4: Capital and TFP with vs. without Adaptation', 'Position', [140, 140, 1000, 300]);
Z_a_sim_adapt = get_sim(d_adapt, 'Z_a');
Z_a_lag_adapt = [get_ss(d_adapt, 'Z_a'), Z_a_sim_adapt(1:end-1)];
calc_tfp_adapt = exp(-(1-w_k*alpha-w_z*psi_z)*get_sim(d_adapt,'D') ./ (1+kappa*Z_a_lag_adapt));
tfp_adapt = (calc_tfp_adapt - 1) * 100;

subplot(1, 3, 1); hold on;
plot(1:time_horizon, pct_dev(d_ac, 'Z'), 'r--', 'LineWidth', 1.5);
plot(1:time_horizon, pct_dev(d_adapt, 'Z'), 'b-', 'LineWidth', 1.5);
title('Effective Public Capital (% \Delta from SS)');
legend('No Adaptation', 'With Adaptation', 'Location', 'best');

subplot(1, 3, 2); hold on;
plot(1:time_horizon, pct_dev(d_ac, 'K'), 'r--', 'LineWidth', 1.5);
plot(1:time_horizon, pct_dev(d_adapt, 'K'), 'b-', 'LineWidth', 1.5);
title('Private Capital (% \Delta from SS)');

subplot(1, 3, 3); hold on;
plot(1:time_horizon, tfp_ac, 'r--', 'LineWidth', 1.5);
plot(1:time_horizon, tfp_adapt, 'b-', 'LineWidth', 1.5);
title('Total Factor Productivity (% \Delta from SS)');