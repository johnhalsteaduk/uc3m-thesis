% =========================================================================
% MASTER RUNNER & PLOTTING SCRIPT: SHORT-RUN & LONG-RUN SCENARIOS
% =========================================================================
R_star = 0.015; 
beta = 1 / (1 + R_star); 

get_sim = @(data, var_name, horizon) reshape(data.oo_.endo_simul(find(strcmp(strtrim(cellstr(data.M_.endo_names)), var_name), 1), 1:horizon), 1, []);
get_ss  = @(data, var_name) data.oo_.steady_state(find(strcmp(strtrim(cellstr(data.M_.endo_names)), var_name), 1));
pct_dev = @(data, var_name, horizon) ((get_sim(data, var_name, horizon) - get_ss(data, var_name)) / get_ss(data, var_name)) * 100;
calc_cev = @(data_crdc, data_debt, var_name, horizon) (sum(beta.^(0:horizon-1) .* get_sim(data_crdc, var_name, horizon)) / sum(beta.^(0:horizon-1) .* get_sim(data_debt, var_name, horizon)) - 1) * 100;

% =========================================================================
% PART A: RUN STANDARD SCENARIOS (SUDDEN STOP)
% =========================================================================
scenarios = {
    'baseline_no_accel',               0,    0,    0,    0,     0,      0,         0;
    'baseline_accel',                  1,    0,    0,    0,     0,      0,         0;
    'tax_only_accel',                  1,    0,    0,    0,     1,      0,         1;
    'debt_only_accel',                 1,    0,    0,    0,     0,      1,         1;
    'baseline_accel_adaptation',       1,    1,    0,    0,     0,      0,         0;
    'debt_ss_tax_adj',                 0,    0,    0,    1,     1,      0,         1;
    'crdc_ss_tax_adj',                 0,    0,    1,    1,     1,      0,         1;
    'debt_ss_l_adj',                   0,    0,    0,    1,     1,      1,         0;
    'crdc_ss_l_adj',                   0,    0,    1,    1,     1,      1,         0;
};
shock_magnitude = 0.25;
for i = 1:size(scenarios, 1)
    file_suffix = scenarios{i, 1};
    fid = fopen('flags.mod', 'w');
    fprintf(fid, '@#define ACCEL_RECON  = %d\n', scenarios{i, 2});
    fprintf(fid, '@#define ADAPTATION   = %d\n', scenarios{i, 3});
    fprintf(fid, '@#define CRDC         = %d\n', scenarios{i, 4});
    fprintf(fid, '@#define FIX_R        = %d\n', scenarios{i, 5});
    fprintf(fid, '@#define FIX_B        = %d\n', scenarios{i, 6});
    fprintf(fid, '@#define FIX_TAU_C    = %d\n', scenarios{i, 7});
    fprintf(fid, '@#define FIX_L        = %d\n', scenarios{i, 8});
    fclose(fid);
    
    fid = fopen('shocks.mod', 'w');
    fprintf(fid, 'shocks;\n    var e_d;\n    periods 1;\n    values %f;\n', shock_magnitude);
    if scenarios{i, 4} == 1
        fprintf(fid, '    var e_crdc;\n    periods 1 2;\n    values 1 1;\n');
    end
    fprintf(fid, 'end;\n');
    fclose(fid);
    
    clear oo_ M_ options_
    dynare main.mod noclearall nostrict
    save(strcat('results_', file_suffix, '.mat'), 'oo_', 'M_');
end
disp('Standard scenarios finished.');

% =========================================================================
% FIGURE 1: SHORT-RUN SUDDEN STOP PLOT
% =========================================================================
horizon_sr = 10;
horizon_cev = 200; 
years_sr = 2015 + (1:horizon_sr) - 1;

d_ss_tax_debt = load('results_debt_ss_tax_adj.mat', 'oo_', 'M_');
d_ss_tax_crdc = load('results_crdc_ss_tax_adj.mat', 'oo_', 'M_');
d_ss_l_debt   = load('results_debt_ss_l_adj.mat', 'oo_', 'M_');
d_ss_l_crdc   = load('results_crdc_ss_l_adj.mat', 'oo_', 'M_');

figure('Name', 'Short-Run Sudden Stop (10-Year Horizon)', 'Position', [50, 50, 1800, 800]);

