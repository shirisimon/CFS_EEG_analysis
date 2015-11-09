
%% PreProcessesing
%% open EEGLAB
clear all
if ~exist('ALLEEG', 'var')
    eeglab
end

%% parameters:

subjects = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' '336' '340' '342' '344' '345' '346' '347' '348' '350'};
for subjectNum = 1:size(subjects,2);        % Subject Number
    file_name = subjects{subjectNum};
    file_path  = ['C:\\Research\\Study 3 - MNS response to invisible actions\\EEG\\Data\\' ...
        subjects{subjectNum} '\\'];
    filter  = [0.5 40];             % [highpass filter  lowpass filter]
    % ref_elcs_beforeICA = [];           % [] - avergae reference
    
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
    EEG = pop_reref(EEG, [69 70]);
    file_name = [file_name '_M1M2ref'];
    EEG = pop_saveset( EEG, 'filename',[file_name '.set'] ,'filepath',file_path);
    
    %% 5. Edit events values :
    EEG = editEvents_v2(EEG);
    EEG = eeg_checkset(EEG);
    %     file_name = [file_name '_evtEdited'];
    %     EEG = pop_epoch( EEG, {'111' '121' '131' ...
    %                                                '112' '122' '132' ...
    %                                                '113' '123' '133' ... 
    %                                                '114' '124' '134'}, [-2.5 2], 'epochinfo', 'yes');
    if ismember(subjects{subjectNum}, {'324' '325' '326' '328'});
        EEG = pop_epoch( EEG, {'101' '102' '103'}, [-2.5 2], 'epochinfo', 'yes');
    else
        EEG = pop_epoch( EEG, {'105' '106' '107'}, [-2.5 2], 'epochinfo', 'yes');
    end
    EEG = eeg_checkset( EEG );
    file_name = [file_name '_locEpochs'];
    EEG = pop_saveset( EEG, 'filename',[file_name '.set'],'filepath',file_path);
    
    %% 6. MANUAL REJECTION OF NOISY DATA
end


