function power = getFreqEnvelope2stimuliIndex(data, times, onset, offset)

time = (times(offset)-times(onset))/1000; 
stimuli_freq = [1.49 1.51]; % in Hz
srate = floor(size(data,2)/time); 

% f = fft(data);
% freq = linspace(0,srate/2,floor(length(f)/2)); % the bin at the center of the mirror corresponds to half of the sampling frequency
% f = f(1:floor(length(f)/2));                   % taking only single side
% f_abs = abs(f) / length(f);                    % normalizing the amplitude
% f_abs = 10*log10(f_abs);

power = bandpower(data,srate,stimuli_freq);