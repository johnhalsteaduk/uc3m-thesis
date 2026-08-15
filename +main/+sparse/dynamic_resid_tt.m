function [T_order, T] = dynamic_resid_tt(y, x, params, steady_state, T_order, T)
if T_order >= 0
    return
end
T_order = 0;
if size(T, 1) < 5
    T = [T; NaN(5 - size(T, 1), 1)];
end
T(1) = 1/y(16);
T(2) = params(2)*1/y(31);
T(3) = y(3)^params(1);
T(4) = exp(y(23)*(-params(8)))*T(3);
T(5) = y(19)^(1-params(1));
end
