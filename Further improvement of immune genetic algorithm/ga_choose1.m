function [ race_new ] = ga_choose1( race,adaptation )
[m,n]=size(race);
race_new=zeros(m,n);
adaptation=1./adaptation;
a=adaptation./sum(adaptation);        % ��һ��
b=cumsum(a);              % ��������
for i=1:m-1
    select=find(b>=rand);     % �±�����
    race_new(i,:)=race(select(1),:);
end
[val,index]=max(adaptation);
race_new(end,:)=race(index,:);
end

