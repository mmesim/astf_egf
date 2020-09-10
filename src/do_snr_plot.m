function []=do_snr_plot(fsignal,psignal,fnoise,pnoise,snr,station,mystring)
%Function to plot the signal, noise, and  SNR
%Saves a Figure [in png format]

f1=figure;
%Plot signal
loglog(fsignal,psignal,'k','LineWidth',1.5);hold on
%Plot Noise
loglog(fnoise,pnoise,'r','LineWidth',1.5)
%Plot SNR
loglog(fsignal,snr,'m','LineWidth',1.5);plot(fsignal,3*ones(length(fsignal),1),'g','LineWidth',1.5)
%Plot prop.
xlim([0.1 25])
xlabel('Frequency [Hz]')
ylabel('Amplitude')
title(sprintf('STATION: %s',station))
legend('Location','SouthWest','Signal','Noise','SNR','SNR=3')
set(gca,'FontSize',15,'FontName','Helvetica','XGrid','on','YGrid','on')
%Save to png
filename=sprintf('%s_%s.png',mystring,station);hold off;
saveas(f1,filename,'png')
close;

end