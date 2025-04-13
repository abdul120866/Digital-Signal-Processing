function hearing_test_example
    % HEARING_TEST_EXAMPLE
    % A simple script to measure your hearing threshold across chosen frequencies.
    % Plays a tone at each frequency, adaptively adjusting amplitude until threshold is found.

    close all; clc;

    % -- Parameters --
    Fs = 44100;            % Audio sampling rate
    testFreqs = [250, 500, 1000, 2000, 4000, 8000, 16000];  % Frequencies to test
    duration = 1.0;        % Each tone's duration (seconds)
    initAmplitude = 0.02;  % Starting amplitude guess
    stepFactor = 2;        % Factor by which amplitude changes (binary search style)
    tolerance = 0.0001;    % Minimum amplitude step

    thresholds = zeros(size(testFreqs));
    
    fprintf('Beginning hearing test...\n');
    fprintf('(Use headphones, ensure volume is safe)\n\n');
    
    for i = 1:length(testFreqs)
        freq = testFreqs(i);
        fprintf('Testing frequency = %.1f Hz...\n', freq);
        
        ampHigh = initAmplitude;  % upper bound on amplitude
        ampLow = 0;               % lower bound
        foundThreshold = false;

        % First, see if the user can hear the initial amplitude:
        canHear = hear_sinus(ampHigh, freq, duration, Fs);
        if ~canHear
            % Increase amplitude until user hears it
            while ~canHear && ampHigh < 1.0
                ampHigh = ampHigh * stepFactor;
                fprintf('Increasing amplitude to %.5f...\n', ampHigh);
                canHear = hear_sinus(ampHigh, freq, duration, Fs);
            end
            if ~canHear
                % user never hears tone up to amplitude=1
                ampHigh = 1.0;
                fprintf(['Max amplitude reached; cannot hear ' ...
                         'this frequency at volume=1.\n']);
            end
        end
        
        % At this point, canHear==true for ampHigh, or ampHigh is at max=1.
        % Now binary search between ampLow and ampHigh:
        while (ampHigh - ampLow) > tolerance
            ampMid = (ampLow + ampHigh)/2;
            yesno = hear_sinus(ampMid, freq, duration, Fs);
            if yesno
                % If user hears ampMid, it’s above threshold
                ampHigh = ampMid;
            else
                % If user does NOT hear ampMid, it’s below threshold
                ampLow = ampMid;
            end
        end
        
        threshold_amp = (ampLow + ampHigh)/2;
        thresholds(i) = threshold_amp;
        fprintf('Estimated threshold amplitude for %.1f Hz = %.5f\n\n', ...
                freq, threshold_amp);
    end
    
    % Convert to dB
    threshold_dB = 20*log10(thresholds);
    
    % Plot results
    figure;
    semilogx(testFreqs, threshold_dB, 'o-');
    xlabel('Frequency (Hz) [log scale]');
    ylabel('Threshold Amplitude (dB)');
    title('Measured Hearing Threshold via Simple Binary Search');
    grid on;
    
    % Display final table in command window
    disp('Summary of results (Amplitude and dB):');
    disp(table(testFreqs', thresholds', threshold_dB', ...
        'VariableNames', {'Frequency_Hz','ThresholdAmplitude','Threshold_dB'}));
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function yesno = hear_sinus(amplitude, frequency, duration, Fs)
% HEAR_SINUS
%   Plays a single tone with the given amplitude, frequency, duration, 
%   sampling rate Fs. Returns boolean yes/no based on user input.

    tt = 0:1/Fs:duration;
    % random initial phase so user can't guess from artifacts
    xx = amplitude * cos(2*pi*frequency*tt + 2*pi*rand());
    
    % Safety check: amplitude should never exceed 1
    xx = max(min(xx, 1), -1);

    sound(xx, Fs);
    pause(duration);  % wait for tone to finish
    
    prompt = 'Did you hear it? [y=yes, Enter=no] ';
    user_response = input(prompt, 's');
    if ~isempty(user_response) && (upper(user_response(1)) == 'Y')
        yesno = true;
    else
        yesno = false;
    end
end
