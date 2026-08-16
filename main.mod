@#define DEBT = 1
@#define CRDC = 0

@#include "parameters.mod"

model;
    @#include "model_core.mod"
end;

% call the external steady state file
steady;

% ensure equations equal 0 at the calculated steady state
resid; 

shocks;
    var e_nd; stderr 1;
end;

@#if DEBT == 1 || CRDC == 1
    stoch_simul(order=1, irf=40) Y C I_k N R W D R_d;
@#else
    stoch_simul(order=1, irf=40) Y C I_k N R W;
@#endif