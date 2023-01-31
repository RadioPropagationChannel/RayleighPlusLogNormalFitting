clear, close all, clc
%% -----------------------------------
load SuzukiSeries1
% load SuzukiSeries2
%%
d = dist_axis;
P = PdBm;
figure, plot(d,P)
xlabel('Traveled distance, m')
ylabel('Received power, dBm')

%% -----------------------------------
p = 10.^(P/10);
figure, plot(d,p)
xlabel('Traveled distance, m')
ylabel('Received power, mW')

%% -----------------------------------
AveragingWindow = 20.0 ;      % meters

windowLength = round(AveragingWindow/ds); % number of samples

W = ones(windowLength,1);  % Create running mean window
W = W/windowLength;        % Normalize window
figure, stem(W)
title('Sliding window for low-pass filtering')
xlabel('Sample number')
ylabel('Amplitude')
xlim([-10 length(W)+10])

%% hann window

% W = hann(windowLength);  % Create Hanning window
% W = W/windowLength;        % Normalize window
% figure, stem(W)
% title('Sliding window for low-pass filtering')
% xlabel('Sample number')
% ylabel('Amplitude')
% xlim([-10 length(W)+10])

%% -----------------------------------
pfilt = conv(p,W,'same');
figure, plot(d, p,'g', d, pfilt,'r')
xlabel('Traveled distance, m')
ylabel('Average received power, W')

%% ----------------------------------------
Pfilt = 10*log10(pfilt); % we now go back to dBm  
figure,plot(d, P, 'g') , hold on
plot(d, Pfilt, 'r', 'Linewidth',2)
xlabel('Traveled distance, m')
ylabel('Power, dBm')
legend('Overall', 'Mean')

%% ---------------------------------------
% Verify fit to Gaussian model 
MM = mean(Pfilt);
SS = std(Pfilt);
disp(['Series mean : ', num2str(MM),' dBm'])
disp(['Series std : ', num2str(SS),' dBm'])
[~, ~, CDFx,CDFy, stepCDF] = fpdfCDFbins(Pfilt, 40);
[pdfX, pdfY, ~, ~, steppdf] = fpdfCDFbins(Pfilt, 20);

%% ----------------------------------------
% Theoretical distribution
Paxis = (min(Pfilt):max(Pfilt));
pdf = 1/(sqrt(2*pi)*SS)*exp(-0.5*((Paxis-MM)/SS).^2);
fhist = pdf*steppdf;
figure, hold on
bar(pdfX, pdfY,'y')
plot(Paxis, fhist,'r', 'LineWidth',2)
xlabel('Locan mean powers in dBm')
ylabel('Probabilities')
xlim([min(Pfilt) max(Pfilt)])

F = 1-qfunc((Paxis-MM)/SS);
figure, hold on
bar(CDFx,CDFy, 'y')
plot(Paxis, F, 'r','LineWidth',2)
xlabel('Locan mean powers in dBm')
ylabel('Probability the abscissa is not exceeded')
xlim([min(Pfilt) max(Pfilt)])
%% autocorrelation of Pfilt

rho_Pfilt = xcov(Pfilt,'coeff');
rho_axis = (1:length(Pfilt)*2-1) - length(Pfilt); % axis in samples
rho_axis = rho_axis*ds;        % axis in meters
figure, plot(rho_axis, rho_Pfilt,'k', 'LineWidth',2)
xlim([-100 100]), grid on

corrThresh = exp(-1); % 0.1  % correlation threshold, tipically 1/e
maxPoint = find(rho_Pfilt == 1);
II = find(rho_Pfilt(maxPoint:end) < corrThresh);
corrLength = rho_axis(II(1)+maxPoint);
disp(['Correlation Length = ',num2str(corrLength),' m'])

%% ------------------------------------------------
% Extract out fast the variations 
% ------------------------------------------------
P0 = P - Pfilt;
figure, plot(d, P0)
ylabel('Normalized fast variations, dB')
xlabel('Traveled distance, m')
% xlim([0 50])
% title('First 50 m of series')

p0 = 10.^(P0/10);
mean_p0 = mean(p0);
p0norm = p0/mean_p0;
vnorm = sqrt(p0norm); 
 
figure, plot(d, vnorm)
ylabel('Normalized fast variations, dB')
xlabel('Traveled distance, m')

%% save to file for processing elsewhere

time_axis = d/V;
PdBm = P0;
save reminderSeries time_axis PdBm

 
