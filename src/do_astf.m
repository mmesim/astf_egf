function    [astf]=do_astf(ms,egf,headerMS,headerEGF,win_stf)
%Function to do astf
%Steps include:
%Convert to displacement
%Cut waveforms
%Do fft and ifft
%Output: (1) ASTF | (2) convolution of EGF and STF

%Preallocate memory
astf=cell(1,numel(ms)); uastf=astf;

for i=1:length(ms)
yms=ms{1,i};
yegf=egf{1,i};
%-------------------------------------------------------------------------
%-------------------Mainshock----------------------------------------------
%Cut waveforms around S arrival
%MS
start=round(headerMS(i).T0./headerMS(1).DELTA);
stop=round(start+(win_stf./headerMS(1).DELTA));
ms_cut=yms(start:stop);

%remove trend and mean
ms_cut=my_detrend(ms_cut,1);
ms_cut=ms_cut-mean(ms_cut);
%Taper
ms_cut=my_taper(ms_cut,headerEGF(1).DELTA);
%--------------------------------------------------------------------------
%-----------------------EGF------------------------------------------------
start=round(headerEGF(i).T0./headerEGF(1).DELTA);
stop=round(start+(win_stf./headerEGF(1).DELTA));
egf_cut=yegf(start:stop);

%remove trend and mean
egf_cut=my_detrend(egf_cut,1);
egf_cut=egf_cut-mean(egf_cut);
%Taper
egf_cut=my_taper(egf_cut,headerEGF(1).DELTA);
%--------------------------------------------------------------------------
% Integrate to Displacement
Dms=cumtrapz(ms_cut);
Degf=cumtrapz(egf_cut);
%Taper-remove mean and trend
Dms=Dms-mean(Dms); Dms=my_detrend(Dms,1);
Dms=my_taper(Dms,headerEGF(1).DELTA);
% 
% 
Degf=Degf-mean(Degf); Degf=my_detrend(Degf,1);
Degf=my_taper(Degf,headerEGF(1).DELTA);
%---------------------------------------------------------------------
%Method 1
%padding zeros
% Nms=[ms_cut' zeros(1,length(ms_cut))];
% Negf=[zeros(1,length(egf_cut)) egf_cut'];
% %deconvolution
% astf{1,i}=real(ifft(fft(Nms)./fft(Negf)));
%convolution
%yN{1,i}=real(ifft(fft(Negf).*fft(astf{1,i})));
%--------------------------------------------------------------------------
%Method 2
%deconvolution using mt_spec
% Based on the F90 Multitaper library by Prieto et al. (2008)
stf = mt_deconv(headerMS(1).DELTA,Dms,Degf,2,7);

%fix order after the fft
time=(1:length(stf)).*headerMS(1).DELTA;

M = 1:length(stf);
N = length(M);

ind=find(M(1,:)>=0 & M(1,:)<=N/2);
d1=stf(ind);

ind2=find(M(1,:)>N/2 & M(1,:)<=N+1);
d2=stf(ind2);

astf{1,i}=[d2 d1];

%filter STF
%stf=my_taper(stf',headerMS(1).DELTA);
%astf{1,i}=my_filter(stf','low',headerMS(1).DELTA,4,4);

%plot
do_astf_plot(Dms,Degf,astf{1,i},headerMS(i),win_stf,time)

end

% Move figures to folder
mkdir('ASTF');
!mv astf_* ASTF/ 

end