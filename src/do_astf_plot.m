function []=do_astf_plot(Dms_cut,Degf_cut,astf,headerMS,win_stf,time)
%Function to plot source time function

x=(1:length(Dms_cut)).*headerMS(1).DELTA;
%start figure
f1=figure;
subplot(2,1,1); 
plot(x,Dms_cut./max(Dms_cut),'-k'); 
hold on
plot(x,Degf_cut./max(Degf_cut),'r');
title(sprintf('Mainshock - EGF [%s]',headerMS(1).KSTNM));
xlim([0 win_stf])
xlabel('Time [sec]')
ylabel('Displacement')
set(gca,'FontSize',15,'FontName','Helvetica')

subplot(2,1,2); 
plot(time,astf./max(astf))
xlim([0 time(end)])
title('ASTF'); 
xlabel('Time [sec]')
ylabel('Amplitude')
set(gca,'FontSize',15,'FontName','Helvetica')


%Save to png
filename=sprintf('astf_%s.png',headerMS(1).KSTNM);hold off;
saveas(f1,filename,'png')
close;

end

