@#include "flags.mod"
@#include "parameters.mod"
@#include "omega_setting.mod"

model;
    @#include "model_core.mod"
end;

% call the external steady state file
steady;

% ensure equations equal 0 at the calculated steady state
resid; 

@#include "shocks.mod"

perfect_foresight_setup(periods=200);
perfect_foresight_solver;