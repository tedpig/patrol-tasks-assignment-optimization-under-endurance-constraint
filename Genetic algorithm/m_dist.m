clc,clear
%定义城市坐标，
%北京：北纬39°54'20''，东经116°25'29''，
%上海：纬度31.20°N、经度121.21°E ，
load city_location.mat
[m,n]=size(city_location);
city_distance=zeros(m,m);
for i=1:m-1
    j=i+1:m;
    latBjInDegrees = city_location(i,1);
    lonBjInDegrees = city_location(i,2);
    latShInDegrees = city_location(j,1);
    lonShInDegrees = city_location(j,2);
    %度分秒坐标转换为度，
    %latBjInDegrees = dms2degrees(latBjInDMS);
    %lonBjInDegrees = dms2degrees(lonBjInDMS);
    %计算大圆航线距离，单位为米
    earthRadiusInMeters = 6371393;
    distgcInMeters = distance('gc',latBjInDegrees, lonBjInDegrees,...
    latShInDegrees, lonShInDegrees, earthRadiusInMeters);
    city_distance(i,j)=distgcInMeters;
    city_distance(j,i)=distgcInMeters;
end
save('city_distance.mat',"city_distance");