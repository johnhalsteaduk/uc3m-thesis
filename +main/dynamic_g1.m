function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
% function g1 = dynamic_g1(T, y, x, params, steady_state, it_, T_flag)
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
%   g1
%

if T_flag
    T = main.dynamic_g1_tt(T, y, x, params, steady_state, it_);
end
g1 = zeros(15, 29);
g1(1,10)=(1+params(12)*(y(11)/y(1)-params(3)))*(-1)/(y(10)*y(10));
g1(1,25)=(-((1+y(27)-params(3)+params(12)*(y(26)/y(12)-params(3)))*params(2)*(-1)/(y(25)*y(25))));
g1(1,11)=T(1)*params(12)*1/y(1);
g1(1,26)=(-(T(2)*params(12)*1/y(12)));
g1(1,1)=T(1)*params(12)*(-y(11))/(y(1)*y(1));
g1(1,12)=(-(T(2)*params(12)*(-y(26))/(y(12)*y(12))));
g1(1,27)=(-T(2));
g1(2,10)=(-y(15))/(y(10)*y(10));
g1(2,13)=(-(params(5)*getPowerDeriv(y(13),params(4),1)));
g1(2,15)=T(1);
g1(3,11)=1;
g1(3,1)=1-params(3)-params(7)*y(17);
g1(3,12)=(-1);
g1(3,17)=y(1)*(-params(7));
g1(4,10)=(-1);
g1(4,11)=(-1);
g1(4,16)=1;
g1(4,3)=(-(1+y(4)*(1-y(5))));
g1(4,18)=1;
g1(4,4)=(-((1-y(5))*y(3)));
g1(4,5)=(-(y(3)*(-y(4))));
g1(5,1)=(-(T(5)*exp(y(17)*(-params(8)))*getPowerDeriv(y(1),params(1),1)));
g1(5,13)=(-(T(4)*getPowerDeriv(y(13),1-params(1),1)));
g1(5,16)=1;
g1(5,17)=(-(T(5)*T(3)*(-params(8))*exp(y(17)*(-params(8)))));
g1(6,1)=(-((-(y(16)*params(1)))/(y(1)*y(1))));
g1(6,14)=1;
g1(6,16)=(-(params(1)/y(1)));
g1(7,13)=(-((-(y(16)*(1-params(1))))/(y(13)*y(13))));
g1(7,15)=1;
g1(7,16)=(-((1-params(1))/y(13)));
g1(8,2)=(-params(6));
g1(8,17)=1;
g1(8,29)=(-1);
g1(9,10)=(-1)/(y(10)*y(10));
g1(9,25)=(-((1+y(28)*(1-y(20)))*(-params(2))/(y(25)*y(25))));
g1(9,28)=(-(params(2)/y(25)*(1-y(20))));
g1(9,20)=(-(params(2)/y(25)*(-y(28))));
g1(10,18)=(-params(9));
g1(10,19)=1;
g1(11,29)=(-1);
g1(11,20)=1;
g1(11,6)=(-1);
g1(11,7)=(-1);
g1(11,8)=(-1);
g1(11,9)=(-1);
g1(12,29)=(-1);
g1(12,21)=1;
g1(13,6)=(-1);
g1(13,22)=1;
g1(14,7)=(-1);
g1(14,23)=1;
g1(15,8)=(-1);
g1(15,24)=1;

end
