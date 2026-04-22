function [y, T, residual, g1] = static_2(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(7, 1);
  residual(1)=(y(7)/y(2))-(params(6)*y(5)^params(4));
  residual(2)=(y(3))-(y(4)-y(4)*(1-params(3)));
  residual(3)=(y(8))-(y(2)+y(3));
  T(1)=exp(y(1));
  T(2)=T(1)*y(4)^params(1);
  T(3)=y(5)^(1-params(1));
  residual(4)=(y(8))-(T(2)*T(3));
  residual(5)=(y(6))-(y(8)*params(1)/y(4));
  residual(6)=(y(7))-(y(8)*(1-params(1))/y(5));
  residual(7)=(1/y(2))-(params(2)/y(2)*(1+y(6)-params(3)));
if nargout > 3
    g1_v = NaN(19, 1);
g1_v(1)=1/y(2);
g1_v(2)=1;
g1_v(3)=1;
g1_v(4)=(-1);
g1_v(5)=(-y(7))/(y(2)*y(2));
g1_v(6)=(-1);
g1_v(7)=(-1)/(y(2)*y(2))-(1+y(6)-params(3))*(-params(2))/(y(2)*y(2));
g1_v(8)=1;
g1_v(9)=1;
g1_v(10)=(-(params(1)/y(4)));
g1_v(11)=(-((1-params(1))/y(5)));
g1_v(12)=(-(1-(1-params(3))));
g1_v(13)=(-(T(3)*T(1)*getPowerDeriv(y(4),params(1),1)));
g1_v(14)=(-((-(y(8)*params(1)))/(y(4)*y(4))));
g1_v(15)=(-(params(6)*getPowerDeriv(y(5),params(4),1)));
g1_v(16)=(-(T(2)*getPowerDeriv(y(5),1-params(1),1)));
g1_v(17)=(-((-(y(8)*(1-params(1))))/(y(5)*y(5))));
g1_v(18)=1;
g1_v(19)=(-(params(2)/y(2)));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 7, 7);
end
end
