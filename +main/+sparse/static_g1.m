function [g1, T_order, T] = static_g1(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T_order, T)
if nargin < 8
    T_order = -1;
    T = NaN(3, 1);
end
[T_order, T] = main.sparse.static_g1_tt(y, x, params, T_order, T);
g1_v = NaN(22, 1);
g1_v(1)=(-1)/(y(1)*y(1))-(1+y(5)-params(3))*(-params(2))/(y(1)*y(1));
g1_v(2)=(-y(6))/(y(1)*y(1));
g1_v(3)=(-1);
g1_v(4)=1;
g1_v(5)=(-1);
g1_v(6)=(-(1-(1-params(3)-params(8)*y(8))));
g1_v(7)=(-(T(3)*exp(y(8)*(-params(9)))*getPowerDeriv(y(3),params(1),1)));
g1_v(8)=(-((-(y(7)*params(1)))/(y(3)*y(3))));
g1_v(9)=(-(params(6)*getPowerDeriv(y(4),params(4),1)));
g1_v(10)=(-(T(2)*getPowerDeriv(y(4),1-params(1),1)));
g1_v(11)=(-((-(y(7)*(1-params(1))))/(y(4)*y(4))));
g1_v(12)=(-(params(2)/y(1)));
g1_v(13)=1;
g1_v(14)=1/y(1);
g1_v(15)=1;
g1_v(16)=1;
g1_v(17)=1;
g1_v(18)=(-(params(1)/y(3)));
g1_v(19)=(-((1-params(1))/y(4)));
g1_v(20)=y(3)*(-params(8));
g1_v(21)=(-(T(3)*T(1)*(-params(9))*exp(y(8)*(-params(9)))));
g1_v(22)=1-params(7);
if ~isoctave && matlab_ver_less_than('9.8')
    sparse_rowval = double(sparse_rowval);
    sparse_colval = double(sparse_colval);
end
g1 = sparse(sparse_rowval, sparse_colval, g1_v, 8, 8);
end
