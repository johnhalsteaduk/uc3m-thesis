function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(8, 1);
  y(21)=y(22)*(1-params(1))/y(19);
  residual(1)=(y(21)/y(16))-(params(5)*y(19)^params(4));
  T(1)=exp(y(23)*(-params(8)));
  T(2)=T(1)*y(3)^params(1);
  T(3)=y(19)^(1-params(1));
  residual(2)=(y(22))-(T(2)*T(3));
  residual(3)=(1/y(16)*(1+params(12)*(y(17)/y(3)-params(3))))-(params(2)*1/y(31)*(1+y(35)-params(3)+params(12)*(y(32)/y(18)-params(3))));
  residual(4)=(y(24))-(y(17)+y(16)+(1+y(10)*(1-y(11)))*y(9)-y(22));
  residual(5)=(y(25))-(params(11)+params(9)*(y(24)-params(10)));
  residual(6)=(1/y(16))-(params(2)/y(31)*(1+y(40)*(1-y(26))));
  residual(7)=(y(20))-(y(22)*params(1)/y(3));
  residual(8)=(y(17))-(y(18)-y(3)*(1-params(3)-params(7)*y(23)));
if nargout > 3
    g1_v = NaN(30, 1);
g1_v(1)=(-(T(3)*T(1)*getPowerDeriv(y(3),params(1),1)));
g1_v(2)=1/y(16)*params(12)*(-y(17))/(y(3)*y(3));
g1_v(3)=(-((-(y(22)*params(1)))/(y(3)*y(3))));
g1_v(4)=1-params(3)-params(7)*y(23);
g1_v(5)=(-(1+y(10)*(1-y(11))));
g1_v(6)=(-((1-y(11))*y(9)));
g1_v(7)=(-(y(22)*(1-params(1))))/(y(19)*y(19))/y(16)-params(5)*getPowerDeriv(y(19),params(4),1);
g1_v(8)=(-(T(2)*getPowerDeriv(y(19),1-params(1),1)));
g1_v(9)=(1-params(1))/y(19)/y(16);
g1_v(10)=1;
g1_v(11)=1;
g1_v(12)=(-(params(1)/y(3)));
g1_v(13)=(-(params(2)*1/y(31)*params(12)*(-y(32))/(y(18)*y(18))));
g1_v(14)=(-1);
g1_v(15)=1;
g1_v(16)=(-params(9));
g1_v(17)=1;
g1_v(18)=(-y(21))/(y(16)*y(16));
g1_v(19)=(1+params(12)*(y(17)/y(3)-params(3)))*(-1)/(y(16)*y(16));
g1_v(20)=(-1);
g1_v(21)=(-1)/(y(16)*y(16));
g1_v(22)=1;
g1_v(23)=1/y(16)*params(12)*1/y(3);
g1_v(24)=(-1);
g1_v(25)=1;
g1_v(26)=(-(params(2)/y(31)*(1-y(26))));
g1_v(27)=(-((1+y(35)-params(3)+params(12)*(y(32)/y(18)-params(3)))*params(2)*(-1)/(y(31)*y(31))));
g1_v(28)=(-((1+y(40)*(1-y(26)))*(-params(2))/(y(31)*y(31))));
g1_v(29)=(-(params(2)*1/y(31)));
g1_v(30)=(-(params(2)*1/y(31)*params(12)*1/y(18)));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 8, 24);
end
end