% Configuration array for Trajectories & Cumulative differences
sr_configs = {
    1, d_ss_tax_debt, d_ss_tax_crdc, 'C_r', 'Tax Adj: C_r', 'b-';
    2, d_ss_tax_debt, d_ss_tax_crdc, 'C_c', 'Tax Adj: C_c', 'r-';
    5, d_ss_l_debt,   d_ss_l_crdc,   'C_r', 'L Adj: C_r',   'b--';
    6, d_ss_l_debt,   d_ss_l_crdc,   'C_c', 'L Adj: C_c',   'r--'
};

cum_labels = cell(1, 4);

for k = 1:size(sr_configs, 1)
    sp_num  = sr_configs{k, 1};
    d_debt  = sr_configs{k, 2};
    d_crdc  = sr_configs{k, 3};
    v_name  = sr_configs{k, 4};
    t_pref  = sr_configs{k, 5};
    l_style = sr_configs{k, 6};

    % 1. Plot Trajectories (Cols 1 & 2)
    subplot(2, 4, sp_num); hold on;
    plot(years_sr, pct_dev(d_debt, v_name, horizon_sr), 'k-', 'LineWidth', 1.5);
    plot(years_sr, pct_dev(d_crdc, v_name, horizon_sr), 'b--', 'LineWidth', 1.5);
    
    md_diff = min(pct_dev(d_crdc, v_name, horizon_sr)) - min(pct_dev(d_debt, v_name, horizon_sr));
    cev_val = calc_cev(d_crdc, d_debt, v_name, horizon_cev);
    title(sprintf('%s (CEV: %.3f%%, \\DeltaMD: +%.2f%%)', t_pref, cev_val, md_diff));
    ylabel('% \Delta SS'); grid on; xlim([2015 2024]);
    if sp_num == 1
        legend('Debt', 'CRDC', 'Location', 'southeast');
    end

    % 2. Populate Combined Cumulative Plot (Col 4)
    subplot(2, 4, [4, 8]); hold on;
    cum_diff = cumsum(pct_dev(d_crdc, v_name, horizon_sr)) - cumsum(pct_dev(d_debt, v_name, horizon_sr));
    plot(years_sr, cum_diff, l_style, 'LineWidth', 2);
    cum_labels{k} = t_pref;
end

% 3. Plot Absolute Fiscal Mechanics (Col 3)
subplot(2, 4, 3); hold on;
plot(years_sr, get_sim(d_ss_tax_debt, 'T', horizon_sr), 'k-', 'LineWidth', 1.5);
plot(years_sr, get_sim(d_ss_tax_crdc, 'T', horizon_sr), 'b--', 'LineWidth', 1.5);
title('Tax Revenue (T) [Tax Adj]');
ylabel('Absolute Level'); grid on; xlim([2015 2024]);
legend('Debt', 'CRDC', 'Location', 'southeast');

subplot(2, 4, 7); hold on;
plot(years_sr, get_sim(d_ss_l_debt, 'L', horizon_sr), 'k-', 'LineWidth', 1.5);
plot(years_sr, get_sim(d_ss_l_crdc, 'L', horizon_sr), 'b--', 'LineWidth', 1.5);
title('Transfers (L) [L Adj]');
xlabel('Year'); ylabel('Absolute Level'); grid on; xlim([2015 2024]);
legend('Debt', 'CRDC', 'Location', 'southeast');

% 4. Finalize Combined Cumulative Plot
subplot(2, 4, [4, 8]); hold on;
yline(0, 'k--', 'LineWidth', 1);
title('Cumulative \Delta (CRDC - Debt)');
xlabel('Year'); ylabel('Cumulative % \Delta SS'); grid on; xlim([2015 2024]);
legend([cum_labels, {'Zero Baseline'}], 'Location', 'northeast');


% =========================================================================
% PART B: HIGH-SPEED GRID SEARCH FOR LONG-RUN ALLOCATIONS
% =========================================================================
disp('Starting Grid Search for omega_r...');
omega_r_grid = 1:1:30; 
sim_horizon = 200; 
plot_horizon = 40; 
discount_vec = beta.^(0:sim_horizon-1)';
grid_configs = {
    'debt_fix_tau', 0, 1, 0; 'crdc_fix_tau', 1, 1, 0;
    'debt_fix_l',   0, 0, 1; 'crdc_fix_l',   1, 0, 1;
};

