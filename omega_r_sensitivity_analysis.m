% =========================================================================
% SENSITIVITY ANALYSIS: VARYING OMEGA_R (RISK PREMIUM SPIKE)
% =========================================================================
omega_vals = linspace(0, 10, 20);
time_horizon = 40;

% Preallocate arrays
max_Rb_d = zeros(size(omega_vals)); min_Cc_d = max_Rb_d; min_Cr_d = max_Rb_d;
max_Rb_c = zeros(size(omega_vals)); min_Cc_c = max_Rb_c; min_Cr_c = max_Rb_c;

% --- 1. RUN STANDARD DEBT SCENARIO ---
% ... [setup code] ...
dynare main.mod noclearall nostrict

idx_Rb = find(strcmp(cellstr(M_.endo_names), 'R_b'));
idx_Cc = find(strcmp(cellstr(M_.endo_names), 'C_c'));
idx_Cr = find(strcmp(cellstr(M_.endo_names), 'C_r'));

for i = 1:length(omega_vals)
    set_param_value('omega_r', omega_vals(i));
    
    % Explicitly pass and return the Dynare structures
    oo_ = perfect_foresight_setup(M_, options_, oo_); 
    oo_ = perfect_foresight_solver(M_, options_, oo_);
    
    max_Rb_d(i) = max(oo_.endo_simul(idx_Rb, 1:time_horizon)) * 100;
    min_Cc_d(i) = min((oo_.endo_simul(idx_Cc, 1:time_horizon) - oo_.steady_state(idx_Cc)) / oo_.steady_state(idx_Cc)) * 100;
    min_Cr_d(i) = min((oo_.endo_simul(idx_Cr, 1:time_horizon) - oo_.steady_state(idx_Cr)) / oo_.steady_state(idx_Cr)) * 100;
end

% --- 2. RUN CRDC SCENARIO ---
% ... [setup code] ...
dynare main.mod noclearall nostrict

for i = 1:length(omega_vals)
    set_param_value('omega_r', omega_vals(i));
    
    % Explicitly pass and return the Dynare structures
    oo_ = perfect_foresight_setup(M_, options_, oo_); 
    oo_ = perfect_foresight_solver(M_, options_, oo_);
    
    max_Rb_c(i) = max(oo_.endo_simul(idx_Rb, 1:time_horizon)) * 100;
    min_Cc_c(i) = min((oo_.endo_simul(idx_Cc, 1:time_horizon) - oo_.steady_state(idx_Cc)) / oo_.steady_state(idx_Cc)) * 100;
    min_Cr_c(i) = min((oo_.endo_simul(idx_Cr, 1:time_horizon) - oo_.steady_state(idx_Cr)) / oo_.steady_state(idx_Cr)) * 100;
end

% --- 3. PLOT RESULTS ---
figure('Name', 'Household Damage vs Risk Premium Spike', 'Position', [100, 100, 1000, 500]);

% Constrained Households (Hand-to-Mouth)
subplot(1,2,1); hold on;
plot(max_Rb_d, min_Cc_d, 'k-o', 'LineWidth', 1.5, 'MarkerSize', 4);
plot(max_Rb_c, min_Cc_c, 'b--s', 'LineWidth', 1.5, 'MarkerSize', 4);
xlabel('Maximum Risk Premium Achieved (%)');
ylabel('Max Consumption Drop (% \Delta SS)');
title('Damage to Constrained Households');
legend('Standard Debt', 'CRDC', 'Location', 'southwest');
grid on;

% Ricardian Households (Capital Owners)
subplot(1,2,2); hold on;
plot(max_Rb_d, min_Cr_d, 'k-o', 'LineWidth', 1.5, 'MarkerSize', 4);
plot(max_Rb_c, min_Cr_c, 'b--s', 'LineWidth', 1.5, 'MarkerSize', 4);
xlabel('Maximum Risk Premium Achieved (%)');
ylabel('Max Consumption Drop (% \Delta SS)');
title('Damage to Ricardian Households');
legend('Standard Debt', 'CRDC', 'Location', 'southwest');
grid on;