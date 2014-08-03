
function extractEpochs(EEG, trigger, window, baseline, file)
EEG = pop_epoch(EEG, trigger, window, 'epochinfo', 'yes');
EEG = eeg_checkset(EEG);
EEG = pop_rmbase(EEG, baseline);
EEG = eeg_checkset(EEG);
if ~isdir(file.output_path)
    mkdir(file.output_path);
end
pop_saveset( EEG, 'filename',[ file.output_name '.set'],'filepath', file.output_path);
end