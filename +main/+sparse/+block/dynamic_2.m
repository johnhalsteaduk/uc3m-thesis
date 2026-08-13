function [y, T, residual, g1] = dynamic_2(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
residual=NaN(7, 1);
  residual(1)=(y(14)/y(9))-(params(6)*y(12)^params(4));
  residual(2)=(y(15))-(y(9)+y(10));
  T(1)=exp(y(16)*(-params(9)));
  T(2)=T(1)*y(3)^params(1);
  T(3)=y(12)^(1-params(1));
  residual(3)=(y(15))-(T(2)*T(3));
  residual(4)=(y(14))-(y(15)*(1-params(1))/y(12));
  residual(5)=(y(10))-(y(11)-(1-params(3)-params(8)*y(16))*y(3));
  residual(6)=(y(13))-(y(15)*params(1)/y(3));
  residual(7)=(1/y(9))-(params(2)/y(17)*(1+y(21)-params(3)));
if nargout > 3
    g1_v = NaN(21, 1);
g1_v(1)=(-(T(3)*T(1)*getPowerDeriv(y(3),params(1),1)));
g1_v(2)=1-params(3)-params(8)*y(16);
g1_v(3)=(-((-(y(15)*params(1)))/(y(3)*y(3))));
g1_v(4)=1/y(9);
g1_v(5)=1;
g1_v(6)=(-1);
g1_v(7)=1;
g1_v(8)=(-(params(6)*getPowerDeriv(y(12),params(4),1)));
g1_v(9)=(-(T(2)*getPowerDeriv(y(12),1-params(1),1)));
g1_v(10)=(-((-(y(15)*(1-params(1))))/(y(12)*y(12))));
g1_v(11)=1;
g1_v(12)=1;
g1_v(13)=(-((1-params(1))/y(12)));
g1_v(14)=(-(params(1)/y(3)));
g1_v(15)=(-1);
g1_v(16)=1;
g1_v(17)=(-y(14))/(y(9)*y(9));
g1_v(18)=(-1);
g1_v(19)=(-1)/(y(9)*y(9));
g1_v(20)=(-(params(2)/y(17)));
g1_v(21)=(-((1+y(21)-params(3))*(-params(2))/(y(17)*y(17))));
    if ~isoctave && matlab_ver_less_than('9.8')
        sparse_rowval = double(sparse_rowval);
        sparse_colval = double(sparse_colval);
    end
    g1 = sparse(sparse_rowval, sparse_colval, g1_v, 7, 21);
end
end
