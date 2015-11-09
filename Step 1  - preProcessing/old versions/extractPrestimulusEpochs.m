function extractPrestimulusEpochs()

subject = {'324' '325' '326' '328' '329' '331' '332' '333' ...
    '334' '335' '336' '337' '340' '342' '343' '344' ...
    '345' '346' '347' '348' '350'};

for s = 1:size(subject,2)
    fileName = [subject{s} '_0.5-40flt_M1M2ref_MANrej_ICA_ICrm_evtEditedv3'];
    source_filePath = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\2nd pool data\\' subject{s} '\\'];
    destin_filePath = [source_filePath '\prestimulus epochs'];
    EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
    
    if ~exist(destin_filePath,'dir')
        mkdir(destin_filePath);
    end
    
    %% recognition 1,4
    EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
    EEG = pop_epoch(EEG, {'114' '124' '134' '111' '121' '131'}, [-2.7 2], 'epochinfo', 'yes');
    EEG = eeg_checkset(EEG);
    EEG = pop_rmbase(EEG, [-2700 -2500]);
    EEG = eeg_checkset(EEG);
    fileName_fullActRec = ['actionEpochs_' fileName];
    EEG = pop_saveset( EEG, 'filename',[ fileName_fullActRec '.set'],'filepath',destin_filePath);
    
    
    %% recognition 1
%     EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
%     EEG = pop_epoch(EEG, {}, [-2.7 2], 'epochinfo', 'yes');
%     EEG = eeg_checkset(EEG);
%     EEG = pop_rmbase(EEG, [-2700 -2500]);
%     EEG = eeg_checkset(EEG);
%     fileName_fullActRec = ['ActRec1_' fileName];
%     EEG = pop_saveset( EEG, 'filename',[ fileName_fullActRec '.set'],'filepath',destin_filePath);
    
end