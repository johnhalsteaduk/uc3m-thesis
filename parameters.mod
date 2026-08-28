% 1. VARIABLES AND PARAMETERS
var C I_k K N R W Y D Z Z_i Z_a I_zi I_za S T tau_c B C_r C_c R_b q F;
varexo e_d e_crdc;
parameters alpha beta delta_k delta_za delta_zi eta psi rho_d omega_k omega_z omega_s omega_r psi_z nu_a kappa v tau_zi tau_za tau_c_ss phi_c S_ss L_ss R_star B_Y_ratio G_Y_ratio lambda_c eta_g lambda_z delta_b q_ss G_ss phi_z Z_i_ss B_ss;

% 2. SET PARAMETERS
alpha    = 0.35;    % Capital share (midpoint between traded 0.3 and non-traded 0.4)
R_star   = 0.015;   % Steady-state international interest rate (1.5%)
beta     = 1 / (1 + R_star);   % Discount factor, calibrated based on R_star
delta_k  = 0.05;    % Private capital depreciation rate
delta_zi = 0.075;   % Standard infrastructure depreciation rate
delta_za = 0.03;    % Adaptation infrastructure depreciation rate
eta      = 1;       % Inverse Frisch elasticity
psi      = 1.75;    % Disutility of labour
rho_d    = 0.80;    % Natural disaster shock persistence
omega_k  = 0.30;    % Private capital destruction scale
omega_z  = 0.40;    % Public capital destruction scale
omega_s  = 0.20;    % Public investment efficiency loss
omega_r  = 0.15;    % Sovereign risk penalty factor
psi_z    = 0.0312;  % Elasticity of output wrt public infrastructure
nu_a     = 1.667;   % Adaptation productivity scaling factor (R_za/R_zi = 50%/30%)
kappa    = 0.5;     % Damage mitigation scaling factor (placeholder)
v        = 2.48;    % Capital adjustment cost parameter
tau_zi   = 0.013;   % Standard public investment to GDP
tau_c_ss = 0.125;   % Steady-state VAT
phi_c    = 0.05;    % Tax reaction to debt deviations
S_ss     = 0.6;     % Steady state public investment
L_ss     = 0;       % Lump sum transfer placeholder
B_Y_ratio = 0.256;  % Steady-state debt-to-GDP ratio
G_Y_ratio = 0.03;   % Steady-state grant-to-GDP ratio
lambda_c = 0.34;    % Percentage of liquidity constrained households
eta_g    = 0.000742;% Debt-elastic risk premium parameter
lambda_z = 1;       % Public investment austerity scaling factor
delta_b  = 0.188;   % Bond decay rate
phi_z  = 2;   % Reconstruction speed;
Z_i_ss = 0;     % Steady state standard public capital placeholder;
G_ss = 0;
q_ss = 1 / (R_star + delta_b);
B_ss = 0;
gamma = 0.5; % amount of crdc relief directed to tax cuts or transfers

@#if ADAPTATION == 1
    tau_za = G_Y_ratio; % Adaptation public investment to GDP
@#else
    tau_za = 0.00;
@#endif