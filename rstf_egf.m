% Script to calculate ASTF for a Mainshock                                %
% using an aftershock as EGF                                              %
% This script works for one MS and one EGF and S arrivals                 %
% ------------------------- M. Mesimeri 08/2020 --------------------------%
clear;clc;close all;tic
%% Parameters
mspath='/home/mmesim/Desktop/WFH/2020_MAGNA_QK_STRONG_MOTION/astf_sm_01/ms';   %path to ms waveforms
egfpath='/home/mmesim/Desktop/WFH/2020_MAGNA_QK_STRONG_MOTION/astf_sm_01/egf'; %path to egf waveforms
rlat=33.5;  %MS latitude
rlon=-116.45; %MS longitude
%SNR parameters
win_snr=1.0;  %Window for SNR calculation [in sec]
fmin=1;       %Minimum Freq. for SNR [in Hz]
fmax=10;      %Maximum Freq. for SNR [in Hz]
thres=3;      %threshold for SNR
%Xcorr parameters
win_corr=2;                %Correlation window around S phases [in sec]
type='bandpass';           %'low', 'high', 'bandpass'
%co=1;                     %low or high corner frequency (high or low pass)
co=[1.5;10];               %low-high corner frequency for bandpass
cc_thres=0.5;              %threshld for CC [0-1]
%ASTF parameters
win_stf=2;                 %Window for ASTF [in sec]
%-------------------------------------------------------------------------
%% Add path
mydir=pwd; pdir=sprintf('%s/src/',pwd); % get working directory path
addpath(genpath(pdir)); %add all *.m scripts to path

%% Load data
disp('Loading MS...')
[msN,msE,headerMsN,headerMsE]=my_loadfiles(mspath); %Load Mainshock
disp('Loading EGF...')
[egfN,egfE,headerEgfN,headerEgfE]=my_loadfiles(egfpath); %Load Egf

%% Preprocess
disp('Preprocessing MS...')
[Tms, TdispMS]=my_preprocessing(msN,msE,headerMsE,rlat,rlon);
disp('Preprocessing EGF...')
[Tegf, TdispEGF]=my_preprocessing(egfN,egfE,headerEgfE,rlat,rlon);

%% SNR - quality check
disp('SNR...')
[MS_SNR,ind_snr]=do_snr(TdispMS,TdispEGF,headerEgfE(1).DELTA,headerMsE,headerEgfE,win_snr,fmin,fmax,thres);

%% XCORR 
disp('Cross-correlation...')
[ms_new,egf_new,headerMS,headerEGF,CCmax]=do_xcorr(Tms,Tegf,ind_snr,type,co,win_corr,cc_thres,headerMsE,headerEgfE);

%% ASTF for each station pair
disp('ASTF....')
astf=do_astf(ms_new,egf_new,headerMS,headerEGF,win_stf);

save data.mat
fprintf('Elapsed time %6.2f minutes... \n',toc/60) %stop timer