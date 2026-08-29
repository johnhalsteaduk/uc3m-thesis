% Script to calculate the maximum raw differences across 4 scenario combinations

% Load datasets
d_dna = load('results_debt_no_austerity.mat', 'oo_', 'M_');
d_da  = load('results_debt_austerity.mat', 'oo_', 'M_');
d_cna = load('results_crdc_no_austerity.mat', 'oo_', 'M_');
d_ca  = load('results_crdc_austerity.mat', 'oo_', 'M_');

names = strtrim(cellstr(d_da.M_.endo_names));
time_horizon = 25;

% List of all variables to check
var_list = {'C', 'I_k', 'K', 'N', 'R', 'W', 'Y', 'D', 'Z', 'Z_i', 'Z_a', 'I_zi', 'I_za', 'S', 'T', 'tau_c', 'B', 'C_r', 'C_c', 'R_b'};

fprintf('\n=== MAX ABSOLUTE DIFFERENCES ACROSS SCENARIOS ===\n');
fprintf('%-8s | %-16s | %-16s | %-16s | %-16s\n', 'Variable', 'Debt: NoAus-Aus', 'NoAus: Debt-CRDC', 'CRDC: NoAus-Aus', 'Aus: Debt-CRDC');
fprintf([repmat('-', 1, 85) '\n']);

for i = 1:length(var_list)
    var = var_list{i};
    idx = strcmp(names, var);
    
    if any(idx)
        % Extract simulations
        sim_dna = d_dna.oo_.endo_simul(idx, 1:time_horizon);
        sim_da  = d_da.oo_.endo_simul(idx, 1:time_horizon);
        sim_cna = d_cna.oo_.endo_simul(idx, 1:time_horizon);
        sim_ca  = d_ca.oo_.endo_simul(idx, 1:time_horizon);
        
        % 1. debt_no_austerity vs debt_austerity
        diff_1 = max(abs(sim_dna - sim_da));
        % 2. debt_no_austerity vs crdc_no_austerity
        diff_2 = max(abs(sim_dna - sim_cna));
        % 3. crdc_no_austerity vs crdc_austerity
        diff_3 = max(abs(sim_cna - sim_ca));
        % 4. debt_austerity vs crdc_austerity
        diff_4 = max(abs(sim_da - sim_ca));
        
        fprintf('%-8s | %-16.6e | %-16.6e | %-16.6e | %-16.6e\n', var, diff_1, diff_2, diff_3, diff_4);
    else
        fprintf('%-8s | NOT FOUND IN MODEL\n', var);
    end
end
fprintf([repmat('=', 1, 85) '\n']);