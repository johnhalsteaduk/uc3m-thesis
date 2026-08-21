@#define DEBT = 0
@#define CRDC = 0
@#define FUND = 1

@#include "parameters.mod"

model;
    @#include "model_core.mod"
end;

% call the external steady state file
steady;

% ensure equations equal 0 at the calculated steady state
resid; 

shocks;
    var e_d; stderr 1;
end;

@#if DEBT == 1
    stoch_simul(order=1, irf=40) Y C I_k N R W B R_b;
    save('results_debt.mat', 'oo_');
@#elseif CRDC == 1
    stoch_simul(order=1, irf=40) Y C I_k N R W B R_b;
    save('results_crdc.mat', 'oo_');
@#elseif FUND == 1
    stoch_simul(order=1, irf=40) Y C I_k N R W;
    save('results_fund.mat', 'oo_');
@#else
    stoch_simul(order=1, irf=40) Y C I_k N R W;
    save('results_baseline.mat', 'oo_');
@#endif