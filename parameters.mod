% 1. VARIABLES AND PARAMETERS
var a C I K N R W Y;
varexo e;
parameters alpha beta delta eta rho psi;

@#if MARTO == 1
    var Z I_Z;
    parameters tau xi S D_Z D_S;
    % TODO: adaptation capital (Z_a), liquidity constrained households, exogenous grants (G),
    % contingency fund (s_fund). These should all be solvable analytically!
@#endif

% 2. SET PARAMETERS
alpha = 0.33; % capital share
beta  = 0.99; % discount factor
delta = 0.025; % depreciation rate
eta   = 1;    % inverse Frisch elasticity
rho   = 0.95; % shock persistence
psi   = 1.75; % disutility of labour

@#if MARTO == 1
    tau  = 0.05; % tax rate TODO
    xi   = 0.5;  % elasticity of output wrt public capital
    S    = 0.5;  % public capital investment efficiency
    
    @#if SHOCK == 1
        D_Z = 0.5; % shock to public capital
        D_S = 0.5; % shock to investment efficiency
    @#else
        D_Z = 0;   % shock to public capital
        D_S = 0;   % shock to investment efficiency    
    @#endif
@#endif