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
    T = rbc_mvp.dynamic_resid_tt(T, y, x, params, steady_state, it_);
end
residual = zeros(10, 1);
    residual(1) = (1/y(5)) - (params(2)/y(14)*(1+y(15)-params(3)));
    residual(2) = (y(10)/y(5)) - (params(6)*y(8)^params(4));
    residual(3) = (y(6)) - (y(7)-(1-params(3))*y(2));
    residual(4) = (y(11)) - (y(5)+y(6));
    residual(5) = (y(11)) - (T(4));
    residual(6) = (y(12)) - (y(3)*(1-params(3)-params(9))+(1-params(10))*y(13));
    residual(7) = (y(13)) - (y(11)*params(7));
    residual(8) = (y(9)) - (y(11)*params(1)/y(2));
    residual(9) = (y(10)) - (y(11)*(1-params(1))/y(8));
    residual(10) = (y(4)) - (params(5)*y(1)-x(it_, 1));

end
