function yesno = hear_sinus(amplitude, frequency, duration, Fs)
    tt = 0:1/Fs:duration;
    % Randomize phase so it’s not always starting at zero
    xx = amplitude * cos(2*pi*frequency*tt + 2*pi*rand());
    sound(xx, Fs);
    pause(duration);  % let it finish playing
    user_response = input('Did you hear it? (y = yes, [Enter] = no): ','s');
    if ~isempty(user_response) && (upper(user_response(1)) == 'Y')
        yesno = true;
    else
        yesno = false;
    end
end
