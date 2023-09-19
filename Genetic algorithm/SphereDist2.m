function d = SphereDist2(x,y,R)
%根据两点的经纬度计算大圆距离(基于Haversine公式)
%x为A点[经度, 纬度], y为B点[经度, 纬度]
if nargin < 3
    R = 6378.137;
end
x = D2R(x);
y = D2R(y);
h = HaverSin(abs(x(2)-y(2)))+cos(x(2))*cos(y(2))*HaverSin(abs(x(1)-y(1)));
d = 2 * R * asin(sqrt(h));

function h = HaverSin(theta)
    h=sin(theta/2)^2;
end

end