res = struct();
for i = 1:size(grid_configs, 1)
    config_name = grid_configs{i, 1};
    fid = fopen('flags.mod', 'w');
    fprintf(fid, '@#define ACCEL_RECON  = 0\n@#define ADAPTATION   = 0\n');
    fprintf(fid, '@#define CRDC         = %d\n@#define FIX_R        = 0\n@#define FIX_B        = 0\n', grid_configs{i, 2});
    fprintf(fid, '@#define FIX_TAU_C    = %d\n@#define FIX_L        = %d\n', grid_configs{i, 3}, grid_configs{i, 4});
    fclose(fid);
    
    fid = fopen('shocks.mod', 'w');
    fprintf(fid, 'shocks;\n    var e_d;\n    periods 1;\n    values %f;\n', shock_magnitude);
    if grid_configs{i, 2} == 1
        fprintf(fid, '    var e_crdc;\n    periods 1 2;\n    values 1 1;\n');
    end
    fprintf(fid, 'end;\n');
    fclose(fid);
    
    clear oo_ M_ options_
    dynare main.mod noclearall nostrict
    options_.periods = sim_horizon;
    
    idx_Cc = find(strcmp(strtrim(cellstr(M_.endo_names)), 'C_c'));
    idx_Cr = find(strcmp(strtrim(cellstr(M_.endo_names)), 'C_r'));
    idx_Rb = find(strcmp(strtrim(cellstr(M_.endo_names)), 'R_b'));
    idx_B  = find(strcmp(strtrim(cellstr(M_.endo_names)), 'B'));
    
    res.(config_name).ss_Cc = oo_.steady_state(idx_Cc);
    res.(config_name).ss_Cr = oo_.steady_state(idx_Cr);
    res.(config_name).ss_B  = oo_.steady_state(idx_B);
    
    res.(config_name).Cc = zeros(length(omega_r_grid), sim_horizon);
    res.(config_name).Cr = zeros(length(omega_r_grid), sim_horizon);
    res.(config_name).Rb = zeros(length(omega_r_grid), sim_horizon);
    res.(config_name).B  = zeros(length(omega_r_grid), sim_horizon);
    
    for j = 1:length(omega_r_grid)
        M_.params(strcmp(strtrim(cellstr(M_.param_names)), 'omega_r')) = omega_r_grid(j);
        oo_ = perfect_foresight_setup(M_, options_, oo_);
        oo_ = perfect_foresight_solver(M_, options_, oo_);
        
        res.(config_name).Cc(j, :) = oo_.endo_simul(idx_Cc, 1:sim_horizon);
        res.(config_name).Cr(j, :) = oo_.endo_simul(idx_Cr, 1:sim_horizon);
        res.(config_name).Rb(j, :) = oo_.endo_simul(idx_Rb, 1:sim_horizon);
        res.(config_name).B(j, :)  = oo_.endo_simul(idx_B, 1:sim_horizon);
    end
end
disp('Grid search complete.');

% --- Calculate Welfare (CEV) and Peak Spreads ---
cev_fix_tau_Cc = zeros(length(omega_r_grid), 1);
cev_fix_l_Cc   = zeros(length(omega_r_grid), 1);
cev_fix_tau_Cr = zeros(length(omega_r_grid), 1);
cev_fix_l_Cr   = zeros(length(omega_r_grid), 1);
peak_spread_tau = zeros(length(omega_r_grid), 1);
peak_spread_l   = zeros(length(omega_r_grid), 1);

