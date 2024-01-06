
% Path='D:\NetEntanglement\600spar1\';
% Netname='29540';
clear;clc;
Path=fullfile('..','results');
Netname='crime';

%load([Path,Netname,'\data.mat'])
[A,N,M]=gen_adj_from_edgeList(fullfile(Path,Netname,'edges.txt'));

L=Lapace(A);
[V,D]=eig(L);%原始网络的特征值
lambda=diag(D);
D=sum(A);
THE=0.01;
%%
lambda_path = fullfile(Path, Netname,'lambda_VER.mat');

if ~exist(lambda_path,'file')
    
    lambda_ral=zeros(N);
    for x=1:N %删除不同的节点
        disp(['calculating lambda for node ', num2str(x)])
        % 构造扰动网络的邻接矩阵(新)
          
        dA=zeros(N);
        neibour = ( A(x,:)>0 );%寻找节点x的邻居
        kx = D(x);%邻居节点个数
        A_loc = A(neibour,neibour);
        N_loc= kx + sum(A_loc(:))/2;%局部子图所包含的边数=kx+邻居节点直接互相连接的边数
        weight=2*N_loc/kx/(kx+1);%C_(kx+1)^2
        if weight==1
            lambda_ral(x,:)=lambda;
            continue;
        end
        neibour(x)=1;%将节点自己也包括进去
        dA=weight-A(neibour,neibour);%代表邻接矩阵变化了多少 %效果较好

        dA=dA-diag(diag(dA));%确保邻接矩阵的对角线为0
        dL=Lapace(dA);
        for j=1:N
            lambda_ral(x,j)=lambda(j)+V(neibour,j)'*dL*V(neibour,j);
        end
    end
    save(lambda_path,'lambda_ral')
else
    disp('local lambda.')
    load(lambda_path)
end

%% 计算原始网络在不同beta值时的谱熵
% belta=linspace(lambda(1),1/lambda(2),100);
% belta= [belta(1:end-1) ,linspace(belta(end),10/lambda(2),50)];
belta=linspace(lambda(1),5/lambda(2),100);
belta= [belta(1:end-1) ,linspace(belta(end),10/lambda(2),100)];


S=zeros(size(belta));
for i=1:length(belta)
    b=belta(i);
    Z=sum(exp(-b*lambda));
    t=-b*lambda;
    S(i)=-sum(  exp(t).*(t/log(2)-log2(Z))/Z   );
end
%%
E=zeros(length(belta),N);
for x=1:N
    xl_=lambda_ral(x,:);
    for i=1:length(belta)
        b=belta(i);
        Z=sum(exp(-b*xl_));
        t=-b*xl_;
        E(i,x)= -sum(  exp(t).*(t/log(2)-log2(Z))/Z   ) - S(i);
    end
end
ent=min(E);
%save(strcat(Path,Netname,'\ent.mat'),'ent')
% plot(E)

%% 写文件

LCC=GCC_curve(A,delque);
THE_n = THE*N;
if THE_n<=2
    THE_n=2;
end
targersize=sum(LCC>THE_n)+1;%+1;%+1是后加的
delque = delque(1:targersize);
LCC = LCC(1:targersize);
% %% 写入节点纠缠度的值
file=fopen(fullfile(Path,Netname,'VE_value.txt'),'wt'); %写的方式打开文件（若不存在，建立文件）；
fprintf(file,'%.16f\n',ent);
fclose(file);
% % % 写入移除节点的列表
file=fopen(fullfile(Path,Netname,'VE_nodelist.txt'),'wt'); %写的方式打开文件（若不存在，建立文件）；
fprintf(file,'%d\n',delque');
fclose(file);
% 写入相应的GCC变化
file=fopen(fullfile(Path,Netname,'VE_gcc.txt'),'wt'); %写的方式打开文件（若不存在，建立文件）；
fprintf(file,'%d\n',LCC');
fclose(file);



