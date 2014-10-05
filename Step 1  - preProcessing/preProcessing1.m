
%% PreProcessesing
%% open EEGLAB
clear all
if ~exist('ALLEEG', 'var')
    eeglab
end

%% parameters:

subjects = {'324' };
for subjectNum = 1:size(subjects,2);        % Subject Number
    file_name   = subjects{subjectNum};
    file_path   = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\'...
                  subjects{subjectNum} '\\'];
    filter             = [0.5 40];             % [highpass filter  lowpass filter]
    ref_elcs_beforeICA = [];           % [] - avergae reference
    
    %% 1. read bdf:
%     EEG = pop_readbdf([file_path subjects{subjectNum} '.bdf'], [], 73, []);
%     EEG.setname = subjects{subjectNum};
%     EEG = eeg_checkset(EEG);
%     EEG = pop_saveset(EEG, 'filename',[file_name '.set'] ,'filepath',file_path);
    EEG = pop_loadset('filename',[file_name '.set'] ,'filepath',file_path);
    
    %% 2. channel loacations edit:
    EEG = editAllLocs(EEG);  % get coordinates for all elcs including face.  
    EEG = eeg_checkset( EEG );
    % EEG = pop_saveset( EEG, 'filename',[file_name '.set'] ,'filepath',file_path);
    
    %% 3. filter data:
    EEG = pop_eegfilt( EEG, filter(1), filter(2), [], [0], 0, 0, 'fir1', 0);
    EEG = eeg_checkset( EEG );
    file_name = [file_name '_' num2str(filter(1)) '-' num2str(filter(2)) 'flt'];
    % EEG = pop_saveset( EEG, 'filename',[file_name '.set'] ,'filepath',file_path);
    
    %% 4. Re-reference to average: (Use to run ICA on mastoids)
    EEG = pop_reref(EEG, ref_elcs_beforeICA);
    file_name = [file_name '_AVGref'];
    EEG = pop_saveset( EEG, 'filename',[file_name '.set'] ,'filepath',file_path);
    
    %% 5. Edit events values :
    EEG = editEvents_v2(EEG);
    EEG = eeg_checkset(EEG);
    file_name = [file_name '_evtEdited'];
    EEG = pop_saveset( EEG, 'filename',[file_name '.set'],'filepath',file_path);
    
    %% 6. MANUAL REJECTION OF NOISY DATA
end


