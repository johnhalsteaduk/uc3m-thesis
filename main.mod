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
end;

perfect_foresight_setup(periods=200);
perfect_foresight_solver;