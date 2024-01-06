function [ GCC_list ] = GCC_curve( A,delete_que )
%%
% A：邻接矩阵
% delete_que:删除节点顺序
% GCC_list：GCC的变化数据
%%
N=length(A);
[ GCC_org,que,connected_head ] = GCC( A );
tag=zeros(1,N);
connected_num=length(connected_head)-1;
components=[];

for i=1:connected_num  
    components{i} = que(connected_head(i):connected_head(i+1)-1);
    tag(components{i})=i;
end
%%

n=length(delete_que);
if n>=N
    GCC_list=zeros(1,N-1);%确保不会将所有节点都删除
else
    GCC_list=zeros(1,n);
end
%%
for i=1:length(delete_que)   
    del_node = delete_que(i);               % 待删除的节点  
    sub = sort(components{tag(del_node)});  % 该节点所在的连通子图
    %若删除的是孤立节点
    if length(sub)<=1
        if i>1
            GCC_list(i)=GCC_list(i-1);
        else
            GCC_list(i)=GCC_org;
        end
        continue;
    end
    components{tag(del_node)} = del_node;
    sub(sub==del_node)=[];                  %在子图中删去待删除的节点
    subA = A(sub,sub);                      %子图的邻接矩阵
    [ GCC_list(i),que,connected_head ] = GCC( subA );
    % 更新连通分支
    for j=connected_num+[1:length(connected_head)-1];        
        components{j} = sub(que(connected_head(j-connected_num):connected_head(j-connected_num+1)-1));
        tag(components{j})= j;
    end
    % 判断图中是否存相较于，删除一个节点得到的最大连通分支，更大的连通分支
    for k=1:connected_num
        GCC_list(i) = max(GCC_list(i),length(  components{k}   ));
    end
    % 更新连通分支数量
    connected_num = connected_num + length(connected_head)-1;    
    %只剩孤立节点，推出循环
    if GCC_list(i)<=1
        GCC_list(i:end)=1;
        break;
    end
end

end