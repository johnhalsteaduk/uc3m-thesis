% Ensure you have generated these four files before running:
file_no_accel = 'results_baseline_no_accel.mat';
file_tax_accel = 'results_baseline_accel.mat'; % Baseline = Tax-financed
file_debt_accel = 'results_debt_accel.mat';
file_grants_accel = 'results_debt_accel_grants.mat'; % New Grants file

time_horizon = 25; % Marto plots a 25-year horizon

%% --- FIGURE 1: SHOCK TRANSMISSION (Marto Fig 2) ---
figure('Name', 'Marto Fig 2: Shock Transmission', 'Position', [100, 100, 1000, 600]);

% Load both datasets
d_no = load(file_no_accel, 'oo_', 'M_');
d_ac = load(file_tax_accel, 'oo_', 'M_');
names = strtrim(cellstr(d_no.M_.endo_names));

% Helper function to get simulated data
get_sim = @(data, var) data.oo_.endo_simul(strcmp(names, var), 1:time_horizon);
get_ss  = @(data, var) data.oo_.steady_state(strcmp(names, var));
pct_dev = @(data, var) ((get_sim(data, var) - get_ss(data, var)) / get_ss(data, var)) * 100;

% 1. Public Capital (Z)
subplot(2, 3, 1); hold on;
plot(1:time_horizon, pct_dev(d_no, 'Z'), 'r-.', 'LineWidth', 1.5);
plot(1:time_horizon, pct_dev(d_ac, 'Z'), 'b-', 'LineWidth', 1.5);
title('Public Capital (% \Delta from SS)'); legend('Without Accel', 'With Accel', 'Location', 'best');

% 2. Private Capital (K)
subplot(2, 3, 2); hold on;
plot(1:time_horizon, pct_dev(d_no, 'K'), 'r-.', 'LineWidth', 1.5);
plot(1:time_horizon, pct_dev(d_ac, 'K'), 'b-', 'LineWidth', 1.5);
title('Private Capital (% \Delta from SS)');

% 3. Total Factor Productivity (TFP)
p_names = strtrim(cellstr(d_no.M_.param_names));
get_p = @(p) d_no.M_.params(strcmp(p_names, p));
w_k = get_p('omega_k'); alpha = get_p('alpha'); w_z = get_p('omega_z');
psi_z = get_p('psi_z'); kappa = get_p('kappa');

% Manually construct the lagged Z_a arrays (Size: 1 x time_horizon)
Z_a_sim_no = get_sim(d_no, 'Z_a');
Z_a_lag_no = [get_ss(d_no, 'Z_a'), Z_a_sim_no(1:end-1)];
Z_a_sim_ac = get_sim(d_ac, 'Z_a');
Z_a_lag_ac = [get_ss(d_ac, 'Z_a'), Z_a_sim_ac(1:end-1)];

% Calculate TFP explicitly
calc_tfp_no = exp(-(1-w_k*alpha-w_z*psi_z)*get_sim(d_no,'D') ./ (1+kappa*Z_a_lag_no));
calc_tfp_ac = exp(-(1-w_k*alpha-w_z*psi_z)*get_sim(d_ac,'D') ./ (1+kappa*Z_a_lag_ac));
tfp_no = (calc_tfp_no - 1) * 100; % ss TFP is 1
tfp_ac = (calc_tfp_ac - 1) * 100;

subplot(2, 3, 3); hold on;
plot(1:time_horizon, tfp_no(1:time_horizon), 'r-.', 'LineWidth', 1.5);
plot(1:time_horizon, tfp_ac(1:time_horizon), 'b-', 'LineWidth', 1.5);
title('Total Factor Productivity (% \Delta from SS)');

% 4. Public Investment as % of GDP
subplot(2, 3, 4); hold on;
plot(1:time_horizon, (get_sim(d_no, 'I_zi') ./ get_sim(d_no, 'Y')) * 100, 'r-.', 'LineWidth', 1.5);
plot(1:time_horizon, (get_sim(d_ac, 'I_zi') ./ get_sim(d_ac, 'Y')) * 100, 'b-', 'LineWidth', 1.5);
title('Public Investment (% of GDP)');

% 5. S and R_b on the same plot (Using With-Accel data)
subplot(2, 3, 5); hold on;
plot(1:time_horizon, get_sim(d_ac, 'S'), 'b-.', 'LineWidth', 1.5);
plot(1:time_horizon, get_sim(d_ac, 'R_b') * 100, 'r-', 'LineWidth', 1.5);
title('Efficiency & Real Interest Rate');
legend('Public investment efficiency', 'Real interest rate (%)', 'Location', 'best', 'FontSize', 7);


%% --- FIGURE 2: POLICY COMPARISON (Marto Fig 3) ---
figure('Name', 'Marto Fig 3: Recovery Policies', 'Position', [120, 120, 1000, 600]);

d_debt   = load(file_debt_accel, 'oo_', 'M_');
d_grants = load(file_grants_accel, 'oo_', 'M_'); % Load Grants Scenario

% 1. Consumption Tax Rate (tau_c)
subplot(2, 3, 1); hold on;
plot(1:time_horizon, get_sim(d_debt, 'tau_c') * 100, 'k-', 'LineWidth', 1.5);
plot(1:time_horizon, get_sim(d_ac, 'tau_c') * 100, 'r*-', 'LineWidth', 1.5);

title('Consumption Tax Rate (%)'); 
legend('Debt-financed', 'Tax-financed', 'Grants are Welcome', 'Location', 'best');

% 2. Total Public Debt (% of GDP)
subplot(2, 3, 2); hold on;
plot(1:time_horizon, (get_sim(d_debt, 'B') ./ get_sim(d_debt, 'Y')) * 100, 'k-', 'LineWidth', 1.5);
plot(1:time_horizon, (get_sim(d_ac, 'B') ./ get_sim(d_ac, 'Y')) * 100, 'r*-', 'LineWidth', 1.5);
title('Total Public Debt (% of GDP)');

% 4. Private Consumption
subplot(2, 3, 4); hold on;
plot(1:time_horizon, pct_dev(d_debt, 'C'), 'k-', 'LineWidth', 1.5);
plot(1:time_horizon, pct_dev(d_ac, 'C'), 'r*-', 'LineWidth', 1.5);
title('Private Consumption (% \Delta from SS)');

% 5. Private Investment
subplot(2, 3, 5); hold on;
plot(1:time_horizon, pct_dev(d_debt, 'I_k'), 'k-', 'LineWidth', 1.5);
plot(1:time_horizon, pct_dev(d_ac, 'I_k'), 'r*-', 'LineWidth', 1.5);
title('Private Investment (% \Delta from SS)');

% 6. Current Account Deficit (% of GDP)
calc_cad = @(d) ([0, diff(get_sim(d, 'B'))] ./ get_sim(d, 'Y')) * 100;
subplot(2, 3, 6); hold on;
plot(1:time_horizon, calc_cad(d_debt), 'k-', 'LineWidth', 1.5);
plot(1:time_horizon, calc_cad(d_ac), 'r*-', 'LineWidth', 1.5);
title('Current Account Deficit (% of GDP)');