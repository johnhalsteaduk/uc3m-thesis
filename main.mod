@#define DEBT = 0
@#define CRDC = 0
@#define FUND = 0

@#include "parameters.mod"

model;
    @#include "model_core.mod"
end;

% call the external steady state file
steady;

% ensure equations equal 0 at the calculated steady state
resid; 

shocks;
    var e_d;
    periods 1;
    values 0.25;
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;

filenames = ["results_debt.mat", "results_crdc.mat", "results_fund.mat", "results_baseline.mat"];

% 1. Determine active scenario filename and save (MATLAB is 1-indexed)
@#if DEBT == 1
    current_file = filenames(1);
@#elseif CRDC == 1
    current_file = filenames(2);
@#elseif FUND == 1
    current_file = filenames(3);
@#else
    current_file = filenames(4);
@#endif

save(current_file, 'oo_');

% Adjust these lists with any specific variables you want for each scenario
var_lists = {
    {'Z', 'K', 'D', 'I_zi', 'I_za', 'S', 'R', 'tau_c', 'B'}, ...          % DEBT vars
    {'Z', 'K', 'D', 'I_zi', 'I_za', 'S', 'R', 'tau_c', 'B', 'CRDC'}, ...  % CRDC vars
    {'Z', 'K', 'D', 'I_zi', 'I_za', 'S', 'R', 'tau_c', 'F'}, ...          % FUND vars
    {'Z', 'K', 'D', 'I_k', 'I_zi', 'I_za', 'S', 'R', 'tau_c'} ...         % BASELINE vars (Comma added)
};
scenario_dict = dictionary(filenames, var_lists);

% Master list for variables that should be plotted in levels
levels_vars = {'S', 'R', 'tau_c'};

% Load, extract, and plot
load(current_file);
vars_to_plot = scenario_dict(current_file);
vars_to_plot = vars_to_plot{1}; % Unpack the cell array from the dictionary

num_vars = length(vars_to_plot);
figure;

for i = 1:num_vars
    var_name = vars_to_plot{i};
    idx = find(strcmp(cellstr(M_.endo_names), var_name));
    
    simul_data = oo_.endo_simul(idx, :);
    ss_data = oo_.steady_state(idx);
    
    % Check if the variable should be plotted in levels
    if ismember(var_name, levels_vars)
        plot_data = simul_data;
    elseif ss_data == 0
        plot_data = simul_data - ss_data; % Absolute deviation
    else
        % Element-wise division added below (./)
        plot_data = ((simul_data - ss_data) ./ ss_data) * 100; % Percentage deviation
    end
    
    subplot(ceil(num_vars/3), 3, i);
    plot(1:40, plot_data(1:40), 'k-', 'LineWidth', 1.5);
    
    % Add reference line: steady state for levels, zero for deviations
    if ismember(var_name, levels_vars)
        yline(ss_data, 'r-'); 
    else
        yline(0, 'r-'); 
    end
    
    title(var_name, 'Interpreter', 'none');
    xlim([1 40]);
end