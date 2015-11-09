%% preProcessign_2nd

clear
subject = {'328' '329' '333'};
%{'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' ...
         
for s = 1:size(subject,2);
    
    fileName = [subject{s} '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_manRej'];
    filePath = ['F:\study 3\' subject{s} ];
    EEG = pop_loadset('filename', [fileName '.set'], 'filepath', filePath);
    
    
    %% 7. run ICA
    % insect the data when done (ICA spectra and maps + ICA scroll)
    % choose ICs of blinks and eye movements 2 remove from data
    
    EEG = pop_runica(EEG, 'extended',1,'interupt','on');
    EEG = eeg_checkset( EEG );
    fileName = [fileName '_ICA'];
    EEG = pop_saveset( EEG, 'filename', [fileName '.set'] ,'filepath', filePath);
    
    %% 8. DIPFIT
    
    EEG = pop_dipfit_settings( EEG, 'hdmfile','C:\\toolbox\\eeglab12_0_1_0b\\plugins\\dipfit2.2\\standard_BESA\\standard_BESA.mat',...
        'coordformat','Spherical', ...
        'mrifile','C:\\toolbox\\eeglab12_0_1_0b\\plugins\\dipfit2.2\\standard_BESA\\avg152t1.mat', ...
        'chanfile','C:\\toolbox\\eeglab12_0_1_0b\\plugins\\dipfit2.2\\standard_BESA\\standard-10-5-cap385.elp', ...
        'chansel', [1:64] );
    EEG = pop_multifit(EEG, [1:70] ,'threshold',100,'dipplot','off');
    fileName = [fileName '_dipFited'];
    EEG = pop_saveset( EEG, 'filename', [fileName '.set'],'filepath',filePath);
    
    
    %% remove ICs
    %     rmIC = input('insert IC 2 remove: ');
    %     EEG = pop_subcomp( EEG, rmIC, 0);
    %     EEG = eeg_checkset( EEG );
    %     fileName = [fileName '_ICrm'];
    %     EEG = pop_saveset( EEG, 'filename', [fileName '.set'],'filepath',filePath);
    
    %% auto rejection
    %     [EEG, trls2rej] = pop_eegthresh(EEG,1,[13 50] ,-100,100,-1.6016,1.9961,0,1);
    %     EEG = pop_rejepoch( EEG, trls2rej ,0);
    %     EEG = eeg_checkset( EEG );
    %     fileName = [fileName '_manRej'];
    %     EEG = pop_saveset( EEG, 'filename', [fileName '.set'],'filepath',filePath);
end


