function [ L ] = Lapace( A )
%   根据输入的邻接矩阵生成对应的图拉普拉斯矩阵
D=diag(sum(A));
L=D-A;
end

