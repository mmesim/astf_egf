function [MS_SNR,ind]=do_snr(ms,egf,delta,headerms,headeregf,win,fmin,fmax,thres)
%Function to clalculate SNR

%preallocate memory
MS_SNR=NaN*(ones(length(egf),1)); EGF_SNR=MS_SNR;

for i=1:length(egf)
if strcmp(headerms(i).KSTNM,headeregf(i).KSTNM)>0
%Temporary vectors with displacement
tempMS=ms{1,i};
tempEGF=egf{1,i};

%Work with Mainshock --signal
[psignal,fsignal,~]=my_fft_prep(tempMS,headerms(i),delta,win,'signal');
%Work with Mainshock --noise
[pnoise,fnoise,~]=my_fft_prep(tempMS,headerms(i),delta,win,'noise');
%Calc MS - SNR
snr=psignal./pnoise;
%SNR check
table=[fsignal' snr];
table=table(table(:,1)>=fmin & table(:,1)<=fmax,:);
MS_SNR(i,1)=median(table(:,2));
%do plot
do_snr_plot(fsignal,psignal,fnoise,pnoise,snr,headerms(i).KSTNM,'ms');

%---------------------------------------------------------------------------
%Work with EGF --signal
[psignal,fsignal,~]=my_fft_prep(tempEGF,headeregf(i),delta,win,'signal');
%Work with EGF --noise
[pnoise,fnoise,~]=my_fft_prep(tempEGF,headeregf(i),delta,win,'noise');
%Calc EGF - SNR
snr=psignal./pnoise;
%SNR check
table=[fsignal' snr];
table=table(table(:,1)>=fmin & table(:,1)<=fmax,:);
EGF_SNR(i,1)=median(table(:,2));
%do plot
do_snr_plot(fsignal,psignal,fnoise,pnoise,snr,headerms(i).KSTNM,'egf');

else
error (' Station missing..Check %s for MS and %s for EGF ', headerms(i).KSTNM,headeregf(i).KSTNM);    
end %end if - check for the same station

end %end of for loop [loop through stations]

%Find MS and EGF that pass SNR threshold
ind=find(MS_SNR(:,1)>=thres & EGF_SNR(:,1)>=thres);
% Move figures to folder
mkdir('SNR_EGF');mkdir('SNR_MS');
!mv egf_* SNR_EGF/ 
!mv ms_* SNR_MS/
%end  %end of function