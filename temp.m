%% temp
sub  =  {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' ...
    '336' '337' '340' '342' '344' '345' '346' '347' '348' '350'};

for s = 1:size(sub,2);
    fileName = [sub{s} '_0.5-40flt_M1M2ref_evtEditedv3_allEpochs_' ...
        'manRej_ICA_dipFited'];
    filePath = ['F:\study 3\' sub{s} '\'];
    EEG = pop_loadset('filename', [fileName '.set'], 'filepath', filePath);
    
    rmIC = input('insert IC 2 remove: ');
    EEG = pop_subcomp( EEG, rmIC, 0);
    EEG = eeg_checkset( EEG );
    fileName = [fileName '_ICrm'];
    EEG = pop_saveset( EEG, 'filename', [fileName '.set'],'filepath',filePath);
end