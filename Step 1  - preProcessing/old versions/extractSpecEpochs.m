
%% extractSpecEpochs
subject =  {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' ...
            '336' '337' '340' '342' '344' '345' '346' '347' '348' '350'};
for s = 1:size(subject,2)
    fileName = [subject{s} '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej'...
        '_ICA_dipFited_ICrm'];
    source_filePath = ['F:\\study 3\\' subject{s}];
    destin_filePath = [source_filePath '\new epochs'];
    EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
    
    if ~exist(destin_filePath,'dir')
        mkdir(destin_filePath);
    end
    
    %% 7. edit events values:
    % EEG = editEvents_v3(EEG);
    % EEG = eeg_checkset(EEG);
    % fileName = [fileName '_evtEditedv3'];
    % EEG = pop_saveset( EEG, 'filename',[ fileName '.set'],'filepath',filePath);
    
    
    %% 8. Extract ALL epochs
    %% all CFS stimuli
    % EEG = pop_epoch( EEG, {  '111' '121' '131' '141' '112' '122' '132' '142' ...
    %                          '113' '123' '133' '143' '114' '124' '134' '144' }, ...
    %      [-1.2 2], 'epochinfo', 'yes');
    % EEG = eeg_checkset( EEG );
    % EEG = eeg_checkset( EEG );
    % fileName_allCFS = ['allCFS_' fileName];
    % EEG = pop_saveset( EEG, 'filename',[ fileName_allCFS '.set'],'filepath',filePath);
    %
    %% all noCFS stimuli
    % EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath);
    % if str2double(subject) > 328
    %     EEG = pop_epoch( EEG, {  '105' '106' '107' '108' }, [-1.6 2], 'epochinfo', 'yes');
    % else
    %     EEG = pop_epoch( EEG, {  '101' '102' '103' '104' }, [-1.6 2], 'epochinfo', 'yes');
    % end
    % EEG = eeg_checkset( EEG );
    % EEG = eeg_checkset( EEG );
    % fileName_allNoCFS = ['allNoCFS_' fileName];
    % EEG = pop_saveset( EEG, 'filename',[ fileName_allNoCFS '.set'],'filepath',filePath);
    
    
    %% MANUALLY REJECT EPOCHS FROM THESE TWO DATASETS ABOVE  - Based on extreame values in C3,C4,O1,O2
    
    %% 9. Extract specific epoches
    %% Rec4 - actions
    try
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
        EEG = pop_epoch( EEG, { '114' '124' '134' }, [-1.6 2], 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-1200 -1000]);
        EEG = eeg_checkset( EEG );
        fileName_fullActRec = ['ActRec4_' fileName];
        EEG = pop_saveset( EEG, 'filename',[ fileName_fullActRec '.set'],'filepath',destin_filePath);
    catch error
    end
    
    %% Rec3 - actions
    try
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
        EEG = pop_epoch( EEG, {  '113' '123' '133' }, [-1.6 2], 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-1200 -1000]);
        EEG = eeg_checkset( EEG );
        fileName_fullActRec = ['ActRec3_' fileName];
        EEG = pop_saveset( EEG, 'filename',[ fileName_fullActRec '.set'],'filepath',destin_filePath);
    catch error
    end
    
    %% Rec34 - actions
    try
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
        EEG = pop_epoch( EEG, { '114' '124' '134' '113' '123' '133' }, [-1.6 2], 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-1200 -1000]);
        EEG = eeg_checkset( EEG );
        fileName_fullActRec = ['ActRec34_' fileName];
        EEG = pop_saveset( EEG, 'filename',[ fileName_fullActRec '.set'],'filepath',destin_filePath);
    catch error
    end
    
    %% Rec2 - actions
    try
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
        EEG = pop_epoch( EEG, {  '112' '122' '132' }, [-1.6 2], 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-1200 -1000]);
        EEG = eeg_checkset( EEG );
        fileName_fullActRec = ['ActRec2_' fileName];
        EEG = pop_saveset( EEG, 'filename',[ fileName_fullActRec '.set'],'filepath',destin_filePath);
    catch error
    end
    
    %% Rec1 - actions
    try
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
        EEG = pop_epoch( EEG, {  '111' '121' '131' }, [-1.6 2], 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-1200 -1000]);
        EEG = eeg_checkset( EEG );
        fileName_noActRec = ['ActRec1_' fileName];
        EEG = pop_saveset( EEG, 'filename',[ fileName_noActRec '.set'],'filepath',destin_filePath);
    catch error
    end
    
    %% Rec12 - actions
    try
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
        EEG = pop_epoch( EEG, { '111' '121' '131' '112' '122' '132' }, [-1.6 2], 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-1200 -1000]);
        EEG = eeg_checkset( EEG );
        fileName_noActRec = ['ActRec12_' fileName];
        EEG = pop_saveset( EEG, 'filename',[ fileName_noActRec '.set'],'filepath',destin_filePath);
    catch error
    end
    
    %% Rec4 - control
    try
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
        EEG = pop_epoch( EEG, { '144' }, [-1.6 2], 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-1200 -1000]);
        EEG = eeg_checkset( EEG );
        fileName_fullCtrlRec = ['CtrlRec4_' fileName];
        EEG = pop_saveset( EEG, 'filename',[ fileName_fullCtrlRec '.set'],'filepath',destin_filePath);
    catch error
    end
    
    %% Rec3 - control
    try
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
        EEG = pop_epoch( EEG, { '143' }, [-1.6 2], 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-1200 -1000]);
        EEG = eeg_checkset( EEG );
        fileName_fullCtrlRec = ['CtrlRec3_' fileName];
        EEG = pop_saveset( EEG, 'filename',[ fileName_fullCtrlRec '.set'],'filepath',destin_filePath);
    catch error
    end
    
    %% Rec34 - control
    try
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
        EEG = pop_epoch( EEG, { '143' '144' }, [-1.2 2], 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-1200 -1000]);
        EEG = eeg_checkset( EEG );
        fileName_fullCtrlRec = ['CtrlRec34_' fileName];
        EEG = pop_saveset( EEG, 'filename',[ fileName_fullCtrlRec '.set'],'filepath',destin_filePath);
    catch error
    end
    
    %% Rec2 - control
    try
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
        EEG = pop_epoch( EEG, { '142' }, [-1.6 2], 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-1200 -1000]);
        EEG = eeg_checkset( EEG );
        fileName_fullCtrlRec = ['CtrlRec2_' fileName];
        EEG = pop_saveset( EEG, 'filename',[ fileName_fullCtrlRec '.set'],'filepath',destin_filePath);
    catch error
    end
    
    %% Rec1 - control
    try
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
        EEG = pop_epoch( EEG, { '141' }, [-1.6 2], 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-1200 -1000]);
        EEG = eeg_checkset( EEG );
        fileName_fullCtrlRec = ['CtrlRec1_' fileName];
        EEG = pop_saveset( EEG, 'filename',[ fileName_fullCtrlRec '.set'],'filepath',destin_filePath);
    catch error
    end
    
    %% Rec12 - control
    try
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
        EEG = pop_epoch( EEG, { '142' '141' }, [-1.6 2], 'epochinfo', 'yes');
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-1200 -1000]);
        EEG = eeg_checkset( EEG );
        fileName_fullCtrlRec = ['CtrlRec12_' fileName];
        EEG = pop_saveset( EEG, 'filename',[ fileName_fullCtrlRec '.set'],'filepath',destin_filePath);
    catch error
    end
    
    %% noCFS - actions
    try
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
        if str2double(subject{s}) > 328
            EEG = pop_epoch( EEG, {  '105' '106' '107' }, [-1.6 2], 'epochinfo', 'yes');
        else
            EEG = pop_epoch( EEG, {  '101' '102' '103' }, [-1.6 2], 'epochinfo', 'yes');
        end
        
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-1600 -1400]);
        EEG = eeg_checkset( EEG );
        fileName_noCFSact = ['noCFSact_' fileName];
        EEG = pop_saveset( EEG, 'filename',[ fileName_noCFSact '.set'],'filepath',destin_filePath);
    catch error
    end
    
    %% noCFS - control
    try
        EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',source_filePath);
        if str2double(subject{s}) > 328
            EEG = pop_epoch( EEG, { '108' }, [-1.6 2], 'epochinfo', 'yes');
        else
            EEG = pop_epoch( EEG, { '104' }, [-1.6 2], 'epochinfo', 'yes');
        end
        
        EEG = eeg_checkset( EEG );
        EEG = pop_rmbase( EEG, [-1600 -1400]);
        EEG = eeg_checkset( EEG );
        fileName_noCFSctrl = ['noCFSctrl_' fileName];
        EEG = pop_saveset( EEG, 'filename',[ fileName_noCFSctrl '.set'],'filepath',destin_filePath);
    catch error
    end
end

%% Exract Epochs Manualy
% fullRecog - all events ending with '54' (from -1 sec to 2)
% unRecog   - all events ending with '61' (same)
% baseline removal - [-1000 -800]

% control   - all events 100+ events (-2.6 to 2)
% baseline removal - [-2600 -2400]

%% 9. Manual/Auto rejection of epochs with artifacts!!!
% save data sets


%% additiona helpfull functions
% EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath);
% EEG = eeg_checkset( EEG );
% pop_eegplot(EEG,1,1,1);


