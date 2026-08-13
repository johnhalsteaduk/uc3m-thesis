% 1. VARIABLES AND PARAMETERS
var C I K N R W Y ND;
varexo e;
parameters alpha beta delta eta rho psi rho_nd omega_k omega_a;

@#if DEBT == 1
    var D R_d
    parameters nu D_ss
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