function [g1, T_order, T] = static_g1(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T_order, T)
if nargin < 8
    T_order = -1;
    T = NaN(4, 1);
end
[T_order, T] = rbc_mvp.sparse.static_g1_tt(y, x, params, T_order, T);
g1_v = NaN(26, 1);
g1_v(1)=(-T(4));
g1_v(2)=1-params(5);
g1_v(3)=(-1)/(y(2)*y(2))-(1+y(6)-params(3))*(-params(2))/(y(2)*y(2));
g1_v(4)=(-y(7))/(y(2)*y(2));
g1_v(5)=(-1);
g1_v(6)=1;
g1_v(7)=(-1);
g1_v(8)=(-(1-(1-params(3))));
g1_v(9)=(-(T(3)*T(2)*exp(y(1))*getPowerDeriv(y(4),params(1),1)));
g1_v(10)=(-((-(y(8)*params(1)))/(y(4)*y(4))));
g1_v(11)=(-(params(6)*getPowerDeriv(y(5),params(4),1)));
g1_v(12)=(-(T(3)*T(1)*getPowerDeriv(y(5),1-params(1),1)));
g1_v(13)=(-((-(y(8)*(1-params(1))))/(y(5)*y(5))));
g1_v(14)=(-(params(2)/y(2)));
g1_v(15)=1;
g1_v(16)=1/y(2);
g1_v(17)=1;
g1_v(18)=1;
g1_v(19)=1;
g1_v(20)=(-params(7));
g1_v(21)=(-(params(1)/y(4)));
g1_v(22)=(-((1-params(1))/y(5)));
g1_v(23)=(-(T(1)*T(2)*getPowerDeriv(y(9),params(8),1)));
g1_v(24)=1-(1-params(3)-params(9));
g1_v(25)=(-(1-params(10)));
g1_v(26)=1;
if ~isoctave && matlab_ver_less_than('9.8')
    sparse_rowval = double(sparse_rowval);
    sparse_colval = double(sparse_colval);
end
g1 = sparse(sparse_rowval, sparse_colval, g1_v, 10, 10);
end
