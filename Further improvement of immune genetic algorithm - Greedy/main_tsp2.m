
clear,clc
close all
tic;
global Y Z ST_P ST duration return_time
load city_location
load city_distance.mat
load city_path.mat
for i=1:length(nodes)
    for j=1:length(nodes)
        city_distance(j,i)=city_distance(i,j);
        city_path{j,i}=flip(city_path{i,j},1);
    end
end
city_distance=city_distance*1000/360;
city_location=nodes([2:26,1],:);
city_distance=city_distance([2:26,1],[2:26,1]);
city_path=city_path{[2:26,1],[2:26,1]};
source=26;              %始发点
City_Number=15;         %节点数量
USV_num=3;
return_time=1;          %最大返回数
num_T=return_time*USV_num;                %旅行商数量
NP=100;        %种群数量
G=300;                           %最大免疫代数
P_Cross=0.8;            %交叉概率
P_Mutation=0.2;         %变异概率
ST_P=[7	15	9	10	5	20	8	13	17	3	16	22	21	23	4	12	6	24	2	25	1	18	19	11	14];
ST=[33302	39120	39742	32929	32148	26845	33596	32180	26813	31152	23874	27103	39902	23817	37826	24653	23584	39359	29928	39404	20667	24234	28944	23348	31531];
duration=[16	17	17	18	13	19	20	18	17	13	18	16	19	13	17	14	20	12	12	13	15	19	14	14	16	10];
Y=[0	0	0	0	1	0	1	0	1	1	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0];
Z=[0	0	1	0	0	0	0	1	0	0	0	0	1	0	0	0	1	0	0	1	0	0	0	0	0];
for i=1:length(ST)
    if Y(i)==1
        ST(i)=int32(ST(i)/200);
    else
        ST(i)=int32(ST(i)/200);
    end
end
% ST_P=randperm(City_Number);
% ST=randi(20000,1,City_Number)+20000;%最晚允许到达时间
% duration=randi(10,1,City_Number)+10;
% Y=zeros(1,City_Number);
% Z=zeros(1,City_Number);
% Y(ST_P(1:5))=1;  %第2种任务
% Z(ST_P(6:10))=1; %第3种任务
Y=[Y(1:City_Number),zeros(1,num_T)];
Z=[Z(1:City_Number),zeros(1,num_T)];
ST=[ST,zeros(1,num_T)];
duration=[duration,15*ones(1,num_T)];
duration(end)=0;
city_distance1=zeros(City_Number+num_T,City_Number+num_T);
city_location1=zeros(City_Number+num_T,2);
city_distance1(1:City_Number,1:City_Number)=city_distance(1:City_Number,1:City_Number);
city_location1(1:City_Number,:)=city_location(1:City_Number,:);
city_location1(City_Number+1:City_Number+num_T,:)=repmat(city_location(source,:),num_T,1);
for i=1:num_T
   city_distance1(City_Number+i,1:City_Number)=city_distance(source,1:City_Number);
   city_distance1(1:City_Number,City_Number+i)=city_distance(1:City_Number,source);
end
city_distance=city_distance1;
City_Number=City_Number+num_T-1;
city_location=city_location1;
%race=zeros(Race_Number,City_Number+2);

[temp,z]=chaotic_op(NP,City_Number);
for i=1:NP                        %初始化种群
    route=[City_Number+1,temp(i,:),City_Number+1];
    f(:,i)=route';
