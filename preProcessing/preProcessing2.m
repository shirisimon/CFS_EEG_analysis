%% preProcessing2
clear all
% subject = {'345' '346' '347' '348' '350'};
% subject = {'336' '340' '342' '344' '345' '346' '347' '348' '350'};
subject = {'325' '326' '328' '329' '331' '332' '333' '334' '335' '336'...
    '340' '342' '344' '345' '346' '347' '348' '350'};
for s = 1:size(subject,2);
    file_name = [subject{s} '_0.5-40flt_AVGref_evtEdited_allEpochs_ICA_clean-ICA'];
    file_path = ['C:\\study3_MNS and conscious perception\\data\\2nd_pool_data_2ndPiplinePreProcessing\\' ...
                  subject{s} '\\'];
    EEG = pop_loadset('filename', [file_name '.set'], 'filepath', file_path);
    
    %% 7. run ICA
    % inspect the data when done (ICA spectra and maps + ICA scroll)
    % choose ICs of blinks and eye movements 2 remove from data
    EEG = pop_runica(EEG, 'extended',1,'interupt','on', 'pca', 69);
    EEG = eeg_checkset( EEG );
    file_name = [file_name '_ICA2nd'];
    % EEG = pop_saveset( EEG, 'filename', [file_name '.set'] ,'filepath', file_path);
    
    %% 8. DIPFIT
    EEG = pop_dipfit_settings( EEG, 'hdmfile','C:\\toolbox\\eeglab12_0_1_0b\\plugins\\dipfit2.2\\standard_BESA\\standard_BESA.mat',...
        'coordformat','Spherical', ...
        'mrifile','C:\\toolbox\\eeglab12_0_1_0b\\plugins\\dipfit2.2\\standard_BESA\\avg152t1.mat', ...
        'chanfile','C:\\toolbox\\eeglab12_0_1_0b\\plugins\\dipfit2.2\\standard_BESA\\standard-10-5-cap385.elp', ...
        'chansel', 1:64);
    EEG = pop_multifit(EEG, [1:70] ,'threshold',100,'dipplot','off');
    file_name = [file_name '_dipFited'];
    EEG = pop_saveset( EEG, 'filename', [file_name '.set'],'filepath',file_path);
    
end
