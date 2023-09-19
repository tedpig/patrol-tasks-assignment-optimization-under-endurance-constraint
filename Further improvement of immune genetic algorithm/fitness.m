function [path, dela_time, End_time, check, race_set]=fitness(race_set,city_distance,goal)
global Y Z ST duration
V=240;
[m,n]=size(race_set);
dela_time=zeros(m,n);
End_time=zeros(m,n);
check=cell(m,n);
for i=1:m
    for j=1:n
        path(i,j)=0;
        dis_race=race_set{i,j};
        [bs,dis_race]= begin_s(dis_race,city_distance,V,goal);
        check{i,j}=zeros(1,length(dis_race));
        Waitandpenal=0;
        for p=1:length(dis_race)-1
            path(i,j)=path(i,j)+city_distance(dis_race(p),dis_race(p+1)); %
            %巡逻点等待时间+惩罚函数
            Waitandpenal=Waitandpenal+Y(dis_race(p+1))*(max(0,bs(p+1)-ST(dis_race(p+1))))+Z(dis_race(p+1))*(max(0,bs(p+1)-ST(dis_race(p+1))));  
            if (Y(dis_race(p+1))+Z(dis_race(p+1)))*ST(dis_race(p+1))<bs(p+1) && (Y(dis_race(p+1))+Z(dis_race(p+1)))==1
                check{i,j}(p+1)=1;
            end
            %path(i,j)=path(i,j)+city_distance(dis_race(p),dis_race(p+1))+Waitandpenal+duration(dis_race(p+1));
            %Waitandpenal=Y(dis_race(p+1))*M*(max(0,sign(path(i,j)-ST(dis_race(p+1)))))+Z(dis_race(p+1))*(M*(max(0,sign(path(i,j)-ST(dis_race(p+1)))))+max(0,sign(ST(dis_race(p+1))-path(i,j))));  
            %path(i,j)=path(i,j)+city_distance(dis_race(p),dis_race(p+1))+Waitandpenal+duration(dis_race(p+1));
        end
         %Waitandpenal=sum(check{i,j});
         dela_time(i,j)=Waitandpenal;
         race_set{i,j}=dis_race;
         End_time(i,j)=bs(end);
    end
end

