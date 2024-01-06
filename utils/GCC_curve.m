function [ GCC_list ] = GCC_curve( A,delete_que )
%%
% A���ڽӾ���
% delete_que:ɾ���ڵ�˳��
% GCC_list��GCC�ı仯����
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
    GCC_list=zeros(1,N-1);%ȷ�����Ὣ���нڵ㶼ɾ��
else
    GCC_list=zeros(1,n);
end
%%
for i=1:length(delete_que)   
    del_node = delete_que(i);               % ��ɾ���Ľڵ�  
    sub = sort(components{tag(del_node)});  % �ýڵ����ڵ���ͨ��ͼ
    %��ɾ�����ǹ����ڵ�
    if length(sub)<=1
        if i>1
            GCC_list(i)=GCC_list(i-1);
        else
            GCC_list(i)=GCC_org;
        end
        continue;
    end
    components{tag(del_node)} = del_node;
    sub(sub==del_node)=[];                  %����ͼ��ɾȥ��ɾ���Ľڵ�
    subA = A(sub,sub);                      %��ͼ���ڽӾ���
    [ GCC_list(i),que,connected_head ] = GCC( subA );
    % ������ͨ��֧
    for j=connected_num+[1:length(connected_head)-1];        
        components{j} = sub(que(connected_head(j-connected_num):connected_head(j-connected_num+1)-1));
        tag(components{j})= j;
    end
    % �ж�ͼ���Ƿ������ڣ�ɾ��һ���ڵ�õ��������ͨ��֧���������ͨ��֧
    for k=1:connected_num
        GCC_list(i) = max(GCC_list(i),length(  components{k}   ));
    end
    % ������ͨ��֧����
    connected_num = connected_num + length(connected_head)-1;    
    %ֻʣ�����ڵ㣬�Ƴ�ѭ��
    if GCC_list(i)<=1
        GCC_list(i:end)=1;
        break;
    end
end

end