%% preProcessing3
clear all
ref_elcs_afterICA = [69 70]; % mean of electrodes M1,M2 is subtructed from each elc in each time point
subject = {'351', '352', '353'};
for s = 1:size(subject,2);
    file_name = [subject{s} '_0.5-40flt_AVGref_evtEdited_manRJ_ICA_dipFited'];
    file_path = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\3rd pool - tests\\'...
        subject{s} '\\'];
    EEG = pop_loadset('filename', [file_name '.set'], 'filepath', file_path);
    
    %% 9. remove ICs - of blinks, eye movements, muscles, heart rate and elc:
    rmIC = input('insert IC 2 remove: ');
    EEG = pop_subcomp( EEG, rmIC, 0);
    EEG = eeg_checkset( EEG );
    file_name = [file_name '_rmIC'];
    EEG = pop_saveset(EEG, 'filename', [file_name '.set'], 'filepath', file_path); 
    save([file_path 'removed_ICs'], 'rmIC');
    
    %% 10. Re-reference to MASTOIDS: 
    EEG = pop_reref(EEG, ref_elcs_afterICA);
    file_name = [subject{s} '_0.5-40flt_M1M2ref_evtEdited_manRJ_ICA_dipFited_rmIC'];
    EEG = pop_saveset( EEG, 'filename',[file_name '.set'] ,'filepath',file_path);
    
    %% 11. Extract all epochs: 
    file.input_name  = file_name;
    file.input_path  = file_path;
    file.output_name = [file_name '_Epochs'];
    file.output_path = file.input_path;
    epochs = {'31', '32', '33', '34', '35', '36'};
    extractEpochs(EEG, epochs, [-1.8 2], [-1800 -1600], file);
end

%% 12. 2nd AUTO REJECTION
% reject noisy epochs
% reject epochs with extram values (100,-100) in C3, C4
% tools regect epochs > extream values > in plot press 'update marks' >
% again in tools > reject epochs > reject marks
% save new data set in GUI

%% 13. Extract epochs per condition batch:
% extractEpochsBatch()

