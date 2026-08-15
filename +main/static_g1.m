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
    T = main.static_g1_tt(T, y, x, params);
end
g1 = zeros(15, 15);
g1(1,1)=(1+params(12)*(y(2)/y(3)-params(3)))*(-1)/(y(1)*y(1))-(params(12)*(y(2)/y(3)-params(3))+1+y(5)-params(3))*params(2)*(-1)/(y(1)*y(1));
g1(1,2)=T(1)*params(12)*1/y(3)-T(1)*params(2)*params(12)*1/y(3);
g1(1,3)=T(1)*params(12)*(-y(2))/(y(3)*y(3))-T(1)*params(2)*params(12)*(-y(2))/(y(3)*y(3));
g1(1,5)=(-(T(1)*params(2)));
g1(2,1)=(-y(6))/(y(1)*y(1));
g1(2,4)=(-(params(5)*getPowerDeriv(y(4),params(4),1)));
g1(2,6)=T(1);
g1(3,2)=1;
g1(3,3)=(-(1-(1-params(3)-params(7)*y(8))));
g1(3,8)=y(3)*(-params(7));
g1(4,1)=(-1);
g1(4,2)=(-1);
g1(4,7)=1;
g1(4,9)=1-(1+y(10)*(1-y(11)));
g1(4,10)=(-(y(9)*(1-y(11))));
g1(4,11)=(-(y(9)*(-y(10))));
g1(5,3)=(-(T(4)*exp(y(8)*(-params(8)))*getPowerDeriv(y(3),params(1),1)));
g1(5,4)=(-(T(3)*getPowerDeriv(y(4),1-params(1),1)));
g1(5,7)=1;
g1(5,8)=(-(T(4)*T(2)*(-params(8))*exp(y(8)*(-params(8)))));
g1(6,3)=(-((-(y(7)*params(1)))/(y(3)*y(3))));
g1(6,5)=1;
g1(6,7)=(-(params(1)/y(3)));
g1(7,4)=(-((-(y(7)*(1-params(1))))/(y(4)*y(4))));
g1(7,6)=1;
g1(7,7)=(-((1-params(1))/y(4)));
g1(8,8)=1-params(6);
g1(9,1)=(-1)/(y(1)*y(1))-(1+y(10)*(1-y(11)))*(-params(2))/(y(1)*y(1));
g1(9,10)=(-((1-y(11))*params(2)/y(1)));
g1(9,11)=(-(params(2)/y(1)*(-y(10))));
g1(10,9)=(-params(9));
g1(10,10)=1;
g1(11,11)=1;
g1(11,12)=(-1);
g1(11,13)=(-1);
g1(11,14)=(-1);
g1(11,15)=(-1);
g1(12,12)=1;
g1(13,12)=(-1);
g1(13,13)=1;
g1(14,13)=(-1);
g1(14,14)=1;
g1(15,14)=(-1);
g1(15,15)=1;

end
