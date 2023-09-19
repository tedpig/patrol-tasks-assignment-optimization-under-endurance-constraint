function [ adaptation, dela_all, End_all,path_all,check_all, race_set ] = ga_adaptation( race, city_distance, num_T )
global Y Z ST duration
M=100;
%V=36000000;
k=race(1,1);
[m,n]=size(race);
adaptation=zeros(1,m);
adaptation_1=zeros(1,m);
adaptation_2=zeros(1,m);
race_set = Tsp_set1(race, num_T); 
%race_set = resetrace(race_set, num_T, city_distance);%调整分组
[path, dela_time, End_time, check, race_set]=fitness(race_set,city_distance, n-num_T);
%path=path+city_distance(race(i,n),race(i,1));
dela_all=sum(dela_time,2);
End_all=max(End_time,[],2);  
path_all=sum(path,2);
%End_all=sum(End_time);  
%adaptation_1=0;
adaptation=dela_all*M+End_all+path_all/M;
check_all=0;
for i=1:length(check)
    check_all=check_all+sum(check{i});
end


% for i=1:m
%     if num_T>1
%         t=k-(1:num_T-1);
%         [~,index]=ismember(t,race(i,:));
%         index=sort(index); 
%         index=[1,index,n];
%         index_num=index(2:size(index,2))-index(1:size(index,2)-1);
%         adaptation_2(i)=max(index_num)*30000;  %系数3000不是一个固定的值，需要根据实际情况取值 
%         adaptation_2(i)=0;
%     end
%     adaptation(i)=adaptation_1(i)+adaptation_2(i);
% end

