

%% PreProcessesing_allCNFs

%% open EEGLAB
if ~exist('ALLEEG', 'var')
    eeglab
end

%% parameters:
subjectNum = '335';        % Subject Number
fileName   = subjectNum;
filePath   = ['C:\\Users\\user\\Dropbox\\study 3 - CFS EEG\\' subjectNum '\\'];
filter     = [0.5 40];     % [highpass filter  lowpass filter]
ref_elcs   = [69 70];      % mean of electrodes M1,M2 is subtructed from each elc in each time point


%% 1. read bdf:
EEG = pop_readbdf([filePath subjectNum '.bdf'], [], 73, []);
EEG.setname = subjectNum;
EEG = eeg_checkset(EEG);
EEG = pop_saveset( EEG, 'filename',[fileName '.set'] ,'filepath',filePath);


%% 2. channel loacations edit:
EEG = pop_chanedit(EEG, 'lookup','C:\\toolbox\\eeglab12_0_1_0b\\plugins\\dipfit2.2\\standard_BESA\\standard-10-5-cap385.elp');
EEG = eeg_checkset( EEG );


%% 3. filter data:
EEG = pop_eegfilt( EEG, filter(1), filter(2), [], [0], 0, 0, 'fir1', 0);
EEG = eeg_checkset( EEG );
fileName = [fileName '_' num2str(filter(1)) '-' num2str(filter(2)) 'flt'];
EEG = pop_saveset( EEG, 'filename',[fileName '.set'] ,'filepath',filePath);


%% 4. re-reference :
EEG = pop_reref(EEG, ref_elcs);
fileName = [fileName '_M1M2ref'];
EEG = pop_saveset( EEG, 'filename',[fileName '.set'] ,'filepath',filePath);
% inspect the data when done
% reject data MANUALLY when needed - trials with blinks on stimulus onset
% save new data set in GUI
EEG = pop_saveset( EEG, 'filename', [fileName '.set'],'filepath',filePath);
y = input('plot EEG? y/n ');
if strcmp(y, 'y')
    fileName = [fileName '_MANrej'];
    pop_eegplot(EEG,1,1,1);
end


%% 5. run ICA
% insect the data when done (ICA spectra and maps + ICA scroll) 
% choose ICs of blinks and eye movements 2 remove from data
EEG = pop_runica(EEG, 'extended',1,'interupt','on');
EEG = eeg_checkset( EEG );
fileName = [fileName '_ICA'];
EEG = pop_saveset( EEG, 'filename', [fileName '.set'] ,'filepath', filePath);


%% 6. remove ICs of blinks and eye movements: 
rmIC = input('insert IC 2 remove: '); 
EEG = pop_subcomp( EEG, rmIC, 0);
EEG = eeg_checkset( EEG );
fileName = [fileName '_ICrm'];
EEG = pop_saveset( EEG, 'filename', [fileName '.set'],'filepath',filePath);


%% 7. edit events values:
EEG = editEvents_v3(EEG);
EEG = eeg_checkset(EEG);
fileName = [fileName '_evtEditedv3'];
EEG = pop_saveset( EEG, 'filename',[ fileName '.set'],'filepath',filePath);


