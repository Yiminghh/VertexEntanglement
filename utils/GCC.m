function [ GCC,que,connected_head ] = GCC( A )
% solve ConnectedComponents
% GCC:�����ͨ��֧��С
% connected_head
%
% ----------------------��ӡ������ͨ��֧-----------------------------------
% for i=1:connected_num
%     que(connected_head(i):connected_head(i+1)-1)
% end
%% �ҵ�������ͨ��֧
N=length(A);%�ڵ���
connected_head=[1];         %��¼ÿ����ͨ��֧�Ŀ�ʼλ��
node_flag=false(1,N);       %��¼ÿ���ڵ��Ƿ��Ѿ���������
que=zeros(1,N);             %ģ�����,Ҳ��¼����ͨ��֧����Ϣ
%% ��ʼ��
que(1)=1;%��ʼ��������ֻ�е�һ���ڵ�
que_head=1;
que_tail=1;
node_flag(1)=true;
notChecked=1;
%%
while 1
    %��������Ԫ��
    if que_head<=que_tail 
        %����             
        cur_node=que(que_head);%��ǰ�ڵ�
        que_head=que_head+1;
        %���
        nei=find(A(cur_node,:)==1);
        %�����ھӽڵ�
        for j=1:length(nei)
            %��δ��ӵĽڵ����
            if node_flag(nei(j))==false 
                node_flag(nei(j))=true;
                que_tail=que_tail+1;
                que(que_tail)=nei(j);
            end          
        end
    %��������Ԫ��   
    else 
        %�ҵ���δ�����Ľڵ�
        notChecked = notChecked-1+find(node_flag(notChecked:end)==false,1);
        %û����δ�����ڵ㣬ѭ������
        if isempty(notChecked)
            break;
        end
        %��δ�����Ľڵ����
        node_flag(notChecked)=true;
        connected_head=[connected_head,que_head];
        que_tail=que_tail+1;
        que(que_tail)=notChecked;
    end
end
%%
connected_num=length(connected_head);                   %��ͨ��֧����
connected_head=[connected_head,N+1];
GCC=max(connected_head(2:end)-connected_head(1:end-1)); %�����ͨ��֧




end


