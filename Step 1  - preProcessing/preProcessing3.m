%% preProcessing3
clear all
loadICs = 0;
rmIC_type = 'blinks';
% loadRejEpochsIdx = 1;
% ref_elcs_afterICA = [69 70]; % mean of electrodes M1,M2 is subtructed from each elc in each time point
% epochRange = [-1.6 2];
% baselineRange = [-1200 -1000];
conds = {'ActRec4', 'ActRec1'};


% subjects = {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' '336'...
%     '340' '342' '344' '345' '346' '347' '348' '350'};
subjects = { '331' '332' '333' '334' '335' '336'...
    '340' '342' '344' '345' '346' '347' '348' '350'};
for s = 1:size(subjects,2);
    %% 9. assign ICA weights and sphers to cond data sets:
    for c = 1:size(conds,2);
        source_file_name = [subjects{s}  '_0.5-40flt_AVGref_evtEdited_allEpochs' ...
            '_ICA_clean-ICA_2ndICA_dipFited'];
        destin_file_name = [conds{c} '_' subjects{s} '_0.5-40flt_M1M2ref_evtEdited_clean-COelcs'];
        source_file_path = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\'...
            subjects{s} '\\'];
        destin_file_path = [source_file_path 'Epochs\\'];
        source_EEG = pop_loadset('filename', [source_file_name '.set'], 'filepath', source_file_path);
        source_EEG = pop_reref(source_EEG, [69 70]); % reference to mastoids for consistency in channels\comps
        EEG = pop_loadset('filename', [destin_file_name '.set'], 'filepath', destin_file_path);
        ALLEEG(1) = source_EEG;
        ALLEEG(2) = EEG;
        EEG = pop_editset(EEG, 'icachansind', 'ALLEEG(1).icachansind', 'icaweights', 'ALLEEG(1).icaweights', 'icasphere', 'ALLEEG(1).icasphere');
        EEG = eeg_checkset( EEG );
        
        %     file_name = [subject{s} '_0.5-40flt_AVGref_evtEdited_manRJ_ICA_dipFited'];
        %     file_path = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\'...
        %         subject{s} '\\'];
        %     EEG = pop_loadset('filename', [file_name '.set'], 'filepath', file_path);
        
        %%  10. remove ICs - of blinks, eye movements, muscles, heart rate and elc:
        if ~loadICs
            rmIC = input('insert IC 2 remove: ');
        else
            load([file_path 'removed_ICs'], 'rmIC');
        end
        EEG = pop_subcomp( EEG, rmIC, 0);
        EEG = eeg_checkset( EEG );
        file_name = [destin_file_name '_rmIC' rmIC_type];
        EEG = pop_saveset(EEG, 'filename', [file_name '.set'], 'filepath', destin_file_path);
        eval(['rmIC' rmIC_type '=rmIC;']);
        save([destin_file_path 'removed_ICs'], ['rmIC' rmIC_type]);
    end
    
    %% 10. Re-reference to MASTOIDS:
    %     EEG = pop_reref(EEG, ref_elcs_afterICA);
    %     file_name = [subject{s} '_0.5-40flt_M1M2ref_evtEdited_manRJ_ICA_dipFited'];
    %      EEG = pop_saveset( EEG, 'filename',[file_name '.set'] ,'filepath',file_path);
    
    %% 11. Extract all epochs:
    %     file.input_name  = file_name;
    %     file.input_path  = file_path;
    %     file.output_name = [file_name '_Epochs'];
    %     file.output_path = file.input_path;
    %     epochs = {'111', '121', '131', '114', '124', '134'};
    %     EEG = extractEpochs(EEG, epochs, epochRange, baselineRange);
    %     if ~isdir(file.output_path)
    %         mkdir(file.output_path);
    %     end
    %     pop_saveset( EEG, 'filename',[ file.output_name '.set'],'filepath', file.output_path);
    %
    %% 12. Auto and\or Manual Rejection of Epochs Excedding Threshold
    %     EEG = pop_eegthresh(EEG,1,[13 50] ,-70,70,epochRange(1), epochRange(2),0,0);
    %     % epochs above threshold [-100, 100], elcs - [13 50]
    %     EEG = pop_rejepoch(EEG, EEG.reject.rejthresh, 0);
    % %     if loadRejEpochsIdx %manual rejection
    % %         load([file_path 'removed_epochs'], 'removed_epochs');
    % %         EEG = pop_rejepoch(EEG, removed_epochs, 1);
    % %     end
    %     pop_saveset( EEG, 'filename',[ file.output_name '.set'],'filepath', file.output_path);
end

%% 13. Extract epochs per condition batch:
% extractEpochsBatch()

