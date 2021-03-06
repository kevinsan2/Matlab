% TLE Data Source. http://www.celestrak.com/  January 20, 2012
clc;
clear all;
% Earth3DPlot(1);

mu    = 398600;          % Earth?s gravitational parameter [km^3/s^2]
R_earth = 6378;          % Earth radius [km]
J2 = 0.0010836;
we = 360*(1 + 1/365.25)/(3600*24);      % Earth's rotation [deg/s]
fname = 'amateur.txt';    % TLE file name
% Open the TLE file and read TLE elements
fid = fopen(fname, 'rb');
while ~feof(fid)
% Reading TLE File
L1 = fscanf(fid,'%23c%*s',1);
L2 = fscanf(fid,'%d%6d%*c%5d%*3c%*2f%f%f%5d%*c%*d%5d%*c%*d%d%5d',[1,9]);
L3 = fscanf(fid,'%d%6d%f%f%f%f%f%f%f%f',[1,9]);
epoch       = L2(1,4)*24*3600;        % Epoch Date and Julian Date Fraction
Db          = L2(1,5);                % Ballistic Coefficient
i           = L3(1,3);                % Inclination [deg]
RAAN        = L3(1,4);        % Right Ascension of the Ascending Node [deg]
e           = L3(1,5)/1e7;            % Eccentricity
omega       = L3(1,6);                % Argument of periapsis [deg]
M           = L3(1,7);                % Mean anomaly [deg]
n           = L3(1,8);                % Mean motion [Revs/day]
% Orbital parametres
a = (mu/(n*2*pi/(24*3600))^2)^(1/3);         % Semi-major axis [km]
T = 2*pi*sqrt(a^3/mu)/60;                    % Period in [min]
rp = a*(1-e);
h = (mu*rp*(1 + e))^0.5;                     % Angular momentum
E = keplerEq(M,e);
theta =  acos((cos(E) -e)/(1 - e*cos(E)))*180/pi;    % [deg] True anomaly

% J2 Propagator
dRAAN = -(1.5*mu^0.5*J2*R_earth^2/((1-e^2)*a^3.5))*cosd(i)*180/pi;
domega = dRAAN*(2.5*sind(i)^2 - 2)/cosd(i);
eps = 1E-9;
dt  = 5;        % time step [sec]
ti  = 0;
j = 1;
while(ti <= T);
    E = 2*atan(tand(theta/2)*((1-e)/(1+e))^0.5);
    M = E  - e*sin(E);
    t0 = M/(2*pi)*T;
    t = t0 + dt;
    M = 2*pi*t/T;
    E = keplerEq(M,e);
    theta = 2*atan(tan(E/2)*((1+e)/(1-e))^0.5)*180/pi;
    RAAN  = RAAN  +  dRAAN*dt ;
    omega = omega + domega*dt;
    [R V] = Orbital2State( h, i, RAAN, e,omega,theta);
    % Considering Earth's rotation
    fi_earth = we*ti;
    Rot = [cosd(fi_earth), sind(fi_earth),0;...
        -sind(fi_earth),cosd(fi_earth),0;0,0,1];
    R = Rot*R;
    ti = ti+dt;
    Rv(j,:) = R';
    j = j+1;
end
scatter3(Rv(:,1),Rv(:,2),Rv(:,3),'.');
end
fclose(fid);
hold off;

% Ground Track
% Open the TLE file and read TLE elements
EarthTopographicMap( 2,820,420);
fid = fopen(fname, 'rb');
while ~feof(fid)
[ h, i, RAAN, e,omega,theta ] = TLE2OE( fid );
[Rv, alfa,delta ] = J2PropagR( h, i, RAAN, e,omega,theta) ;
scatter(alfa,delta,'.');
end
fclose(fid);
figure(2);
legend('RADUGA 32', 'RADUGA-1 4', 'RADUGA-1 5', 'RADUGA-1 7', 'RADUGA-1M 1');
 text(270,-80,'smallsats.org','Color',[1 1 1], 'VerticalAlignment','middle',...
	'HorizontalAlignment','left','FontSize',14 );
title('RADUGA satellites ground track');