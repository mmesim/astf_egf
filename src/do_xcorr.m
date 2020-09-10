function [ms_new,egf_new,headerMS,headerEGF,CCmax]=do_xcorr(ms,egf,ind,type,co,win_corr,cc_thres,headerms,headeregf)
%Function to cross correlate signals
%Velocity!!!!!!
%Keep only those with SNR above threshold

ms=ms(ind); egf=egf(ind);
headerms=headerms(ind);
headeregf=headeregf(ind);

%Preallocate memory
CCmax=NaN*(ones(numel(ind),1));

for i=1:length(ind)
y1=ms{1,i};
y2=egf{1,i};    
%Filter
yf1=my_filter(y1,type,headerms(1).DELTA,co,2);
yf2=my_filter(y2,type,headerms(1).DELTA,co,2); 
%Cut waveforms - MS
start=round(headerms(i).T0./headerms(1).DELTA);
stop=round(start+(win_corr./headerms(1).DELTA));
yf1_cut=yf1(start:stop);
%Cut waveforms - EGF
start=round(headeregf(i).T0./headeregf(1).DELTA);
stop=round(start+(win_corr./headeregf(1).DELTA));
yf2_cut=yf2(start:stop);
%Xcorr
[cc,~]=xcorr(yf1_cut,yf2_cut,'coeff');
CCmax(i,1)=max(cc);
end

% Here return the final index
index=find(CCmax(:,1)>=cc_thres);
ms_new=ms(index);headerMS=headerms(index);
egf_new=egf(index);headerEGF=headeregf(index);
end