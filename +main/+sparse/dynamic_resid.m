function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(5, 1);
end
[T_order, T] = main.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(15, 1);
    residual(1) = (T(1)*(1+params(12)*(y(17)/y(3)-params(3)))) - (T(2)*(1+y(35)-params(3)+params(12)*(y(32)/y(18)-params(3))));
    residual(2) = (y(21)/y(16)) - (params(5)*y(19)^params(4));
    residual(3) = (y(17)) - (y(18)-y(3)*(1-params(3)-params(7)*y(23)));
    residual(4) = (y(24)) - (y(17)+y(16)+(1+y(10)*(1-y(11)))*y(9)-y(22));
    residual(5) = (y(22)) - (T(4)*T(5));
    residual(6) = (y(20)) - (y(22)*params(1)/y(3));
    residual(7) = (y(21)) - (y(22)*(1-params(1))/y(19));
    residual(8) = (y(23)) - (params(6)*y(8)+x(1));
    residual(9) = (T(1)) - (params(2)/y(31)*(1+y(40)*(1-y(26))));
    residual(10) = (y(25)) - (params(11)+params(9)*(y(24)-params(10)));
    residual(11) = (y(26)) - (x(1)+y(12)+y(13)+y(14)+y(15));
    residual(12) = (y(27)) - (x(1));
    residual(13) = (y(28)) - (y(12));
    residual(14) = (y(29)) - (y(13));
    residual(15) = (y(30)) - (y(14));
end
