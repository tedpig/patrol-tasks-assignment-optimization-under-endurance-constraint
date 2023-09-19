 
 
%pop——种群数量
%dim——问题维度
%ub——变量上界，[1,dim]矩阵
%lb——变量下界，[1,dim]矩阵
%fobj——适应度函数（指针）
%MaxIter——最大迭代次数
%Best_Pos——x的最佳值
%Best_Score——最优适应度值
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
City_Number=25;         %城市数量
USV_num=4;
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
Y=[Y,zeros(1,num_T)];
Z=[Z,zeros(1,num_T)];
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
fobj=@(race, city_distance, num_T)ga_adaptation(race, city_distance, num_T);%设置适应度函数
N=City_Number;

pop=50;%萤火虫数目
gamma=0.1;%光强吸收系数
T_max=100;%最大迭代次数
K=50;%混沌迭代次数
ew=0.2;%选取精英比例


[Best_Pos,Best_Score,IterCurve]=FA(pop,N,city_distance, num_T,fobj,100);
%…………………………………………绘图…………………………………………
figure(1);
plot(IterCurve,'r-','linewidth',2);
grid on;
title('萤火虫算法迭代曲线');
xlabel('迭代次数');
ylabel('适应度值');
%…………………………………… 结果显示……………………………………
disp(['求解得到的x1，x2是:',num2str(Best_Pos(1)),' ',num2str(Best_Pos(2))]);
disp(['最优解对应的函数:',num2str(Best_Score)]);
 
%…………………………………………萤火虫算法主体………………………………………
function [Best_Pos,Best_Score,IterCurve]=FA(pop,dim,city_distance, num_T,fobj,MaxIter)
  beta0=2;%最大吸引度β0
  gamma=1;%光吸收强度系数γ
  alpha=0.2;%步长因子
  %dmax=norm(ub-lb);%返回上下界的2范数，用于后面的距离归一化计算
  x=initialization(pop,dim);%种群初始化
  Fitness=zeros(1,pop);%适应度值初始化
  for i=1:pop
      Fitness(i)=fobj(x(i,:),city_distance, num_T);%计算适应度值
  end
  [~,Index]=min(Fitness);%寻找适应度值最小的位置
  Global_Best_Pos=x(Index,:);
  Global_Best_Score=Fitness(Index);
  x_new=x;%用于记录新位置
  for t=1:MaxIter
      for i=1:pop
          for j=1:dim
              if Fitness(j)<Fitness(i)
                  r_ij=norm(x(i,:)-x(j,:))./dmax;%计算2范数，即距离
                  beta=beta0*exp(-gamma*r_ij^2);
                  Pos_new=x(i,:)+beta*(x(j,:)-x(i,:))+alpha.*rand(1,dim);
                  Pos_new=BoundrayCheck(Pos_new,ub,lb,dim);
                  Fitness_new=fobj(Pos_new);
                  if Fitness_new<Fitness(i)
                      x_new(i,:)=Pos_new;
                      Fitness(i)=Fitness_new;
                      if Fitness_new<Global_Best_Score
                          Global_Best_Score=Fitness_new;
                          Global_Best_Pos=Pos_new;
                      end
                  end
              end
          end%结束j循环
      end%结束i循环
      x_double=[x;x_new];%将更新后的x_new和历史的x合并组成2*pop只萤火虫
      for i=1:2*pop
          Fitness_double(i)=fobj(x_double(i,:));
      end
      [~,SortIndex]=sort(Fitness_double);%适应度重新排序
      for k=1:pop  %选取适应度靠前的pop只萤火虫，作为下次循环的种群
          x(k,:)=x_double(SortIndex(k),:);
      end%结束k循环
      IterCurve(t)=Global_Best_Score;
  end%结束t循环
  Best_Pos=Global_Best_Pos;
  Best_Score=Global_Best_Score;
end

function x=initialization(NP,City_Number)
[temp,z]=chaotic_op(NP,City_Number);
for i=1:NP                        %初始化种群
    route=[City_Number+1,temp(i,:),City_Number+1];
    x(i,:)=route;
end
end