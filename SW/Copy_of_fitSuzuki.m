clear, close all, clc
%% -----------------------------------
load SuzukiSeries
% load series12new
% load series2000
%%
d = dist_axis;
P = PdBm;
figure, plot(d,P)
xlabel('Traveled distance, m')
ylabel('Received power, dBm')
figure, plot(d,P)
xlim([0 100])
xlabel('Traveled distance, m')
ylabel('Received power, dBm')
title('First 100 m of the series') 
%% -----------------------------------
p = 10.^(P/10)/1000;
figure, plot(d,p)
xlabel('Traveled distance, m')
ylabel('Received power, W')
figure, plot(d,p)
xlim([0 100])
xlabel('Traveled distance, m')
ylabel('Received power, W')
title('First 100 m of the series') 
%% -----------------------------------
wlFraction = 4;            % samling fraction of wavelength
ds = d(2)-d(1);            % m, sample spacing 
wl = ds*wlFraction;        % m, wavelength
windowWavelengths = 10;    % No. of wavelengths in running mean filte
windowLength = wlFraction*windowWavelengths;  % samples in window 
W = ones(windowLength,1);  % Create running mean window
W = W/windowLength;        % Normalize window
figure, stem(W)
title('Sliding window for filtering')
xlabel('Sample number')
ylabel('Amplitude')
axis([-10 length(W)+10 0 0.05])
%% -----------------------------------
pfilt = conv(p,W,'same');
figure, plot(d, p, d, pfilt,'r')
xlabel('Traveled distance, m')
ylabel('Average received power, W')
figure, plot(d, p,d, pfilt,'r' )
xlim([0 100])
legend('Overall', 'Mean')
xlabel('Traveled distance, m')
ylabel('Power, W')
%% ----------------------------------------
Pfilt = 10*log10(pfilt) + 30; % we now go back to dBm  
%% --------------------------------------
figure,plot(d, P, 'g') , hold on
plot(d, Pfilt, 'r', 'Linewidth',2)
xlabel('Traveled distance, m')
ylabel('Power, dBm')
legend('Overall', 'Mean')
figure, plot(d, P,'g'), hold on
plot(d, Pfilt, 'r', 'Linewidth',2)
xlabel('Traveled distance, m')
ylabel('Power, dBm')
legend('Overall', 'Mean')
xlim([0 50])
title('First 50 m in series')
%% ---------------------------------------
% Verify fit to Gaussian model 
MM = mean(Pfilt);
SS = std(Pfilt);
disp(['Series mean : ', num2str(MM),' dBm'])
disp(['Series std : ', num2str(SS),' dBm'])
N_bins = 20;
[a,b] = hist(Pfilt,N_bins);
histBin = b(2)-b(1);
a = a/length(Pfilt);
aa = cumsum(a);
%% ----------------------------------------
% Theoretical distribution
Paxis = (min(Pfilt):max(Pfilt));
pdf = 1/(sqrt(2*pi)*SS)*exp(-0.5*((Paxis-MM)/SS).^2);
fhist = pdf*histBin;
figure, bar(b,a,'y'), hold on, plot(Paxis, fhist,'r', 'LineWidth',2)
xlabel('Potecias medias, dBm')
ylabel('Probabilidades')
F = 1-qfunc((Paxis-MM)/SS);
figure, bar(b,aa, 'y'), hold on, plot(Paxis, F, 'r','LineWidth',2)
xlabel('Potecias medias, dBm')
ylabel('Probabilidad de no exceder la abscisa')




%% ------------------------------------------------
% Extract out fast the variations 
% ------------------------------------------------
P0 = P - Pfilt;
figure, plot(d, P0)
ylabel('Normalized fast variations, dB')
xlabel('Traveled distance, m')
xlim([0 50])
title('First 50 m of series')
vnorm = 10.^(P0/20);
% mean(r0.^2)   
figure, plot(d, vnorm)
ylabel('Normalized fast variations, dB')
xlabel('Traveled distance, m')
xlim([0 50])
title('First 50 m of series')