%% 8. Extract ALL epochs
%% all CFS stimuli
EEG = pop_epoch( EEG, {  '111' '121' '131' '141' '112' '122' '132' '142' ...
                         '113' '123' '133' '143' '114' '124' '134' '144' }, ...
     [-1.2 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = eeg_checkset( EEG );
fileName_allCFS = ['allCFS_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_allCFS '.set'],'filepath',filePath);

%% all noCFS stimuli
EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath); 
EEG = pop_epoch( EEG, {  '105' '106' '107' '108' }, [-1.6 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = eeg_checkset( EEG );
fileName_allNoCFS = ['allNoCFS_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_allNoCFS '.set'],'filepath',filePath);

%% MANUALLY REJECT EPOCHS FROM THESE TWO DATASETS ABOVE  - Based on extreame values in C3,C4,O1,O2

%% 9. Extract specific epoches
%% Rec4 - actions
fileName = fileName_allCFS; 
EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath); 
EEG = pop_epoch( EEG, { '114' '124' '134' }, [-1.2 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1200 -1000]);
EEG = eeg_checkset( EEG );
fileName_fullActRec = ['ActRec4_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_fullActRec '.set'],'filepath',filePath);

%% Rec3 - actions
EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath); 
EEG = pop_epoch( EEG, {  '113' '123' '133' }, [-1.2 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1200 -1000]);
EEG = eeg_checkset( EEG );
fileName_fullActRec = ['ActRec3_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_fullActRec '.set'],'filepath',filePath);

%% Rec34 - actions
EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath); 
EEG = pop_epoch( EEG, { '114' '124' '134' '113' '123' '133' }, [-1.2 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1200 -1000]);
EEG = eeg_checkset( EEG );
fileName_fullActRec = ['ActRec34_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_fullActRec '.set'],'filepath',filePath);

%% Rec2 - actions
EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath); 
EEG = pop_epoch( EEG, {  '112' '122' '132' }, [-1.2 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1200 -1000]);
EEG = eeg_checkset( EEG );
fileName_fullActRec = ['ActRec2_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_fullActRec '.set'],'filepath',filePath);

%% Rec1 - actions
EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath); 
EEG = pop_epoch( EEG, {  '111' '121' '131' }, [-1.2 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1200 -1000]);
EEG = eeg_checkset( EEG );
fileName_noActRec = ['ActRec1_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_noActRec '.set'],'filepath',filePath);

%% Rec12 - actions
EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath); 
EEG = pop_epoch( EEG, { '111' '121' '131' '112' '122' '132' }, [-1.2 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1200 -1000]);
EEG = eeg_checkset( EEG );
fileName_noActRec = ['ActRec12_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_noActRec '.set'],'filepath',filePath);


%% Rec4 - control
EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath); 
EEG = pop_epoch( EEG, { '144' }, [-1.2 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1200 -1000]);
EEG = eeg_checkset( EEG );
fileName_fullCtrlRec = ['CtrlRec4_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_fullCtrlRec '.set'],'filepath',filePath);

%% Rec3 - control
EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath); 
EEG = pop_epoch( EEG, { '143' }, [-1.2 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1200 -1000]);
EEG = eeg_checkset( EEG );
fileName_fullCtrlRec = ['CtrlRec3_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_fullCtrlRec '.set'],'filepath',filePath);

%% Rec34 - control
EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath); 
EEG = pop_epoch( EEG, { '143' '144' }, [-1.2 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1200 -1000]);
EEG = eeg_checkset( EEG );
fileName_fullCtrlRec = ['CtrlRec34_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_fullCtrlRec '.set'],'filepath',filePath);

%% Rec2 - control
EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath); 
EEG = pop_epoch( EEG, { '142' }, [-1.2 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1200 -1000]);
EEG = eeg_checkset( EEG );
fileName_fullCtrlRec = ['CtrlRec2_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_fullCtrlRec '.set'],'filepath',filePath);

%% Rec1 - control
EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath); 
EEG = pop_epoch( EEG, { '141' }, [-1.2 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1200 -1000]);
EEG = eeg_checkset( EEG );
fileName_fullCtrlRec = ['CtrlRec1_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_fullCtrlRec '.set'],'filepath',filePath);

%% Rec12 - control
EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath); 
EEG = pop_epoch( EEG, { '142' '141' }, [-1.2 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1200 -1000]);
EEG = eeg_checkset( EEG );
fileName_fullCtrlRec = ['CtrlRec12_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_fullCtrlRec '.set'],'filepath',filePath);

%% noCFS - actions
fileName = 'fileName_allNoCFS';
EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath); 
EEG = pop_epoch( EEG, { '105' '106' '107' }, [-1.6 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1600 -1400]);
EEG = eeg_checkset( EEG );
fileName_noCFSact = ['noCFSact_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_noCFSact '.set'],'filepath',filePath);

%% noCFS - control
EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath); 
EEG = pop_epoch( EEG, { '108' }, [-1.6 2], 'epochinfo', 'yes');
EEG = eeg_checkset( EEG );
EEG = pop_rmbase( EEG, [-1600 -1400]);
EEG = eeg_checkset( EEG );
fileName_noCFSctrl = ['noCFSctrl_' fileName];
EEG = pop_saveset( EEG, 'filename',[ fileName_noCFSctrl '.set'],'filepath',filePath);


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


