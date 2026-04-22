function [T_order, T] = dynamic_resid_tt(y, x, params, steady_state, T_order, T)
if T_order >= 0
    return
end
T_order = 0;
if size(T, 1) < 4
    T = [T; NaN(4 - size(T, 1), 1)];
end
T(1) = exp(y(11))*y(4)^params(1);
T(2) = y(15)^(1-params(1));
T(3) = y(9)^params(8);
T(4) = T(1)*T(2)*T(3);
end
