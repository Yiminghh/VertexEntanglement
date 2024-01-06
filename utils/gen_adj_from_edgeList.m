function [A,N,M] = gen_adj_from_edgeList(edgeList_file)
% 读取无向无权图，生成其邻接矩阵
% edgeList_file: 边列表
% A: 邻接矩阵
% N: 节点数
% M: 边数
% edgeList_file = fullfile('..','data','email','edges.txt');
edges = load(edgeList_file);
M=length(edges);
N=max(edges(:));
A=zeros(N);
for i = 1:M
    a = edges(i,1);
    b = edges(i,2);
    if a == b
      continue
    end
    A(a,b) = 1;
    A(b,a) = 1;
end

end

%%


