function [y, T] = static_2(y, x, params, sparse_rowval, sparse_colval, sparse_colptr, T)
  y(12)=x(1);
  y(13)=y(12);
  y(14)=y(13);
  y(15)=y(14);
  y(11)=x(1)+y(12)+y(13)+y(14)+y(15);
end