end
%len=zeros(NP,1);                  %存储路径长度
len=ga_adaptation(f',city_distance,num_T);
% for k=1:size(f,2)
%    same=sum(logical(f(:,k)-f));
%    ND(k,1)=length(same(same==0))-1;
% end
% P=(len.*exp(-ND))./sum(len).*exp(-ND);
% Sortf=select(P,f,NP/2);
[Sortlen,Index]=sort(len');
Sortf=f(:,Index);                 %种群个体排序
gen=0;                            %免疫代数
Ncl=5;                            %克隆个数
%%%%%%%%%%%%%%%%%%%%%%%%%%%免疫循环%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N=City_Number;

while gen<G
   part1_f=Sortf(:,randperm(NP/2));
   for i=1:NP/2
       %%%%%%%%%%%%选激励度前NP/3个体进行免疫操作%%%%%%%%%%%%%%%
       a=part1_f(:,i);
       Ca=repmat(a,1,Ncl);
       alen(1)=ga_adaptation(a',city_distance,num_T);
       for j=2:Ncl
           p1=floor(2+N*rand());
           p2=floor(2+N*rand());
           while p1==p2
               p1=floor(2+N*rand());
               p2=floor(2+N*rand());
           end
           tmp=Ca(p1,j);
           Ca(p1,j)=Ca(p2,j);
           Ca(p2,j)=tmp;
           alen(j) = ga_adaptation(Ca(:,j)',city_distance,num_T);
       end
       [Calen,index]=min(alen);
       %Ca(:,1)=Sortf(:,i);            %保留克隆源个体
       %%%%%%%%%%%%克隆%%%%%%%%%%%%%%
       %alen(i) = ga_adaptation(Ca(:,j)',city_distance,num_T);
       SortCa=Ca(:,index);
       af(:,i)=SortCa;
       malen(i)=alen(index);
   end
%    for k=1:length(alen)
%        aND(k)=sum(sum(logical(af(:,k)-af)));
%    end
%    malen=mapminmax(alen,0,1)-E*mapminmax(aND,0,1);
   %%%%%%%%%%%%%%%%%%%%%%%%%%种群交叉%%%%%%%%%%%%%%%%%%%%%%%%%%
   naf=af(:,randperm(NP/2));
   %naf = ga_choose1( af',malen );
   %naf=naf';
   for i=1:2:NP/2
       b1=naf(:,i);
       b2=naf(:,i+1);         
       [b1,b2,a,b]=Crossover(b1',b2');
%        Colen1 = ga_adaptation(a,city_distance,num_T);
%        Colen2 = ga_adaptation(b,city_distance,num_T);
       %%%%%%%%%%%%克隆抑制，保留亲和度最高的个体%%%%%%%%%%%%%%
       %Cblen = ga_adaptation(Cb(:,j)',city_distance,num_T);
       %SortCb=Cb(:,2);
       bf(:,i)=a;
       bf(:,i+1)=b;
       mblen(i)=ga_adaptation(a,city_distance,num_T);
       mblen(i+1)=ga_adaptation(b,city_distance,num_T);
   end  
%    for k=1:length(blen)
%        %len(i)=ga_adaptation(f(:,i)',city_distance,num_T);
%        bND(k)=sum(sum(logical(bf(:,k)-bf)));
%    end
%    mblen=mapminmax(blen,0,1)-E*mapminmax( bND,0,1);
   %%%%%%%%%%%%%%%%%%%%%%%%%%种群刷新%%%%%%%%%%%%%%%%%%%%%%%%%%
   
   for i=1:NP/2
       [temp,z]=chaotic_op(NP/2,City_Number,z);
       %temp=randperm(City_Number);
       route=[City_Number+1,temp(i,:),City_Number+1];
       cf(:,i)=route';          %随机生成初始种群
       mclen(i)=ga_adaptation(cf(:,i)',city_distance,num_T);
          %计算路径长度
   end
%    for k=1:length(clen)
%        cND(k)=sum(sum(logical(cf(:,k)-cf)));
%    end
%    mclen=mapminmax(clen,0,1)-E*mapminmax( cND,0,1);
   %%%%%%%%%%%%%%%%%%%%免疫种群与新种群合并%%%%%%%%%%%%%%%%%%%%%

   %f=[af,bf,cf,Sortf(:,1:NP/2)];
   f=[af,bf,cf];
   len=[malen,mblen,mclen];
   %len=[malen,mblen,mclen,Sortlen(1:NP/2)];
   %len=ga_adaptation(f',city_distance,num_T);
%    for k=1:size(f,2)
%        same=sum(logical(f(:,k)-f));
%        ND(k,1)=length(same(same==0))-1;
%    end
%    P=(len.*exp(-ND))./sum(len).*exp(-ND);
%    Sortf=select(P,f,NP/2);
   [Sortlen,Index]=sort(len);
   Sortlen=Sortlen(1:NP);
   Sortf=f(:,Index(1:NP));
   [adaptation, dela_all, End_all,path_all]=ga_adaptation(Sortf(:,1)',city_distance,num_T);
   gen=gen+1;
   trace(gen,:)=[adaptation, dela_all, End_all,path_all];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%输出优化结果%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Bestf=Sortf(:,1);                 %最优变量
Bestf=f(:,Index(1));                 %最优变量
Bestlen=trace(end,:);               %最优值
figure
[bestpath,best_time,pathtime,check]=ga_plot(Bestf', city_distance, city_location, num_T);
title(['目标值优化:',num2str(trace(end,1))]);

figure,plot(trace(:,1),'.-')
xlabel('迭代次数')
ylabel('目标函数值')
title('亲和度进化曲线')

figure,plot(trace(:,2),'.-')
xlabel('迭代次数')
ylabel('目标函数1')
title('任务时间偏离变化曲线')


figure,plot(trace(:,3),'.-')
xlabel('迭代次数')
ylabel('目标函数2')
title('完成任务时间变化曲线')

figure,plot(trace(:,4),'.-')
xlabel('迭代次数')
ylabel('目标函数3')
title('各完成时间总和变化曲线')

%save('IA-GA.mat','trace','Bestf');
toc;