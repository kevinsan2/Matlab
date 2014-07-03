% Prabhakar. S
% AE 110 Lab Assignment
% Satellite Tracking Program
% Satellite:  NOAA 12
% Program Name elaz : Elevation-Azimuth being called by the program sts
clear all;clc;close all;
addpath(genpath(cd));
fileInDir = dir('*.txt');
% Orbital Elements ready for degree to radians conversion!
% Two Line Elements and the Epoch Data are obtained from the GUI Interface
for i = 1:length(fileInDir)
    disp(sprintf(['%g) ' fileInDir(i).name],i));
end
n = input('file?');
pro = 1;
filename = fileInDir(n).name;
[yoe,doe,moe,frac] = importFirstLineFunction(filename);
doe = 2;
moe = 7;
yoe = yoe+2000;
[incl,raan,e,aop,ma,revs] = importSecondLineFunction(filename);
I2 = yoe;		% Year of epoch
J2 = moe;			% Month of epoch
%h2 = hoe;       % Hour of epoch
%m2 = mioe;       % Minute of epoch
%K2 = doe + hoe/24 + mioe/(24*60);		% Day of epoch
K2=doe;
zero=0; % For printing a single digit month or day preceeded by a zero.
%ut=.08235372;
%frac=.08235372; % fraction of the day from the TLE

% This calculation is to find the Julian Date,
% JD Fortran code written by Fliegel and Van Flandern [1968]
% Handout by Dr. P

JD = UTCtoJulianDay(K2,J2,I2);

%JD = (K2 - 32075 + round(1461 * (I2 + 4800 + (J2 -14)/12)/4 ...
%+ 367* (J2 - 2 - (J2 - 14)/12*12)/12 - 3*((I2 + 4900 + (J2 - 14)/12)/100)/4)) ;
% fprintf('\n Two Line Elements Data - 28 Dec 2000, Time 11:30:00\n');
% fprintf(' The Julian Date is %f',JD);

% Propagation begins
I = yoe;								% Year
J = moe;								% Month
%h = hoe;   				   		% Hour
%m = mioe;     				 		% Minute
%K = doe + hoe/24 + mioe/(24*60);	% Day
K=doe;

JD0 = UTCtoJulianDay(K,J,I);


%JD0 = (K - 32075 + round(1461 * (I + 4800 + (J -14)/12)/4 ...
%+ 367 * (J - 2 - (J - 14)/12*12)/12 - 3*((I + 4900 + (J - 14)/12)/100)/4)) ;

I3 = yoe;							% Year
J3 = moe;							% Month
%h3 = hoe;       					% Hour
%m3 = mioe;       				% Minute
%K3 = (doe+pro) + h3/24 + m3/(24*60);	% Day
K3 = (doe+pro);

JD1 = UTCtoJulianDay(K3,J3,I3);


%JD1 = K3 - 32075 + round(1461 * (I3 + 4800 + (J3 -14)/12)/4 ...
%  + 367 * (J3 - 2 - (J3 - 14)/12*12)/12 - 3*((I3 + 4900 + (J3 - 14)/12)/100)/4);
% Propagation ends here.

% Propagation step Size
step = 5/(24*60); % (days) right now for every 5 minutes
j=1;


fprintf('\n\t\t\t SATELLITE    TRACKING    SYSTEM  \n');
fprintf(' ---------------------------------------------------------------------------');
fprintf('\n				             G r e g o r i a n   D a t e \n');
fprintf(' ---------------------------------------------------------------------------');
fprintf('\n  Julian Date      Azimuth     Elevation  Month/Day/Year Hour:Minute:Seconds\n');
fprintf(' ---------------------------------------------------------------------------\n');
count = 1;
while JD0<JD1;
    
    % Declaring variables and initializing values
    
