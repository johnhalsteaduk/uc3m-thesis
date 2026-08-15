function [residual, T_order, T] = static_resid(y, x, params, T_order, T)
if nargin < 5
    T_order = -1;
    T = NaN(4, 1);
end
[T_order, T] = main.sparse.static_resid_tt(y, x, params, T_order, T);
residual = NaN(15, 1);
    residual(1) = (T(1)*(1+params(12)*(y(2)/y(3)-params(3)))) - (T(1)*params(2)*(params(12)*(y(2)/y(3)-params(3))+1+y(5)-params(3)));
    residual(2) = (y(6)/y(1)) - (params(5)*y(4)^params(4));
    residual(3) = (y(2)) - (y(3)-y(3)*(1-params(3)-params(7)*y(8)));
    residual(4) = (y(9)) - (y(2)+y(1)+y(9)*(1+y(10)*(1-y(11)))-y(7));
    residual(5) = (y(7)) - (T(3)*T(4));
    residual(6) = (y(5)) - (y(7)*params(1)/y(3));
    residual(7) = (y(6)) - (y(7)*(1-params(1))/y(4));
    residual(8) = (y(8)) - (y(8)*params(6)+x(1));
    residual(9) = (T(1)) - ((1+y(10)*(1-y(11)))*params(2)/y(1));
    residual(10) = (y(10)) - (params(11)+params(9)*(y(9)-params(10)));
    residual(11) = (y(11)) - (x(1)+y(12)+y(13)+y(14)+y(15));
    residual(12) = (y(12)) - (x(1));
    residual(13) = (y(13)) - (y(12));
    residual(14) = (y(14)) - (y(13));
    residual(15) = (y(15)) - (y(14));
end
