function residual = static_resid(T, y, x, params, T_flag)
% function residual = static_resid(T, y, x, params, T_flag)
%
% File created by Dynare Preprocessor from .mod file
%
% Inputs:
%   T         [#temp variables by 1]  double   vector of temporary terms to be filled by function
%   y         [M_.endo_nbr by 1]      double   vector of endogenous variables in declaration order
%   x         [M_.exo_nbr by 1]       double   vector of exogenous variables in declaration order
%   params    [M_.param_nbr by 1]     double   vector of parameter values in declaration order
%                                              to evaluate the model
%   T_flag    boolean                 boolean  flag saying whether or not to calculate temporary terms
%
% Output:
%   residual
%

if T_flag
    T = main.static_resid_tt(T, y, x, params);
end
residual = zeros(15, 1);
    residual(1) = (T(1)*(1+params(12)*(y(2)/y(3)-params(3)))) - (T(1)*params(2)*(params(12)*(y(2)/y(3)-params(3))+1+y(5)-params(3)));
    residual(2) = (y(6)/y(1)) - (params(5)*y(4)^params(4));
    residual(3) = (y(2)) - (y(3)-y(3)*(1-params(3)-params(7)*y(8)));
    residual(4) = (y(9)) - (y(2)+y(1)+y(9)*(1+y(10)*(1-y(11)))-y(7));
    residual(5) = (y(7)) - (T(3)*T(4));
    residual(6) = (y(5)) - (y(7)*params(1)/y(3));
    residual(7) = (y(6)) - (y(7)*(1-params(1))/y(4));
    residual(8) = (y(8)) - (y(8)*params(6)+x(1));
    residual(9) = (T(1)) - ((1+y(10)*(1-y(11)))*params(2)/y(1));
    residual(10) = (y(10)) - (params(11)+params(9)*(y(9)-params(10)));
    residual(11) = (y(11)) - (x(1)+y(12)+y(13)+y(14)+y(15));
    residual(12) = (y(12)) - (x(1));
    residual(13) = (y(13)) - (y(12));
    residual(14) = (y(14)) - (y(13));
    residual(15) = (y(15)) - (y(14));

end
