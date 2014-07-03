% Julian day fraction
% jdf = 80.67537181;
function [days,hours,min,sec] = julianDayFractionToUTC(jdf)
if nargin<1
    jdf=50.28438588;
end
days = floor(jdf);
fdays = jdf - days;
hours = floor(fdays*24);
fdays = fdays*24 - hours;
min = floor(fdays*60);
fdays = fdays*60 - min;
sec = fdays*60;
