% 1. VARIABLES AND PARAMETERS
var C I K N R W Y ND;
varexo e_nd;
parameters alpha beta delta eta psi rho_nd omega_k omega_a;

@#if DEBT == 1 || CRDC == 1
    var D R_d;
    parameters nu D_ss R_star phi;
@#endif

@#if CRDC == 1
    var CRDC;
@#endif

% 2. SET PARAMETERS
alpha = 0.33; % capital share
beta  = 0.99; % discount factor
delta = 0.025; % depreciation rate
eta   = 1;    % inverse Frisch elasticity
psi   = 1.75; % disutility of labour
rho_nd  = 0.80; % Natural disaster shock persistence
omega_k = 0.25; % Capital destruction scale
omega_a = 0.20; % TFP penalty scale

@#if DEBT == 1 || CRDC == 1
    nu = 0.001;
    D_ss = 0.60;
    R_star = 1/beta - 1;
    phi = 2.5;
    @#endif