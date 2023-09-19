function [ race_new ] = ga_cross1( race,P_Cross )
%˳�򽻲�
k=race(1,1);
[m,n]=size(race);
race=race(1:m,2:n-1);
[m,n]=size(race);
race_new=race;
for i=1:m-1
    flag=rand;
    if(flag<=P_Cross)
        list=randi(n,2,1);
        index_1=min(list);
        index_2=max(list);
        child=zeros(1,n);
        parent_1=race_new(i,:);
        parent_2=race_new(i+1,:);
        child(index_1:index_2)=parent_2(index_1:index_2);
        index=ismember(parent_1,child(index_1:index_2));
        parent_1(index)=[];
        if index_1>1
            child(1:index_1-1)=parent_1(1:index_1-1);
        end
        if index_2<n
            child(index_2+1:end)=parent_1(end-n+index_2+1:end);
        end
        race_new(i,:)=child;
    end
end
race_new=[k*ones(m,1),race_new,k*ones(m,1)];
end

