function icol = find_eph(Eph,sv,time)
%FIND_EPH  Finds the proper column in ephemeris array

%Kai Borre and C.C. Goad 11-26-96
%Copyright (c) by Kai Borre
%$Revision: 1.2 $  $Date: 2004/02/09  $

icol = 0;
% find which columns has the selected sat data
isat = find(Eph(1,:) == sv);
% how many columns has the selected sat data
n = size(isat,2);
if n == 0
   return
end;
icol = isat(1);
% find the minimum dt, because the first column has the selected sat has
% the lowest time on 21st row, all the rest on the right are greater.
dtmin = Eph(21,icol)-time;
for t = isat
   dt = Eph(21,t)-time;
   if dt < 0
      if abs(dt) < abs(dtmin)
         icol = t;
         dtmin = dt;
      end
   end
end
%%%%%%%%%%%%  find_eph.m  %%%%%%%%%%%%%%%%%
