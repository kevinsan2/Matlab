clc;
clear all;
mu = 398600;             % Standard gravitational parameter for the earth
fname = 'amateur.txt';   % TLE file name
% Open the TLE file and read TLE elements
fprintf('a[km]  e  inc[deg]  RAAN[deg]  w[deg] M[deg] T[min] h_p[km] h_a[km]\n\n ')
fid = fopen(fname, 'rb');
i = 1;
while ~feof(fid)
L1 = fscanf(fid,'%23c%*s',1);
L2 = fscanf(fid,'%d%6d%*c%5d%*3c%*2f%f%f%5d%*c%*d%5d%*c%*d%d%5d',[1,9]);
L3 = fscanf(fid,'%d%6d%f%f%f%f%f%f%f%f',[1,9]);
epoch = L2(1,4)*24*3600;        % Epoch Date and Julian Date Fraction
Db    = L2(1,5);                % Ballistic Coefficient
inc(i)= L3(1,3);                % Inclination [deg]
RAAN(i) = L3(1,4);              % Right Ascension of the Ascending Node [deg]
e(i)  = L3(1,5)/1e7;            % Eccentricity
w(i)  = L3(1,6);                % Argument of periapsis [deg]
M(i)  = L3(1,7);                % Mean anomaly [deg]
n     = L3(1,8);                % Mean motion [Revs per day]

% Orbital parametres
a(i) = (mu/(n*2*pi/(24*3600))^2)^(1/3);       % Semi-major axis [km]
T(i) = 2*pi*sqrt(a(i)^3/mu)/60;               % Period in [min]
Re = 6371;
h_p(i) = (1 - e(i))*a(i) - Re;                % Perigee Altitude [km]
h_a(i) = (1 + e(i))*a(i) - Re;                % Apogee Altitude [km]

% Orbital Elements
OE = [a(i) e(i) inc(i) RAAN(i) w(i) M(i) T(i) h_p(i) h_a(i)];
fprintf(L1);
fprintf('%4.2f  %7.7f   %4.4f  %4.4f   %4.4f  %4.4f  %4.2f  %4.2f  %4.2f \n', OE);

% names(i,:) = [L1];
i = i+1;
end
fclose(fid);

scatter(a,inc,'b*');
grid on;
xlabel('Semi-major axis [km]');
ylabel('Inclination [deg]');
title('CubeSats currently in orbit (Number of CubeSats 44, December 08, 2012)');