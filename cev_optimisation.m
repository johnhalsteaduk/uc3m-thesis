% =========================================================================
% CEV OPTIMIZATION: GRID SEARCH FOR GAMMA AND THETA
% =========================================================================
global M_ oo_ options_

% 1. Define the Grid Bounds
gamma_grid = 0:0.1:1;     % Proportion of relief allocated to policy
theta_grid = 0.1:0.1:1;   % Payout rate from the relief fund
time_horizon = 100;

% Preallocate results matrix
cev_surface = NaN(length(gamma_grid), length(theta_grid));

% Locate parameter indices in Dynare memory
gamma_idx = strmatch('gamma', M_.param_names, 'exact');
theta_idx = strmatch('theta', M_.param_names, 'exact');
beta = M_.params(strmatch('beta', M_.param_names, 'exact'));
lambda_c = M_.params(strmatch('lambda_c', M_.param_names, 'exact'));

% Baseline Utility (Assumes you have already run the baseline scenario)
% U_base_r and U_base_c must be defined in your workspace from the baseline run
% U_base_r = sum((beta.^(0:time_horizon-1)) .* log(C_r_baseline_path));
% U_base_c = sum((beta.^(0:time_horizon-1)) .* log(C_c_baseline_path));

% 2. Execute Grid Search
for i = 1:length(gamma_grid)
    for j = 1:length(theta_grid)
        
        % Update parameters
        M_.params(gamma_idx) = gamma_grid(i);
        M_.params(theta_idx) = theta_grid(j);
        
        % Suppress Dynare output 
        options_.noprint = 1;
        options_.verbosity = 0;
        
        % Run deterministic solver setup and computation
        oo_ = perfect_foresight_setup(M_, options_, oo_);
        oo_ = perfect_foresight_solver(M_, options_, oo_);

        % Check if model solved successfully (status == 1 means success)
        if oo_.deterministic_simulation.status == 1 
            % Extract paths
            C_r_path = oo_.endo_simul(strmatch('C_r', M_.endo_names, 'exact'), 1:time_horizon);
            C_c_path = oo_.endo_simul(strmatch('C_c', M_.endo_names, 'exact'), 1:time_horizon);
            
            % Compute utilities
            U_alt_r = sum((beta.^(0:time_horizon-1)) .* log(C_r_path));
            U_alt_c = sum((beta.^(0:time_horizon-1)) .* log(C_c_path));
            
            % Compute CEV
            cev_r = (exp((1 - beta) * (U_alt_r - U_base_r)) - 1) * 100;
            cev_c = (exp((1 - beta) * (U_alt_c - U_base_c)) - 1) * 100;
            
            % Store Total Population-Weighted CEV
            cev_surface(i, j) = lambda_c * cev_c + (1 - lambda_c) * cev_r;
        end
    end
end

% 3. Find and Plot the Optimum
[max_cev, linear_idx] = max(cev_surface(:));
[best_i, best_j] = ind2sub(size(cev_surface), linear_idx);

fprintf('Optimal Gamma: %.2f\n', gamma_grid(best_i));
fprintf('Optimal Theta: %.2f\n', theta_grid(best_j));
fprintf('Maximum Total CEV: %.4f%%\n', max_cev);

figure('Name', 'CEV Optimization Surface');
surf(theta_grid, gamma_grid, cev_surface);
xlabel('Theta (Payout Rate)');
ylabel('Gamma (Allocation Proportion)');
zlabel('Total CEV (%)');
title('Welfare Optimization Surface');