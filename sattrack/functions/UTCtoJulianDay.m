function JD = UTCtoJulianDay(day,month,year)
if nargin<3
    day = 1;
    m = 1;
    y = 2000;
else
    m = month;
    y = year;
end
a = floor((14-m)/12);
y = y+4800-a;
m = m+12*a-3;
JD = day + floor((153*m + 2)/5) + 365*y + floor(y/4)...
    -floor(y/100) + floor(y/400) - 32045;
% A = floor(Y/100);
% B = floor(A/4);
% C = 2-A+B;
% E = floor(365.25*(Y+4716));
% F = (30.6001*(M+1));
% JD= C+D+E+F-1524.5;