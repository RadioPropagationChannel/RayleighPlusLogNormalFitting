clear, clc, close all

NFFT = 2^17;  % number of points in FFTs

load('SuzukiSeries1.mat')
% load('SuzukiSeries2.mat')

% "dist_axis" from file
% "PdBm" from file 
% "V" from file
% "fGHz" from file  
% "ds" from file 
% "ts" from file 
% "fs" from file

wl = 3e8/(fGHz*1e9);  % Wavelength in m
fm = V/wl;  % maximum Doppler freq in Hz

time_axis = dist_axis/V;

figure, plot(time_axis,PdBm)
pW = 10.^(PdBm/10)/1000;  % power in W
figure, plot(time_axis,pW)

% pW = pW - mean(pW);  % we could remove the DC component is needed

SpW = abs(fft(pW,NFFT)).^2;
freq_axis = (1:NFFT)*fs/NFFT;  % axis in Hz

figure, hold on, grid on
set(gca, 'XScale', 'log');
semilogx(freq_axis, 10*log10(SpW))
aa = axis;
semilogx([2*fm 2*fm], [aa(3) aa(4)], 'r')
xlim([0 fs/2])
xlabel('Frequency in Hz (cycles/second)')
ylabel('dB')
title('Spectrum of Rayleigh + lognormal series')

%%
space_freq_axis = freq_axis/V;
figure, hold on, grid on
set(gca, 'XScale', 'log');
semilogx(space_freq_axis, 10*log10(SpW))
aa = axis;
semilogx([2*fm/V 2*fm/V], [aa(3) aa(4)], 'r')
xlim([0 fs/2/V])
xlabel('Spatial frequency in cycles/meter')
ylabel('dB')
title('Spectrum of Rayleigh + lognormal series')


