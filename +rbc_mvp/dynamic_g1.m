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
    T = rbc_mvp.dynamic_g1_tt(T, y, x, params, steady_state, it_);
end
g1 = zeros(10, 16);
g1(1,5)=(-1)/(y(5)*y(5));
g1(1,14)=(-((1+y(15)-params(3))*(-params(2))/(y(14)*y(14))));
g1(1,15)=(-(params(2)/y(14)));
g1(2,5)=(-y(10))/(y(5)*y(5));
g1(2,8)=(-(params(6)*getPowerDeriv(y(8),params(4),1)));
g1(2,10)=1/y(5);
g1(3,6)=1;
g1(3,2)=1-params(3);
g1(3,7)=(-1);
g1(4,5)=(-1);
g1(4,6)=(-1);
g1(4,11)=1;
g1(5,4)=(-T(4));
g1(5,2)=(-(T(3)*T(2)*exp(y(4))*getPowerDeriv(y(2),params(1),1)));
g1(5,8)=(-(T(3)*T(1)*getPowerDeriv(y(8),1-params(1),1)));
g1(5,11)=1;
g1(5,3)=(-(T(1)*T(2)*getPowerDeriv(y(3),params(8),1)));
g1(6,3)=(-(1-params(3)-params(9)));
g1(6,12)=1;
g1(6,13)=(-(1-params(10)));
g1(7,11)=(-params(7));
g1(7,13)=1;
g1(8,2)=(-((-(y(11)*params(1)))/(y(2)*y(2))));
g1(8,9)=1;
g1(8,11)=(-(params(1)/y(2)));
g1(9,8)=(-((-(y(11)*(1-params(1))))/(y(8)*y(8))));
g1(9,10)=1;
g1(9,11)=(-((1-params(1))/y(8)));
g1(10,1)=(-params(5));
g1(10,4)=1;
g1(10,16)=1;

end
