% 1. VARIABLES AND PARAMETERS
var C I_k K N R W Y D Z Z_i Z_a I_zi I_za S T tau_c L;
varexo e_d;
parameters alpha beta delta_k delta_za delta_zi eta psi rho_d omega_k omega_z omega_s psi_z rho_z xi nu_a kappa v tau_zi tau_za tau_c_ss phi_c S_ss L_ss;

@#if DEBT == 1 || CRDC == 1
    var B R_b CRDC;
    parameters eta_g B_ss R_star;
@#elseif FUND == 1
    var F I_f W_f;
    parameters F_target tau_f omega_f R_star;
@#endif

% 2. SET PARAMETERS
alpha    = 0.35;    % Capital share (midpoint between traded 0.3 and non-traded 0.4)
beta     = 0.99;    % Discount factor
delta_k  = 0.05;    % Private capital depreciation rate
delta_zi = 0.075;   % Standard infrastructure depreciation rate
delta_za = 0.03;    % Adaptation infrastructure depreciation rate
eta      = 1;       % Inverse Frisch elasticity
psi      = 1.75;    % Disutility of labour
rho_d    = 0.80;    % Natural disaster shock persistence
omega_k  = 0.30;    % Private capital destruction scale
omega_z  = 0.40;    % Public capital destruction scale
omega_s  = 0.5;     % Public investment efficiency loss
psi_z    = 0.0312;  % Elasticity of output wrt public infrastructure
rho_z    = 0.90;    % CES weight tilted in favor of standard infrastructure
xi       = 10.0;    % CES elasticity of substitution (High substitutability proxy for infinity)
nu_a     = 1.667;   % Adaptation productivity scaling factor (R_za/R_zi = 50%/30%)
kappa    = 0.5;     % Damage mitigation scaling factor (placeholder)
v        = 5;       % Portfolio adjustment cost parameter
tau_zi   = 0.013;   % Standard public investment to GDP
tau_za   = 0.00001; % Adaptation public investment to GDP (0% prior to disaster)
tau_c_ss = 0.125;   % Steady-state VAT 
phi_c    = 0.10;    % Tax reaction to debt deviations
S_ss     = 0.6;     % Steady state public investment
L_ss     = 0;       % Lump sum transfer placeholder

@#if DEBT == 1 || CRDC == 1
    eta_g  = 0.001;      % Debt-elastic risk premium parameter
    B_ss   = 0.60;       % Steady-state debt-to-GDP ratio
    R_star = 1/beta - 1; % Steady-state international interest rate
@#elseif FUND == 1
    F_target = 0.10;
    tau_f    = 0.05;
    omega_f  = 0.50;
    R_star   = 1/beta - 1; 
@#endif