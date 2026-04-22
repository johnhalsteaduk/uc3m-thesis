function [g1, T_order, T] = dynamic_g1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T_order, T)
if nargin < 9
    T_order = -1;
    T = NaN(3, 1);
end
[T_order, T] = main.sparse.dynamic_g1_tt(y, x, params, steady_state, T_order, T);
g1_v = NaN(25, 1);
g1_v(1)=(-params(5));
g1_v(2)=1-params(3);
g1_v(3)=(-(T(2)*exp(y(9))*getPowerDeriv(y(4),params(1),1)));
g1_v(4)=(-((-(y(16)*params(1)))/(y(4)*y(4))));
g1_v(5)=(-T(3));
g1_v(6)=1;
g1_v(7)=(-1)/(y(10)*y(10));
g1_v(8)=(-y(15))/(y(10)*y(10));
g1_v(9)=(-1);
g1_v(10)=1;
g1_v(11)=(-1);
g1_v(12)=(-1);
g1_v(13)=(-(params(6)*getPowerDeriv(y(13),params(4),1)));
g1_v(14)=(-(T(1)*getPowerDeriv(y(13),1-params(1),1)));
g1_v(15)=(-((-(y(16)*(1-params(1))))/(y(13)*y(13))));
g1_v(16)=1;
g1_v(17)=1/y(10);
g1_v(18)=1;
g1_v(19)=1;
g1_v(20)=1;
g1_v(21)=(-(params(1)/y(4)));
g1_v(22)=(-((1-params(1))/y(13)));
g1_v(23)=(-((1+y(22)-params(3))*(-params(2))/(y(18)*y(18))));
g1_v(24)=(-(params(2)/y(18)));
g1_v(25)=1;
if ~isoctave && matlab_ver_less_than('9.8')
    sparse_rowval = double(sparse_rowval);
    sparse_colval = double(sparse_colval);
end
g1 = sparse(sparse_rowval, sparse_colval, g1_v, 8, 25);
end
