%% ica_tests

%% load data
subject = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' '336' '340'...
           '342' '344' '345' '346' '347' '348' '350'};
for s  = 1:size(subject,2)
    file_name = [subject{s} '_0.5-40flt_AVGref_evtEdited_allEpochs'];
    file_path = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\' subject{s} '\\'];
    EEG = pop_loadset('filename', [file_name '.set'], 'filepath', file_path);
    
    %% remove noisy epochs 
    EEG = pop_eegthresh(EEG,1,[13 50 27 64] ,-100,100,EEG.xmin, EEG.xmax,0,0); 
    EEG = pop_rejepoch(EEG, EEG.reject.rejthresh, 1);
    
    %% run ICA:
    EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1, 'pca', 71, 'interupt','off');
    %EEG = pop_runica(EEG, 'icatype', 'runica', 'extended',1, 'pca', 71);
    file_name = [file_name '_ICA'];
    EEG = pop_saveset( EEG, 'filename', [file_name '.set'] ,'filepath', file_path);
end

