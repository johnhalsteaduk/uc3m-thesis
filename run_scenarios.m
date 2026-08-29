% =========================================================================
% Master Scenario Runner for Dynare
% =========================================================================
scenarios = {
    % Name                                          ACCEL  DEBT_ONLY  TAX_ONLY  CRDC  ADAPT  RESIL  REPEAT_SHOCKS
    % --- Part 1: Baseline & Replication (Single Shock at t=5) ---
    'baseline_no_accel',                              0,       0,         0,      0,    0,     0,        0;
    'baseline_accel',                                 1,       0,         0,      0,    0,     0,        0;
    'tax_only_accel',                                 1,       0,         1,      0,    0,     0,        0;
    'debt_only_accel',                                1,       1,         0,      0,    0,     0,        0;
    'baseline_accel_adaptation',                      1,       0,         0,      0,    1,     0,        0;
    
    % --- Part 2: CRDC Resilience Comparison (Repeating Shocks, No Accel) ---
    'debt_adaptation',                                0,       0,         0,      0,    1,     0,        1;
    'debt_resilience',                                0,       0,         0,      0,    1,     1,        1;    
    'crdc_adaptation',                                0,       0,         0,      1,    1,     0,        1;
    'crdc_resilience',                                0,       0,         0,      1,    1,     1,        1;
};

for i = 1:size(scenarios, 1)
    file_suffix = scenarios{i, 1};
    
    % Write macro-processor flags to flags.mod
    fid = fopen('flags.mod', 'w');
    fprintf(fid, '@#define ACCEL_RECON  = %d\n', scenarios{i, 2});
    fprintf(fid, '@#define DEBT_ONLY    = %d\n', scenarios{i, 3});
    fprintf(fid, '@#define TAX_ONLY     = %d\n', scenarios{i, 4});
    fprintf(fid, '@#define CRDC         = %d\n', scenarios{i, 5});
    fprintf(fid, '@#define ADAPTATION   = %d\n', scenarios{i, 6});
    fprintf(fid, '@#define RESILIENCE   = %d\n', scenarios{i, 7});
    fclose(fid);
    
    % --- Dynamic Shock Generator ---
    shock_magnitude = 0.25;
    shock_freq = 20;   % Years between shocks
    sim_periods = 200; % Must match your perfect_foresight_setup(periods=200)
    
    % Set the first shock to occur in period 5 (representing 2015)
    first_shock_year = 5; 
    
    if scenarios{i, 8} == 1
        % Repeat shocks every X years, leaving a buffer at the end 
        num_shocks = floor((sim_periods - first_shock_year - 10) / shock_freq) + 1; 
    else
        % Part 1: Single shock
        num_shocks = 1;
    end
    
    % The CRDC profile: [Grace Year 1, Grace Year 2, Repay 1, Repay 2, Repay 3, Repay 4]
    crdc_profile = [1, 1, 0.8, 0.6, 0.4, 0.2]; 
    
    ed_periods = [];
    ed_values  = [];
    crdc_periods = [];
    crdc_values  = [];
    
    for s = 1:num_shocks
        base_year = first_shock_year + (s-1)*shock_freq;
        
        % Natural Disaster Shock
        ed_periods = [ed_periods, base_year];
        ed_values  = [ed_values, shock_magnitude];
        
        % CRDC Liquidity Injection (starts the year after the shock)
        crdc_periods = [crdc_periods, base_year + (1:length(crdc_profile))];
        crdc_values  = [crdc_values, crdc_profile];
    end
    
    % Write to shocks.mod
    fid = fopen('shocks.mod', 'w');
    fprintf(fid, 'shocks;\n');
    fprintf(fid, '    var e_d;\n');
    fprintf(fid, '    periods %s;\n', num2str(ed_periods));
    fprintf(fid, '    values %s;\n', num2str(ed_values));
    
    if scenarios{i, 5} == 1 || scenarios{i, 7} == 1 % If CRDC OR RESILIENCE is active
        fprintf(fid, '    var e_crdc;\n');
        fprintf(fid, '    periods %s;\n', num2str(crdc_periods));
        fprintf(fid, '    values %s;\n', num2str(crdc_values));
    end
    fprintf(fid, 'end;\n');
    fclose(fid);
    
    % Run Dynare and save results
    clear oo_ M_ options_
    dynare main.mod noclearall nostrict
    save(strcat('results_', file_suffix, '.mat'), 'oo_', 'M_');
end
disp('All scenarios finished computing successfully.');