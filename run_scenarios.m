% =========================================================================
% Master Scenario Runner for Dynare
% =========================================================================
scenarios = {
    % Name                           ACCEL  DEBT_ONLY  TAX_ONLY  CRDC  ADAPT  HIGH_RISK
    % --- Part 1: Baseline & Replication ---
    'baseline_no_accel',               0,       0,         0,      0,    0,      0;
    'baseline_accel',                  1,       0,         0,      0,    0,      0;
    'tax_only_accel',                  1,       0,         1,      0,    0,      0;
    'debt_only_accel',                 1,       1,         0,      0,    0,      0;
    'baseline_accel_adaptation',       1,       0,         0,      0,    1,      0;
    
    % --- Part 2: CRDC Friction Comparisons ---
    % 1. Normal Market Conditions (Standard omega_r)
    'debt_normal',                     1,       0,         0,      0,    0,      0;
    'crdc_normal',                     1,       0,         0,      1,    0,      0;
    
    % 2. Market Stress (High omega_r)
    'debt_high_risk',                  1,       0,         0,      0,    0,      1;
    'crdc_high_risk',                  1,       0,         0,      1,    0,      1;
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
    fprintf(fid, '@#define HIGH_RISK    = %d\n', scenarios{i, 7});
    fclose(fid);
    
    % --- Dynamic Shock Generator ---
    shock_magnitude = 0.25;
    
    % The CRDC profile: [Year 1 Grace, Year 2 Grace]
    crdc_profile = [1, 1]; 
    
    % Natural Disaster Shock (applied in period 1)
    ed_periods = 1;
    ed_values  = shock_magnitude;
    
    % CRDC Liquidity Injection (starts the year after the shock)
    crdc_periods = (1:length(crdc_profile));
    crdc_values  = crdc_profile;
    
    % Write to shocks.mod
    fid = fopen('shocks.mod', 'w');
    fprintf(fid, 'shocks;\n');
    fprintf(fid, '    var e_d;\n');
    fprintf(fid, '    periods %d;\n', ed_periods);
    fprintf(fid, '    values %f;\n', ed_values);
    
    if scenarios{i, 5} == 1 % If CRDC is active
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