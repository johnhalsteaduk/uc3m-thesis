function [y, T] = dynamic_1(y, x, params, steady_state, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(23)=params(6)*y(8)+x(1);
  y(27)=x(1);
  y(28)=y(12);
  y(29)=y(13);
  y(30)=y(14);
  y(26)=x(1)+y(12)+y(13)+y(14)+y(15);
end
