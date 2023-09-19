function Sortf=select(P,f,NP)
a=P./sum(P);        % 归一化
b=cumsum(a);              % 区域向量
for i=1:NP
	select=find(b>=rand);     % 下标数组
	Sortf(:,i)=f(:,select(1));                 % 事件序号
end

