@#define DEBT = 0

@#include "parameters.mod"

model;
    @#if DEBT == 1
        @#include "model_debt.mod"
    @#else
        @#include "model_core.mod"
    @#endif
end;

% Call the external steady state file
steady;

% Rigorous check: ensure equations equal 0 at the calculated steady state
resid; 

shocks;
    var e; stderr 0.01;
end;

@#if DEBT == 1
    
@#else
    stoch_simul(order=1, irf=40) Y C I N R W;
@#endif