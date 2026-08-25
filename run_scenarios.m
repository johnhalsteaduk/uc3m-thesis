scenarios = {
    % Name                   AUSTERITY ACCEL  DEBT  CRDC  DEBT_ONLY
    'debt_no_austerity',         0,      1,    1,    0,       0;
    'debt_austerity',            1,      1,    1,    0,       0;
    'crdc_no_austerity',         0,      1,    0,    1,       0;
    'crdc_austerity',            1,      1,    0,    1,       0;
    'baseline_no_accel',         0,      0,    0,    0,       0;
    'baseline_accel',            0,      1,    0,    0,       0;
    'debt_only_no_accel',        0,      0,    0,    0,       1;
    'debt_only_accel',           0,      1,    0,    0,       1;
};

for i = 1:size(scenarios, 1)
    file_suffix = scenarios{i, 1};
    
    fid = fopen('flags.mod', 'w');
    fprintf(fid, '@#define AUSTERITY = %d\n', scenarios{i, 2});
    fprintf(fid, '@#define ACCEL_RECON = %d\n', scenarios{i, 3});
    fprintf(fid, '@#define DEBT = %d\n', scenarios{i, 4});
    fprintf(fid, '@#define CRDC = %d\n', scenarios{i, 5});
    fprintf(fid, '@#define DEBT_ONLY = %d\n', scenarios{i, 6});
    fclose(fid);
    
    clear oo_ M_ options_
    dynare main.mod noclearall nostrict
    save(strcat('results_', file_suffix, '.mat'), 'oo_', 'M_');
end
disp('All scenarios finished computing.');