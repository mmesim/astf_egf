function [p,f,yfft]=my_fft_prep(y,header,delta,win,mystring)
%Prepare waveforms and then do ft
%Cut in given window for signal or noise

if strcmp(mystring,'signal')==1
%Cut in window for signal
start=round((header.T0)./delta);
stop=round(start+(win./delta));
ycut=y(start:stop);

elseif strcmp(mystring,'noise')==1
%Cut in window for noise
stop=round(win./delta);
ycut=y(1:stop);
       
end
%Do fft
[p,f,yfft]=my_fft(ycut,delta);
end