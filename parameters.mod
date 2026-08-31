% 1. VARIABLES AND PARAMETERS
var C I_k K N R_k W Y D D_r Z Z_i Z_a I_zi I_za S T tau_c B C_r C_c R_b Q F L;
varexo e_d e_crdc;

parameters alpha delta_k delta_za delta_zi eta psi rho_d rho_dr omega_tfp omega_s omega_r psi_z nu_a pi v tau_zi tau_za tau_c_target phi_c S_target R_star B_Y_ratio lambda_c nu_g eta_g delta_b phi_z phi_l;

% 2. SET PARAMETERS
alpha    = 0.35;    % Capital share (midpoint between traded 0.3 and non-traded 0.4)
R_star   = 0.015;   % Steady-state international interest rate (1.5%)
delta_k  = 0.05;    % Private capital depreciation rate
delta_zi = 0.075;   % Standard infrastructure depreciation rate
delta_za = 0.03;    % Adaptation infrastructure depreciation rate
eta      = 1.00;    % Inverse Frisch elasticity
psi      = 1.75;    % Disutility of labour
rho_d    = 0.2;    % Natural disaster shock persistence
rho_dr    = 0.9;    % Natural disaster shock persistence
omega_tfp  = 0.8;    % Public capital destruction scale
omega_s  = 0.50;    % Public investment efficiency loss
omega_r = 0.5;
psi_z    = 0.0312;  % Elasticity of output wrt public infrastructure
nu_a     = 1.667;   % Adaptation productivity scaling factor (R_za/R_zi = 50%/30%)
pi       = 0.4;    % Adaptation base effectiveness
v        = 10;    % Capital adjustment cost parameter
tau_zi   = 0.013;   % Standard public investment to GDP
tau_c_target = 0.125;   % Steady-state VAT
phi_c    = 0.05;    % Tax reaction to debt deviations
S_target     = 0.60;    % Steady state public investment
B_Y_ratio= 0.256;   % Steady-state debt-to-GDP ratio
lambda_c = 0.34;    % Percentage of liquidity constrained households
nu_g     = 1;
eta_g    = 0.001;% Debt-elastic risk premium parameter
delta_b  = 0.188;   % Bond decay rate
phi_z    = 1;    % Reconstruction speed
phi_l    = 0.5;   % Transfer reaction to debt deviations

@#if ADAPTATION == 1
    tau_za = 0.03; % Adaptation public investment to GDP
@#else
    tau_za = 0.00;
@#endif