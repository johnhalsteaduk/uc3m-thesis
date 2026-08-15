function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
% function residual = dynamic_resid(T, y, x, params, steady_state, it_, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T             [#temp variables by 1]     double   vector of temporary terms to be filled by function
%   y             [#dynamic variables by 1]  double   vector of endogenous variables in the order stored
%                                                     in M_.lead_lag_incidence; see the Manual
%   x             [nperiods by M_.exo_nbr]   double   matrix of exogenous variables (in declaration order)
%                                                     for all simulation periods
%   steady_state  [M_.endo_nbr by 1]         double   vector of steady state values
%   params        [M_.param_nbr by 1]        double   vector of parameter values in declaration order
%   it_           scalar                     double   time period for exogenous variables for which
%                                                     to evaluate the model
%   T_flag        boolean                    boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   residual
%

if T_flag
    T = main.dynamic_resid_tt(T, y, x, params, steady_state, it_);
end
residual = zeros(15, 1);
    residual(1) = (T(1)*(1+params(12)*(y(11)/y(1)-params(3)))) - (T(2)*(1+y(27)-params(3)+params(12)*(y(26)/y(12)-params(3))));
    residual(2) = (y(15)/y(10)) - (params(5)*y(13)^params(4));
    residual(3) = (y(11)) - (y(12)-y(1)*(1-params(3)-params(7)*y(17)));
    residual(4) = (y(18)) - (y(11)+y(10)+(1+y(4)*(1-y(5)))*y(3)-y(16));
    residual(5) = (y(16)) - (T(4)*T(5));
    residual(6) = (y(14)) - (y(16)*params(1)/y(1));
    residual(7) = (y(15)) - (y(16)*(1-params(1))/y(13));
    residual(8) = (y(17)) - (params(6)*y(2)+x(it_, 1));
    residual(9) = (T(1)) - (params(2)/y(25)*(1+y(28)*(1-y(20))));
    residual(10) = (y(19)) - (params(11)+params(9)*(y(18)-params(10)));
    residual(11) = (y(20)) - (x(it_, 1)+y(6)+y(7)+y(8)+y(9));
    residual(12) = (y(21)) - (x(it_, 1));
    residual(13) = (y(22)) - (y(6));
    residual(14) = (y(23)) - (y(7));
    residual(15) = (y(24)) - (y(8));

end
