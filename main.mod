@#define MARTO = 0
@#define SHOCK = 1

@#include "parameters.mod"

model;
    @#if MARTO == 0
        @#include "model_core.mod"
    @#else
        @#include "model_marto.mod"
    @#endif
end;

% Call the external steady state file
steady;

% Rigorous check: ensure equations equal 0 at the calculated steady state
resid; 

shocks;
    var e; stderr 0.01;
end;

@#if MARTO == 0
    stoch_simul(order=1, irf=40) Y C I N R W;
@#else
    stoch_simul(order=1, irf=40) Y C I N R W Z I_Z;
@#endif