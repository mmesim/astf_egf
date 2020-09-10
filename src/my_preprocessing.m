function [Tt, Tdisp]=my_preprocessing(yN,yE,header,lat,lon)
% Function for preprocessing waveforms
%(1)remove trend
%(2)remove mean
%(3) rotate
%(4) taper
%(5) integrate to displacemnt
%(6) remove trend and mean
%--------------------------------------------------------------------------
%Input: velocity (instrument corrected) waveforms + headers + MS location
%Output: T [Transverse component velocity]
%Output: Tdisp [Transverse component Displacemnt]
%--------------------------------------------------------------------------
%Preallocate memory
Tt=cell(1,length(yN));
Tdisp=cell(1,length(yE));


for i=1:length(yN)
%00. Grab waveforms
tempN=yN{1,i};
tempE=yE{1,i};
%01. Remove mean
ymN=tempN-mean(tempN);
ymE=tempE-mean(tempE);
%02. Remove trend
yrN=my_detrend(ymN,1);
yrE=my_detrend(ymE,1);
%03. Rotate
[~,T]=my_rotation(header,lat,lon,yrN,yrE);
%04. Taper
Tt{1,i}=my_taper(T,header(1).DELTA);
%05. Integrate to displacement
Tint=cumtrapz(Tt{1,i});
%06. Remove trend and mean
Tint=my_detrend(Tint,1);
Tint=Tint-mean(Tint);
Tdisp{1,i}=my_taper(Tint,header(1).DELTA);
end


end