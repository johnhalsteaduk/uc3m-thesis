function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(7, 1);
  y(20)=y(18)*params(7);
  y(17)=y(18)*(1-params(1))/y(15);
  residual(1)=(y(17)/y(12))-(params(6)*y(15)^params(4));
  residual(2)=(y(18))-(y(12)+y(13));
  T(1)=exp(y(11));
  T(2)=T(1)*y(4)^params(1);
  T(3)=y(15)^(1-params(1));
  T(4)=y(9)^params(8);
  residual(3)=(y(18))-(T(2)*T(3)*T(4));
  residual(4)=(y(13))-(y(14)-(1-params(3))*y(4));
  residual(5)=(y(19))-(y(9)*(1-params(3)-params(9))+(1-params(10))*y(20));
  residual(6)=(y(16))-(y(18)*params(1)/y(4));
  residual(7)=(1/y(12))-(params(2)/y(22)*(1+y(26)-params(3)));
if nargout > 3
    g1_v = NaN(22, 1);
g1_v(1)=(-(T(4)*T(3)*T(1)*getPowerDeriv(y(4),params(1),1)));
g1_v(2)=1-params(3);
g1_v(3)=(-((-(y(18)*params(1)))/(y(4)*y(4))));
g1_v(4)=(-(T(2)*T(3)*getPowerDeriv(y(9),params(8),1)));
g1_v(5)=(-(1-params(3)-params(9)));
g1_v(6)=(-(y(18)*(1-params(1))))/(y(15)*y(15))/y(12)-params(6)*getPowerDeriv(y(15),params(4),1);
g1_v(7)=(-(T(4)*T(2)*getPowerDeriv(y(15),1-params(1),1)));
g1_v(8)=(-1);
g1_v(9)=1;
g1_v(10)=(1-params(1))/y(15)/y(12);
g1_v(11)=1;
g1_v(12)=1;
g1_v(13)=(-((1-params(10))*params(7)));
g1_v(14)=(-(params(1)/y(4)));
g1_v(15)=(-1);
g1_v(16)=1;
g1_v(17)=1;
g1_v(18)=(-y(17))/(y(12)*y(12));
g1_v(19)=(-1);
g1_v(20)=(-1)/(y(12)*y(12));
g1_v(21)=(-(params(2)/y(22)));
g1_v(22)=(-((1+y(26)-params(3))*(-params(2))/(y(22)*y(22))));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 7, 21);
end
end
