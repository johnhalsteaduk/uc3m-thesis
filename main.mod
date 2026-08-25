@#include "flags.mod"
@#include "parameters.mod"

model;
    @#include "model_core.mod"
end;

% call the external steady state file
steady;

% ensure equations equal 0 at the calculated steady state
resid; 

shocks;
    var e_d;
    periods 1;
    values 0.25;
    @#if CRDC == 1
        var e_crdc; periods 2:3; values 1;
    @#endif
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;