function [ L ] = Lapace( A )
%   ����������ڽӾ������ɶ�Ӧ��ͼ������˹����
D=diag(sum(A));
L=D-A;
end

