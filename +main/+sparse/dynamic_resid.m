function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(3, 1);
end
[T_order, T] = main.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(8, 1);
    residual(1) = (1/y(9)) - (params(2)/y(17)*(1+y(21)-params(3)));
    residual(2) = (y(14)/y(9)) - (params(6)*y(12)^params(4));
    residual(3) = (y(10)) - (y(11)-(1-params(3)-params(8)*y(16))*y(3));
    residual(4) = (y(15)) - (y(9)+y(10));
    residual(5) = (y(15)) - (T(2)*T(3));
    residual(6) = (y(13)) - (y(15)*params(1)/y(3));
    residual(7) = (y(14)) - (y(15)*(1-params(1))/y(12));
    residual(8) = (y(16)) - (params(7)*y(8)+x(1));
end
