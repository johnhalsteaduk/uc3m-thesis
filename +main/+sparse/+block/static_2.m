function [y, T, residual, g1] = static_2(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(7, 1);
  residual(1)=(y(6)/y(1))-(params(6)*y(4)^params(4));
  residual(2)=(y(2))-(y(3)-y(3)*(1-params(3)-params(8)*y(8)));
  residual(3)=(y(7))-(y(1)+y(2));
  T(1)=exp(y(8)*(-params(9)));
  T(2)=T(1)*y(3)^params(1);
  T(3)=y(4)^(1-params(1));
  residual(4)=(y(7))-(T(2)*T(3));
  residual(5)=(y(5))-(y(7)*params(1)/y(3));
  residual(6)=(y(6))-(y(7)*(1-params(1))/y(4));
  residual(7)=(1/y(1))-(params(2)/y(1)*(1+y(5)-params(3)));
if nargout > 3
    g1_v = NaN(19, 1);
g1_v(1)=(-(params(6)*getPowerDeriv(y(4),params(4),1)));
g1_v(2)=(-(T(2)*getPowerDeriv(y(4),1-params(1),1)));
g1_v(3)=(-((-(y(7)*(1-params(1))))/(y(4)*y(4))));
g1_v(4)=1;
g1_v(5)=(-1);
g1_v(6)=(-y(6))/(y(1)*y(1));
g1_v(7)=(-1);
g1_v(8)=(-1)/(y(1)*y(1))-(1+y(5)-params(3))*(-params(2))/(y(1)*y(1));
g1_v(9)=1;
g1_v(10)=1;
g1_v(11)=(-(params(1)/y(3)));
g1_v(12)=(-((1-params(1))/y(4)));
g1_v(13)=(-(1-(1-params(3)-params(8)*y(8))));
g1_v(14)=(-(T(3)*T(1)*getPowerDeriv(y(3),params(1),1)));
g1_v(15)=(-((-(y(7)*params(1)))/(y(3)*y(3))));
g1_v(16)=1/y(1);
g1_v(17)=1;
g1_v(18)=1;
g1_v(19)=(-(params(2)/y(1)));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 7, 7);
end
end
