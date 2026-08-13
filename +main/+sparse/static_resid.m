function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(3, 1);
end
[T_order, T] = main.sparse.static_resid_tt(y, x, params, T_order, T);
residual = NaN(8, 1);
    residual(1) = (1/y(1)) - (params(2)/y(1)*(1+y(5)-params(3)));
    residual(2) = (y(6)/y(1)) - (params(6)*y(4)^params(4));
    residual(3) = (y(2)) - (y(3)-y(3)*(1-params(3)-params(8)*y(8)));
    residual(4) = (y(7)) - (y(1)+y(2));
    residual(5) = (y(7)) - (T(2)*T(3));
    residual(6) = (y(5)) - (y(7)*params(1)/y(3));
    residual(7) = (y(6)) - (y(7)*(1-params(1))/y(4));
    residual(8) = (y(8)) - (y(8)*params(7)+x(1));
end
