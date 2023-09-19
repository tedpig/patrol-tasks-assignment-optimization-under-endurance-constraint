clc
clear

load city_location.mat
load city_distance.mat
load city_path.mat
global S_dot E_dot S_row S_col RR
S_dot=[30.54 122.00];
E_dot=[30.65 122.18];
geolimits([S_dot(1) E_dot(1)],[S_dot(2) E_dot(2)]);

for i=1:length(nodes)
    for j=1:length(nodes)
        city_distance(j,i)=city_distance(i,j);
        city_path{j,i}=flip(city_path{i,j},1);
    end
end

city_distance=city_distance([2:26,1],[2:26,1]);
city_path=city_path([2:26,1],[2:26,1]);
source=nodes(1,:);
nodes=nodes([2:26],:);



hold on;
A=[5 7 9 10 15];B=[3 8 13 17 20];
for i=1:length(nodes)
    if ismember(i,A)
        geoplot(nodes(i,1),nodes(i,2),'k^',"MarkerFaceColor",'k')
    elseif ismember(i,B)
        geoplot(nodes(i,1),nodes(i,2),'ks',"MarkerFaceColor",'k','MarkerSize',8)
    else
        geoplot(nodes(i,1),nodes(i,2),'ko',"MarkerFaceColor",'k')
    end    
    text(nodes(i,1)+0.0021,nodes(i,2)-0.001,num2str(i));
end

geoplot(source(1),source(2),'rp',"MarkerFaceColor",'r','MarkerSize',8)
text(source(1)+0.0021,source(2)-0.001,'0','Color','r');
for i=1:length(city_path)-1
    for j=i+1:length(city_path)
        route=city_path{i,j};
        lon=route(:,1);
        lat=route(:,2);
        geoplot(lat, lon,'LineWidth', 0.5,'Color','k','LineStyle','--');
    end
end

% wm = webmap('National Geographic Map');
% wmmarker(nodes(:,1), nodes(:,2), 'Color', 'g');
% wmmarker(source(1), source(2), 'Color', 'r');
% for i=1:length(nodes)-1
%     for j=i+1:length(nodes)
%         route=city_path{i,j};
%         lon=route(:,1);
%         lat=route(:,2);
%         wmline(lat, lon,'Color', 'black', 'Width', 0.5);
%     end
% end
