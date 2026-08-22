scenarios = {
    'baseline_no_accel', 0, 0, 0, 0;
    'baseline_accel',    1, 0, 0, 0;
    'debt_no_accel',     0, 1, 0, 0;
    'debt_accel',        1, 1, 0, 0;
    'crdc_no_accel',     0, 0, 1, 0;
    'crdc_accel',        1, 0, 1, 0;
    'fund_no_accel',     0, 0, 0, 1;
    'fund_accel',        1, 0, 0, 1;
};

for i = 1:size(scenarios, 1)
    file_suffix = scenarios{i, 1};
    
    % 1. Write the current flags to a temporary file
    fid = fopen('flags.mod', 'w');
    fprintf(fid, '@#define ACCEL_RECON = %d\n', scenarios{i, 2});
    fprintf(fid, '@#define DEBT = %d\n', scenarios{i, 3});
    fprintf(fid, '@#define CRDC = %d\n', scenarios{i, 4});
    fprintf(fid, '@#define FUND = %d\n', scenarios{i, 5});
    fclose(fid);
    
    % 2. Run Dynare (noclearall prevents workspace deletion)
    dynare main.mod noclearall
    
    % 3. Save the results explicitly
    save(strcat('results_', file_suffix, '.mat'), 'oo_', 'M_');
end

disp('All scenarios finished computing.');