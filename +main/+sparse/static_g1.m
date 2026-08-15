function [g1, T_order, T] = static_g1(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T_order, T)
if nargin < 8
    T_order = -1;
    T = NaN(4, 1);
end
[T_order, T] = main.sparse.static_g1_tt(y, x, params, T_order, T);
g1_v = NaN(44, 1);
g1_v(1)=(1+params(12)*(y(2)/y(3)-params(3)))*(-1)/(y(1)*y(1))-(params(12)*(y(2)/y(3)-params(3))+1+y(5)-params(3))*params(2)*(-1)/(y(1)*y(1));
g1_v(2)=(-y(6))/(y(1)*y(1));
g1_v(3)=(-1);
g1_v(4)=(-1)/(y(1)*y(1))-(1+y(10)*(1-y(11)))*(-params(2))/(y(1)*y(1));
g1_v(5)=T(1)*params(12)*1/y(3)-T(1)*params(2)*params(12)*1/y(3);
g1_v(6)=1;
g1_v(7)=(-1);
g1_v(8)=T(1)*params(12)*(-y(2))/(y(3)*y(3))-T(1)*params(2)*params(12)*(-y(2))/(y(3)*y(3));
g1_v(9)=(-(1-(1-params(3)-params(7)*y(8))));
g1_v(10)=(-(T(4)*exp(y(8)*(-params(8)))*getPowerDeriv(y(3),params(1),1)));
g1_v(11)=(-((-(y(7)*params(1)))/(y(3)*y(3))));
g1_v(12)=(-(params(5)*getPowerDeriv(y(4),params(4),1)));
g1_v(13)=(-(T(3)*getPowerDeriv(y(4),1-params(1),1)));
g1_v(14)=(-((-(y(7)*(1-params(1))))/(y(4)*y(4))));
g1_v(15)=(-(T(1)*params(2)));
g1_v(16)=1;
g1_v(17)=T(1);
g1_v(18)=1;
g1_v(19)=1;
g1_v(20)=1;
g1_v(21)=(-(params(1)/y(3)));
g1_v(22)=(-((1-params(1))/y(4)));
g1_v(23)=y(3)*(-params(7));
g1_v(24)=(-(T(4)*T(2)*(-params(8))*exp(y(8)*(-params(8)))));
g1_v(25)=1-params(6);
g1_v(26)=1-(1+y(10)*(1-y(11)));
g1_v(27)=(-params(9));
g1_v(28)=(-(y(9)*(1-y(11))));
g1_v(29)=(-((1-y(11))*params(2)/y(1)));
g1_v(30)=1;
g1_v(31)=(-(y(9)*(-y(10))));
g1_v(32)=(-(params(2)/y(1)*(-y(10))));
g1_v(33)=1;
g1_v(34)=(-1);
g1_v(35)=1;
g1_v(36)=(-1);
g1_v(37)=(-1);
g1_v(38)=1;
g1_v(39)=(-1);
g1_v(40)=(-1);
g1_v(41)=1;
g1_v(42)=(-1);
g1_v(43)=(-1);
g1_v(44)=1;
if ~isoctave && matlab_ver_less_than('9.8')
    sparse_rowval = double(sparse_rowval);
    sparse_colval = double(sparse_colval);
end
g1 = sparse(sparse_rowval, sparse_colval, g1_v, 15, 15);
end
