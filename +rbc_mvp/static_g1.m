function g1 = static_g1(T, y, x, params, T_flag)
% function g1 = static_g1(T, y, x, params, T_flag)
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
%   g1
%

if T_flag
    T = rbc_mvp.static_g1_tt(T, y, x, params);
end
g1 = zeros(10, 10);
g1(1,2)=(-1)/(y(2)*y(2))-(1+y(6)-params(3))*(-params(2))/(y(2)*y(2));
g1(1,6)=(-(params(2)/y(2)));
g1(2,2)=(-y(7))/(y(2)*y(2));
g1(2,5)=(-(params(6)*getPowerDeriv(y(5),params(4),1)));
g1(2,7)=1/y(2);
g1(3,3)=1;
g1(3,4)=(-(1-(1-params(3))));
g1(4,2)=(-1);
g1(4,3)=(-1);
g1(4,8)=1;
g1(5,1)=(-T(4));
g1(5,4)=(-(T(3)*T(2)*exp(y(1))*getPowerDeriv(y(4),params(1),1)));
g1(5,5)=(-(T(3)*T(1)*getPowerDeriv(y(5),1-params(1),1)));
g1(5,8)=1;
g1(5,9)=(-(T(1)*T(2)*getPowerDeriv(y(9),params(8),1)));
g1(6,9)=1-(1-params(3)-params(9));
g1(6,10)=(-(1-params(10)));
g1(7,8)=(-params(7));
g1(7,10)=1;
g1(8,4)=(-((-(y(8)*params(1)))/(y(4)*y(4))));
g1(8,6)=1;
g1(8,8)=(-(params(1)/y(4)));
g1(9,5)=(-((-(y(8)*(1-params(1))))/(y(5)*y(5))));
g1(9,7)=1;
g1(9,8)=(-((1-params(1))/y(5)));
g1(10,1)=1-params(5);

end
