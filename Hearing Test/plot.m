freqs = [250, 500, 1000, 2000, 4000, 8000, 16000];
A_min = [0.015, 0.010, 0.0055, 0.0035, 0.0040, 0.009, 0.03];
dBvals = 20*log10(A_min);

figure;
semilogx(freqs, dBvals, 'o-');  % Plot dB vs log-scale frequency
grid on;
xlabel('Frequency (Hz) [log scale]');
ylabel('Minimum Audible Amplitude (dB)');
title('Measured Hearing Threshold');
