function race_set = Tsp_set(race, num_T) 
[m,n]=size(race);
race_set=cell(m,num_T);
for j=1:m
    race_set{j,1}=race(j,1);
    set=1;
    for i=2:n-1
        race_set{j,set}=[race_set{j,set},race(j,i)];
        if race(j,i)>=n-num_T
            set=set+1;
            race_set{j,set}=[race_set{j,set},race(j,i)];
        end
    end
    race_set{j,set}=[race_set{j,set},race(j,end)];
end