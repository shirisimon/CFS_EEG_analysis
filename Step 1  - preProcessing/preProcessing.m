
%% PreProcessesing

%% open EEGLAB
if ~exist('ALLEEG', 'var')
    eeglab
end

%% parameters:

subjects = {'351'};
for subjectNum = 1:size(subjects,2);        % Subject Number
    fileName   = subjects{subjectNum};
    filePath   = ['F:\\study 3\\' subjects{subjectNum} '\\'];
    filter     = [0.5 40];     % [highpass filter  lowpass filter]
    ref_elcs   = [69 70];      % mean of electrodes M1,M2 is subtructed from each elc in each time point
    
    %% 1. read bdf:
    EEG = pop_readbdf([filePath subjects{subjectNum} '.bdf'], [], 73, []);
    EEG.setname = subjects{subjectNum};
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
    
    %% 5. Edit events values :
    EEG = editEvents_v3(EEG);
    EEG = eeg_checkset(EEG);
    fileName = [fileName '_evtEditedv3'];
    EEG = pop_saveset( EEG, 'filename',[ fileName '.set'],'filepath',filePath);
    
    %% 6. Extract all epochs :
    if str2double(subjects{subjectNum}) > 328
        EEG = pop_epoch( EEG, {  '111' '121' '131' '141' '112' '122' '132' '142' ...
            '113' '123' '133' '143' '114' '124' '134' '144' ...
            '105'  '106'  '107'  '108'}, ...
            [-1.6 2], 'epochinfo', 'yes');
    else
        EEG = pop_epoch( EEG, {  '111' '121' '131' '141' '112' '122' '132' '142' ...
            '113' '123' '133' '143' '114' '124' '134' '144' ...
            '101'  '102'  '103'  '104'}, ...
            [-1.6 2], 'epochinfo', 'yes');
    end
    fileName = [fileName '_allEpochs'];
    EEG = pop_saveset( EEG, 'filename', [fileName '.set'],'filepath',filePath);
    
end

%% 9. remove ICs - of blinks, eye movements, muscles, heart rate and elc:
%% in preProcessing_2nd

%% 10. Auto Epoch Rejection :
% reject epochs with extram values (100,-100) in C3, C4
% tools regect epochs > extream values > in plot press 'update marks' >
% again in tools > reject epochs > reject marks
% save new data set in GUI

%% 11. Extract specific epoches
% extractSpecEpochs;

%% additiona helpfull functions
% EEG = pop_loadset('filename',[fileName '.set'] ,'filepath',filePath);
% EEG = eeg_checkset( EEG );
% pop_eegplot(EEG,1,1,1);


