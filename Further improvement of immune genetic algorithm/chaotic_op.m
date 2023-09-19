%D是维度,引入混沌算子
function [pOp,z] = chaotic_op(NP,D,initial)
%u=1:3/(D-1):4;
u=4;
if nargin==3
    z(1,:)=initial;
else
    z(1,:)=rand(1,D);
%    z(1,1)=rand(1);
%     for i=2:D
%         z(1,i)=z(1,i-1)*u*(1-z(1,i-1));
%     end
end
[~,pOp(1,:)]=sort(z(1,:));

for i=2:NP
    z(i,:)=z(i-1,:).*u.*(1-z(i-1,:));
    [~,pOp(i,:)]=sort(z(i,:));
end
z=z(end,:);	
end
