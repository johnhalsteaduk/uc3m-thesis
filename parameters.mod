% 1. VARIABLES AND PARAMETERS
var C I_k K N R W Y ND Z Z_i Z_a I_zi I_za S T;
varexo e_nd;
parameters alpha beta delta_k delta_za delta_zi eta psi rho_nd omega_k omega_a omega_z omega_s xi rho_z xi_ces nu_a pi_d nu_d tau_zi tau_za;

@#if DEBT == 1 || CRDC == 1
    var D R_d;
    parameters nu D_ss R_star phi;
@#endif

@#if CRDC == 1
    var CRDC;
@#endif

% 2. SET PARAMETERS
alpha    = 0.35;    % Capital share (midpoint between traded 0.3 and non-traded 0.4)
beta     = 0.99;    % Discount factor (placeholder)
delta_k  = 0.05;    % Private capital depreciation rate (5%)
delta_zi = 0.075;   % Standard infrastructure depreciation rate (7.5%)
delta_za = 0.03;    % Adaptation infrastructure depreciation rate (3%)
eta      = 1;       % Inverse Frisch elasticity (placeholder)
psi      = 1.75;    % Disutility of labour (placeholder)

rho_nd   = 0.80;    % Natural disaster shock persistence (placeholder)
omega_k  = 0.30;    % Private capital destruction scale
omega_a  = 0.20;    % TFP penalty scale (approx 20% impact)
omega_z  = 0.40;    % Public capital destruction scale
omega_s  = 0.20;    % Public investment efficiency loss (20%)

xi       = 0.0312;  % Elasticity of output wrt public infrastructure
rho_z    = 0.90;    % CES weight tilted in favor of standard infrastructure (90%)
xi_ces   = 10.0;    % CES elasticity of substitution (High substitutability proxy for infinity)
nu_a     = 1.667;   % Adaptation productivity scaling factor (R_za/R_zi = 50%/30%)
pi_d     = 0.50;    % Damage mitigation scaling factor (placeholder)
nu_d     = 0.50;    % Damage mitigation exponent (placeholder)

tau_zi   = 0.013;   % Standard public investment to GDP (1.3%)
tau_za   = 0.00001; % Adaptation public investment to GDP (0% prior to disaster)

@#if DEBT == 1 || CRDC == 1
    nu     = 0.001;
    D_ss   = 0.60;
    R_star = 1/beta - 1;
    phi    = 2.5;
@#endif