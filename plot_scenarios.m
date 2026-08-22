% Define the 5 figure configurations
% Format: {Files to load}, {Legend labels}, {Line colors}, 'Window Title'
configs = {
    % % Figure 1: Baseline
    % {'results_baseline_no_accel.mat', 'results_baseline_accel.mat'}, ...
    % {'Baseline Standard', 'Baseline Accelerated'}, {'b--', 'r-'}, '1. Baseline Comparison';
    % 
    % % Figure 2: Debt
    % {'results_debt_no_accel.mat', 'results_debt_accel.mat'}, ...
    % {'Debt Standard', 'Debt Accelerated'}, {'b--', 'r-'}, '2. Debt Comparison';
    % 
    % % Figure 3: CRDC
    % {'results_crdc_no_accel.mat', 'results_crdc_accel.mat'}, ...
    % {'CRDC Standard', 'CRDC Accelerated'}, {'b--', 'r-'}, '3. CRDC Comparison';
    % 
    % % Figure 4: Fund
    % {'results_fund_no_accel.mat', 'results_fund_accel.mat'}, ...
    % {'Fund Standard', 'Fund Accelerated'}, {'b--', 'r-'}, '4. Fund Comparison';
    
    % Figure 5: All Non-Accelerated
    {'results_baseline_no_accel.mat', 'results_debt_no_accel.mat', 'results_crdc_no_accel.mat', 'results_fund_no_accel.mat'}, ...
    {'Tax-Financed', 'Debt', 'CRDC', 'Fund'}, {'k-', 'b--', 'r-.', 'm:'}, '5. All Non-Accelerated Policies';
};

vars_to_plot = {'C', 'Z', 'K', 'D', 'I_k', 'I_zi', 'I_za', 'S', 'R', 'tau_c'};
levels_vars = {'S', 'R', 'tau_c'};
num_vars = length(vars_to_plot);

% Loop through each of the 5 figure configurations
for c = 1:size(configs, 1)
    files_to_compare = configs{c, 1};
    labels = configs{c, 2};
    colors = configs{c, 3};
    fig_title = configs{c, 4};
    
    figure('Name', fig_title, 'Position', [100+(c*20), 100+(c*20), 1000, 600]);
    
    for i = 1:num_vars
        var_name = vars_to_plot{i};
        subplot(ceil(num_vars/3), 3, i);
        hold on;
        
        for j = 1:length(files_to_compare)
            if exist(files_to_compare{j}, 'file')
                data = load(files_to_compare{j}, 'oo_', 'M_');
                idx = find(strcmp(cellstr(data.M_.endo_names), var_name));
                
                if ~isempty(idx)
                    sim_data = data.oo_.endo_simul(idx, :);
                    ss_data = data.oo_.steady_state(idx);
                    
                    if ismember(var_name, levels_vars)
                        plot_data = sim_data;
                    elseif ss_data == 0
                        plot_data = sim_data - ss_data; 
                    else
                        plot_data = ((sim_data - ss_data) ./ ss_data) * 100; 
                    end
                    
                    plot(1:40, plot_data(1:40), colors{j}, 'LineWidth', 1.5);
                    
                    % Reference line (draw only once per subplot)
                    if j == 1 
                        if ismember(var_name, levels_vars)
                            yline(ss_data, 'k:'); 
                        else
                            yline(0, 'k:'); 
                        end
                    end
                end
            else
                fprintf('Warning: File %s not found. Skipping in plot.\n', files_to_compare{j});
            end
        end
        
        hold off;
        title(var_name, 'Interpreter', 'none');
        xlim([1 40]);
        if i == 1
            legend(labels, 'Location', 'best', 'FontSize', 8);
        end
    end
end