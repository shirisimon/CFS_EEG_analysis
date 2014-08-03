%% preProcessing2
clear all
subject = {'351' '352' '353'};
for s = 1:size(subject,2);
    file_name = [subject{s} '_0.5-40flt_AVGref_evtEdited_manRJ'];
    file_path = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\3rd pool - tests\\' subject{s} '\\'];
    EEG = pop_loadset('filename', [file_name '.set'], 'filepath', file_path);
    
    %% 7. run ICA
    % insect the data when done (ICA spectra and maps + ICA scroll)
    % choose ICs of blinks and eye movements 2 remove from data
    EEG = pop_runica(EEG, 'extended',1,'interupt','on');
    EEG = eeg_checkset( EEG );
    file_name = [file_name '_ICA'];
    EEG = pop_saveset( EEG, 'filename', [file_name '.set'] ,'filepath', file_path);
    
    %% 8. DIPFIT
    EEG = pop_dipfit_settings( EEG, 'hdmfile','C:\\toolbox\\eeglab12_0_1_0b\\plugins\\dipfit2.2\\standard_BESA\\standard_BESA.mat',...
        'coordformat','Spherical', ...
        'mrifile','C:\\toolbox\\eeglab12_0_1_0b\\plugins\\dipfit2.2\\standard_BESA\\avg152t1.mat', ...
        'chanfile','C:\\toolbox\\eeglab12_0_1_0b\\plugins\\dipfit2.2\\standard_BESA\\standard-10-5-cap385.elp', ...
        'chansel', [1:64] );
    EEG = pop_multifit(EEG, [1:70] ,'threshold',100,'dipplot','off');
    file_name = [file_name '_dipFited'];
    EEG = pop_saveset( EEG, 'filename', [file_name '.set'],'filepath',file_path);
    
end
