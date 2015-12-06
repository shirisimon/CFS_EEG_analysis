%% manual rejection
clear all
% eeglab
subject = {'334'};
% {'324' '325' '326' '328' '329' '331' '332' '333' '334' '335' '336' '340' '342' '344' '345' '346' '347' '348' '350'};
% condition = {'ActRec1'};
for s = 1:length(subject)
   % input_name_source = [subject{s} '_0.5-40flt_AVGref_evtEdited_allEpochs_ICA_clean-ICA_2ndICA_dipFited'];
   input_name_source = [subject{s} '_0.5-40flt_AVGref_evtEdited_allEpochs_ICA_clean-ICA'];
   input_path_source = ['C:\\Research\\Study 3 - MNS response to invisible actions\\EEG\Data\\' ...
        '2nd_pool_data_2ndPiplinePreProcessing\\' subject{s} '\\']; %Epochs\\'];
    EEG_source = pop_loadset('filename', [input_name_source '.set'], 'filepath', input_path_source);
    
    input_name_target = [subject{s} '_0.5-40flt_M1M2ref_allEpochs'];
    input_path_target = ['C:\\Research\\Study 3 - MNS response to invisible actions\\EEG\\Data\\' subject{s} '\\']; %Epochs\\'];
    EEG_target = pop_loadset('filename', [input_name_target '.set'], 'filepath', input_path_target);
    % pop_eegplot(EEG,0,1,1);
    % eegplot(EEG.data([13 50 27 64],:,:), 'spacing', 40, 'command', 0);
    %%
    urevents = [];
    for e = 1:EEG_source.trials
        urevents = [urevents, EEG_source.epoch(e).eventurevent{2}];
    end
    rejepochs = [];
    for e = 1:EEG_target.trials
        if sum(EEG_target.epoch(e).eventtype{2} == [111 121 123 114 124 134])
            if ismember(EEG_target.epoch(e).eventurevent{2}, urevents)
                rejepochs = [rejepochs, 0]; % trial is in source dataset so dont reject it
            else
                rejepochs = [rejepochs, 1]; % trial is not in source dataset so reject it
            end
        else
            rejepochs = [rejepochs, 0]; % trial is in of medial recognition 
        end
    end
        
    EEG_target = pop_rejepoch(EEG_target, rejepochs, 0);
    output_name = [input_name_target '_clean'];
    pop_saveset(EEG_target, 'filename', [output_name '.set'], 'filepath', input_path_target);
end
