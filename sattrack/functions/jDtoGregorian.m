function [day,month,year] = f(JD)
%  	Description
%	[day,month,year] = f(JD)
%   JD = julian date
%	
a = JD + 32044;
b = floor((4*a + 3)/146097);
c = a - floor(146097*b/4);
d = floor((4*c+3)/(1461));
e = c-floor(1461*d/4);
m = floor(((5*e+2)/153));
day = e - floor((153*m+2)/5) + 1;
month = m + 3 - 12*floor(m/10);
year = 100*b + d - 4800 + floor(m/10);
end % function
