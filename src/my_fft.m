function [p,f,y]=my_fft(x,dt)
%This function was taken from ISOLA package
%Thank you!

%%fft
fs=1/dt;
m = length(x);      % Window length
n = pow2(nextpow2(m));  % Transform length
y = fft(detrend(x,'constant'),n);         % DFT of signal
f = (0:n-1)*(fs/n);  % Frequency range
p = abs(y); %.*conj(y)/n;       % Power of the DFT

f=f(1:floor(n/2));
p=p(1:floor(n/2));