%     degtorad = pi/180;		% Radians conversion factor
    i = degtorad(incl);		% Inclination
    CapOmega = degtorad(raan);		% Right Ascension of the Ascending Node - denoted by symbol Capital Omega
    ecc = e;					% Eccentricity
    SmallOmega = degtorad(aop);						% Argument of Periapsis - denoted by  small Omega
    Mo = degtorad(ma);		% Initial Mean anomaly
    n = revs;	   		% Mean Motion (revs/day)
    GP = 3.986e5;				% Gravitational parameter - denoted by nu
    a = 6775;					% Semi-major Axis
%     a = (GP/n^2)^(1/3);
%     fprintf('Semi-major axis is computed to be :%g\n',a);
    
    Latitude = degtorad(0);
    Longitude = degtorad(280);
    L = ((degtorad(90)) - Latitude);
    
    We = 6.300388097;		% Angular velocity of planet Earth
    perturb = degtorad(98.9246096453622); % Perturbation due to the Oblateness
    tq = 2448621.5; % JD for
    Qg = perturb + We * (JD0 - tq);
    Q = Qg + Longitude;
    
    tp = JD - Mo/n;
    M = n * (JD0 - tp);
    
    E = M;				          		% Use M for the first value of E
    f=M-E+ecc*sin(E);			 		% Kepler's Equation
    while abs(f)>0.00000001; 		% Loop for Kepler's equation begins
        f=M-E+ecc*sin(E);			 	%
        fd=-1+ecc*cos(E);			 	%
        E=E-f/fd;						%
    end;							 		% loop for Kepler's eqn ends here!
    
    
    % Computing true anomaly and radius
    
    TA=2*atan((((1+ecc)/(1-ecc))^0.5)*tan(E/2));
    if TA<0;
        TA=2*pi+TA;
    end;
    
    r=a*(1-ecc*cos(E)); % radius
    
    
    % Coordinate transformations
	radius = 6378.14;
    adot = (-(3/2) * n * 1.0827e-3 * (radius/a)^2 * cos(i))/(1-ecc^2)^2;
    A = CapOmega + adot * (JD0 - JD);
    SmallOmega = SmallOmega + adot * (JD0 - JD);
    
    Rseu = [0; 0; radius];
    Txyz = [    cos(A)  -sin(A) 0;
                sin(A)  cos(A)  0;
                0       0       1 ] * ...
            [   1       0       0;
                0       cos(i)  -sin(i);
                0       sin(i)  cos(i)] * ...
        [       cos(SmallOmega) -sin(SmallOmega) 0;
        sin(SmallOmega) cos(SmallOmega) 0;
        0 0 1 ];
    Tseu = [ cos(L) 0 -sin(L);
        0 1 0;
        sin(L) 0 cos(L)] * [ cos(Q) sin(Q) 0;
                            -sin(Q) cos(Q) 0;
                            0 0 1];
    ruvw = [ (r * cos(TA)); (r * sin(TA)); 0 ];
    satRseu = Tseu*(Txyz*ruvw);
    xyzcoord(:,j) = satRseu;
    Pseu = satRseu - Rseu;
    P = (Pseu(1)^2 + Pseu(2)^2 + Pseu(3)^2)^0.5;
    [Az2,El2] = fAzimElev(Pseu',satRseu');
    Az2deg = radtodeg(Az2);
    El2deg = radtodeg(El2);
    El = radtodeg(asin ( Pseu(3)/P ));
    Az = radtodeg(atan2 ( Pseu(2), -Pseu(1)));
    if Az < 0;
        Az = 360 + Az;
    end;
    
    %Loop begins here  %if El>0;
    
    array(j,1) = JD0;
    array(j,3) = Az;
    array(j,4) = El;
    %array(j,5) = cat(year,month,day);
    [latb(:,j), longb(:,j), h(:,j)] = fGC2GL(xyzcoord(:,j)'*1e3);
    % [Latitude (rad) Longitude (rad) Height (m)]
    j = j+1;
    % loop ends here
    
    JD0 = JD0 + step;
    % Gregorian Date from Julian Date
    % This calculation is valid for any Julian Day Number including negative JDN and
    % produces a Gregorian date (or possibly a proleptic Gregorian date)
    
    Z = floor(JD0 - 1721118.5); % JD0 is the Julian Date in propagation
    R = (JD0 - 1721118.5 - Z);  % R is the fractional part of JD0
    G = (Z - .25);
    A = (floor(G / 36524.25));  % Calculate the value of A which is the number of full centuries
    B = (A - (A / 4)); % The value of B is this number of days minus a constant
    year = (floor((B+G) / 365.25)); % Calculate the value of Y, the year in a calendar whose years start on March 1
    C = (B + Z - floor(365.25 * year));  % Day count
    month = (fix((5 * C + 456) / 153));  % Month
    UT = (C - fix((153 * month - 457) / 5) + R); % Calculation for UTC
    day = floor(UT);  % Gregorian Day
    
    if month > 12;
        year = year + 1 ;
        month = month - 12;
    end;
    UT = UT - floor(UT);
    UT = UT*24;
    hr = floor(UT);   %  hour
    UT = UT-floor(UT);
    UT =UT* 60;
    min = floor(UT);  % minute
    UT =UT- floor(UT);
    UT =UT* 60;
    secs = round(UT); % seconds
    if secs==60;
        min=min+1;
        secs=0;
    end;
    % Gregorian Date conversion algorithm ends here
    
    % computations for printintg two digits in case year,month,day,min and secs is < 10
    % (i.e) to print third month, 3 as 03 and day 5 as 05 etc..
    ZERO=int2str(zero);
    MIN=int2str(min); % converting minute into a string
    if min <10;
        MinNew=strcat(ZERO,MIN);
        min=MinNew;
    else
        min=MIN;
    end;
    
    DAY=int2str(day); % converting DAY into a string
    if day <10;
        DayNew=strcat(ZERO,DAY);
        day=DayNew;
    else
        day=DAY;
    end;
    HR=int2str(hr); % converting Hour into a string
    if hr <10;
        HrNew=strcat(ZERO,HR);
        hr=HrNew;
    else
        hr=HR;
    end;
    
    MONTH=int2str(month); % converting month into a string
    if month <10;
        MonthNew=strcat(ZERO,MONTH);
        month=MonthNew;
    else
        month=MONTH;
    end;
    
    SECS=int2str(secs); % converting seconds into a string
    if secs <10;
        SecsNew=strcat(ZERO,SECS);
        secs=SecsNew;
    else
        secs=SECS;
    end;
    
    % computations for printing two digits ends here!
    
    if El;
        fprintf('\n %f | %f | %f |  %s/%s/%4d  |  %s:%s:%s  |',...
           JD0, Az, El, month,day,year, hr,min,secs);
        %plot(El,Az);
        count = count + 1;
    end;
    
    statusOfSat(j,:) = {JD0, Az, El,radtodeg(Az2),radtodeg(El2), month,day,year, hr,min,secs};
end
fprintf('\n');
latbdeg = radtodeg(latb); 
longbdeg = radtodeg(longb);
%%
% clc
fprintf('Latitude Longitude Height\n')
for i = 1:length(xyzcoord)
    [latitude(i) longitude(i) height(i)] = fGC2GL(xyzcoord(:,i));
    fprintf('%g        %g        %g\n',radtodeg(latitude(i)),...
        radtodeg(longitude(i)),...
        height(i));
end
%%
figure(2);plot(latbdeg,longbdeg,'*');
%% Plots
% % 2D plot of elevation and azimuth
% for i = 1:length(latb)
% figure(2);plot(latb(i),longb(i),'*');
% hold on;
% axis([])
% % hTitle, hXLabel, hYLabel
% hTitle = title(sprintf('Title'));
% hXLabel = xlabel('Azimuth');
% hYLabel = ylabel('Elevation');
% % Configuration
% set( gca                       , ...
%     'FontName'   , 'Helvetica' );
% set([hTitle, hXLabel, hYLabel], ...
%     'FontName'   , 'AvantGarde');
% set( gca             , ...
%     'FontSize'   , 8           );
% set([hXLabel, hYLabel]  , ...
%     'FontSize'   , 10          );
% set( hTitle                    , ...
%     'FontSize'   , 12          , ...
%     'FontWeight' , 'bold'      );
% set(gca, ...
%     'Box'         , 'off'         , ...
%     'TickDir'     , 'out'         , ...
%     'TickLength'  , [.02 .02]     , ...
%     'XMinorTick'  , 'on'          , ...
%     'YMinorTick'  , 'on'          , ...
%     'XColor'      , [.3 .3 .3]    , ...
%     'YColor'      , [.3 .3 .3]    , ...
%     'ZColor'      , [.3 .3 .3]    , ...
%     'LineWidth'   , 1             );
% end
%% Plot xyz
% npanels = 180;   % Number of globe panels around the equator deg/panel = 360/npanels
% alpha =.5;
% image_file = 'http://upload.wikimedia.org/wikipedia/commons/thumb/c/cd/Land_ocean_ice_2048.jpg/1024px-Land_ocean_ice_2048.jpg';
% cdata = imread(image_file);
% [X,Y,Z] = ellipsoid(0, 0, 0, radius,radius...
% ,radius, npanels); 
% figure(1);
% plot3(xyzcoord(2,:),xyzcoord(3,:),xyzcoord(1,:),'*')
% hold on;
% globe=surf(X,Y, -Z, 'FaceColor', 'texturemap', 'CData', cdata,...
%     'FaceAlpha', alpha, 'EdgeColor', 'none')
% 
% %% Plot 3D
% % with earth sphere
% erot    = 7.2921158553e-5; % earth rotation rate (radians/sec)
% erotDegreePerDay = erot*(180/pi)*(3600/1)*(24/1);
% view([90,0]);
% 
% for i = 1:floor(length(xyzcoord(1,:))/4)
%     figure(2);clf;hold on;
%     globe=surf(X,Y, -Z, 'FaceColor', 'texturemap', 'CData', cdata,...
%     'FaceAlpha', alpha, 'EdgeColor', 'none');
% %     rotate(globe,[0 0 1],i*step*erotDegreePerDay);
%     view([90,0]);
%     plot3(xyzcoord(2,i),xyzcoord(3,i),xyzcoord(1,i),'*')
%     pause(.01)
%     hTitle = title(sprintf('Title'));
%     hXLabel = xlabel('x');
%     hYLabel = ylabel('y');
%     hZLabel = zlabel('z');
%     set( gca                       , ...
%         'FontName'   , 'Helvetica' );
%     set([hTitle, hXLabel, hYLabel, hZLabel], ...
%         'FontName'   , 'AvantGarde');
%     set( gca             , ...
%         'FontSize'   , 8           );
%     set([hXLabel, hYLabel, hZLabel]  , ...
%         'FontSize'   , 10          );
%     set( hTitle                    , ...
%         'FontSize'   , 12          , ...
%         'FontWeight' , 'bold'      );
%     set(gca, ...
%         'Box'         , 'on'         , ...
%         'TickDir'     , 'out'         , ...
%         'TickLength'  , [.02 .02]     , ...
%         'XMinorTick'  , 'on'          , ...
%         'YMinorTick'  , 'on'          , ...
%         'ZMinorTick'  , 'on'          , ...
%         'XColor'      , [.3 .3 .3]    , ...
%         'YColor'      , [.3 .3 .3]    , ...
%         'ZColor'      , [.3 .3 .3]    , ...
%         'LineWidth'   , 1             );
%     hold off
% end
%%
% figure(5)
% mesh(X,Y,Z)
% hold on;
% plot3(xyzcoord(1,:),xyzcoord(2,:),xyzcoord(3,:),'*')
