% 1. VARIABLES AND PARAMETERS
var C I_k K N R W Y D Z Z_i Z_a I_zi I_za S T tau_c B C_r C_c R_b;
varexo e_d;
parameters alpha beta delta_k delta_za delta_zi eta psi rho_d omega_k omega_z omega_s omega_r psi_z nu_a kappa v tau_zi tau_za tau_c_ss phi_c S_ss L_ss R_star B_Y_ratio lambda_c eta_g lambda_z;

@#if ACCEL_RECON == 1
    parameters phi_z Z_i_ss;
@#endif

@#if CRDC == 1
    varexo e_crdc;
    parameters B_ss;
@#endif

% 2. SET PARAMETERS
alpha    = 0.35;    % Capital share (midpoint between traded 0.3 and non-traded 0.4)
beta     = 0.985;   % Discount factor, calibrated for R_star of 1.5%
delta_k  = 0.05;    % Private capital depreciation rate
delta_zi = 0.075;   % Standard infrastructure depreciation rate
delta_za = 0.03;    % Adaptation infrastructure depreciation rate
eta      = 1;       % Inverse Frisch elasticity
psi      = 1.75;    % Disutility of labour
rho_d    = 0.80;    % Natural disaster shock persistence
omega_k  = 0.30;    % Private capital destruction scale
omega_z  = 0.40;    % Public capital destruction scale
omega_s  = 0.5;     % Public investment efficiency loss
omega_r  = 0.15;    % Sovereign risk penalty factor (source: 2015 Standard & Poor's report)
psi_z    = 0.0312;  % Elasticity of output wrt public infrastructure
nu_a     = 1.667;   % Adaptation productivity scaling factor (R_za/R_zi = 50%/30%)
kappa    = 0.5;     % Damage mitigation scaling factor (placeholder)
v        = 5;       % Portfolio adjustment cost parameter
tau_zi   = 0.013;   % Standard public investment to GDP
tau_za   = 0.00001; % Adaptation public investment to GDP (0% prior to disaster)
tau_c_ss = 0.125;   % Steady-state VAT 
phi_c    = 0.01;    % Tax reaction to debt deviations
S_ss     = 0.6;     % Steady state public investment
L_ss     = 0;       % Lump sum transfer placeholder
B_Y_ratio = 0.256;  % Steady-state debt-to-GDP ratio
R_star   = 1/beta - 1; % Steady-state international interest rate
lambda_c = 0.34;    % Percentage of liquidity constrained households
eta_g    = 0.002;   % Debt-elastic risk premium parameter
lambda_z = 1;     % Public investment austerity scaling factor

@#if ACCEL_RECON == 1
    phi_z  = 0.5; % Reconstruction speed;
    Z_i_ss = 0;    % Steady state standard public capital placeholder;
@#endif