for j = 1:length(omega_r_grid)
    % C_c Welfare
    pv_debt_tau_Cc = sum(discount_vec .* res.debt_fix_tau.Cc(j, :)');
    pv_crdc_tau_Cc = sum(discount_vec .* res.crdc_fix_tau.Cc(j, :)');
    cev_fix_tau_Cc(j) = ((pv_crdc_tau_Cc / pv_debt_tau_Cc) - 1) * 100;
    
    pv_debt_l_Cc = sum(discount_vec .* res.debt_fix_l.Cc(j, :)');
    pv_crdc_l_Cc = sum(discount_vec .* res.crdc_fix_l.Cc(j, :)');
    cev_fix_l_Cc(j) = ((pv_crdc_l_Cc / pv_debt_l_Cc) - 1) * 100;

    % C_r Welfare
    pv_debt_tau_Cr = sum(discount_vec .* res.debt_fix_tau.Cr(j, :)');
    pv_crdc_tau_Cr = sum(discount_vec .* res.crdc_fix_tau.Cr(j, :)');
    cev_fix_tau_Cr(j) = ((pv_crdc_tau_Cr / pv_debt_tau_Cr) - 1) * 100;
    
    pv_debt_l_Cr = sum(discount_vec .* res.debt_fix_l.Cr(j, :)');
    pv_crdc_l_Cr = sum(discount_vec .* res.crdc_fix_l.Cr(j, :)');
    cev_fix_l_Cr(j) = ((pv_crdc_l_Cr / pv_debt_l_Cr) - 1) * 100;
    
    % Peak Spreads
    peak_spread_tau(j) = (max(res.debt_fix_tau.Rb(j, :)) - R_star) * 10000;
    peak_spread_l(j)   = (max(res.debt_fix_l.Rb(j, :)) - R_star) * 10000;
end

% =========================================================================
% FIGURE 2: LONG-RUN GRID SEARCH PLOT (2x4)
% =========================================================================
years = 2015 + (1:plot_horizon) - 1;
colors = {'g-', 'b-', 'm-'};
target_omegas = [10, 20, 30]; 
plot_idx = zeros(1, 3);
for k = 1:3
    plot_idx(k) = find(omega_r_grid == target_omegas(k));
end

figure('Name', 'Long-Run Welfare & IRF Differentials', 'Position', [50, 100, 1800, 800]);

% 1. Combined CEV Plot (spanning subplots 1 & 5 down the left column)
subplot(2, 4, [1, 5]); hold on;
plot(peak_spread_tau, cev_fix_tau_Cc, 'b-', 'LineWidth', 2);
plot(peak_spread_l, cev_fix_l_Cc, 'r-', 'LineWidth', 2);
plot(peak_spread_tau, cev_fix_tau_Cr, 'b--', 'LineWidth', 2);
plot(peak_spread_l, cev_fix_l_Cr, 'r--', 'LineWidth', 2);
title('CEV by Fiscal Rule & Household');
xlabel('Peak Sovereign Spread (bps)'); ylabel('CEV (%)'); grid on;
legend('C_c (Fix Tau)', 'C_c (Fix L)', 'C_r (Fix Tau)', 'C_r (Fix L)', 'Location', 'southeast');

% Configuration array for the percentage spreads
lr_configs = {
    2, res.crdc_fix_tau.Cc, res.debt_fix_tau.Cc, 'C_c', 'Fix Tau', peak_spread_tau, res.debt_fix_tau.ss_Cc;
    3, res.crdc_fix_l.Cc,   res.debt_fix_l.Cc,   'C_c', 'Fix L',   peak_spread_l,   res.debt_fix_l.ss_Cc;
    4, res.crdc_fix_tau.B,  res.debt_fix_tau.B,  'B',   'Fix Tau', peak_spread_tau, res.debt_fix_tau.ss_B;
    6, res.crdc_fix_tau.Cr, res.debt_fix_tau.Cr, 'C_r', 'Fix Tau', peak_spread_tau, res.debt_fix_tau.ss_Cr;
    7, res.crdc_fix_l.Cr,   res.debt_fix_l.Cr,   'C_r', 'Fix L',   peak_spread_l,   res.debt_fix_l.ss_Cr;
    8, res.crdc_fix_l.B,    res.debt_fix_l.B,    'B',   'Fix L',   peak_spread_l,   res.debt_fix_l.ss_B
};

for k = 1:size(lr_configs, 1)
    sp_num   = lr_configs{k, 1};
    d_crdc   = lr_configs{k, 2};
    d_debt   = lr_configs{k, 3};
    v_name   = lr_configs{k, 4};
    rule_name = lr_configs{k, 5};
    p_spread = lr_configs{k, 6};
    ss_val   = lr_configs{k, 7};

    subplot(2, 4, sp_num); hold on;
    labels = cell(1, 3);
    for m = 1:3
        idx = plot_idx(m);
        diff_pct = (d_crdc(idx, 1:plot_horizon) - d_debt(idx, 1:plot_horizon)) / ss_val * 100;
        plot(years, diff_pct, colors{m}, 'LineWidth', 1.5);
        labels{m} = sprintf('\\omega_r = %d (%d bps)', target_omegas(m), round(p_spread(idx)));
    end
    title(sprintf('%s %% Spread (CRDC - Debt) [%s]', v_name, rule_name));
    xlabel('Year'); ylabel(sprintf('%% \\Delta %s', v_name)); grid on; xlim([2015 2049]);
    legend(labels, 'Location', 'southeast');
end