
function EEG = extractEpochs(EEG, trigger, window, baseline)

if nargin<4
    baseline = [];
end

EEG = pop_epoch(EEG, trigger, window, 'epochinfo', 'yes');
EEG = eeg_checkset(EEG);
if ~isempty(baseline)
    EEG = pop_rmbase(EEG, baseline);
end
EEG = eeg_checkset(EEG);
end