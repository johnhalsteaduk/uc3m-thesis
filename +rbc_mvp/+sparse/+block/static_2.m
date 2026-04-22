function [y, T, residual, g1] = static_2(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(9, 1);
  residual(1)=(y(7)/y(2))-(params(6)*y(5)^params(4));
  residual(2)=(y(3))-(y(4)-y(4)*(1-params(3)));
  residual(3)=(y(8))-(y(2)+y(3));
  T(1)=exp(y(1));
  T(2)=T(1)*y(4)^params(1);
  T(3)=y(5)^(1-params(1));
  T(4)=T(2)*T(3);
  T(5)=y(9)^params(8);
  residual(4)=(y(8))-(T(4)*T(5));
  residual(5)=(y(9))-(y(9)*(1-params(3)-params(9))+(1-params(10))*y(10));
  residual(6)=(y(10))-(y(8)*params(7));
  residual(7)=(y(6))-(y(8)*params(1)/y(4));
  residual(8)=(y(7))-(y(8)*(1-params(1))/y(5));
  residual(9)=(1/y(2))-(params(2)/y(2)*(1+y(6)-params(3)));
if nargout > 3
    g1_v = NaN(24, 1);
g1_v(1)=(-(params(6)*getPowerDeriv(y(5),params(4),1)));
g1_v(2)=(-(T(5)*T(2)*getPowerDeriv(y(5),1-params(1),1)));
g1_v(3)=(-((-(y(8)*(1-params(1))))/(y(5)*y(5))));
g1_v(4)=1;
g1_v(5)=(-1);
g1_v(6)=(-y(7))/(y(2)*y(2));
g1_v(7)=(-1);
g1_v(8)=(-1)/(y(2)*y(2))-(1+y(6)-params(3))*(-params(2))/(y(2)*y(2));
g1_v(9)=1;
g1_v(10)=1;
g1_v(11)=(-params(7));
g1_v(12)=(-(params(1)/y(4)));
g1_v(13)=(-((1-params(1))/y(5)));
g1_v(14)=(-(T(4)*getPowerDeriv(y(9),params(8),1)));
g1_v(15)=1-(1-params(3)-params(9));
g1_v(16)=(-(1-params(10)));
g1_v(17)=1;
g1_v(18)=(-(1-(1-params(3))));
g1_v(19)=(-(T(5)*T(3)*T(1)*getPowerDeriv(y(4),params(1),1)));
g1_v(20)=(-((-(y(8)*params(1)))/(y(4)*y(4))));
g1_v(21)=1/y(2);
g1_v(22)=1;
g1_v(23)=1;
g1_v(24)=(-(params(2)/y(2)));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 9, 9);
end
end
