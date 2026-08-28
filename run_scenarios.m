% =========================================================================
% Master Scenario Runner for Dynare
% =========================================================================
scenarios = {
    % Name                                          ACCEL  DEBT  CRDC  ADAPT  AUST  RESIL  DEBT_ONLY
    % --- Part 1: Baseline & Replication ---
    'baseline_no_accel',                              0,     0,    0,    0,     0,    0,     0;
    'baseline_accel',                                 1,     0,    0,    0,     0,    0,     0;
    'debt_only_accel',                                1,     0,    0,    0,     0,    0,     1;
    'baseline_accel_adaptation',                      1,     0,    0,    1,     0,    0,     0;
    
    % --- Part 2: CRDC, Austerity & Resilience Extensions ---
    'debt_accel_adaptation',                          1,     1,    0,    1,     0,    0,     0;
    'crdc_accel_adaptation',                          1,     0,    1,    1,     0,    0,     0;
    'crdc_accel_adaptation_resilience',               1,     0,    1,    1,     0,    1,     0; % Added for your new comparison
    'debt_accel_adaptation_austerity',                1,     1,    0,    1,     1,    0,     0;
    'crdc_accel_adaptation_austerity',                1,     0,    1,    1,     1,    0,     0;
    'debt_accel_adaptation_austerity_resilience',     1,     1,    0,    1,     1,    1,     0;
    'crdc_accel_adaptation_austerity_resilience',     1,     0,    1,    1,     1,    1,     0;
};

for i = 1:size(scenarios, 1)
    file_suffix = scenarios{i, 1};
    
    % Write macro-processor flags to flags.mod
    fid = fopen('flags.mod', 'w');
    fprintf(fid, '@#define ACCEL_RECON = %d\n', scenarios{i, 2});
    fprintf(fid, '@#define DEBT        = %d\n', scenarios{i, 3});
    fprintf(fid, '@#define CRDC        = %d\n', scenarios{i, 4});
    fprintf(fid, '@#define ADAPTATION  = %d\n', scenarios{i, 5});
    fprintf(fid, '@#define AUSTERITY   = %d\n', scenarios{i, 6});
    fprintf(fid, '@#define RESILIENCE  = %d\n', scenarios{i, 7});
    fprintf(fid, '@#define DEBT_ONLY   = %d\n', scenarios{i, 8});
    fclose(fid);
    
    % Run Dynare and save results
    clear oo_ M_ options_
    dynare main.mod noclearall nostrict
    save(strcat('results_', file_suffix, '.mat'), 'oo_', 'M_');
end
disp('All scenarios finished computing successfully.');