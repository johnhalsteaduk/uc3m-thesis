function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(3, 1);
end
[T_order, T] = main.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(8, 1);
    residual(1) = (1/y(10)) - (params(2)/y(18)*(1+y(22)-params(3)));
    residual(2) = (y(15)/y(10)) - (params(6)*y(13)^params(4));
    residual(3) = (y(11)) - (y(12)-(1-params(3))*y(4));
    residual(4) = (y(16)) - (y(10)+y(11));
    residual(5) = (y(16)) - (T(3));
    residual(6) = (y(14)) - (y(16)*params(1)/y(4));
    residual(7) = (y(15)) - (y(16)*(1-params(1))/y(13));
    residual(8) = (y(9)) - (params(5)*y(1)-x(1));
end
