
function extractEpochsBatch()
clear all
close all
epochRange = [-1.8 2];
baselineRange = [];

subject = {'351' '352' '353'};
% subject =  {'324' '326' '328' '329' '331' '332' '333' '334' '335' '336' '340'...
%             '342' '344' '345' '346' '347' '348' '350'};
for s = 1:size(subject,2) 
    file = struct;
    file.input_path = ['F:\\Study 3 - MNS response to invisible actions\\EEG\\Data\\3rd pool - tests\\' subject{s} '\\'];
    file.input_name = [subject{s} '_0.5-40flt_M1M2ref_evtEdited_manRJ_ICA_dipFited_rmIC_Epochs'];
    file.output_path = [file.input_path '\\Epochs\\'];
    if ~isdir(file.output_path)
        mkdir(file.output_path);
    end
    
    %% Control - Actions
    EEG = pop_loadset('filename',[file.input_name '.set'] ,'filepath', file.input_path);
    file.output_name = ['ControlA_' file.input_name];
    EEG = extractEpochs(EEG, {'31' '32' '33'}, epochRange, baselineRange);
    pop_saveset( EEG, 'filename',[ file.output_name '.set'],'filepath', file.output_path);
    
    %% Control - Balls
    EEG = pop_loadset('filename',[file.input_name '.set'] ,'filepath', file.input_path);
    file.output_name = ['ControlB_' file.input_name];
    EEG = extractEpochs(EEG, {'34' '35' '36'}, epochRange, baselineRange);
    pop_saveset( EEG, 'filename',[ file.output_name '.set'],'filepath', file.output_path);
    
end
end