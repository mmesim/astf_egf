function [R,T]=my_rotation(header,lat,lon,yN,yE)
%function to rotate horizontal components
%to radial and transverse
%---------------------------------------------------------------
%grab station coordinates 
%use one of the two components
%E-W
Estlo=header.STLO;
Estla=header.STLA;
%Calcualte azimuth from reference point to station
phi=azimuth(lat,lon,Estla,Estlo,'radians');
%grab waveforms
N=yN;
E=yE;
% Rotate
R=cos(phi)*N+sin(phi)*E;
T=-sin(phi)*N+cos(phi)*E;
%next

end 
