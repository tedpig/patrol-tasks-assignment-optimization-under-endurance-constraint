function [ race_new ] = ga_mutation1( race,P_Mutation,city_distance,num_T,g_adaptation )
%±‰“Ï
k1=3;
k=race(1,1);
[m,n]=size(race);
race=race(1:m,2:n-1);
[m,n]=size(race);
race_new=race;
for i=1:m
    flag=rand;
    if(flag<=P_Mutation)
        race_set=zeros(k1,n);
        list=find(race_new(i,:)==randi(n-num_T+1));
        temp=race_new(i,list);
        [~,ind]=sort(city_distance(temp,1:n-num_T+1));
        k2=1;
        for j=1:k1
            newrace=race_new(i,:);
            del=temp;
            list1=list;
            while list1>1
                list1=list1-1;
                if newrace(list1)<=n-num_T+1
                   del=[del,newrace(list1)];
                else
                    break;
                end
            end
            list1=list;
            while list1<n
                list1=list1+1;
                if newrace(list1)<=n-num_T+1
                   del=[del,newrace(list1)];
                else
                    break;
                end
            end
            while ismember(ind(k2),del)
                k2=k2+1;
            end
            list2=newrace==ind(j);
            newrace(list)=ind(j);
            newrace(list2)=temp;
            race_set(j,:)=newrace;
            k2=k2+1;
        end    
        adaptation1=ga_adaptation([k*ones(k1,1),race_set,k*ones(k1,1)],city_distance,num_T);
        [min_adaptation1,ind]=min(adaptation1);
        if min_adaptation1<=g_adaptation
            race_new(i,:)=race_set(ind,:);
        end
    end
end
race_new=[k*ones(m,1),race_new,k*ones(m,1)];
end

