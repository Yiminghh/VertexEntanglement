function [ GCC,que,connected_head ] = GCC( A )
% solve ConnectedComponents
% GCC:最大连通分支大小
% connected_head
%
% ----------------------打印所有连通分支-----------------------------------
% for i=1:connected_num
%     que(connected_head(i):connected_head(i+1)-1)
% end
%% 找到所有连通分支
N=length(A);%节点数
connected_head=[1];         %记录每个连通分支的开始位置
node_flag=false(1,N);       %记录每个节点是否已经便利过了
que=zeros(1,N);             %模拟队列,也记录了连通分支的信息
%% 初始化
que(1)=1;%初始化队列中只有第一个节点
que_head=1;
que_tail=1;
node_flag(1)=true;
notChecked=1;
%%
while 1
    %队列中有元素
    if que_head<=que_tail 
        %出队             
        cur_node=que(que_head);%当前节点
        que_head=que_head+1;
        %入队
        nei=find(A(cur_node,:)==1);
        %遍历邻居节点
        for j=1:length(nei)
            %尚未入队的节点入队
            if node_flag(nei(j))==false 
                node_flag(nei(j))=true;
                que_tail=que_tail+1;
                que(que_tail)=nei(j);
            end          
        end
    %队列中无元素   
    else 
        %找到尚未遍历的节点
        notChecked = notChecked-1+find(node_flag(notChecked:end)==false,1);
        %没有尚未遍历节点，循环结束
        if isempty(notChecked)
            break;
        end
        %尚未遍历的节点入队
        node_flag(notChecked)=true;
        connected_head=[connected_head,que_head];
        que_tail=que_tail+1;
        que(que_tail)=notChecked;
    end
end
%%
connected_num=length(connected_head);                   %连通分支数量
connected_head=[connected_head,N+1];
GCC=max(connected_head(2:end)-connected_head(1:end-1)); %最大连通分支




end


