% =========================================================================
% WELFARE ANALYSIS: CUMULATIVE CONSUMPTION RESCUED BY CRDC OVER TIME
% =========================================================================
% Select three representative risk premium scalars for comparison
omega_vals = [0.5, 2.0, 5.0]; 
time_horizon = 40;
years = 2010 + (1:time_horizon) - 1;

% Preallocate storage for cumulative differences
cum_saved_Cc = zeros(length(omega_vals), time_horizon);
cum_saved_Cr = zeros(length(omega_vals), time_horizon);

for i = 1:length(omega_vals)
    current_omega = omega_vals(i);
    
    % --- 1. RUN STANDARD DEBT SCENARIO ---
    fid = fopen('shocks.mod', 'w');
    fprintf(fid, 'shocks;\n    var e_d;\n    periods 1;\n    values 0.25;\nend;\n');
    fclose(fid);

    fid = fopen('flags.mod', 'w');
    fprintf(fid, '@#define ACCEL_RECON=1\n@#define DEBT_ONLY=0\n@#define TAX_ONLY=0\n@#define CRDC=0\n@#define ADAPTATION=1\n@#define FISCAL_LIMIT=0\n@#define HIGH_RISK=0\n');
    fclose(fid);

    dynare main.mod noclearall nostrict
    
    idx_Cc = find(strcmp(cellstr(M_.endo_names), 'C_c'));
    idx_Cr = find(strcmp(cellstr(M_.endo_names), 'C_r'));
    
    set_param_value('omega_r', current_omega);
    oo_ = perfect_foresight_setup(M_, options_, oo_); 
    oo_ = perfect_foresight_solver(M_, options_, oo_);
    
    Cc_debt = oo_.endo_simul(idx_Cc, 1:time_horizon);
    Cr_debt = oo_.endo_simul(idx_Cr, 1:time_horizon);
    Cc_ss   = oo_.steady_state(idx_Cc);
    Cr_ss   = oo_.steady_state(idx_Cr);
    
    % --- 2. RUN CRDC SCENARIO ---
    fid = fopen('shocks.mod', 'w');
    fprintf(fid, 'shocks;\n    var e_d;\n    periods 1;\n    values 0.25;\n    var e_crdc;\n    periods 2 3;\n    values 1 1;\nend;\n');
    fclose(fid);

    fid = fopen('flags.mod', 'w');
    fprintf(fid, '@#define ACCEL_RECON=1\n@#define DEBT_ONLY=0\n@#define TAX_ONLY=0\n@#define CRDC=1\n@#define ADAPTATION=1\n@#define FISCAL_LIMIT=0\n@#define HIGH_RISK=0\n');
    fclose(fid);

    dynare main.mod noclearall nostrict
    
    set_param_value('omega_r', current_omega);
    oo_ = perfect_foresight_setup(M_, options_, oo_); 
    oo_ = perfect_foresight_solver(M_, options_, oo_);
    
    Cc_crdc = oo_.endo_simul(idx_Cc, 1:time_horizon);
    Cr_crdc = oo_.endo_simul(idx_Cr, 1:time_horizon);
    
    % --- 3. CALCULATE CUMULATIVE RESCUED CONSUMPTION ---
    % Sum of (CRDC - Debt) up to year t, scaled by steady state
    cum_saved_Cc(i, :) = cumsum(Cc_crdc - Cc_debt) / Cc_ss * 100;
    cum_saved_Cr(i, :) = cumsum(Cr_crdc - Cr_debt) / Cr_ss * 100;
end

% --- 4. PLOT RESULTS ---
figure('Name', 'Cumulative Consumption Rescued by CRDC', 'Position', [100, 100, 1100, 500]);

line_styles = {'-', '--', '-.'};
colors = {'[0 0.4470 0.7410]', '[0.8500 0.3250 0.0980]', '[0.9290 0.6940 0.1250]'};
labels = {'Low Risk (\omega_r = 0.5)', 'Base Risk (\omega_r = 2.0)', 'High Risk (\omega_r = 5.0)'};

% Constrained Households (Hand-to-Mouth)
subplot(1, 2, 1); hold on;
for i = 1:length(omega_vals)
    plot(years, cum_saved_Cc(i, :), 'LineStyle', line_styles{i}, 'Color', eval(colors{i}), 'LineWidth', 2);
end
xlabel('Year');
ylabel('Cumulative Gain (% of SS Cons.)');
title('Constrained Households (C_c)');
legend(labels, 'Location', 'northwest');
grid on; xlim([2010 2049]);

% Ricardian Households (Capital Owners)
subplot(1, 2, 2); hold on;
for i = 1:length(omega_vals)
    plot(years, cum_saved_Cr(i, :), 'LineStyle', line_styles{i}, 'Color', eval(colors{i}), 'LineWidth', 2);
end
xlabel('Year');
ylabel('Cumulative Gain (% of SS Cons.)');
title('Ricardian Households (C_r)');
legend(labels, 'Location', 'northwest');
grid on; xlim([2010 2049]);