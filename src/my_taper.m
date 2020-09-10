function yt = my_taper(y,f)
% apply hanning taper to a vector
%Originally in ISOLA package
%---------------------------------------------------------
n=length(y);
%construct an n point taper
m=round(n*f+.49999);
x=(0:2*m-1)'/(2*m-1);
yy = .5*(1 - cos(2*pi*x));             % 2*m point hanning window
x=[yy(1:m); ones(n-2*m,1); y(m+1:2*m)];

%return tapered waveform
yt=y.*x;

end