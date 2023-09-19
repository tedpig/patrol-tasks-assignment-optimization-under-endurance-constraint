load coast
axesm('mercator','MapLatLimit',[28 47],'MapLonLimit',[-10 37],...
    'Grid','on','Frame','on','MeridianLabel','on','ParallelLabel','on')
geoshow(lat,long,'DisplayType','line','color','b')
waypoints = [36,-5; 36,-2; 38,5; 38,11; 35,13; 33,30; 31.5,32];
[X, Y] = mfwdtran(waypoints(:,1),waypoints(:,2));
annotation('arrow',[X(1:(end-1)) Y(1:(end-1))], [X(2:end) Y(2:end)])