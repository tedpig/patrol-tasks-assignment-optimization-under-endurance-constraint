function [ best_path,best_time,path_time,check] = ga_plot( race, city_distance, city_location, num_T )
    %pclr = ~get(0,'DefaultAxesColor');
    %clr = [1 0 0; 0 0 1; 0.67 0 1; 0 1 0; 1 0.5 0];
    global return_time
    clr = hsv(num_T/return_time);
    [m,n]=size(race);
    point=zeros(n,2);
    [adaptation,path_time,~, ~, check,race_set]=ga_adaptation(race, city_distance, num_T);
    [best_time,index]=min(adaptation);
    best_path=race_set(index,:);
    %o_position=find(best_path>=n-num_T);
    hAx=gca;
    for i=1:num_T/return_time
        point=city_location(best_path{i},:);
        plot(hAx,point(:,1),point(:,2),'-o','color',clr(i,:),'MarkerFaceColor',clr(i,:)); 
        %plot(hAx,point(:,1),point(:,2),'-o','MarkerEdgeColor',clr(i,:) ,'MarkerFaceColor','r');
        hold(hAx,'on');
    end
    hold(hAx,'off');
end

