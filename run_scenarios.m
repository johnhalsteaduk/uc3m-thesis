% =========================================================================
% Master Scenario Runner for Dynare
% =========================================================================
scenarios = {
    % Name                           ACCEL ADAPT CRDC  HIGH_RISK  FIX_R  FIX_B  FIX_TAU_C  FIX_L
    % --- Part 1: Baseline & Replication ---
    'baseline_no_accel',               0,    0,    0,       0,         0,     0,      0,         0;
    'baseline_accel',                  1,    0,    0,       0,         0,     0,      0,         0;
    'tax_only_accel',                  1,    0,    0,       0,         0,     1,      0,         1;
    'debt_only_accel',                 1,    0,    0,       0,         0,     0,      1,         1;
    'baseline_accel_adaptation',       1,    1,    0,       0,         0,     0,      0,         0;

    % --- Part 2: Short Run Sudden Stop (Credit Freeze) ---
    'debt_ss_tax_adj',                 0,    0,    0,       0,         1,     1,      0,         1;
    'crdc_ss_tax_adj',                 0,    0,    1,       0,         1,     1,      0,         1;
    'debt_ss_l_adj',                   0,    0,    0,       0,         1,     1,      1,         0;
    'crdc_ss_l_adj',                   0,    0,    1,       0,         1,     1,      1,         0;

    % --- Part 3: Long Run Normal Borrowing, Normal Risk ---
    'debt_norm_fix_tau',               0,    0,    0,       0,         0,     0,      1,         0;
    'debt_norm_fix_l',                 0,    0,    0,       0,         0,     0,      0,         1;
    'crdc_norm_fix_tau',               0,    0,    1,       0,         0,     0,      1,         0;
    'crdc_norm_fix_l',                 0,    0,    1,       0,         0,     0,      0,         1;

    % --- Part 4: Long Run Normal Borrowing, High Risk ---
    'debt_hr_fix_tau',                 0,    0,    0,       1,         0,     0,      1,         0;
    'debt_hr_fix_l',                   0,    0,    0,       1,         0,     0,      0,         1;
    'crdc_hr_fix_tau',                 0,    0,    1,       1,         0,     0,      1,         0;
    'crdc_hr_fix_l',                   0,    0,    1,       1,         0,     0,      0,         1;
};

for i = 1:size(scenarios, 1)
    file_suffix = scenarios{i, 1};
    
    % Write macro-processor flags to flags.mod
    fid = fopen('flags.mod', 'w');
    fprintf(fid, '@#define ACCEL_RECON  = %d\n', scenarios{i, 2});
    fprintf(fid, '@#define ADAPTATION   = %d\n', scenarios{i, 3});
    fprintf(fid, '@#define CRDC         = %d\n', scenarios{i, 4});
    fprintf(fid, '@#define HIGH_RISK    = %d\n', scenarios{i, 5});
    fprintf(fid, '@#define FIX_R        = %d\n', scenarios{i, 6});
    fprintf(fid, '@#define FIX_B        = %d\n', scenarios{i, 7});
    fprintf(fid, '@#define FIX_TAU_C    = %d\n', scenarios{i, 8});
    fprintf(fid, '@#define FIX_L        = %d\n', scenarios{i, 9});
    fclose(fid);
    
    % --- Dynamic Shock Generator ---
    shock_magnitude = 0.25;
    ed_periods = 1;
    ed_values  = shock_magnitude;
    
    crdc_periods = [1, 2]; 
    crdc_values  = [1, 1]; 
    
    % Write to shocks.mod
    fid = fopen('shocks.mod', 'w');
    fprintf(fid, 'shocks;\n');
    fprintf(fid, '    var e_d;\n');
    fprintf(fid, '    periods %d;\n', ed_periods);
    fprintf(fid, '    values %f;\n', ed_values);
    
    if scenarios{i, 4} == 1 % If CRDC is active
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