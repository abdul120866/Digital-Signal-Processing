%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% VoiceDBSpectrogram.m
%
% 1. Loads a voice recording from Lab #1 (must be a WAV or MAT file)
% 2. Selects a vowel region
% 3. Creates a dB spectrogram with a "long" section length (narrowband)
% 4. Measures harmonic spacing -> fundamental frequency
% 5. Compares fundamental period to the pitch period from Lab #1
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear; close all; clc;

%% (1) Load your recorded voice signal
% Suppose your file is "my_voice.wav" or "lab1_voice.wav"
[xx, fs] = audioread('Recording(1).m4a');  % <-- change filename as needed
xx = xx(:);                             % ensure column vector

% Create a time axis for reference
tt = (0:length(xx)-1)/fs;

%% (2) Select the vowel region
% Suppose from prior inspection or from Lab #1 we know the vowel is around [0.5, 0.8] sec
% Adjust these times based on your data.
tStartVowel = 0.5;  
tEndVowel   = 0.8;
idxVowel    = (tt >= tStartVowel) & (tt <= tEndVowel);
xxVowel     = xx(idxVowel);
ttVowel     = tt(idxVowel);

% Optional: plot wave to visually confirm region
figure;
plot(tt, xx);
hold on; grid on;
xlabel('Time (seconds)'); ylabel('Amplitude');
title('Full Voice Recording with Selected Vowel Region');
% highlight vowel region in a different color:
plot(ttVowel, xxVowel, 'r'); 
legend('Full signal','Vowel region');

%% (3) Create a "long" dB-spectrogram
% A "long" section length -> narrower frequency bins, but less time resolution.
% Typically, for a vowel region we might pick ~20-30 ms or more.
% Let's pick TSECT = 0.025 sec => LSECT in samples = TSECT * fs
TSECT = 0.025;               % 25 ms
LSECT = round(TSECT * fs);   % # of samples

DBrange = 80;  % floor at -80 dB
% We assume you have a function "plotspecDB(xx, fs, Lsect, DBrange)"
% If not, you can use the built-in spectrogram() and convert to dB yourself.

figure;
plotspecDB(xxVowel, fs, LSECT, DBrange);
title(sprintf('dB Spectrogram, Vowel Region (TSECT=%.3f s, LSECT=%d)', ...
               TSECT, LSECT));

% --> Inspect the plot to see the horizontal harmonic lines

%% (4) Annotate the spectrogram
% You might do this manually in the figure: e.g. add text, arrows, etc.
% to indicate the vowel region, parameter values, etc.

%% (5) Measure the frequency separation of the harmonic lines
% Zoom in on the spectrogram in frequency around your vowel formants.
% Use MATLAB's Data Cursor to read off frequencies of adjacent harmonics.

disp('--------------------------------------------------------');
disp('Use Data Cursor on the spectrogram to identify two adjacent');
disp('harmonic lines in the vowel region. Record frequency1 (f1) and frequency2 (f2).');
disp('Then frequency separation is f2 - f1 = fundamental freq f0.');
disp('Compute fundamental period as 1/f0. Compare to Lab #1 pitch period.');
disp('--------------------------------------------------------');
