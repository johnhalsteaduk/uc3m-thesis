% 1. VARIABLES AND PARAMETERS
var C I_k K N R W Y D Z Z_i Z_a I_zi I_za S T;
varexo e_d;
parameters alpha beta delta_k delta_za delta_zi eta psi rho_d omega_k omega_a omega_z omega_s psi_z rho_z xi nu_a kappa tau_zi tau_za v;

@#if CRDC == 1
    var CRDC;
@#endif

@#if DEBT == 1 || CRDC == 1
    var B R_b;
    parameters eta_g B_ss R_star;
@#elseif FUND == 1
    var F I_f W_f;
    parameters F_target tau_f omega_f R_star;
@#endif

% 2. SET PARAMETERS
alpha    = 0.35;    % Capital share (midpoint between traded 0.3 and non-traded 0.4)
beta     = 0.99;    % Discount factor (placeholder)
delta_k  = 0.05;    % Private capital depreciation rate (5%)
delta_zi = 0.075;   % Standard infrastructure depreciation rate (7.5%)
delta_za = 0.03;    % Adaptation infrastructure depreciation rate (3%)
eta      = 1;       % Inverse Frisch elasticity (placeholder)
psi      = 1.75;    % Disutility of labour (placeholder)
rho_d   = 0.80;    % Natural disaster shock persistence (placeholder)
omega_k  = 0.30;    % Private capital destruction scale
omega_z  = 0.40;    % Public capital destruction scale
omega_s  = 0.20;    % Public investment efficiency loss (20%)
psi_z    = 0.0312;  % Elasticity of output wrt public infrastructure
rho_z    = 0.90;    % CES weight tilted in favor of standard infrastructure (90%)
xi       = 10.0;    % CES elasticity of substitution (High substitutability proxy for infinity)
nu_a     = 1.667;   % Adaptation productivity scaling factor (R_za/R_zi = 50%/30%)
kappa    = 0.50;    % Damage mitigation scaling factor (placeholder)
tau_zi   = 0.013;   % Standard public investment to GDP (1.3%)
tau_za   = 0.00001; % Adaptation public investment to GDP (0% prior to disaster)
v        = 2.5;        % Portfolio adjustment cost parameter

@#if DEBT == 1 || CRDC == 1
    eta_g  = 0.001;      % Debt-elastic risk premium parameter
    B_ss   = 0.60;       % Steady-state debt-to-GDP ratio (60%)
    R_star = 1/beta - 1; % Steady-state international interest rate
@#elseif FUND == 1
    F_target = 0.10;
    tau_f    = 0.05;
    omega_f  = 0.50;
    R_star   = 1/beta - 1; 
@#endif