function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(4, 1);
end
[T_order, T] = rbc_mvp.sparse.static_resid_tt(y, x, params, T_order, T);
residual = NaN(10, 1);
    residual(1) = (1/y(2)) - (params(2)/y(2)*(1+y(6)-params(3)));
    residual(2) = (y(7)/y(2)) - (params(6)*y(5)^params(4));
    residual(3) = (y(3)) - (y(4)-y(4)*(1-params(3)));
    residual(4) = (y(8)) - (y(2)+y(3));
    residual(5) = (y(8)) - (T(4));
    residual(6) = (y(9)) - (y(9)*(1-params(3)-params(9))+(1-params(10))*y(10));
    residual(7) = (y(10)) - (y(8)*params(7));
    residual(8) = (y(6)) - (y(8)*params(1)/y(4));
    residual(9) = (y(7)) - (y(8)*(1-params(1))/y(5));
    residual(10) = (y(1)) - (y(1)*params(5)-x(1));
end
