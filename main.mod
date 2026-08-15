@#define DEBT = 0
@#define CRDC = 1

@#include "parameters.mod"

model;
    @#if DEBT == 1
        @#include "model_debt.mod"
        @#elseif CRDC == 1
        @#include "model_crdc.mod"
        @#else
        @#include "model_core.mod"
    @#endif
end;

% call the external steady state file
steady;

% ensure equations equal 0 at the calculated steady state
resid; 

shocks;
    var e_nd; stderr 1;
end;

@#if DEBT == 1 || CRDC == 1
    stoch_simul(order=1, irf=40) Y C I N R W D R_d;
@#else
    stoch_simul(order=1, irf=40) Y C I N R W;
@#endif