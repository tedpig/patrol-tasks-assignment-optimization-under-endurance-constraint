
tic;
clear,clc
close all
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
source=26;              %ʼ����
USV_num=4;              %�������ͧ����
return_time=3;          %��󷵻���
num_T=return_time*USV_num;                %����������
City_Number=25;         %��������
Race_Number=100;        %��Ⱥ����
Iteration=300;          %��������
P_Cross=0.8;            %�������
P_Mutation=0.2;         %�������
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
% ST=randi(20000,1,City_Number)+20000;%����������ʱ��
% duration=randi(10,1,City_Number)+10;
% Y=zeros(1,City_Number);
% Z=zeros(1,City_Number);
% Y(ST_P(1:5))=1;  %��2������
% Z(ST_P(6:10))=1; %��3������
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
race=zeros(Race_Number,City_Number+2);

for i=1:Race_Number                         %��ʼ����Ⱥ
    temp=randperm(City_Number);
    route=[City_Number+1,temp,City_Number+1];
    %route=init_pop(City_Number, Y, Z, ST, duration, city_distance, num_T);
%    route=ga_hamilton(route, city_distance,num_T);         %ʹ�ø���Ȧ�㷨�Ż���ʼ��Ⱥ
    race(i,:)=route;
end
adaptation=ga_adaptation(race,city_distance,num_T);
p_adaptation=adaptation;
p_path=race;
[g_adaptation,ind]=min(p_adaptation);
g_path=race(ind,:);
for t=1:Iteration
    adaptation=ga_adaptation(race,city_distance,num_T);
    [~,index]=min(adaptation);
    g_path=race(index,:);
    race=ga_choose(race,adaptation);
    race=ga_cross(race,P_Cross);
    race=ga_mutation(race,P_Mutation,city_distance,num_T,g_adaptation);
    %race=ga_exchange(race,P_Cross);
    %race=ga_invert(race,P_Cross);
    [adaptation, dela_all, End_all,path_all]=ga_adaptation(g_path,city_distance,num_T);
    trace(t,:)=[adaptation, dela_all, End_all,path_all];
end
figure
Bestf=g_path';
[bestpath,best_time,pathtime,check]=ga_plot(g_path, city_distance, city_location, num_T);
title(['Ŀ��ֵ�Ż�:',num2str(trace(end,1))]);

figure,plot(trace(:,1),'.-')
xlabel('��������')
ylabel('Ŀ�꺯��ֵ')
title('�׺ͶȽ�������')

figure,plot(trace(:,2),'.-')
xlabel('��������')
ylabel('Ŀ�꺯��1')
title('����ʱ��ƫ��仯����')


figure,plot(trace(:,3),'.-')
xlabel('��������')
ylabel('Ŀ�꺯��2')
title('�������ʱ��仯����')

figure,plot(trace(:,4),'.-')
xlabel('��������')
ylabel('Ŀ�꺯��3')
title('�����ʱ���ܺͱ仯����')

save('GA.mat','trace','Bestf');
toc;
