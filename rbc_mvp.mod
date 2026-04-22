% 0. FLAGS
@#define MARTO = 1
@#define SHOCK = 1

% 1. VARIABLES AND PARAMETERS
var a C I K N R W Y
@#if MARTO == 1
    Z % Public capital
    I_Z % Public capital investment
%    S % Investment efficiency
@#endif
;

varexo e;
parameters alpha beta delta eta rho psi
@#if MARTO ==1
    tau zeta D_Z D_S
@#endif
;

% 2. SET PARAMETERS
alpha = 0.33; % capital share
beta = 0.99; % discount factor
delta = 0.025; % depreciation rate
eta = 1; % inverse Frisch elasticity
rho = 0.95; % shock persistence
psi = 1.75; % disutility of labour
@#if MARTO ==1
    tau = 0.05; % tax rate TODO
    zeta = 0.5; % elasticity of output wrt public capital
    @#if SHOCK == 1
        D_Z = 0.5; % shock to public capital
        D_S = 0.5; % shock to investment efficiency
    @#else
        D_Z = 0; % shock to public capital
        D_S = 0; % shock to investment efficiency    
    @#endif
@#endif

% 3. DEFINE MODEL
model;
    % 1. Euler equation
    1/C = beta/C(+1)*(R(+1)+1-delta);
    % 2. Labour supply
    W/C = psi*N^eta;
    % 3. Investment
    I = K-(1-delta)*K(-1);
    @#if MARTO == 0
        % 4. Resource constraint
        Y = C+I;
        % 5. Production function
        Y = exp(a)*K(-1)^alpha*N^(1-alpha);
    @#else
        % Resource constraint
        Y = C+I+I_Z;
        % Add public capital to production function
        Y = exp(a)*K(-1)^alpha*N^(1-alpha)*Z(-1)^zeta;
        % Public capital
        Z = (1-delta-D_Z)*Z(-1)+(1-D_S)*I_Z;
        % Public capital investment
        I_Z = tau*Y; % TODO massive oversimplification to make the model work - invest tau % of output in public capital
    @#endif
    
    % 6. Factor prices
    R = alpha*Y/K(-1);
    W = (1-alpha)*Y/N;
    % 7. Shocks: negative productivity shock. a = log(A).
    a = rho*a(-1)-e;
end;    

% 4. STEADY STATE
steady_state_model;
    % define steady state values of endogenous variables
    a = 0;
    R_ss = 1/beta-(1-delta);
    K_Y_ratio = alpha/R_ss;
    I_Y_ratio = delta*K_Y_ratio;
    @#if MARTO == 0
        C_Y_ratio = 1-I_Y_ratio;
    @#else
        C_Y_ratio = 1-I_Y_ratio-I_Z_Y_ratio;
        I_Z_Y_ratio = tau;
        Z = (1-D_S)*I_Z/(delta-D_Z);
    @#endif

    
    K = K_Y_ratio*Y;
    I = I_Y_ratio*Y;
    C = C_Y_ratio*Y;
    %{
    a = 0;
    R_ss = 1/beta-(1-delta);
    K_N_ratio = (alpha/R_ss)^(1/(1-alpha));
    Y_N_ratio = exp(a)*K_N_ratio^alpha;
    W_ss = (1-alpha)*Y_N_ratio;
    C_N_ratio = Y_N_ratio-delta*K_N_ratio;
    N = (W_ss/(psi*C_N_ratio))^(1/(1+eta));

    K = K_N_ratio*N;
    Y = Y_N_ratio*N;
    C = C_N_ratio*N;

    W = W_ss;
    R = R_ss;
    I = delta*K;
    %}
end;

resid;

% 5. SIMULATION BLOCK
shocks;
    var e; stderr 0.01; % define shock with 1% standard deviation
end;

stoch_simul(order=1, irf=40) Y C I N R W;