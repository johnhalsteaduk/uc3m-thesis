function [g1, T_order, T] = dynamic_g1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T_order, T)
if nargin < 9
    T_order = -1;
    T = NaN(4, 1);
end
[T_order, T] = rbc_mvp.sparse.dynamic_g1_tt(y, x, params, steady_state, T_order, T);
g1_v = NaN(31, 1);
g1_v(1)=(-params(5));
g1_v(2)=1-params(3);
g1_v(3)=(-(T(3)*T(2)*exp(y(11))*getPowerDeriv(y(4),params(1),1)));
g1_v(4)=(-((-(y(18)*params(1)))/(y(4)*y(4))));
g1_v(5)=(-(T(1)*T(2)*getPowerDeriv(y(9),params(8),1)));
g1_v(6)=(-(1-params(3)-params(9)));
g1_v(7)=(-T(4));
g1_v(8)=1;
g1_v(9)=(-1)/(y(12)*y(12));
g1_v(10)=(-y(17))/(y(12)*y(12));
g1_v(11)=(-1);
g1_v(12)=1;
g1_v(13)=(-1);
g1_v(14)=(-1);
g1_v(15)=(-(params(6)*getPowerDeriv(y(15),params(4),1)));
g1_v(16)=(-(T(3)*T(1)*getPowerDeriv(y(15),1-params(1),1)));
g1_v(17)=(-((-(y(18)*(1-params(1))))/(y(15)*y(15))));
g1_v(18)=1;
g1_v(19)=1/y(12);
g1_v(20)=1;
g1_v(21)=1;
g1_v(22)=1;
g1_v(23)=(-params(7));
g1_v(24)=(-(params(1)/y(4)));
g1_v(25)=(-((1-params(1))/y(15)));
g1_v(26)=1;
g1_v(27)=(-(1-params(10)));
g1_v(28)=1;
g1_v(29)=(-((1+y(26)-params(3))*(-params(2))/(y(22)*y(22))));
g1_v(30)=(-(params(2)/y(22)));
g1_v(31)=1;
if ~isoctave && matlab_ver_less_than('9.8')
    sparse_rowval = double(sparse_rowval);
    sparse_colval = double(sparse_colval);
end
g1 = sparse(sparse_rowval, sparse_colval, g1_v, 10, 31);
end
