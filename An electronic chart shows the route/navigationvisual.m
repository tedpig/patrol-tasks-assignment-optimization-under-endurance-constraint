clc
clear

global return_time Z Y ST duration S_dot E_dot
return_time=3;
USV_num=4;
num_T=return_time*USV_num;
load city_location.mat
load city_distance.mat
load city_path.mat
load IA-GA.mat
%global S_dot E_dot S_row S_col RR
% S_dot=[30.54 122.00];
% E_dot=[30.65 122.18];
% geolimits([S_dot(1) E_dot(1)],[S_dot(2) E_dot(2)]);

for i=1:length(nodes)
    for j=1:length(nodes)
        city_distance(j,i)=city_distance(i,j);
        city_path{j,i}=flip(city_path{i,j},1);
    end
end
city_distance=city_distance*1000/360;
city_location=nodes([2:26,1],:);
city_distance=city_distance([2:26,1],[2:26,1]);
city_path=city_path([2:26,1],[2:26,1]);
source=26;
City_Number=25;

ST_P=[7	15	9	10	5	20	8	13	17	3	16	22	21	23	4	12	6	24	2	25	1	18	19	11	14];
ST=[33302	39120	39742	32929	32148	26845	33596	32180	26813	31152	23874	27103	39902	23817	37826	24653	23584	39359	29928	39404	20667	24234	28944	23348	31531];
duration=[16	17	17	18	13	19	20	18	17	13	18	16	19	13	17	14	20	12	12	13	15	19	14	14	16	10];
Y=[0	0	0	0	1	0	1	0	1	1	0	0	0	0	1	0	0	0	0	0	0	0	0	0	0];
Z=[0	0	1	0	0	0	0	1	0	0	0	0	1	0	0	0	1	0	0	1	0	0	0	0	0];
for i=1:length(ST)
    if Y(i)==1
        ST(i)=int32(ST(i)/200);
    else
        ST(i)=int32(ST(i)/200);
    end
end

Y=[Y,zeros(1,num_T)];
Z=[Z,zeros(1,num_T)];
ST=[ST,zeros(1,num_T)];
duration=[duration,15*ones(1,num_T)];
duration(City_Number+num_T)=0;
city_distance1=zeros(City_Number+num_T,City_Number+num_T);
city_location1=zeros(City_Number+num_T,2);
city_distance1(1:City_Number,1:City_Number)=city_distance(1:City_Number,1:City_Number);
city_location1(1:City_Number,:)=city_location(1:City_Number,:);
city_location1(City_Number+1:City_Number+num_T,:)=repmat(city_location(source,:),num_T,1);
for i=1:num_T
   city_distance1(City_Number+i,1:City_Number)=city_distance(source,1:City_Number);
   city_distance1(1:City_Number,City_Number+i)=city_distance(1:City_Number,source);
end
city_distance=city_distance1;
%City_Number=City_Number+num_T-1;
city_location=city_location1;
race_set = Tsp_set1(Bestf', num_T); 
n=length(Bestf);

[adaptation,path_time,~, ~, check,race_set]=ga_adaptation(Bestf', city_distance, 12);
[path, dela_time, End_time, check, race_set]=fitness(race_set,city_distance, n-num_T);
V=240;
goal=26;

for i=1:length(race_set)
    route=race_set{i};    
    [bs, route]= begin_s(route,city_distance, V, goal);
    ZY=(Z+Y);
    T_strain=ZY(route).*ST(route);
    dev_time=max(ZY(route).*bs-T_strain,0);
    waitime=max((Z(route).*ST(route)-Z(route).*bs),0);
    for j=1:length(route)-1
        if route(j)>=goal && Z(route(j+1))==1
            if j==1
                optime=0;
            else
                optime=ST(goal);
            end
            waitime(j)=bs(j+1)-city_distance(route(j+1),route(j))-optime;
        end
    end
    waitime_set(i)=sum(waitime);
end

% wm = webmap('National Geographic Map');
% wmmarker(city_location(1:City_Number,1), city_location(1:City_Number,2), 'Color', 'g');
% wmmarker(city_location(City_Number+1,1), city_location(City_Number+1,2), 'Color', 'r');
% clr = hsv(num_T/return_time);
% for k=1:length(race_set)
%     point=race_set{k};
%     point(point>length(city_path))=City_Number+1;
%     if length(point)>1
%         for i=1:length(point)-1
%             route=city_path{point(i),point(i+1)};
%             lon=route(:,1);
%             lat=route(:,2);
%             wmline(lat, lon,'Color', clr(k,:), 'Width', 0.5);
%         end
%     end
% end

figure(1);
set(gcf,'position',[100 100 850 550]);
S_dot=[30.54 122.00];
E_dot=[30.65 122.19];
geolimits([S_dot(1) E_dot(1)],[S_dot(2) E_dot(2)]);
[latitudeLimits,longitudeLimits] = geolimits;

source=nodes(1,:);
nodes=nodes([2:26],:);
A=[5 7 9 10 15];B=[3 8 13 17 20];
hold on;
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
%clr = hsv(num_T/return_time);
clr={'red', 'blue', 'black', 'magenta', 'cyan', 'green', 'yellow', 'white', 'none'};
for k=1:length(race_set)
    point=race_set{k};
    point(point>length(city_path))=City_Number+1;
    if length(point)>1
        for i=1:length(point)-1
            route=city_path{point(i),point(i+1)};
            lon=route(:,1);
            lat=route(:,2);
            geoplot(lat(1:end-1), lon(1:end-1),'LineWidth', 0.5,'Color',clr{k},'LineStyle','--')
            [fp1] = CoorFromAxis2Fig(gca,longitudeLimits,latitudeLimits,[lon(end-1) lat(end-1)]);
            [fp2] = CoorFromAxis2Fig(gca,longitudeLimits,latitudeLimits,[lon(end) lat(end)]);
            geo_X(1)=fp1(1);geo_X(2)=fp2(1);geo_Y(1)=fp1(2);geo_Y(2)=fp2(2);
            %geoquiver(lat(end-1),lon(end-1),lat(end)-lat(end-1),lon(end)-lon(end-1));
            %geoshow(lat(end),lon(end),'DisplayType','line','Marker','>','color','r')
            %[X, Y] = mfwdtran(lat,lon);
            annotation('arrow',geo_X,geo_Y,'Color',clr{k},'LineStyle','--') ;
            %wmline(lat, lon,'Color', clr(k,:), 'Width', 0.5);
        end
    end
end

