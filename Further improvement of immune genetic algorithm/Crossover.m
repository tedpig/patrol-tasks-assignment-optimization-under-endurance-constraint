% Order Crossover, OX

function [a,b,a0,b0]=Crossover(a,b)
    L=length(a);
    a0=zeros(1,L);
    b0=zeros(1,L);
    a0(1)=a(1);
    b0(1)=b(1);
    a0(end)=a(end);
    b0(end)=b(end);
    % generate a random number in the range [2:L-1]
    % 1. choose 2 points
    r1 = randsrc(1,1,[2:L-1]);
    r2 = randsrc(1,1,[2:L-1]); 
    while r1==r2
        r1 = randsrc(1,1,[2:L-1]);
        r2 = randsrc(1,1,[2:L-1]);
    end
    % start and end
    s = min([r1,r2]);
    e = max([r1,r2]);
    % choose 2 parts of chromosome
    a0(s:e) = b(s:e);
    b0(s:e) = a(s:e);
    %ismember(b(s:e),a);
    k1=2;k2=2;
    for i = 2:L-1
        if a0(i)==0 
            while ismember(a(k1),b(s:e))
                k1=k1+1;
            end
            a0(i)=a(k1);
            k1=k1+1;
        end
        if b0(i)==0
            while ismember(b(k2),a(s:e))
                k2=k2+1;
            end
            b0(i)=b(k2);
            k2=k2+1;
        end
    end
end