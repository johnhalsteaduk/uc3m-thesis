function [residual, T_order, T] = dynamic_resid(y, x, params, steady_state, T_order, T)
if nargin < 6
    T_order = -1;
    T = NaN(4, 1);
end
[T_order, T] = rbc_mvp.sparse.dynamic_resid_tt(y, x, params, steady_state, T_order, T);
residual = NaN(10, 1);
    residual(1) = (1/y(12)) - (params(2)/y(22)*(1+y(26)-params(3)));
    residual(2) = (y(17)/y(12)) - (params(6)*y(15)^params(4));
    residual(3) = (y(13)) - (y(14)-(1-params(3))*y(4));
    residual(4) = (y(18)) - (y(12)+y(13));
    residual(5) = (y(18)) - (T(4));
    residual(6) = (y(19)) - (y(9)*(1-params(3)-params(9))+(1-params(10))*y(20));
    residual(7) = (y(20)) - (y(18)*params(7));
    residual(8) = (y(16)) - (y(18)*params(1)/y(4));
    residual(9) = (y(17)) - (y(18)*(1-params(1))/y(15));
    residual(10) = (y(11)) - (params(5)*y(1)-x(1));
end
